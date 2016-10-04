%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% ProcessCTDchipod_TTide_Falkor.m
%
% Script to do CTD-chipod processing for TTide, Falkor .
%
%
% 30 June 2015 - A. Pickering - apickering@coas.oregonstate.edu
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear ; close all ; clc

this_script_name='ProcessCTDchipod_TTide_Falkor.m'

tstart=tic;

% path for 'mixingsoftware'
mixpath='/Users/Andy/Cruises_Research/mixingsoftware/'

% cd to CTD_chipod folder and add paths we need
addpath(fullfile(mixpath,'CTD_Chipod'))
addpath(fullfile(mixpath,'general')) % makelen.m in /general is needed
addpath(fullfile(mixpath,'marlcham')) % for integrate.m
addpath(fullfile(mixpath,'adcp')) % need for mergefields_jn.m in load_chipod_data

addpath /Users/Andy/Cruises_Research/seawater_ver3_2/

% *** Path where ctd data are located (already processed into mat files). 
ctd_out_dir_root='/Users/Andy/Dropbox/chipod/ctd/ctd_processed/'
ctd_out_dir_raw=fullfile(ctd_out_dir_root,'raw')
ctd_out_dir_bin=fullfile(ctd_out_dir_root,'binned')

%chi_data_path='/Users/Andy/Dropbox/mendocino/data/chipod600/'
chi_data_path='/Users/Andy/Dropbox/chipod/chipod/'

chi_processed_path='/Users/Andy/Cruises_Research/Tasmania/Data/Chipod/Falkor/processed/'
ChkMkDir(chi_processed_path)

% path to save figures to
fig_path=[chi_processed_path 'figures/'];
ChkMkDir(fig_path)
% ~~~~~~

% Make a list of all ctd files
% *** replace 'leg1' with name that is in your ctd files ***
CTD_list=dir(fullfile(ctd_out_dir_raw,'*FK150117*.mat'));

%%
% make a text file to print a summary of results to
txtfname=['Results' datestr(floor(now)) '.txt'];

if exist(fullfile(chi_processed_path,txtfname),'file')
    delete(fullfile(chi_processed_path,txtfname))
end

fileID= fopen(fullfile(chi_processed_path,txtfname),'a');
fprintf(fileID,['\n \n CTD-chipod Processing Summary\n']);
fprintf(fileID,['\n \n Created ' datestr(now) '\n']);
fprintf(fileID,'\n CTD path \n');
fprintf(fileID,[ctd_out_dir_root '\n']);
fprintf(fileID,'\n Chipod data path \n');
fprintf(fileID,[chi_data_path '\n']);
fprintf(fileID,'\n Chipod processed path \n');
fprintf(fileID,[chi_processed_path '\n']);
fprintf(fileID,'\n figure path \n');
fprintf(fileID,[fig_path '\n \n']);
fprintf(fileID,[' \n There are ' num2str(length(CTD_list)) ' CTD files' ]);

% we loop through and do processing for each ctd file

hb=waitbar(0,'Looping through ctd files');

for a=45:length(CTD_list)
    
    close all
    a
    waitbar(a/length(CTD_list),hb)
    
    clear castname tlim time_range cast_suffix_tmp cast_suffix CTD_24hz
    castname=CTD_list(a).name;
    
    fprintf(fileID,[' \n \n ~' castname ]);
    
    %load CTD profile
     load(fullfile(ctd_out_dir_raw ,castname))
 
     % 24Hz data loaded here is in a structure named 'data2'
    CTD_24hz=data2;clear data2
    CTD_24hz.ctd_file=castname;
    % Sometimes the time needs to be converted from computer time into matlab (datenum?) time.
    % Time will be converted when CTD time is more than 5 years bigger than now.
    % JRM
    tlim=now+5*365;
    if any(CTD_24hz.time > tlim)
        tmp=linspace(CTD_24hz.time(1),CTD_24hz.time(end),length(CTD_24hz.time));
