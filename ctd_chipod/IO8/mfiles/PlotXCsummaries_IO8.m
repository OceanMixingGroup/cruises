%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% PlotXCsummaries_IO8.m
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
% 06/14/16 - A.Pickering
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear ; close all

saveplot=1

%***
Load_chipod_paths_I08
Chipod_Deploy_Info_I08
addpath /Users/Andy/Cruises_Research/mixingsoftware/CTD_Chipod/mfiles/
%***

load(fullfile(BaseDir,'data',[ChiInfo.Project '_XC']),'XC')

xvar='lat'
%xvar='dnum'

for iSN=1:length(ChiInfo.SNs)
    clear X
    whSN=ChiInfo.SNs{iSN}
    castdir=ChiInfo.(whSN).InstDir
    whsens='T1'
    
    try
    close all
    ax=PlotChipodXC_allVars(XC,whSN,castdir,whsens,xvar);
    end
    
    if saveplot==1
        print(fullfile(BaseDir,'Figures',['XC_' whSN '_Vs_' xvar '_' castdir 'AllVars']),'-dpng')
    end
    
    
end % iSN

%%

clear ; close all

saveplot=1

%***
Load_chipod_paths_I08
Chipod_Deploy_Info_I08
load(fullfile(BaseDir,'data',[ChiInfo.Project '_XC']),'XC')
addpath /Users/Andy/Cruises_Research/ChiPod/mfiles/
%***

whvar='chi'
whvar='KT'

ax=PlotChipodXC_OneVarAllSN(XC,ChiInfo,whvar)
ylim([0 5000])

axes(ax(1))
title([ChiInfo.Project '  -  ' whvar])

linkaxes(ax)

if saveplot==1
    print(fullfile(BaseDir,'Figures',[ChiInfo.Project '_' whvar '_AllSNs_Vslat']),'-dpng')
end

%%
ax=PlotChipodXC_OneVarAllSN(XC,ChiInfo,whvar,{'SN2020','SN2003','SN2004','SN2001'})
%%
if saveplot==1
print(fullfile(BaseDir,'Figures',[ChiInfo.Project '_' whvar '_2020_2003_2004_2001']),'-dpng')
end
%%