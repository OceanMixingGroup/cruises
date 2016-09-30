%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Load_chipod_paths_FLEAT.m
%
% See also process_chipod_script_template.m
%
%------------------
% 09/30/16 - A. Pickering - apickering@coas.oregonstate.edu
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

%*** Replace 'IO9' with project name
%BaseDir='/Users/Andy/Cruises_Research/ChiPod/FLEAT/'
BaseDir=fullfile('/Volumes/SP PHD U3/NonBackup/FLEAT/')

% Folder with raw CTD data (.hex and .XMLCON files)
%CTD_data_dir=fullfile(BaseDir,'Data','raw','CTD')
CTD_data_dir=fullfile('/Volumes/SP PHD U3/NonBackup/FLEAT/Data/raw/ctd')

% Base directory for all processed CTD output
CTD_out_dir_root=fullfile(BaseDir,'Data','proc','CTD')

% Folder to save processed 24Hz CTD mat files to
CTD_out_dir_24hz=fullfile(CTD_out_dir_root,'24hz')

% Folder to save processed and binned CTD mat files to
CTD_out_dir_bin=fullfile(CTD_out_dir_root,'binned')

% Folder to save figures to
CTD_out_dir_figs=fullfile(CTD_out_dir_root,'figures')

% folder for raw chi pod data
%chi_data_path=fullfile(BaseDir,'Data','raw','Chipod')
chi_data_path=fullfile('/Volumes/SP PHD U3/NonBackup/FLEAT/Data/raw/chipod')

% folder for processed chipod output
chi_proc_path=fullfile('/Volumes/SP PHD U3/NonBackup/FLEAT/','Data','proc','Chipod')

ChkMkDir(CTD_out_dir_root)
ChkMkDir(CTD_out_dir_bin)
ChkMkDir(CTD_out_dir_24hz)
ChkMkDir(CTD_out_dir_figs)
ChkMkDir(chi_proc_path)

%%