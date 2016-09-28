%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% DoChiCalc_I08.m
%
% Template for script to do chi calculations for CTD-chipod data. This is
% second step of CTD-chipod processing.
%
% '***' indicates where changes need to be made to modify the template for
% specific cruises
%
% *MakeCasts_CTDchipod_Template.m needs to be run first*
%
% The actual iterative chi computation is done with get_chipod_chi.m, which
% is in /mixingsoftware/chipod/compute_chi/.
%
% OUTPUT:
% For each cast, produces and saves a structure 'avg' with results
%
% This script is part of CTD-chipod routines maintained in a github repo at
% https://github.com/OceanMixingGroup/mixingsoftware/tree/master/CTD_Chipod
%
% Dependencies:
% Compute_N2_dTdz_forChi.m
% ctd_rmdepthloops.m
% MakeCtdChiWindows.m
% fast_psd.m
% get_chipod_chi.m
%
% stopped at iSN=3,icast=25
%
%----------------
% 05/24/16 - AP - Initial coding
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear ; close all

% ***
this_script_name='DoChiCalc_I08.m'

% *** load/set paths for data
Load_chipod_paths_I08

% *** load deployment info
Chipod_Deploy_Info_I08

%~~ set some params for following calcs
do_T2_big=1;         % do calc for T2 if big chipod
Params.z_smooth=20;  % distance (m) over which to smooth N^2 and dT/dz
Params.nfft=128;     % nfft to use in computing wavenumber spectra
Params.extra_z=2;    % number of extra meters to get rid of due to CTD pressure loops.
Params.wthresh = 0.3;% w threshold for removing CTD pressure loops
Params.TPthresh=1e-6 % minimum TP variance to do calculation
Params.fmax=7;      % max freq to integrate TP spectrum to in chi calc
Params.resp_corr=0;  % correct TP spectra for freq response of thermistor
Params.fc=99;        % cutoff frequency for response correction
Params.gamma=0.2;    % mixing efficiency
%~~

% use default fc=99 for no correction (to make file paths same)
if Params.resp_corr==0
    Params.fc=99;
end

% initialize a text file for summary of processing
MakeResultsTextFile_ChiCalc_DoChiCalc

