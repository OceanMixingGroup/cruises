%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% PlotXCsummaries_Tbeam.m
%
% A template for making mostly automated summary plots of CTD0-chipod data
%
% Uses structure 'XC' made w/ Make_Combined_Chi_Struct_...
%
% %*** Indicates where changes needed for specific cruise
%
% OUTPUT
% - Plots all vars for each SN
% - Plots one var for all SN
%
% Dependencies:
% - PlotChipodXC_allVars
% - PlotChipodXC_OneVarAllSN
%
%------------
% 07/06/16 - A.Pickering - apickering@coas.oregonstate.edu
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear ; close all

saveplot=1

%***
Load_chipod_paths_Tbeam
Chipod_Deploy_Info_TTIDE_Falkor_Big
addpath /Users/Andy/Cruises_Research/mixingsoftware/CTD_Chipod/mfiles/
%***

%*** change this if not using default processing Params
Params=SetDefaultChiParams

pathstr=MakePathStr(Params)

load(fullfile(BaseDir,'data',[ChiInfo.Project '_XC_' pathstr]),'XC')

%xvar='lat'
xvar='dnum'

for iSN=1:length(ChiInfo.SNs)
    clear X
    whSN=ChiInfo.SNs{iSN}
    castdir=ChiInfo.(whSN).InstDir
    whsens='T1'
    
    if isstruct(castdir)
        castdir=castdir.(whsens)
    end
    close all
    ax=PlotChipodXC_allVars(XC,whSN,castdir,whsens,xvar);
    
    ylim([0 2000])
    
    if saveplot==1
        print(fullfile(BaseDir,'Figures',['XC_' whSN '_Vs_' xvar '_' castdir 'AllVars']),'-dpng')
    end
    
    
end % iSN

%%

close all

for ivar=1:2
    
    switch ivar
        case 1
            whvar='chi'
        case 2
            whvar='KT'
    end
    
    xvar='dnum'
    ax=PlotChipodXC_OneVarAllSN(XC,ChiInfo,whvar,xvar)
    ylim([0 5000])
    
    axes(ax(1))
    title([ChiInfo.Project '  -  ' whvar])
    
    ylim([0 2000])
    
    %    linkaxes(ax)
    
    if saveplot==1
        print(fullfile(BaseDir,'Figures',[ChiInfo.Project '_' whvar '_AllSNs_Vslat']),'-dpng')
    end
    
end % ivar

%%