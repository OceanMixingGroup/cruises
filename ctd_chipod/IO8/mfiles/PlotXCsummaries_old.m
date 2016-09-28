%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% PlotXCsummaries.m
%
%
%------------
% 05/24/16 - A.Pickering
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear ; close all

saveplot=1

addpath /Users/Andy/Cruises_Research/ChiPod/IO8/mfiles/
%addpath /Users/Andy/Cruises_Research/ChiPod/mfiles/
addpath /Users/Andy/Cruises_Research/mixingsoftware/CTD_Chipod/mfiles/

Load_chipod_paths_I08

load(fullfile(BaseDir,'data',['I08_XC']),'XC')

for whcase=1:8
    try
        switch whcase
            case 1
                whSN='SN1013';castdir='up'
            case 2
                whSN='SN2020';castdir='up'
            case 3
                whSN='SN2014';castdir='up'
            case 4
                whSN='SN2009';castdir='up'
            case 5
                whSN='SN2004';castdir='down'
            case 6
                whSN='SN2003';castdir='up'
            case 7
                whSN='SN2002';castdir='down'
            case 8
                whSN='SN2001';castdir='down'
        end
        
        clear X
        X=XC.([whSN '_' castdir])
        
        close all
        ax=PlotChipodXC_allVars(XC,whSN,castdir);
        
        if saveplot==1
            print(fullfile(BaseDir,'Figures',['XC_' whSN '_' castdir 'AllVars']),'-dpng')
        end
        
    end % try
    
end % whcase

%%

clear ; close all

Load_chipod_paths_I08

Chipod_Deploy_Info_I08

load(fullfile(BaseDir,'data',['I08_XC']),'XC')

addpath /Users/Andy/Cruises_Research/ChiPod/mfiles/

whvar='chi'
%whvar='N2'
whvar='dTdz'
whvar='KT'

ax=PlotChipodXC_OneVarAllSN(XC,ChiInfo,whvar,{'SN1013','SN2009','SN2002'})
%ax=PlotChipodXC_OneVarAllSN(XC,ChiInfo,whvar)
ylim([0 5000])

axes(ax(1))
title(['I08  -  ' whvar])

print(fullfile(BaseDir,'Figures',['I08_' whvar '_1013_2009_2002']),'-dpng')
%%
%%

clear ; close all

Load_chipod_paths_I08

Chipod_Deploy_Info_I08

load(fullfile(BaseDir,'data',['I08_XC']),'XC')

addpath /Users/Andy/Cruises_Research/ChiPod/mfiles/

whvar='chi'
%whvar='N2'
%whvar='dTdz'
%whvar='KT'

ax=PlotChipodXC_OneVarAllSN(XC,ChiInfo,whvar,{'SN2020','SN2003','SN2004','SN2001'})
%ax=PlotChipodXC_OneVarAllSN(XC,ChiInfo,whvar)
%ylim([0 5000])

axes(ax(1))
title(['I08  -  ' whvar])

print(fullfile(BaseDir,'Figures',['I08_' whvar '_2020_2003_2004_2001']),'-dpng')
%%