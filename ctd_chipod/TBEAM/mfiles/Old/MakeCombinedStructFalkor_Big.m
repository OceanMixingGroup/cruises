%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% MakeCombinedStructFalkor_Big.m
%
% Combine all CTD-chipod profiles from Falkor into one structure
%
%----------------------------------
% 06/06/16 - AP - A. Pickering - apickering@coas.oregonstate.edu
% 06/07/16 - AP - Do up and down casts
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% Make a transect vs lat

clear ; close all

Load_chipod_paths_TTide_Falkor
Chipod_Deploy_Info_TTIDE_Falkor_Big

savedata=0

% Make a list of all the 24 hz CTD casts we have
CTD_list=dir(fullfile(CTD_out_dir_24hz,['*' ChiInfo.CastString '*.mat*']));
Ncasts=length(CTD_list);
disp(['There are ' num2str(Ncasts) ' CTD casts to process in ' CTD_out_dir_24hz])
%

% Params for chipod processing (determines file paths to proc data)
Params.z_smooth=20;  % distance (m) over which to smooth N^2 and dT/dz
Params.nfft=128;     % nfft to use in computing wavenumber spectra
Params.TPthresh=1e-6 % minimum TP variance to do calculation
Params.fmax=7;       % max freq to integrate TP spectrum to in chi calc
Params.resp_corr=0;  % correct TP spectra for freq response of thermistor
Params.fc=99;        % cutoff frequency for response correction
Params.gamma=0.2;    % mixing efficiency

% Naming string for chipod files based on params
params_str=['zsm' num2str(Params.z_smooth) 'm_fmax' num2str(Params.fmax) 'Hz_respcorr' num2str(Params.resp_corr) '_fc_' num2str(Params.fc) 'hz_gamma' num2str(Params.gamma*100)]

whsens='T1';

%BaseDir='/Users/Andy/Cruises_Research/ChiPod/P16N/';

% parameters for depth-binnning
zmin=0;
dzbin=10;
zmax=6000;
zbin = [zmin:dzbin:zmax]';

lat=nan*ones(1,Ncasts);
lon=nan*ones(1,Ncasts);
dnum=nan*ones(1,Ncasts);
eps=nan*ones(length(zbin),Ncasts);
chi=eps;
KT=eps;
dTdz=eps;
N2=eps;
t=eps;
s=eps;
TPvar=eps;

emptystruct=struct('lat',lat,'lon',lon,'dnum',dnum,'TPvar',TPvar,'eps',eps,'chi',chi,'KT',KT,'dTdz',dTdz,'N2',N2,'t',t,'s',s);

XC=struct();
XC.Name=['FAlkor'];
XC.ChiDataDir=chi_proc_path;
XC.MakeInfo=['Made ' datestr(now) ' w/ MakeCombinedStructFAlkor_Big.m'];
XC.BinInfo=['Profiles averaged in ' num2str(dzbin) 'm bins'];
XC.allSNs=ChiInfo.SNs;
XC.castnames={};

minobs=2;