% choose which sensor to work on
for iSN=1:length(ChiInfo.SNs)
    
    clear whSN
    whSN=ChiInfo.SNs{iSN}
    
    % specific paths for this sensor
    clear chi_proc_path_specific chi_fig_path savedir_cal
    chi_proc_path_specific=fullfile(chi_proc_path,[whSN]);
    chi_fig_path_specific=fullfile(chi_proc_path_specific,'figures')
    savedir_cal=fullfile(chi_proc_path_specific,'cal')
    fprintf(fileID,['\n processed path: \n ' chi_proc_path  ]);
    
    % get list of cast files we have
    clear Flist
    castdir=ChiInfo.(whSN).InstDir
    %Flist=dir(fullfile(savedir_cal,['*' whSN '*cast.mat']));
    
    % * Do only the 'clean' direction
    Flist=dir(fullfile(savedir_cal,['*' whSN '*' castdir 'cast.mat']));
    disp(['There are ' num2str(length(Flist)) ' casts to process '])
    fprintf(fileID,['\n There are ' num2str(length(Flist)) ' casts to process \n\n ']);
    
    % for each cast, do chi calculations
    for icast=1:length(Flist)
        
        fprintf(fileID,['\n-------\n working on ' Flist(icast).name ' (icast=' num2str(icast) ')\n-------']);
        
        try
            close all
            
            if ChiInfo.(whSN).isbig==1 && do_T2_big==1
                Ncasestodo=2;
            else
                Ncasestodo=1;
            end
            
            whfig=6; % # for figure filename, so they can be viewed in order in Finder
            
            for whcasetodo=1:Ncasestodo
                
                clear ctd chi_todo_now whsens TP
                close all
                switch whcasetodo
                    
                    % do T1
                    case 1
                        whsens='T1';
                        
                        % do T2
                    case 2
                        whsens='T2';
                end
                
                fprintf(fileID,['\n----\n  sensor ' whsens]);
                
                %-- load data
                clear fname castfile id1
                castfile=Flist(icast).name;
                id1=strfind(castfile,['_' whSN]);
                castStr=castfile(1:id1-1);
                %  fname=fullfile(savedir_cal,[castStr '_' whSN '_' castdir 'cast.mat']);
                fname=fullfile(savedir_cal,castfile)
                load(fname)
                %---
                
                clear TP ctd
                TP=C.([whsens 'P']);
                
                % compute background N^2 and dT/dz for chi calculations
                clear ctd
                ctd=Compute_N2_dTdz_forChi(C.ctd.bin,Params.z_smooth);
                
                % remove loops in CTD data
                clear datau2 bad_inds tmp
                [datau2,bad_inds] = ctd_rmdepthloops(C.ctd.raw,Params.extra_z,Params.wthresh);
                tmp=ones(size(datau2.p));
                tmp(bad_inds)=0;
                
                %chi_todo_now.is_good_data=interp1(datau2.datenum,tmp,chi_todo_now.datenum,'nearest');
                C.is_good_data=interp1(datau2.datenum,tmp,C.datenum,'nearest');
                
                clear ib_loop Nloop
                ib_loop=find(C.is_good_data==0);
                Nloop=length(ib_loop);
                fprintf(fileID,['\n  ' num2str(round(Nloop/length(C.datenum)*100)) ' percent of points removed for depth loops ']);
                disp(['\n  ' num2str(round(Nloop/length(C.datenum)*100)) ' percent of points removed for depth loops ']);
                
                figure(55);clf
                plot(C.datenum,C.P)
                xlabel(['Time on ' datestr(floor(nanmin(C.datenum)))])
                ylabel('Pressure')
                title([castStr '_' C.castdir],'interpreter','none')
                axis ij
                datetick('x')
                grid on
                
                
                % find segments of good data (where no glitches AND
                % no depth loops)
                clear idg b Nsegs
                TP(ib_loop)=nan;
                
                %-- get windows for chi calculation
                clear todo_inds Nwindows
                [todo_inds,Nwindows]=MakeCtdChiWindows(TP,Params.nfft);
                
                %~ make 'avg' structure for the processed data
                clear avg
                avg=struct();
                avg.Params=Params;
                tfields={'datenum','P','N2','dTdz','fspd','T','S','P','theta','sigma',...
                    'chi1','eps1','KT1','TP1var'};
                for n=1:length(tfields)
                    avg.(tfields{n})=NaN*ones(Nwindows,1);
                end
                
                avg.samplerate=1./nanmedian(diff(C.datenum))/24/3600;
                
                % get average time, pressure, and fallspeed in each window
                for iwind=1:Nwindows
                    clear inds
                    inds=todo_inds(iwind,1) : todo_inds(iwind,2);
                    avg.datenum(iwind)=nanmean(C.datenum(inds));
                    avg.P(iwind)=nanmean(C.P(inds));
                    avg.fspd(iwind)=nanmean(C.fspd(inds));
                end
                
                %~~ plot histogram of avg.P to see how many good windows we have in
                % each 10m bin
                figure
                hi=histogram(avg.P,0:10:nanmax(avg.P));
                hi.Orientation='Horizontal';axis ij;
                ylabel('P [db]')
                xlabel('# good data windows')
                title([whSN ' cast ' castStr ' - ' C.castdir 'cast'],'interpreter','none')
                print('-dpng',fullfile(chi_fig_path_specific,[whSN '_' castStr '_Fig' num2str(whfig) '_' C.castdir 'cast_chi_' whsens '_avgPhist']))
                whfig=whfig+1;
                
                % get N2, dTdz for each window
                good_inds=find(~isnan(ctd.p));
                % interpolate ctd data to same pressures as chipod
                avg.N2=interp1(ctd.p(good_inds),ctd.N2(good_inds),avg.P);
                avg.dTdz=interp1(ctd.p(good_inds),ctd.dTdz(good_inds),avg.P);
                avg.T=interp1(ctd.p(good_inds),ctd.t1(good_inds),avg.P);
                avg.S=interp1(ctd.p(good_inds),ctd.s1(good_inds),avg.P);
                
                % note sw_visc not included in newer versions of sw?
                avg.nu=sw_visc_ctdchi(avg.S,avg.T,avg.P);
                avg.tdif=sw_tdif_ctdchi(avg.S,avg.T,avg.P);
                
                % loop through each window and do the chi
                % computation
                for iwind=1:Nwindows
                    clear inds
                    inds=todo_inds(iwind,1) : todo_inds(iwind,2);
                    
                    % integrate dT/dt spectrum
                    clear tp_power freq
                    [tp_power,freq]=fast_psd(TP(inds),Params.nfft,avg.samplerate);
                    avg.TP1var(iwind)=sum(tp_power)*nanmean(diff(freq));
                    
                    if avg.TP1var(iwind)>Params.TPthresh
                        
                        % apply filter correction for sensor response?
                        if Params.resp_corr==1
                            trans_fcn=0;
                            trans_fcn1=0;
                            thermistor_filter_order=2;
                            thermistor_cutoff_frequency=Params.fc;
                            analog_filter_order=4;
                            analog_filter_freq=50;
                            tp_power=invert_filt(freq,invert_filt(freq,tp_power,thermistor_filter_order, ...
                                thermistor_cutoff_frequency),analog_filter_order,analog_filter_freq);
                        end
                        
                        % compute chi using iterative procedure
                        [chi1,epsil1,k,spec,kk,speck,stats]=get_chipod_chi(freq,tp_power,abs(avg.fspd(iwind)),avg.nu(iwind),...
                            avg.tdif(iwind),avg.dTdz(iwind),'nsqr',avg.N2(iwind),'fmax',Params.fmax,'gamma',Params.gamma);
                        %            'doplots',1 for plots
                        avg.chi1(iwind)=chi1(1);
                        avg.eps1(iwind)=epsil1(1);
                        avg.KT1(iwind)=0.5*chi1(1)/avg.dTdz(iwind)^2;
                        
                    end % if T1Pvar>threshold
                    
                end % windows
                
                
                %~ plot summary figure
                ax=CTD_chipod_profile_summary(avg,C,TP);
                axes(ax(1))
                title(['cast ' castStr],'interpreter','none')
                axes(ax(2))
                title([whSN],'interpreter','none')
                axes(ax(3))
                title(['Sensor ' whsens])
                print('-dpng',fullfile(chi_fig_path_specific,[whSN '_' castStr '_Fig' num2str(whfig) '_' C.castdir 'cast_chi_' whsens '_avg_chi_KT_dTdz']))
                whfig=whfig+1;
                %~~~
                
                castname=castStr;
                
                % add lat/lon to avg structure
                avg.lat=nanmean(ctd.lat);
                avg.lon=nanmean(ctd.lon);
                avg.castname=castname;
                avg.castdir=C.castdir;
                avg.Info=C.Info;
                avg.MakeInfo=['Made ' datestr(now) ' w/ ' this_script_name ];
                
                ctd.castname=castname;
                ctd.MakeInfo=['Made ' datestr(now) ' w/ ' this_script_name ];
                
                %chi_proc_path_avg=fullfile(chi_proc_path_specific,'avg');
                chi_proc_path_avg=fullfile(chi_proc_path_specific,'avg',...
                    ['zsm' num2str(Params.z_smooth) 'm_fmax' num2str(Params.fmax) 'Hz_respcorr' num2str(Params.resp_corr) '_fc_' num2str(Params.fc) 'hz_gamma' num2str(Params.gamma*100)] )
                
                ChkMkDir(chi_proc_path_avg)
                processed_file=fullfile(chi_proc_path_avg,['avg_' castStr '_' avg.castdir 'cast_' whSN '_' whsens '.mat']);
                save(processed_file,'avg','ctd')
                %~~~
                
                ngc=find(~isnan(avg.chi1));
                if numel(ngc)>1
                    fprintf(fileID,['\n Chi computed for ' C.castdir 'cast, sensor ' whsens]);
                    fprintf(fileID,['\n ' processed_file '\n']);
                end
                
            end % up/down, T1/T2
            
        catch
            disp(['Error on ' Flist(icast).name])
        end
        
    end % cast #
    
end % iSN (different chipods)
%%