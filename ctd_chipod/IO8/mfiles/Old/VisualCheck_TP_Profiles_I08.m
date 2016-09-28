%~~~~~~~~~~~~~~~~~~
%
% VisualCheck_TP_Profiles_I09.m
%
% Script to cycle through chipod TP profiles for different cast #s
% and visually mark as good or bad, to edit out obviously bad data.
%
% This will be run after MakeCasts, but before DoChiCalc. Before I was
% doing this after the DoChiCalc, but there were a lot of profiles that
% were bad and I was wasting a lot of time processing those.
%
%
% Modified from VisualCheckChipodProfiles.m
%
% OUTPUT ?
%
% Saves a file with field 'isgood' that can
% be loaded later and used to edit out bad profiles when combining into
% transects or plotting.
%
%
%------------------------------
% 05/19/16 - A. Pickering - apickering@coas.oregonstate.edu
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear ; close all

savedata=1
% choose which Leg to do


Load_chipod_paths_I09
Chipod_Deploy_Info_I09

%ChkMkDir

% we use T1 sensor unless it is a big chipod
whsens='T1'
%~~~~

BaseDir='/Users/Andy/Cruises_Research/ChiPod/I09/';

% Loop over each SN
for iSN=1:length(ChiInfo.SNs)
    
    clear whSN 
    whSN=ChiInfo.SNs{iSN}
    
    % Make a list of all the cast files we have for this SN
    clear Flist
    Flist = dir( fullfile( chi_proc_path, whSN,'cal',['*' whSN '*.mat']) )
    Ncasts=length(Flist)
    
    %isgood.([whSN '_' castdir])=ones(1,Ncasts);
    isgood=nan*ones(1,Ncasts);

    %
    for whfile=1:Ncasts%
        clear avg ctd whcast chifile ctdfile_bin ctdfile_raw chifile1
        try
        % load the file
        clear C
        load( fullfile( chi_proc_path, whSN,'cal',Flist(whfile).name))
                
        figure(1);clf
        agutwocolumn(1)
%        wysiwyg
        plot(C.T1P,C.P)
        xlim(0.3*[-1 1])
        ylim([0 nanmax(C.P)])
        axis ij
        grid on
        gridxy
        title([ whSN ' ' Flist(whfile).name],'interpreter','none')
        
        keystr=input('Press b if bad, q if questionable','s');
        if strcmp(keystr,'b') % file exists but is bad
            isgood(whfile)=nan;
        elseif strcmp(keystr,'q')
            isgood(whfile)=0;            
        else
            isgood(whfile)=1;            
        end % cast#
        end %try
    end % whfile

    if savedata==1
    save(fullfile('/Users/Andy/Cruises_Research/ChiPod/I09/mfiles/',[whSN '_TPcheck.mat']),'Flist','isgood')    
    end
    
end % SN

%%

save(fullfile('/Users/Andy/Cruises_Research/ChiPod/P16N/mfiles/processing',[cruise '_' whSN '_TPcheck.mat']),'Flist','isgood')

%%

% save Flist, isgood
% in DoChicalc, can check each file against this list

isgood.Info=['-2=File does not exist. nan=bad profile. 1=ok,']
%
isgood.MakeInfo=['Made ' datestr(now) ' w/ VisualCheckChipodProfiles.m']
%
%save(fullfile(chi_proc_path,['P16N' cruise '_VisCheck']),'isgood')

%%