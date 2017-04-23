%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Load_chipod_paths_TTide_Falkor.m
%
% Set paths for TTide CTD-chipod processing
%
%
%
%----------------------
% June 24, 2015 - A. Pickering
% 10/4/16 - AP - moving processed data to hard drive to free up space
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

%BaseDir='/Users/Andy/Cruises_Research/ChiPod/Tbeam/'
BaseDir='/Volumes/SP PHD U3/NonBackup/Tbeam/'
cruisedir='/Users/Andy/Cruises_Research/OceanMixingGroup/cruises/ctd_chipod/Tbeam/'

CTD_data_dir='/Users/Andy/Cruises_Research/ChiPod/Tasmania/Data/Falkor/ctd/ctd_processed/raw/'
%CTD_data_dir=fullfile(BaseDir,'Data','

CTD_out_dir_root='/Users/Andy/Cruises_Research/ChiPod/Tasmania/Data/Falkor/ctd/ctd_processed/';
%CTD_out_dir_root=fullfile(BaseDir

CTD_out_dir_24hz=fullfile(CTD_out_dir_root,'raw')

CTD_out_dir_bin=CTD_out_dir_root%

% *** Path where chipod data are located
%chi_data_path='/Users/Andy/Dropbox/chipod/chipod/'
chi_data_path='/Users/Andy/Cruises_Research/ChiPod/Tasmania/Data/Falkor/chipod/channel4'

% *** path where processed chipod data will be saved
%chi_proc_path='/Users/Andy/Cruises_Research/ChiPod/Tasmania/Data/Falkor/processed/'
chi_proc_path=fullfile(BaseDir,'Data','proc','Chipod')

%%