hb=waitbar(0)
%
% Loop through each sensor
for iSN=1:length(ChiInfo.SNs)
    
    clear whSN castdir
    whSN=ChiInfo.SNs{iSN};
    
    for idir=1:2
        
        switch idir
            case 1
                castdir='up'
            case 2
                castdir='down'
        end
        
        if ChiInfo.(whSN).isbig
            ntodo=2;
        else
            ntodo=1;
        end
        
        for isens=1:ntodo
            switch isens
                case 1
                    whsens='T1';
                case 2
                    whsens='T2'
            end
            XC.([whSN '_' castdir '_' whsens])=emptystruct ;
            
            % Start a waitbar
            waitbar(iSN/length(ChiInfo.SNs),hb,['Getting profiles for ' whSN])
            
            % Loop through each cast
            for icast=1:Ncasts
                
                clear avg ctd ctdfile chifile
                
                % Name of the file we're working on
                ctd_cast=CTD_list(icast).name;
                castStr=ctd_cast(1:end-8); % Assumes file ends w/ _raw.mat
                
                % Name of the processed chipod file (if it exists)
                % later
                chifile=fullfile(chi_proc_path,whSN,'avg',params_str,['avg_' castStr '_' castdir 'cast_' whSN '_' whsens '.mat'] )         ;
                
                if  exist(chifile,'file')==2 && ~strcmp(ctd_cast,'ox_test_24hz.mat') && ~strcmp(ctd_cast,'99702_24hz.mat')
                    clear avg ctd
                    %load(ctdfile)
                    load(chifile)
                    
                    avg.P(find(avg.P<0))=nan;
                    
                    [XC.([whSN '_' castdir '_' whsens]).TPvar(:,icast) zout ] = binprofile(avg.TP1var,avg.P, zmin, dzbin, zmax,minobs );
                    [XC.([whSN '_' castdir '_' whsens]).eps(:,icast)   zout ] = binprofile(avg.eps1  ,avg.P, zmin, dzbin, zmax,minobs );
                    [XC.([whSN '_' castdir '_' whsens]).chi(:,icast)   zout ] = binprofile(avg.chi1  ,avg.P, zmin, dzbin, zmax,minobs );
                    [XC.([whSN '_' castdir '_' whsens]).KT(:,icast)    zout ] = binprofile(avg.KT1   ,avg.P, zmin, dzbin, zmax,minobs );
                    [XC.([whSN '_' castdir '_' whsens]).dTdz(:,icast)  zout ] = binprofile(avg.dTdz  ,avg.P, zmin, dzbin, zmax,minobs );
                    [XC.([whSN '_' castdir '_' whsens]).N2(:,icast)    zout ] = binprofile(avg.N2    ,avg.P, zmin, dzbin, zmax,minobs );
                    
                    [XC.([whSN '_' castdir '_' whsens]).t(:,icast) zout]   =binprofile(avg.T,avg.P, zmin, dzbin, zmax,minobs);
                    [XC.([whSN '_' castdir '_' whsens]).s(:,icast) zout]   =binprofile(avg.S,avg.P, zmin, dzbin, zmax,minobs);
                    %                   lat(icast)=nanmean(ctd.lat);
                    %                    lon(icast)=nanmean(ctd.lon);
                    XC.([whSN '_' castdir '_' whsens]).lon(icast)=nanmean(ctd.lon);
                    XC.([whSN '_' castdir '_' whsens]).lat(icast)=nanmean(ctd.lat);
                    XC.([whSN '_' castdir '_' whsens]).dnum(icast)=nanmean(ctd.datenum);
                end
                
                %pause
                
            end % wh cast
            XC.([whSN '_' castdir '_' whsens]).P=zbin;
            %
            %            idb=find(XC.([whSN '_' castdir '_' whsens]).dTdz<0);
            %            XC.([whSN '_' castdir '_' whsens]).dTdz(idb)=nan;
            
        end % whsens
        
    end % idir (castdir)
    
end % wh SN

delete(hb)

if savedata==1
    save(fullfile(BaseDir,'data',['I08_XC']),'XC')
end

%%

whSN='SN1001';castdir='up'
%whSN='SN1006';castdir='up'
%whSN='SN1008';castdir='down'
whSN='SN1014';castdir='up'

X=XC.([whSN '_' castdir '_' whsens])
%addpath /Users/Andy/Cruises_Research/ChiPod/mfiles/
addpath /Users/Andy/Cruises_Research/mixingsoftware/CTD_Chipod/mfiles/
close all
%ax=PlotChipodXC_allVars(XC,whSN,castdir);

%%

saveplot=1

whSN='SN1001';
%whSN='SN1008'
%whSN='SN1006'
%whSN='SN1014'

yl=[0 2100]

whsens='T2'
whvar='chi'

figure(1);clf

castdir='down'
X=XC.([whSN '_' castdir '_' whsens]);
X.dnum(find(X.dnum==0))=nan;
ax1=subplot(211);
%ezpc(1:length(X.lat),X.P,log10(X.(whvar)))
ezpc(X.dnum,X.P,log10(X.(whvar)))
hold on
plot(X.dnum,0,'kd')
cb=colorbar
caxis([-10 -5]);
title([whSN ' ' castdir 'cast ' whsens ' log_{10} ' whvar])
ylim(yl)
%xlabel('icast','fontsize',16)
datetick('x')
ylabel('Pressure [db]','fontsize',16)
%
if strcmp(whSN,'SN1001')
    xlim([datenum(2015,1,31) nanmax(X.dnum)])
end

castdir='up'
X=XC.([whSN '_' castdir '_' whsens]);
X.dnum(find(X.dnum==0))=nan;
ax2=subplot(212);
%ezpc(1:length(X.lat),X.P,log10(X.(whvar)))
ezpc(X.dnum,X.P,log10(X.(whvar)))
hold on
plot(X.dnum,0,'kd')

cb=colorbar;
caxis([-10 -5])
title([whSN ' ' castdir 'cast ' whsens ' log_{10} ' whvar])
ylim(yl)
%xlabel('icast','fontsize',16)
datetick('x')
ylabel('Pressure [db]','fontsize',16)

if strcmp(whSN,'SN1001')
    xlim([datenum(2015,1,31) nanmax(X.dnum)])
end

linkaxes([ax1 ax2])

if saveplot==1
    figdir='/Users/Andy/Cruises_Research/ChiPod/Tasmania/Figures/Falkor/'
    figname=[whSN '_' whvar '_' whsens '_UpDownPcolor']
    print(fullfile(figdir,figname),'-dpng')
end

%%