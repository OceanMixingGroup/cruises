%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% PlotTimeOffsets_TTIDE_Falkor.m
%
% Plot chipod time offsets for Falkor TTIDE cruises.
%
%-----------------
% 02/16/16 - A.Pickering
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear ; close all

saveplot=0


Chipod_Deploy_Info_TTIDE_Falkor_Big
Load_chipod_paths_TTide_Falkor

% loop through chipods
for iSN=4%1:length(ChiInfo.SNs)
    
    clear whSN
    whSN=ChiInfo.SNs{iSN}
    
    % make list of files for this sensor
    clear Flist
    Flist=dir( fullfile( chi_proc_path,whSN,'cal',['*' whSN '.mat']) )
    
    tms=nan*ones(1,length(Flist));
    toffs=nan*ones(1,length(Flist));
    hb=waitbar(0)
    for icast=1:length(Flist)
        waitbar(icast/length(Flist),hb,['Working on ' whSN])
        try
            clear chidat
            load(fullfile(  chi_proc_path,whSN,'cal',Flist(icast).name))
            toffs(icast)=chidat.time_offset_correction_used*86400;
            tms(icast)=nanmean(chidat.datenum);
        end
    end
    delete(hb)
    
    
    figure(1);clf
    agutwocolumn(0.6)
    wysiwyg
    plot(tms,toffs,'o')
    datetick('x',2)
    xlabel('date','fontsize',15)
    ylabel('time offset (sec)','fontsize',15)
    title([ChiInfo.Project whSN])
    grid on
    gridxy
    
    %
    
    if saveplot==1
%        figdir='/Users/Andy/Cruises_Research/ChiPod/P16N/figures/';
 %       print('-dpng','-r300',fullfile(figdir,cruise,['P16N_' cruise '_' whSN '_TimeOffsets' ]))   ;
    end
    
end % wh SN

%%



%%