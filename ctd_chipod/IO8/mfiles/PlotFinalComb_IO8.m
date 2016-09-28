%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% PlotFinalComb_IO8.m
%
% Plot the 'final' combined profiles made in Combine_XC_sensors_IO8.m
%
%------------
% 07/28/16 - A.Pickering - apickering@coas.oregonstate.edu
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear ; close all

Load_chipod_paths_I08
Chipod_Deploy_Info_I08

Params=SetDefaultChiParams
pathstr=MakePathStr(Params)

% x-variable to plot against
xvar='lat'

load(fullfile(BaseDir,'Data',['IO8_XC_' pathstr '.mat']))
XC1=XC;clear XC

load(fullfile(BaseDir,'Data',['IO8_XCcomb_' pathstr '.mat']))


figure(1);clf
agutwocolumn(1)
wysiwyg

set(gcf,'defaultaxesfontsize',14)

ax1=subplot(311);
ezpc(XC.(xvar),XC.P,log10(XC1.SN1013_down_T1.dTdz));
cb=colorbar;
cb.Label.String='log_{10}dTdz';
cb.FontSize=14;
ylim([0 nanmax(XC.P)])
title([ChiInfo.Project ' final combined profiles '])
caxis([-5 -0.5])
xlabel(xvar,'fontsize',16)
ylabel('Pres. [db]','fontsize',16)

ax2=subplot(312);
ezpc(XC.(xvar),XC.P,log10(XC1.SN1013_down_T1.N2));
cb=colorbar;
cb.Label.String='log_{10}N^2';
cb.FontSize=14;
ylim([0 nanmax(XC.P)])
caxis([-7 -3])
xlabel(xvar,'fontsize',16)
ylabel('Pres. [db]','fontsize',16)


ax3=subplot(313);
ezpc(XC.(xvar),XC.P',log10(XC.comb3.chi));
cb=colorbar;
cb.Label.String='log_{10}\chi';
cb.FontSize=14;
ylim([0 nanmax(XC.P)])
caxis([-12 -5])
xlabel(xvar,'fontsize',16)
ylabel('Pres. [db]','fontsize',16)

linkaxes([ax1 ax2 ax3])

%%