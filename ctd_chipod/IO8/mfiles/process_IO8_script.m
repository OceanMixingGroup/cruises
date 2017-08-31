%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Script to run all CTD-chipod processing for IO8
%
%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear ; close all

Project='IO8'

PlotChipodDataRaw_I08

MakeCasts_CTDchipod_function(Project)

Plot_TP_profiles_EachCast_IO8

Plot_TP_profiles_EachSN_EachCast_IO8

PlotTimeOffsetsI08

VisCheck_TP_profiles_EachCast_IO8

Plot_TP_profiles_EachCast_IO8_MarkBad

DoChiCalc_IO8

%%