%        CTD_24hz.datenum=tmp'/24/3600+datenum([1970 1 1 0 0 0]);
         CTD_24hz.datenum=tmp'/24/3600+datenum([2000 1 1 0 0 0]); %note different than usual convention
    end
    
    clear tlim tmp
    time_range=[min(CTD_24hz.datenum) max(CTD_24hz.datenum)]
    datestr(time_range(1))
    datestr(time_range(2))
    
    
    % find castnumber
    clear ik
    ik=strfind(castname,'CTD')
    cast_suffix=castname(ik+3:ik+5)
        
    % load chipod deployment info
    Chipod_Deploy_Info_TTIDE_Falkor
        
    for up_down_big=1%
        
        close all
        
        % *** edit this info for your cruise/instruments ***
        
        switch up_down_big
            case 1
                whSN='SN1006'; %
                the_chi_path=fullfile(chi_data_path,'channel4','ti24-4')
        end
        
        short_labs={whSN};
        
        this_chi_info=ChiInfo.(whSN);
        
        clear chi_path az_correction suffix isbig cal is_downcast
%        chi_path=fullfile(chi_data_path);
        suffix=this_chi_info.suffix;
        isbig=this_chi_info.isbig;
        cal=this_chi_info.cal;
        
        fprintf(fileID,[ ' \n \n ' short_labs{up_down_big} ]);
        
        d.time_range=datestr(time_range); % Time range of cast
        
        chi_processed_path_specific=fullfile(chi_processed_path,['chi_' short_labs{up_down_big} ]);
        ChkMkDir(chi_processed_path_specific)
        
        fig_path_specific=fullfile(fig_path,['chi_' short_labs{up_down_big} ]);
        ChkMkDir(fig_path_specific)
        
        % filename for partly processed chipod data (will check if already exists)
        % this is file with chipod data for just time range of CTD cast
        processed_file=fullfile(chi_processed_path_specific,['cast_' cast_suffix '_' short_labs{up_down_big} '.mat']);
        %
        %~~ Load chipod data
        % comment out below to redo finding chi files and
        % alignment/calibrations
        if  0%exist(processed_file,'file')
            disp('loading preexisting file')
            fprintf(fileID,' file already exists, loading');
            load(processed_file)
        else
            disp('loading chipod data')
            
            chidat=load_chipod_data(the_chi_path,time_range,suffix,isbig);

            chidat.time_range=time_range;
            chidat.castname=castname;
            save(processed_file,'chidat')
            
            %~ Moved this info here. For some chipods, this info changes
            % during deployment, so we will wire that in here for now...
            clear is_downcast az_correction
            
            az_correction=this_chi_info.az_correction;
                        
            % carry over chipod info
            chidat.Info=this_chi_info;
            chidat.cal=this_chi_info.cal;
            
            if length(chidat.datenum)>1000
                
                % Align
                [CTD_24hz chidat]=AlignChipodCTD(CTD_24hz,chidat,az_correction,1);
                print('-dpng',[fig_path  'chi_' short_labs{up_down_big} '/cast_' cast_suffix '_w_TimeOffset'])
                
                % Calibrate T and dT/dt
                [CTD_24hz chidat]=CalibrateChipodCTD(CTD_24hz,chidat,az_correction,1);
                print('-dpng',[fig_path  'chi_' short_labs{up_down_big} '/cast_' cast_suffix '_w_dTdtSpectraCheck'])
                
                % save again, with time-offset and calibration added
                save(processed_file,'chidat')
                
                % check if T calibration is ok
                clear out2 err pvar
                out2=interp1(chidat.datenum,chidat.cal.T1,CTD_24hz.datenum);
                err=out2-CTD_24hz.t1;
                pvar=100* (1-(nanvar(err)/nanvar(CTD_24hz.t1)) );
                if pvar<50
                    disp('Warning T calibration not good')
                    fprintf(fileID,' *T calibration not good* ');
                end
                
                %~~~~
                do_timeseries_plot=1;
                if do_timeseries_plot
                    
                    xls=[min(CTD_24hz.datenum) max(CTD_24hz.datenum)];
                    figure(2);clf
                    agutwocolumn(1)
                    wysiwyg
                    clf
                    
                    h(1)=subplot(411);
                    plot(CTD_24hz.datenum,CTD_24hz.t1)
                    hold on
                    plot(chidat.datenum,chidat.cal.T1)
                    plot(chidat.datenum,chidat.cal.T2-.5)
                    ylabel('T [\circ C]')
                    xlim(xls)
                    datetick('x')
                    title(['Cast ' cast_suffix ', ' short_labs{up_down_big} '  ' datestr(time_range(1),'dd-mmm-yyyy HH:MM') '-' datestr(time_range(2),15) ', ' CTD_list(a).name],'interpreter','none')
                    legend('CTD','chi','chi2-.5','location','best')
                    grid on
                    
                    h(2)=subplot(412);
                    plot(CTD_24hz.datenum,CTD_24hz.p);
                    ylabel('P [dB]')
                    xlim(xls)
                    datetick('x')
                    grid on
                    
                    h(3)=subplot(413);
                    plot(chidat.datenum,chidat.cal.T1P-.01)
                    hold on
                    plot(chidat.datenum,chidat.cal.T2P+.01)
                    ylabel('dT/dt [K/s]')
                    xlim(xls)
                    ylim(10*[-1 1])
                    datetick('x')
                    grid on
                    
                    h(4)=subplot(414);
                    plot(chidat.datenum,chidat.fspd)
                    ylabel('fallspeed [m/s]')
                    xlim(xls)
                    ylim(3*[-1 1])
                    datetick('x')
                    xlabel(['Time on ' datestr(time_range(1),'dd-mmm-yyyy')])
                    grid on
                    
                    linkaxes(h,'x');
                    orient tall
                    pause(.01)
                    
                    print('-dpng','-r300',[fig_path  'chi_' short_labs{up_down_big} '/cast_' cast_suffix '_T_P_dTdz_fspd.png']);
                end
                %~~~~
                
            else
                disp('no good chi data for this profile');
                fprintf(fileID,' No chi file found ');
            end % if we have good chipod data for this profile
            
        end % already processed
        
        %                 else
        %             disp('this file already processed')
        %             fprintf(fileID,' file already exists, skipping ');
        %end % already processed
        
        
        if ~isempty(chidat.datenum) % if we have good data for this cast
            
            
            clear datad_1m datau_1m chi_inds p_max ind_max ctd
            
            % load 1-m CTD data.
            binnedfile=fullfile(ctd_out_dir_bin,['FK150117_CTD' cast_suffix '.mat'])
            if exist(binnedfile,'file')
                %load([ctd_out_dir_root '/binned/' castname(1:end-6) '.mat']);
                load(binnedfile)
                
                % find max p from chi (which is really just P from CTD)
                [p_max,ind_max]=max(chidat.cal.P);
                
                %~ break up chi into down and up casts
                
                % upcast
                chi_up=struct();
                chi_up.datenum=chidat.cal.datenum(ind_max:length(chidat.cal.P));
                chi_up.P=chidat.cal.P(ind_max:length(chidat.cal.P));
                chi_up.T1P=chidat.cal.T1P(ind_max:length(chidat.cal.P));
                chi_up.fspd=chidat.cal.fspd(ind_max:length(chidat.cal.P));
                chi_up.castdir='up';
                chi_up.Info=this_chi_info;
                % 2nd sensor on 'big' chipods
                chi_up.T2P=chidat.cal.T2P(ind_max:length(chidat.cal.P));
                
                % downcast
                chi_dn=struct();
                chi_dn.datenum=chidat.cal.datenum(1:ind_max);
                chi_dn.P=chidat.cal.P(1:ind_max);
                chi_dn.T1P=chidat.cal.T1P(1:ind_max);
                chi_dn.fspd=chidat.cal.fspd(1:ind_max);
                chi_dn.castdir='down';
                chi_dn.Info=this_chi_info;
                % 2nd sensor on 'big' chipods
                chi_dn.T2P=chidat.cal.T2P(1:ind_max);
                %~
                
                
                %~~~
                % save these data here now ?
                clear fname_dn fname_up
                fname_dn=fullfile(chi_processed_path_specific,['cast_' cast_suffix '_' short_labs{up_down_big} '_downcast.mat']);
                save(fname_dn,'chi_dn')
                fname_up=fullfile(chi_processed_path_specific,['cast_' cast_suffix '_' short_labs{up_down_big} '_upcast.mat']);
                save(fname_up,'chi_up')
                %~~~
                
                
                %~~
                do_T2_big=1; % do calc for T2 if big chipod
                % define some parameters that are the same for up/down and
                % T1/T2:
                z_smooth=20
                nfft=128;
                extra_z=2; % number of extra meters to get rid of due to CTD pressure loops.
                wthresh = 0.4;
                
                if isbig==1 && do_T2_big==1
                    Ncasestodo=4
                else
                    Ncasestodo=2
                end
                
                for whcasetodo=1:Ncasestodo
                    
                    clear ctd chi_todo_now whsens TP
                    
                    switch whcasetodo
                        
                        case 1 % downcast T1
                            clear ctd chi_todo_now
                            % fallspeed_correction=-1;
                            ctd=datad_1m;
                            chi_todo_now=chi_dn;
                            % ~~ Choose which dT/dt to use (for mini
                            % chipods, only T1P. For big, we will do T1P
                            % and T2P).
                            whsens='T1';
                            TP=chi_todo_now.T1P;
                            disp('Doing T1 downcast')
                        case 2 % upcast T1
                            clear avg ctd chi_todo_now
                            %fallspeed_correction=1;
                            ctd=datau_1m;
                            chi_todo_now=chi_up;
                            whsens='T1';
                            TP=chi_todo_now.T1P;
                            disp('Doing T1 upcast')
                        case 3 %downcast T2
                            clear ctd chi_todo_now
                            %fallspeed_correction=-1;
                            ctd=datad_1m;
                            chi_todo_now=chi_dn;
                            % ~~ Choose which dT/dt to use (for mini
                            % chipods, only T1P. For big, we will do T1P
                            % and T2P).
                            TP=chi_todo_now.T2P;
                            whsens='T2';
                            disp('Doing T2 downcast')
                        case 4 % upcast T2
                            clear avg ctd chi_todo_now
                            %                                fallspeed_correction=1;
                            ctd=datau_1m;
                            chi_todo_now=chi_up;
                            TP=chi_todo_now.T2P;
                            whsens='T2';
                            disp('Doing T2 upcast')
                    end
                    
                    
                    % AP May 11 - replace with function
                    ctd=Compute_N2_dTdz_forChi(ctd,z_smooth);
                    
                    %~~ plot N2 and dTdz
                    doplot=1;
                    if doplot
                        figure(3);clf
                        subplot(121)
                        hT=plot(log10(abs(ctd.N2)),ctd.p);
                        xlabel('log_{10}N^2'),ylabel('depth [m]')
                        title(castname,'interpreter','none')
                        grid on
                        axis ij
                        
                        subplot(122)
                        plot(log10(abs(ctd.dTdz)),ctd.p)
                        xlabel('log_{10} dT/dz [^{o}Cm^{-1}]'),ylabel('depth [m]')
                        title([chi_todo_now.castdir 'cast'])
                        grid on
                        axis ij
                        print('-dpng',[fig_path  'chi_' short_labs{up_down_big} '/cast_' cast_suffix '_' chi_todo_now.castdir 'cast_N2_dTdz'])
                    end
                    %~~
                    
                    %~~~ now let's do the chi computations:
                    
                    % remove loops in CTD data
                    %                         extra_z=2; % number of extra meters to get rid of due to CTD pressure loops.
                    %                         wthresh = 0.4;
                    clear datau2 bad_inds tmp
                    [datau2,bad_inds] = ctd_rmdepthloops(CTD_24hz,extra_z,wthresh);
                    tmp=ones(size(datau2.p));
                    tmp(bad_inds)=0;
                    
                    % new AP
                    chi_todo_now.is_good_data=interp1(datau2.datenum,tmp,chi_todo_now.datenum,'nearest');
                    %
                    figure(55);clf
                    plot(chi_todo_now.datenum,chi_todo_now.P)
                    xlabel('Time')
                    ylabel('Pressure')
                    title(['cast_' cast_suffix '_' chi_todo_now.castdir],'interpreter','none')
                    axis ij
                    datetick('x')
                    
                    
                    %%% Now we'll do the main looping through of the data.
                    clear avg  todo_inds
                    
                    [avg todo_inds]=Prepare_Avg_for_ChiCalc(nfft,chi_todo_now,ctd);
                    
                    clear fspd good_chi_inds
                    fspd=chi_todo_now.fspd;
                    good_chi_inds=chi_todo_now.is_good_data;
                    
                    %~ compute chi in overlapping windows
                    avg=ComputeChi_for_CTDprofile(avg,nfft,fspd,TP,good_chi_inds,todo_inds);
                    %~ plot summary figure
                    ax=CTD_chipod_profile_summary(avg,chi_todo_now,TP);
                    axes(ax(1))
                    title(['cast ' cast_suffix])
                    axes(ax(2))
                    title([short_labs{up_down_big}],'interpreter','none')
                    print('-dpng',[fig_path  'chi_' short_labs{up_down_big} '/cast_' cast_suffix '_' chi_todo_now.castdir 'cast_chi_' short_labs{up_down_big} '_' whsens '_avg_chi_KT_dTdz'])
                    
                    %~~~
                    avg.castname=castname;
                    avg.castdir=chi_todo_now.castdir;
                    avg.Info=this_chi_info;
                    ctd.castname=castname;
                    
                    avg.castname=castname;
                    ctd.castname=castname;
                    avg.MakeInfo=['Made ' datestr(now) ' w/ ' this_script_name ];
                    ctd.MakeInfo=['Made ' datestr(now) ' w/ ' this_script_name ];
                    
                    chi_processed_path_avg=fullfile(chi_processed_path_specific,'avg');
                    ChkMkDir(chi_processed_path_avg)
                    processed_file=fullfile(chi_processed_path_avg,['avg_' cast_suffix '_' avg.castdir 'cast_' short_labs{up_down_big} '_' whsens '.mat']);
                    save(processed_file,'avg','ctd')
                    %~~~
                    
                    ngc=find(~isnan(avg.chi1));
                    if numel(ngc)>1
                        fprintf(fileID,['\n Chi computed for ' chi_todo_now.castdir 'cast, sensor ' whsens]);
                        fprintf(fileID,['\n ' processed_file]);
                    end
                    
                    
                end % up,down, T1/T2
                
                
                
            end % if we have binned ctd data
            
            %             else
            %                 disp('no good chi data for this profile');
            %                 fprintf(fileID,' No chi file found ');
            %             end % if we have good chipod data for this profile
            
            %         else
            %             disp('this file already processed')
            %             fprintf(fileID,' file already exists, skipping ');
            %         end % already processed
            %
        end % have good data for this cast
        
    end % each chipod on rosette (up_down_big)
    
    
end % each CTD file

delete(hb)

telapse=toc(tstart)
fprintf(fileID,['\n \n Done! \n Processing took ' num2str(telapse/60) ' mins to run']);

%
%%
