%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Script to run all CTD-chipod processing for IO8
%
%
%--------------
% A.Pickering - andypicke@gmail.com
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear ; close all


% *** Should only need to modify below section, 'Load_chipod_paths_', and 
% Chipod_Deploy_Info_... files
%~~~~~~~~~~~~~~~~~ 
the_project='IO8'

% path to 'mixingsoftware' 
mixpath = '/Users/Andy/Cruises_Research/mixingsoftwae/';

%~~~~~~~~~~~~~~~~~

eval(['Load_chipod_paths_' the_project])
eval(['Chipod_Deploy_Info_' the_project])


status_out = check_data_struct_ctd_chipod(the_project,mixpath);
if status_out~=1
    error('error: missing or incorrect folder structure')
end


% Add paths we will need
addpath(fullfile(mixpath,'CTD_Chipod'));
addpath(fullfile(mixpath,'CTD_Chipod','mfiles'));
addpath(fullfile(mixpath,'chipod'))    ;% raw_load_chipod.m
addpath(fullfile(mixpath,'general'))   ;% makelen.m in /general is needed
addpath(fullfile(mixpath,'marlcham'))  ;% for integrate.m
addpath(fullfile(mixpath,'adcp'))      ;% need for mergefields_jn.m in load_chipod_data

%% Make plots of the raw chipod files

PlotChipodDataRaw_General(the_project,mixpath)

%% Make 'casts'; get chipod data for each CTD profile and save separately

MakeCasts_CTDchipod_function(the_project,mixpath)

%% Plot chipod TP for each cast/instrument

Plot_TP_profiles_EachCast_CTDchipod(the_project)

%%
% replace w/ generic***
%Plot_TP_profiles_EachSN_EachCast_IO8

%% Make a summary of chipod data/processing

SummarizeChiProc(the_project)

%% Optional; inspect and mark bad profiles so they don't get processed

%VisCheck_TP_profiles_EachCast_IO8
% * replace w/ generic function?

%Plot_TP_profiles_EachCast_IO8_MarkBad

%% Do the actual chipod calc for each profile 

% * Uses default Params for now, need to add Params option to function
% input
do_chi_calc_ctd_chipod(the_project,mixpath)

%% Combine all profiles into a single structure 'XC'

XC = make_combined_chi_struct(the_project,mixpath)

%% Make some standard plots (ie depth-lat transects) from 'XC'

plot_XC_summaries(the_project)

%% Write automated latex notes file w/ some standard info and plots

Write_Latex_Notes(the_project)


%%