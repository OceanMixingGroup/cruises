%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Combine_XC_sensors_IO8.m
%
% Combine different chipods on each cast into one cross-section
%
%---------------
% 07/28/16 - A.Pickering
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear ; close all

%***
Load_chipod_paths_I08
Chipod_Deploy_Info_I08
mixpath='/Users/Andy/Cruises_Research/mixingsoftware/'


addpath(fullfile(mixpath,'CTD_Chipod','mfiles'))

% Params for chipod calc
Params=SetDefaultChiParams
%***

% This line unique to IO9
ChiInfo.CastString=''

pathstr=MakePathStr(Params)

% Make a list of all the 24 hz CTD casts we have
CTD_list=dir(fullfile(CTD_out_dir_24hz,['*' ChiInfo.CastString '*.mat*']));
Ncasts=length(CTD_list);
disp(['There are ' num2str(Ncasts) ' CTD casts to process in ' CTD_out_dir_24hz])

% load XC
load(fullfile(BaseDir,'data',[ChiInfo.Project '_XC_' pathstr]),'XC')

% load the visual-check good/bad indices
load(fullfile(BaseDir,'Data','GB.mat'))

% Parameters for depth-binnning
zmin=0;
dzbin=10;
zmax=6000;
zbin = [zmin:dzbin:zmax]';
minobs=2;

% Make empty structures for the combined data
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
XC.Name=[ChiInfo.Project];
XC.ChiDataDir=chi_proc_path;
XC.BinInfo=['Profiles averaged in ' num2str(dzbin) 'm bins'];
XC.allSNs=ChiInfo.SNs;
XC.castnames={CTD_list.name};

XC.lat=lat;
XC.lon=lon;
XC.dnum=dnum;

%%
% We'll combine the profiles in 3 different ways to compare: make empty
% arrays here
XC.comb1=emptystruct;
XC.comb2=emptystruct;
XC.comb3=emptystruct;

%%

for icast=1:Ncasts
    
    clear avg ctd_cast castStr ctdfile chifile chi_all GB
    
    % Name of the file we're working on
    ctd_cast=CTD_list(icast).name;
    castStr=ctd_cast(1:end-9); % Assumes file ends w/ _24hz.mat
    
    chi_all=[];
    GB=[];
    %~~ 1st get data from each sensor
    for iSN=1:length(ChiInfo.SNs)
        
        whsens='T1';
        clear whSN castdir
        whSN=ChiInfo.SNs{iSN};
        castdir=ChiInfo.(whSN).InstDir.(whsens);
        
        % Name of the processed chipod file (if it exists)
        chifile=fullfile(chi_proc_path,whSN,'avg',pathstr,['avg_' castStr '_' castdir 'cast_' whSN '_' whsens '.mat'] )         ;
        
        try
            clear avg
            load(chifile)
            [chichi zout ] = binprofile(avg.chi1  ,avg.P, zmin, dzbin, zmax,minobs );
            chi_all=[chi_all chichi(:)];
            GB=[GB GBinds.(whSN)(icast)];
            XC.lat(icast)=nanmean(avg.lat);
            XC.dnum(icast)=naneman(avg.datenum);

        end
    end % iSN
    
    
    %~~ Now we'll combine them in different methods
    % method (1) - mean of all profiles
    try
        XC.comb1.chi(:,icast)=nanmean(chi_all,2);
    end
    
    % method (2) - mean of all 'good' profiles
    try
        XC.comb2.chi(:,icast)=nanmean(chi_all(:,find(GB==1)),2);
    end
    
    % method (3) - min of all profiles
    try
        XC.comb3.chi(:,icast)=nanmin(chi_all,[],2);
        %        XC.comb3.chi(:,icast)=nanmin(chi_all(:,find(GB==1)),[],2);
    end
    

    
end % icast

XC.icast=1:Ncasts;
XC.P=zmin:dzbin:zmax;
XC.P=XC.P(:);
%%

figure(1);clf
agutwocolumn(1)
wysiwyg

cl=[-12 -5]

subplot(311)
ezpc(XC.icast,XC.P,log10(XC.comb1.chi))
colorbar
caxis(cl)
title('mean of all sensors')
xlabel('icast')
ylabel('Depth')

subplot(312)
ezpc(XC.icast,XC.P,log10(XC.comb2.chi))
colorbar
caxis(cl)
title('mean of all GOOD sensors')
xlabel('icast')
ylabel('Depth')

subplot(313)
ezpc(XC.icast,XC.P,log10(XC.comb3.chi))
colorbar
caxis(cl)
title('minimum of all sensors')
xlabel('icast')
ylabel('Depth')

%%

save(fullfile(BaseDir,'Data',[ChiInfo.Project '_XCcomb_' pathstr]),'XC')

%%