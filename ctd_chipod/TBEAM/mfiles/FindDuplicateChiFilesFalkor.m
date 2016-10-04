%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% FindDuplicateChiFilesFalkor.m
%
%
%-----------------------
% 12/07/15 - A.Pickering - Initial Coding
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear ; close all ; clc

Load_chipod_paths_TTide_Falkor

Chipod_Deploy_Info_TTIDE_Falkor_Big

txtfname=['FalkorDuplicates.txt'];
fileID= fopen(fullfile(chi_proc_path,txtfname),'w');


for iSN=1:length(ChiInfo.SNs)
    
    whSN=ChiInfo.SNs{iSN}
    
    fprintf(fileID,['\n~~~~~~~~~~~~~~~~~~~\n' whSN])
    
    this_chi_info=ChiInfo.(whSN);
    
    % full path to raw data for this chipod
    chi_path=fullfile(chi_data_path,this_chi_info.loggerSN);
    chi_path=fullfile(chi_data_path,whSN);
    suffix=this_chi_info.suffix;
    
    Flist=dir(fullfile(chi_path,['*' suffix]))
    clc
    
    for ifile=1:length(Flist)
        
        fname=Flist(ifile).name;
        id1=strfind(fname,['.' suffix]);
        dstr=fname(id1-8:id1-1);
        Flist2=dir(fullfile(chi_path,['*' dstr '*']));
        
        if length(Flist2)>1
            disp(['found duplicate for ' dstr])
            fprintf(fileID,['\n found duplicate for ' dstr])
            for a=1:length(Flist2)
                disp(Flist2(a).name)
                fprintf(fileID,['\n' (Flist2(a).name)])
            end
            fprintf(fileID,'\n\n')
        end
        
    end
    
end

fclose(fileID)
%%