%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% PlotTimeOffsetsI08.m
%
% Plot chipod time offsets for I08 cruise.
%
% ** need to re-run MakeCasts w/ time offset added
%
%
%-----------------
% 05/24/16 - A.Pickering
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear ; close all

saveplot=0

Project = 'IO8'
eval(['Load_chipod_paths_' Project ])
eval(['Chipod_Deploy_Info_' Project ])


% loop through chipods
for iSN=1%:length(ChiInfo.SNs)
    
    clear whSN
    whSN=ChiInfo.SNs{iSN}
    
    % make list of files for this sensor
    clear Flist
    Flist = dir( fullfile( chi_proc_path,whSN,'cal',['*' whSN '.mat']) )
    
    tms=nan*ones(1,length(Flist));
    toffs=nan*ones(1,length(Flist));
    hb=waitbar(0)
    for icast=1:length(Flist)
        waitbar(icast/length(Flist),hb,['Working on ' whSN])
        %try
            clear chidat
            load(fullfile(  chi_proc_path,whSN,'cast',Flist(icast).name))
            toffs(icast) = chidat.time_offset_correction_used*86400;
            tms(icast) = nanmean(chidat.datenum);
        %end
    end % icast
    delete(hb)
    
    
    figure(1);clf
    agutwocolumn(0.6)
    wysiwyg
    plot(tms,toffs,'o')
    datetick('x')
    xlabel('date','fontsize',15)
    ylabel('time offset (sec)','fontsize',15)
    title([whSN])
    grid on
    
    %
    
    if saveplot==1
%        figdir='/Users/Andy/Cruises_Research/ChiPod/P16N/figures/';
        print('-dpng','-r300',fullfile(figdir,cruise,[ 'I08_' whSN '_TimeOffsets' ]))   ;
    end
    
end % wh SN

%%



%%