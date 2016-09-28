%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% MakeCombinedStructI08.m
%
% Combine all CTD-chipod profiles from IO8 into one structure
%
%----------------------------------
% 05/24/16 - AP - A. Pickering - apickering@coas.oregonstate.edu
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% Make a transect vs lat

clear ; close all

Load_chipod_paths_I08
Chipod_Deploy_Info_I08

savedata=1

% CTD files don't have the 'I08' prefix in this dataset
ChiInfo.CastString=''
 
% Make a list of all the 24 hz CTD casts we have
CTD_list=dir(fullfile(CTD_out_dir_24hz,['*' ChiInfo.CastString '*.mat*']));
Ncasts=length(CTD_list);
disp(['There are ' num2str(Ncasts) ' CTD casts to process in ' CTD_out_dir_24hz])

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
eps=nan*ones(length(zbin),Ncasts);
chi=eps;
KT=eps;
dTdz=eps;
N2=eps;
t=eps;
s=eps;
TPvar=eps;

emptystruct=struct('lat',lat,'lon',lon,'TPvar',TPvar,'eps',eps,'chi',chi,'KT',KT,'dTdz',dTdz,'N2',N2,'t',t,'s',s);

XC=struct();
XC.Name=['I08'];
XC.ChiDataDir=chi_proc_path;
XC.MakeInfo=['Made ' datestr(now) ' w/ MakeCombinedStructI08.m'];
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
    castdir=ChiInfo.(whSN).InstDir   ; % only get 'clean' data
    XC.([whSN '_' castdir])=emptystruct ;
    
    % Start a waitbar
    waitbar(iSN/length(ChiInfo.SNs),hb,['Getting profiles for ' whSN])
    
    % Loop through each cast
    for icast=1:Ncasts

        clear avg ctd ctdfile chifile
        
        % Name of the file we're working on
        ctd_cast=CTD_list(icast).name;
        castStr=ctd_cast(1:end-9) % Assumes file ends w/ _24Hz.mat
        
        % Name of the processed chipod file (if it exists)
        % later
        chifile=fullfile(chi_proc_path,whSN,'avg',params_str,['avg_' castStr '_' castdir 'cast_' whSN '_' whsens '.mat'] )         ;
        
        if  exist(chifile,'file')==2 && ~strcmp(ctd_cast,'ox_test_24hz.mat') && ~strcmp(ctd_cast,'99702_24hz.mat')
            clear avg ctd
%           load(ctdfile)
            load(chifile)
            
            avg.P(find(avg.P<0))=nan;
            
            [XC.([whSN '_' castdir]).TPvar(:,icast) zout ] = binprofile(avg.TP1var,avg.P, zmin, dzbin, zmax,minobs );
            [XC.([whSN '_' castdir]).eps(:,icast)   zout ] = binprofile(avg.eps1  ,avg.P, zmin, dzbin, zmax,minobs );
            [XC.([whSN '_' castdir]).chi(:,icast)   zout ] = binprofile(avg.chi1  ,avg.P, zmin, dzbin, zmax,minobs );
            [XC.([whSN '_' castdir]).KT(:,icast)    zout ] = binprofile(avg.KT1   ,avg.P, zmin, dzbin, zmax,minobs );
            [XC.([whSN '_' castdir]).dTdz(:,icast)  zout ] = binprofile(avg.dTdz  ,avg.P, zmin, dzbin, zmax,minobs );
            [XC.([whSN '_' castdir]).N2(:,icast)    zout ] = binprofile(avg.N2    ,avg.P, zmin, dzbin, zmax,minobs );
                        
            [XC.([whSN '_' castdir]).t(:,icast) zout]   =binprofile(avg.T,avg.P, zmin, dzbin, zmax,minobs);
            [XC.([whSN '_' castdir]).s(:,icast) zout]   =binprofile(avg.S,avg.P, zmin, dzbin, zmax,minobs);
            lat(icast)=nanmean(ctd.lat);
            lon(icast)=nanmean(ctd.lon);
            XC.([whSN '_' castdir]).lon(icast)=nanmean(ctd.lon);
            XC.([whSN '_' castdir]).lat(icast)=nanmean(ctd.lat);
        end
        
        %pause
        
    end % wh cast
                XC.([whSN '_' castdir]).P=zbin;
    %
    idb=find(XC.([whSN '_' castdir]).dTdz<0);
    XC.([whSN '_' castdir]).dTdz(idb)=nan;
    
end % wh SN

delete(hb)

if savedata==1
    save(fullfile(BaseDir,'data',['I08_XC']),'XC')
end

%%
whSN='SN1013';castdir='up'
%whSN='SN2002';castdir='down'
%whSN='SN2009';castdir='up'
X=XC.([whSN '_' castdir])

close all
ax=PlotChipodXC_allVars(XC,whSN,castdir);
%%
for wht=1:length(X.lat)
figure(1);clf
semilogx(X.chi(:,wht),X.P(:,wht))
axis ij
pause(1)
end
