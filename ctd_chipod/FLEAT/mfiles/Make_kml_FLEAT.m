%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Make_kml_FLEAT.m
%
%----------------
% 09/16/16 - A.Pickering - andypicke@gmail.com
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear ; clc ; close all

project='FLEAT'

cruisedir='/Users/Andy/Cruises_Research/OceanMixingGroup/cruises/ctd_chipod/FLEAT/'
addpath(fullfile(cruisedir,'mfiles'))
%addpath(fullfile('/Users/Andy/Cruises_Research/ChiPod/',project,'mfiles'))

eval(['Load_chipod_paths_' project ])
%
load(fullfile(BaseDir,'Data','proc_info'))
%
kmlwrite(fullfile(BaseDir,'Data',[project 'kml']),proc_info.lat,proc_info.lon,'color','r')

%%