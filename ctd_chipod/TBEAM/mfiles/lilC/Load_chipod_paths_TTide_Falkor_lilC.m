%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Load_chipod_paths_TTide_Falkor_lilC.m
%
% Set paths for TTide CTD-chipod processing
%
% For Falkor cruise, 'little' CTD
%
%
%----------------------
% 12/18/15 - A. Pickering - apickering@coas.oregonstate.edu
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

CTD_data_dir='/Users/Andy/Cruises_Research/Tasmania/Data/Falkor/ctd/lilC_data/Data/0Hex'

CTD_out_dir_root='/Users/Andy/Cruises_Research/Tasmania/Data/Falkor/ctd/ctd_processed/';

CTD_out_dir_24hz=fullfile(CTD_out_dir_root,'raw')

CTD_out_dir_bin=CTD_out_dir_root%

% *** Path where chipod data are located
%chi_data_path='/Users/Andy/Dropbox/chipod/chipod/'
chi_data_path='/Users/Andy/Cruises_Research/Tasmania/Data/Falkor/chipod/channel4'

% *** path where processed chipod data will be saved
chi_proc_path='/Users/Andy/Cruises_Research/Tasmania/Data/Falkor/processed/'
%'/Users/Andy/Cruises_Research/Tasmania/Data/Chipod_CTD/Processed_v2/';


%%