
%%
clear ; close all
%datapath='/Users/Andy/Cruises_Research/ChiPod/Tasmania/Data/Falkor/chipod/channel4/SN1001'
%datapath='/Users/Andy/Cruises_Research/ChiPod/Tasmania/Data/Falkor/chipod/1001'
datapath='/Users/Andy/Cruises_Research/ChiPod/Tasmania/Data/Falkor/chipod/channel123_wHead'
%datapath='/Users/Andy/Cruises_Research/ChiPod/Tasmania/Data/Falkor/chipod/channel123/SN1001'
fname='F15012502.A1001'
fname='F15012710.A1001'
%fname='XX15012416.A1001'
%fname='F915021104.A1001'
%fname='ttide_raw_15021004.1001'
[data head]=raw_load_chipod(fullfile(datapath,fname));
%[data head]=raw_load_chipod_copy(fullfile(datapath,fname));
%[out,counter]=load_mini_chipod(fullfile(datapath,fname));
%[out,counter]=load_mini_chipod(fullfile(datapath,fname),8400);
%%