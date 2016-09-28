%%

% clear ; close all
% 
% addpath /Users/Andy/Cruises_Research/ChiPod/I08S/mfiles/
% 
% Load_chipod_paths_I08
% 
% load(fullfile(BaseDir,'data',['I08_XC']),'XC')

%kmlwrite(fullfile(BaseDir,'Data','I08kml'),XC.SN1013_up.lat,XC.SN1013_up.lon,'color','r','Icon',{'p'})

%% Use CTD casts instead

clear ; close all

addpath /Users/Andy/Cruises_Research/ChiPod/I08S/mfiles/

Load_chipod_paths_I08

Chipod_Deploy_Info_I08

% Make list of which CTD casts we have processed
CTDlist=dir([CTD_out_dir_bin '/*.mat'])
Ncasts=length(CTDlist)
%
lats=nan*ones(1,Ncasts);
lons=nan*ones(1,Ncasts);

hb=waitbar(0)
for icast=1:Ncasts
load(fullfile(CTD_out_dir_bin,CTDlist(icast).name))    
    lats(icast)=nanmean(datad_1m.lat);
    lons(icast)=nanmean(datad_1m.lon);
end

kmlwrite(fullfile(BaseDir,'Data','I08kml'),lats,lons,'color','r')
%%

