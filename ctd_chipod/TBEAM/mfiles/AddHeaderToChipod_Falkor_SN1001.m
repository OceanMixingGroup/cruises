%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% AddHeaderToChipod_Falkor_SN1001.m
%
% This script is used to merge the header and raw file  of the chipod raw
% data (SN1001) from Falkor TTIDE cruise,  which do not have the header
% prepended on them in the first place.
%
% Modified from script mergedata.m, from Pavan Vutukur on 02/12/16.
%
%--------------
% 02/12/16 - A.Pickering - apickering@coas.oregonstate.edu
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear all

%Call the the header to want to merge
hname = '/Users/Andy/Cruises_Research/ChiPod/Tasmania/Data/Falkor/chipod/header_ctd_1001.1001'
fid=fopen(hname,'r');
H = fread(fid); %reads the header
%
%dir the location of the location of raw files (which do not have the
%header).
%nm = dir('C:\Users\mixing\Documents\RAMA Chipods\526\raw');
rawdir='/Users/Andy/Cruises_Research/ChiPod/Tasmania/Data/Falkor/chipod/channel123/'
nm=dir(fullfile(rawdir,'*.A1001'))
%
%path of the directory where the concatenated files should be saved in.
%pathname = 'C:\Users\mixing\Documents\RAMA Chipods\526\raw\';
savedir='/Users/Andy/Cruises_Research/ChiPod/Tasmania/Data/Falkor/chipod/channel123_wHead/'
%pathname=

for i = 1:length(nm)%131:251 %the files that need to be merged
    
    clear fid2 D fid3 A
    
    % open the raw chipod file w/o header
    fid2 = fopen(fullfile(rawdir,nm(i).name),'r');
    %fid2 = fopen(fullfile(savedir,nm(i).name),'r');
    D = fread(fid2);
    disp([' file w/o header: ' fullfile(rawdir,nm(i).name)])
    
    % open (create) the file to write to
    fid3 = fopen(fullfile(savedir,nm(i).name),'w');
    display(nm(i).name)
    disp([' file w header: ' fullfile(savedir,nm(i).name)])
    
    % cat the header and file together
    A = cat(1,H,D);
    
    % write the concatenated file
    fwrite(fid3,A);
    
    fclose(fid2);
    fclose(fid3);
    %clear the arrays and loop it.
    
    clear fid2 fid3 A D;
    
end

clear all;


%%