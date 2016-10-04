%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% MakeSummaryTableFalkor.m
%
% Make Latex table showing which casts we have chipod data for.
%
% Uses data from Xproc.mat, made in MakeCasts_CTDchipod_Falkor_Big.m
%
%------------------
% 06/07/16 - A.Pickering - apickering@coas.oregonstate.edu
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%
clear ; close all

cd /Users/Andy/Cruises_Research/ChiPod/Tasmania/processing/Falkor

load('Xproc.mat')

clc
disp('/hline')
disp(['icast' and 'Name' and 'SN1001' and 'SN1006' and 'SN1008' and 'SN1014' ])
disp('/hline /hline')
for icast=1:length(Xproc.icast)
    and=' & ';
    disp([num2str(Xproc.icast(icast)) and '\verb+' Xproc.Name{icast} '+' and num2str(Xproc.SN1001.IsChiData(icast)) ...
        and num2str(Xproc.SN1006.IsChiData(icast)) and num2str(Xproc.SN1008.IsChiData(icast))...
        and num2str(Xproc.SN1014.IsChiData(icast)) ' \\ '])
end
%%