%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% MakeCasts_CTDchipod_Tbeam.m
%
% Find data for each cast, align and calibrate etc.. save files for each
% cast.
%
% For 'Big' CTD
%
% *Next step in processing is DoChiCalc_Template.m
%
% * Need to RUN for all *
%
%---------------------
% 11/10/15 - A.Pickering - Initial coding
% 12/10/15 - AP - Got SN1006 sort of working. Time offset doesn't work on
% some casts, not sure why. Maybe spikes in dpdt? Or possible that CTD has
% tilted alot and so AZ from chipod not always == dp/dt? . Strange, the
% time offset seems to work perfectly for parts of the timesreis, but not
% for others...
% 02/02/16 - AP - Cleaning up and streamlining a bit.
% 02/02/16 - AP - Also add condition to skip, not save file if T cal not good
% 06/01/16 - AP - Modify to use entire CTD file name
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear ; close all ; clc

this_script_name='ProcessCTDchipod_Falkor_Big.m'

% start a timer
tstart=tic;

% *** path for 'mixingsoftware' ***
mixpath='/Users/Andy/Cruises_Research/mixingsoftware/';

% add paths we need
addpath(fullfile(mixpath,'CTD_Chipod'));
addpath(fullfile(mixpath,'CTD_Chipod','mfiles'));
addpath(fullfile(mixpath,'chipod')); % raw_load_chipod.m
addpath(fullfile(mixpath,'general')); % makelen.m in /general is needed
addpath(fullfile(mixpath,'marlcham')); % for integrate.m
addpath(fullfile(mixpath,'adcp')); % need for mergefields_jn.m in load_chipod_data

% Load paths for CTD and chipod data
Load_chipod_paths_TTide_Falkor
ChkMkDir(chi_proc_path)

% Load chipod deployment info
Chipod_Deploy_Info_TTIDE_Falkor_Big

% load list of bad files to ignore
bad_file_list_TTIDE_Falkor
%
% Make a list of all ctd files we have
CTD_list=dir(fullfile(CTD_out_dir_24hz,['*' ChiInfo.CastString '*.mat*']));
disp(['There are ' num2str(length(CTD_list)) ' CTD casts to process in ' CTD_out_dir_24hz])

% make a text file to print a summary of results to
MakeResultsTextFile;

fprintf(fileID,['\n There are ' num2str(length(CTD_list)) ' CTD casts to process in ' CTD_out_dir_24hz]);
disp(['\n There are ' num2str(length(CTD_list)) ' CTD casts to process in ' CTD_out_dir_24hz])

% Make a structure to save processing summary info

% Make a structure to save processing summary info

if ~exist(fullfile(BaseDir,'Data','proc_info.mat'),'file')
    
    proc_info=struct;
    proc_info.Project=ChiInfo.Project;
    proc_info.SNs=ChiInfo.SNs;
    proc_info.icast=nan*ones(1,length(CTD_list));
    proc_info.Name=cell(1,length(CTD_list));
    proc_info.duration=nan*ones(1,length(CTD_list));
    proc_info.MaxP=nan*ones(1,length(CTD_list));
    proc_info.Prange=nan*ones(1,length(CTD_list));
    proc_info.drange=nan*ones(length(CTD_list),2);
    proc_info.lon=nan*ones(1,length(CTD_list));
    proc_info.lat=nan*ones(1,length(CTD_list));
    
    empt_struct.toffset=nan*ones(1,length(CTD_list));
    empt_struct.IsChiData=nan*ones(1,length(CTD_list));
    empt_struct.T1cal=nan*ones(1,length(CTD_list));
    empt_struct.T2cal=nan*ones(1,length(CTD_list));
    
    for iSN=1:length(ChiInfo.SNs)
        proc_info.(ChiInfo.SNs{iSN})=empt_struct ;
    end
    
else
    disp('proc_info already exists, will load and add to it')
    load(fullfile(BaseDir,'Data','proc_info.mat'))
end


%%
% Loop through each ctd file
hb=waitbar(0,'Looping through ctd files');

