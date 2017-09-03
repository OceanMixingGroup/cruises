%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Plot_TP_profiles_EachCast_IO8.m
%
% Template for script to plot TP profiles from all chipods for each
% cast. Allows comparison of TP from different sensors.
%
%
% Dependencies:
% Load_chipod_paths_Template.m
% Chipod_Deploy_Info_Template.m
% MakeCasts... needs to be run first
%
%-----------------
% 07/28/16 - A.Pickering - apickering@coas.oregonstate.edu
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% Plot T' profiles from each sensor/cast direction for one cast
% trying to assess which sensors are clean/noisy

clear ; close all

Project = 'IO8'

Plot_TP_profiles_EachCast_CTDchipod(Project)

%%