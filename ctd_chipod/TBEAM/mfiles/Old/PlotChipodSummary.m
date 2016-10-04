%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% PlotChipodSummary.m
%
% Make a summary plot of processed chipod data: Bin and pcolor each
% profile vs cast #.
%
% Originally written for Falkor TTIDE data, but trying to keep as general as possible with paths, SNs etc. so it can be
% applied to other datasets as well.
%
%----------------
% 12/18/15 - A.Pickering - apickering@coas.oregonstate.edu
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear ; close all

saveplot=0

Load_chipod_paths_TTide_Falkor

Chipod_Deploy_Info_TTIDE_Falkor_Big

% get list of CTD cast names
ctdlist=dir(fullfile(CTD_data_dir,['*' ChiInfo.CastString '*.mat']))
%%
zmin=0;
dzbin=10;
zmax=2100;
minobs=3
zbin = [zmin:dzbin:zmax]';
nb = length(zbin);
%zvec=0:2000;


for iSN=1%:length(ChiInfo.SNs)
    
    clear epsup epsdn
    epsup=nan*ones(nb,length(ctdlist));
    epsdn=nan*ones(nb,length(ctdlist));
    
    whSN=ChiInfo.SNs{iSN}
    
    %
    for icast=1:length(ctdlist)
        
        clear ctdfile
        ctdfile=ctdlist(icast).name;
        
        %    whSN='SN1006';
        %    whSN='SN1008';
        %        whSN='SN1014';
        if strcmp(whSN,'SN1001')
        whsens='T2'
        else
        whsens='T1';
        end
        
        castdir='up';
        chifile=fullfile(chi_proc_path,whSN,'avg',['avg_cast_' ctdfile(10:15) '_' whSN '_' castdir 'cast_' whsens '.mat'])
        try
            clear avg
            load(chifile)
            % bin profile
            [epsup(:,icast) zout Nobs] = binprofile(avg.eps1,avg.P, zmin, dzbin, zmax,minobs);
        end
        
        castdir='down';
        chifile=fullfile(chi_proc_path,whSN,'avg',['avg_cast_' ctdfile(10:15) '_' whSN '_' castdir 'cast_' whsens '.mat'])
        try
            clear avg
            load(chifile)
            % bin profile
            [epsdn(:,icast) zout Nobs] = binprofile(avg.eps1,avg.P, zmin, dzbin, zmax,minobs);
        end
        
        
    end % icast
    
    %
    figure(1);clf
    agutwocolumn(1)
    wysiwyg
    
    if strcmp(whSN,'SN1006')
        xl=[0 20]
    else
    xl=[45 117]
    end
    
    ax1=subplot(211)
    ezpc(1:length(ctdlist),zout,log10(epsup))
    xlim(xl)
    caxis([-11 -5])
    cb=colorbar;
    cb.Label.String='log_{10}\epsilon';
    cb.Label.FontSize=16;
    ylabel('pressure [db]')
    xlabel('cast #')
    title([whSN ' - ' whsens ' upcast'])
    
    ax2=subplot(212)
    ezpc(1:length(ctdlist),zout,log10(epsdn))
    xlim(xl)
    caxis([-11 -5])
    cb=colorbar;
    cb.Label.String='log_{10}\epsilon';
    cb.Label.FontSize=16;
    ylabel('pressure [db]')
    xlabel('cast #')
    title([whSN ' - ' whsens ' downcast'])
    
    linkaxes([ax1 ax2])
    
    % save figure
    
    if saveplot==1
        print(fullfile('/Users/Andy/Cruises_Research/ChiPod/Tasmania/Figures/Falkor',[whSN '_alleps_up_down']),'-dpng')
    end
    
end % iSN

%%