for icast=1:length(CTD_list)
    
    close all
    clear castname tlim time_range cast_suffix_tmp cast_suffix CTD_24hz
    
    % update waitbar
    waitbar(icast/length(CTD_list),hb)
    
    % CTD castname we are working with
    castname=CTD_list(icast).name
    
    %##
    fprintf(fileID,[ '\n\n\n ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~' ]);
    fprintf(fileID,[' \n \n CTD-file: ' castname ' (icast=' num2str(icast) ')' ]);
    %##
    
    % Load 24hz CTD profile
    load(fullfile(CTD_out_dir_24hz, castname))
    CTD_24hz=data2;clear data2
    CTD_24hz.ctd_file=castname;
    
    % Sometimes the 24hz CTD time needs to be fixed
    tlim=now+5*365;
    if any(CTD_24hz.time > tlim )
        tmp=linspace(CTD_24hz.time(1),CTD_24hz.time(end),length(CTD_24hz.time));
        %CTD_24hz.datenum=tmp'/24/3600+datenum([1970 1 1 0 0 0]);
        CTD_24hz.datenum=tmp'/24/3600+datenum([2000 1 1 0 0 0]);
    end
    
    % Get time range of CTD cast
    clear tlim tmp
    idb=find(CTD_24hz.datenum<datenum(2015,1,1));
    CTD_24hz.datenum(idb)=nan;
    time_range=[min(CTD_24hz.datenum) max(CTD_24hz.datenum)];
    d.time_range=datestr(time_range);
    fprintf(fileID,['\n Time-range: ' datestr(time_range(1)) ' to ' datestr(time_range(2))]);
    
    % Name of CTD cast to use (assumes 24Hz CTD cast files end in '_raw.mat'
    castStr=castname(1:end-8)
      
    % edit out some obvious spikes in CTD temp so they don't screw up
    % calibrations etc.
    clear ib
    ib=find(CTD_24hz.t1<-2 | CTD_24hz.t1>40);
    CTD_24hz.t1(ib)=nan;
    
    clear ib
    ib=find(abs(diffs(CTD_24hz.t1))>2);
    CTD_24hz.t1(ib)=nan;
    
    clear ib
    ib=find(CTD_24hz.p<0);
    CTD_24hz.p(ib)=nan;
    CTD_24hz.t1(ib)=nan;
    
    clear ib
    ib=find(abs(diffs(CTD_24hz.p))>10);
    CTD_24hz.p(ib)=nan;
    CTD_24hz.t1(ib)=nan;
            
    proc_info.icast(icast)=icast;
    proc_info.Name(icast)={castStr};
    proc_info.MaxP(icast)=nanmax(CTD_24hz.p);
    proc_info.duration(icast)=nanmax(CTD_24hz.datenum)-nanmin(CTD_24hz.datenum);
    proc_info.Prange(icast)=range(CTD_24hz.p);
    proc_info.drange(icast,:)=time_range;
    
    proc_info.lon(icast)=nanmean(CTD_24hz.lon);
    proc_info.lat(icast)=nanmean(CTD_24hz.lat);
    

    %-- loop through each chipod  --
    for iSN=1%:length(ChiInfo.SNs)
        
        try
            close all
            clear whSN this_chi_info chi_path az_correction suffix isbig cal is_downcast
            
            whSN=ChiInfo.SNs{iSN};
            this_chi_info=ChiInfo.(whSN);
                        
            % full path to raw data for this chipod
            if strcmp(whSN,'SN1001')
                %chi_path='/Users/Andy/Cruises_Research/ChiPod/Tasmania/Data/Falkor/chipod/1001'
                chi_path='/Users/Andy/Cruises_Research/ChiPod/Tasmania/Data/Falkor/chipod/channel123_wHead/';
            else
                %chi_path=fullfile(chi_data_path,this_chi_info.loggerSN);
                chi_path=fullfile(chi_data_path,whSN);
            end
            
            suffix=this_chi_info.suffix;
            isbig=this_chi_info.isbig;
            cal=this_chi_info.cal;
            
            fprintf(fileID,[ ' \n\n ---------' ]);
            fprintf(fileID,[ ' \n ' whSN ]);
            fprintf(fileID,[ ' \n ---------\n' ]);
            
            %~~ specific paths for this chipod
            chi_proc_path_specific=fullfile(chi_proc_path,[whSN]);
            ChkMkDir(chi_proc_path_specific)
            
            chi_fig_path_specific=fullfile(chi_proc_path_specific,'figures');
            ChkMkDir(chi_fig_path_specific)
            %~~
            
            ax=PlotRawCTDTbeam(CTD_24hz);
            print('-dpng',fullfile(chi_fig_path_specific,[whSN '_' castStr '_Fig0_RawCTD']))            
            
            %~~ Load chipod data
            if  1 %~exist(processed_file,'file')
                %load(processed_file)
                % else
                disp('loading chipod data')
                
                
                if strcmp(whSN,'SN1006') && time_range(1)>datenum(2015,1,25,0,0,0)
                    chidat=[];
                    disp('SN1006 switched to little CTD before this time')
                    fprintf(fileID,'SN1006 switched to little CTD before this time')
                else
                    
                    % Find and load raw chipod data for this time range
                    clear chidat
%                   chidat=load_chipod_data(chi_path,time_range,suffix,isbig,1,bad_file_list);
                    chidat=load_chipod_data(chi_path,time_range,suffix,isbig,1);
                    if length(chidat.datenum)>1000
                        
                        proc_info.(whSN).IsChiData(icast)=1;
                        
                        ab=get(gcf,'Children');
                        axes(ab(end));
                        title([whSN ' - ' castname ' - Raw Data '],'interpreter','none')
                        
                        % save plot
                        print('-dpng',fullfile(chi_fig_path_specific,[whSN '_' castStr '_Fig1_RawChipodTS']))
                        
                        chidat.time_range=time_range;
                        chidat.castname=castname;
                        
                        savedir_cast=fullfile(chi_proc_path_specific,'cast');
                        ChkMkDir(savedir_cast)
                        save(fullfile(savedir_cast,[castStr '_' whSN '.mat']),'chidat')
                        
                        % carry over chipod info
                        chidat.Info=this_chi_info;
                        chidat.cal=this_chi_info.cal;
                        az_correction=this_chi_info.az_correction;
                        
                        if strcmp(whSN,'SN1006')
                            a1=chidat.AX;
                            a2=chidat.AZ;
                            chidat=rmfield(chidat,{'AX','AZ'});
                            chidat.AX=a2;
                            chidat.AZ=a1;
                            az_correction=1;
                            chidat.Info.az_correction=1;
                            this_chi_info.az_correction=1;
                        end
                        
                        if strcmp(whSN,'SN1014')
                            a1=chidat.AX;
                            a2=chidat.AZ;
                            chidat=rmfield(chidat,{'AX','AZ'});
                            chidat.AX=a2;
                            chidat.AZ=a1;
                            az_correction=1;
                            chidat.Info.az_correction=1;
                            this_chi_info.az_correction=1;
                        end
                        
                        if strcmp(whSN,'SN1008')
                            a1=chidat.AX;
                            a2=chidat.AZ;
                            chidat=rmfield(chidat,{'AX','AZ'});
                            chidat.AX=a2;
                            chidat.AZ=a1;
                        end
                        
                        % Align
                        [CTD_24hz chidat]=AlignChipodCTD(CTD_24hz,chidat,az_correction,1);
                        ylim(2.5*[-1 1])
                        print('-dpng',fullfile(chi_fig_path_specific,[whSN '_' castStr '_Fig2_w_TimeOffset']))
                        
                        % zoom in and plot again
                        xlim([nanmin(chidat.datenum)+range(chidat.datenum)/5 (nanmin(chidat.datenum)+range(chidat.datenum)/5 +300/86400)])
                        print('-dpng',fullfile(chi_fig_path_specific,[whSN '_' castStr '_Fig3_w_TimeOffset_Zoom']))
                        
                        % edit out some spikes and spurious values in CTD pressure
                        clear ib
                        ib=find(CTD_24hz.p<0);
                        CTD_24hz.p(ib)=nan;
                        clear ib
                        ib=find(abs(diff(CTD_24hz.p))>10 );
                        CTD_24hz.p(ib+1)=nan;
                        %CTD_24hz.t1(ib+1)=nan;
                                                
                        % Calibrate T and dT/dt
                        [CTD_24hz chidat]=CalibrateChipodCTD(CTD_24hz,chidat,az_correction,1);
                        print('-dpng',fullfile(chi_fig_path_specific,[whSN '_' castStr '_Fig4_dTdtSpectraCheck']))
                        
                        clear cal_good_T1 cal_good_T2
                        
                        % check if T1 calibration is ok
                        clear out2 err pvar
                        out2=interp1(chidat.datenum,chidat.cal.T1,CTD_24hz.datenum);
                        err=out2-CTD_24hz.t1;
                        pvar=100* (1-(nanvar(err)/nanvar(CTD_24hz.t1)) );
                        if pvar<95
                            disp('Warning T1 calibration not good')
                            fprintf(fileID,' *T1 calibration not good* ');
                            cal_good_T1=0;
                        else
                            cal_good_T1=1;
                        end
                        
                        if this_chi_info.isbig==1
                            % check if T2 calibration is ok
                            clear out2 err pvar
                            out2=interp1(chidat.datenum,chidat.cal.T2,CTD_24hz.datenum);
                            err=out2-CTD_24hz.t1;
                            pvar=100* (1-(nanvar(err)/nanvar(CTD_24hz.t1)) );
                            if pvar<90
                                disp('Warning T2 calibration not good')
                                fprintf(fileID,' *T2 calibration not good* ');
                                cal_good_T2=0;
                            else
                                cal_good_T2=1;
                                
                            end
                            proc_info.(whSN).T2cal(icast)=cal_good_T2;
                        else
                            cal_good_T2=nan;
                        end
                        
                        
                        proc_info.(whSN).T1cal(icast)=cal_good_T1;
                        proc_info.(whSN).toffset(icast)=chidat.time_offset_correction_used*86400; % in sec
                        
                        %~~~~
                        do_timeseries_plot=1;
                        if do_timeseries_plot
                            
                            h=ChiPodTimeseriesPlot(CTD_24hz,chidat);
                            axes(h(1))
                            title([castStr ', ' whSN '  ' datestr(time_range(1),'dd-mmm-yyyy HH:MM') '-' datestr(time_range(2),15) ', ' CTD_list(icast).name],'interpreter','none')
                            axes(h(end))
                            xlabel(['Time on ' datestr(time_range(1),'dd-mmm-yyyy')])
                            %                            print('-dpng','-r300',fullfile(chi_fig_path_specific,[whSN '_cast_' cast_suffix '_Fig5_T_P_dTdz_fspd.png']));
                            print('-dpng','-r300',fullfile(chi_fig_path_specific,[whSN '_' castStr '_Fig5_T_P_dTdz_fspd.png']));
                        end
                        %~~~~
                        
                        clear datad_1m datau_1m chi_inds p_max ind_max ctd binned_name
                        
                        binned_name=castname(1:end-17); % CTD file naming for this project is weird...                        
                        
                        if cal_good_T1==1 || cal_good_T2==1
                            
                            if exist(fullfile(CTD_out_dir_bin,[ binned_name '.mat']),'file')==2
                                load(fullfile(CTD_out_dir_bin,[ binned_name '.mat']));
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
                                if this_chi_info.isbig
                                    % 2nd sensor on 'big' chipods
                                    chi_up.T2P=chidat.cal.T2P(ind_max:length(chidat.cal.P));
                                end
                                chi_up.ctd.bin=datau_1m;
                                chi_up.ctd.raw=CTD_24hz;
                                chi_up.time_offset_correction_used=chidat.time_offset_correction_used;
                                
                                % downcast
                                chi_dn=struct();
                                chi_dn.datenum=chidat.cal.datenum(1:ind_max);
                                chi_dn.P=chidat.cal.P(1:ind_max);
                                chi_dn.T1P=chidat.cal.T1P(1:ind_max);
                                chi_dn.fspd=chidat.cal.fspd(1:ind_max);
                                chi_dn.castdir='down';
                                chi_dn.Info=this_chi_info;
                                if this_chi_info.isbig
                                    % 2nd sensor on 'big' chipods
                                    chi_dn.T2P=chidat.cal.T2P(1:ind_max);
                                end
                                chi_dn.ctd.bin=datad_1m;
                                chi_dn.ctd.raw=CTD_24hz;
                                chi_dn.time_offset_correction_used=chidat.time_offset_correction_used;
                                %~
                                
                                
                                %~~~
                                % save these data here now
                                clear fname_dn fname_up
                                
                                savedir_cal=fullfile(chi_proc_path_specific,'cal')
                                ChkMkDir(savedir_cal)
                                
                                fname_dn=fullfile(savedir_cal,[castStr '_' whSN '_downcast.mat']);
                                clear C;C=chi_dn;
                                save(fname_dn,'C')
                                fprintf(fileID,['\n Saved file: ' fname_dn])
                                
                                fname_up=fullfile(savedir_cal,[castStr '_' whSN '_upcast.mat']);
                                clear C;C=chi_up;
                                save(fname_up,'C')
                                fprintf(fileID,['\n Saved file: ' fname_up])
                                clear C
                                %~~~
                                %
                            else
                                fprintf(fileID,'\n No binned CTD file')
                            end % if we have binned ctd data
                            
                        end % cal is good
                        
                        
                    else
                        disp('no good chi data for this profile');
                        fprintf(fileID,' No chi file found ');
                        proc_info.(whSN).IsChiData(icast)=0;
                    end % if we have good chipod data for this profile
                                        
                end % SN1006 before switched to little CTD
                
            else
                disp('this file already processed')
                fprintf(fileID,' file already exists, skipping ');
            end % already processed
                        
        catch
            fprintf(fileID,['Error on icast=' num2str(icast) ', ' whSN]);
        end % try
    end % each chipod on rosette (up_down_big)
    
    % save processing info (save after each cast in case it crashes)
    proc_info.MakeInfo=['Made ' datestr(now) ' w/ ' this_script_name]
    proc_info.last_iSN=iSN;
    proc_info.last_icast=icast;
    save(fullfile(BaseDir,'Data','proc_info.mat'),'proc_info')
    
end % icast (each CTD file)

delete(hb)

telapse=toc(tstart)

% throw out any bad ranges in proc_info
proc_info.Prange(find(proc_info.Prange>8000))=nan;

proc_info.Readme={'Prange : max pressure of each CTD cast' ; ...
    'drange : time range of each cast (datenum)' ;...
    'Name : CTD filename for each cast';...
    'duration : length of cast in days'}

save(fullfile(BaseDir,'Data','proc_info.mat'),'proc_info')


%##
fprintf(fileID,['\n \n Done! \n Processing took ' num2str(telapse/60) ' mins to run']);
%##

%
%%
