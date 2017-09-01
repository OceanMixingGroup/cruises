%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Script to run all CTD-chipod processing for IO8
%
%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear ; close all


% Should only need to modify below section, and 'Load_chipod_paths_' file
%~~~~~~~~~~~~~~~~~ 
Project='IO8'

% path to 'mixingsoftware' 
mixpath = '/Users/Andy/Cruises_Research/mixingsoftware/';

%~~~~~~~~~~~~~~~~~

eval(['Load_chipod_paths_' Project])
eval(['Chipod_Deploy_Info_' Project])

 
% Add paths we will need
addpath(fullfile(mixpath,'CTD_Chipod'));
addpath(fullfile(mixpath,'CTD_Chipod','mfiles'));
addpath(fullfile(mixpath,'chipod'))    ;% raw_load_chipod.m
addpath(fullfile(mixpath,'general'))   ;% makelen.m in /general is needed
addpath(fullfile(mixpath,'marlcham'))  ;% for integrate.m
addpath(fullfile(mixpath,'adcp'))      ;% need for mergefields_jn.m in load_chipod_data

%%

PlotChipodDataRaw_General(BaseDir,chi_data_path,fig_path,ChiInfo)

%%
MakeCasts_CTDchipod_function(Project)

%%
%Plot_TP_profiles_EachCast_IO8
Plot_TP_profiles_EachCast_CTDchipod(Project)

Plot_TP_profiles_EachSN_EachCast_IO8

%PlotTimeOffsetsI08
% * replace w/ generic function that uses proc_info.mat file?

VisCheck_TP_profiles_EachCast_IO8
% * replace w/ generic function?

Plot_TP_profiles_EachCast_IO8_MarkBad

%%
DoChiCalc_IO8
% * replace w/ generic function?

%%