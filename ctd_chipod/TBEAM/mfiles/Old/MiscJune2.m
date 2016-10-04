%~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% MiscJune2.m
%
% Load Xproc.mat from MakeCasts and summarize CTD and chippod data.
%
% check that CTD cast is >x mins, and Prange>xm, otherwise might be bad
%
%---------------
% 06/06/16 - AP
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear ; close all

cd /Users/Andy/Cruises_Research/ChiPod/Tasmania/processing/Falkor

load('Xproc.mat')

whSN='SN1001'
%whSN='SN1008'
%whSN='SN1006'
%whSN='SN1014'

Ncasts=length(Xproc.icast)
rr=3
cc=1

figure(1);clf
agutwocolumn(1)
wysiwyg

ax1=subplot(rr,cc,1);
plot(Xproc.icast,Xproc.(whSN).IsChiData,'o')
grid on
SubplotLetterMW('chi data');

ax2=subplot(rr,cc,2);
plot(Xproc.icast,Xproc.(whSN).T1cal,'o')
grid on
SubplotLetterMW('T1 cal');

ax3=subplot(rr,cc,3);
plot(Xproc.icast,Xproc.(whSN).toffset,'o')
grid on
ylabel('toffset')
xlabel('icast','fontsize',16)

linkaxes([ax1 ax2 ax3],'x')

%%

figure(1);clf
agutwocolumn(0.75)
wysiwyg

for iSN=1:4
    switch iSN
        case 1
            whSN='SN1001';
        case 2
            whSN='SN1006';
        case 3
            whSN='SN1008';
        case 4
            whSN='SN1014';
    end
    
    idg=find(Xproc.(whSN).IsChiData==1);
    
    ax1=subplot(211);
    %plot(Xproc.icast(idg),Xproc.(whSN).IsChiData(idg)+iSN-1,'o')
    plot(Xproc.(whSN).drange(idg,1),Xproc.(whSN).IsChiData(idg)+iSN-1,'o')
    hold on
    grid on
    
    ax2=subplot(212);
    plot(Xproc.icast(idg),Xproc.(whSN).IsChiData(idg)+iSN-1,'o')
%    plot(Xproc.(whSN).drange(idg,1),Xproc.(whSN).IsChiData(idg)+iSN-1,'o')
    hold on
    grid on
    
end % iSN


axes(ax1)
datetick('x')

set(gca,'YTick',1:4)
set(gca,'YTickLabel',['SN1001' ;'SN1006'; 'SN1008' ;'SN1014'])
set(gca,'Fontsize',15)
title('T-beam Falkor - Casts w/ \chi pod data')

axes(ax2)
xlabel('Cast id','fontsize',16)
set(gca,'YTick',1:4)
set(gca,'YTickLabel',['SN1001' ;'SN1006'; 'SN1008' ;'SN1014'])
set(gca,'Fontsize',15)


figdir='/Users/Andy/Cruises_Research/ChiPod/Tasmania/Figures/Falkor/'
figname='Falkor_haveChiData_all'
print(fullfile(figdir,figname),'-dpng')

%%

id1=find(Xproc.(whSN).IsChiData==1);
id2=find(Xproc.(whSN).T1cal==1);
id5=find(abs(Xproc.(whSN).toffset)<60);
id3=find(Xproc.duration*24*60 < 20)
id4=find(Xproc.Prange < 100)
idg=intersect(id2,id5);

disp([num2str(length(id3)) ' out of ' num2str(Ncasts) ' casts have duration less than 20 mins '])
disp([num2str(length(id4)) ' out of ' num2str(Ncasts) ' casts have P range less than 100 m '])

disp([num2str(length(id1)) ' out of ' num2str(Ncasts) ' casts have chi data '])
disp([num2str(length(id2)) ' out of ' num2str(Ncasts) ' casts have good T1 cal '])
disp([num2str(length(id5)) ' out of ' num2str(Ncasts) ' casts have toffset <1 min '])

disp([num2str(length(idg)) ' out of ' num2str(Ncasts) ' casts have good T1 cal AND t-offset <1 min '])

%%

clc
for iSN=1:4
    switch iSN
        case 1
            whSN='SN1001';
        case 2
            whSN='SN1006';
        case 3
            whSN='SN1008';
        case 4
            whSN='SN1014';
    end
    id1=find(Xproc.(whSN).IsChiData==1);
    id2=find(Xproc.(whSN).T1cal==1);
    id22=find(Xproc.(whSN).T2cal==1);
    id5=find(abs(Xproc.(whSN).toffset)<60);
    id3=find(Xproc.duration*24*60 < 20);
    id4=find(Xproc.Prange < 100);
    idg=intersect(id2,id5);
    
    
    
    disp([whSN ':'])
    disp('\begin{itemize}')
    
    disp([ '\item ' num2str(length(id3)) ' out of ' num2str(Ncasts) ' casts have duration less than 20 mins '])
    disp([ '\item '  num2str(length(id4)) ' out of ' num2str(Ncasts) ' casts have P range less than 100 m '])
    
    disp([ '\item '  num2str(length(id1)) ' out of ' num2str(Ncasts) ' casts have $\chi$pod data '])
    disp([ '\item '  num2str(length(id2)) ' out of ' num2str(Ncasts) ' casts have good T1 cal '])
    
    if strcmp(whSN,'SN1001')
        disp([ '\item '  num2str(length(id22)) ' out of ' num2str(Ncasts) ' casts have good T2 cal '])
    end
    disp([ '\item '  num2str(length(id5)) ' out of ' num2str(Ncasts) ' casts have toffset less than 1 min '])
    disp('\end{itemize}')
    
end

%%

