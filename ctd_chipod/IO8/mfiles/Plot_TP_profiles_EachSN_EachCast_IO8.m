%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Plot_TP_profiles_EachSN_EachCast_IO8.m
%
% Template for script to plot TP profiles from each chipods for each
% cast. Allows comparison of TP from different sensors.
%
%
% Dependencies:
% Load_chipod_paths_Template.m
% Chipod_Deploy_Info_Template.m
% MakeCasts... needs to be run first
%
%-----------------
% 04/28/17 - A.Pickering - apickering@coas.oregonstate.edu
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% Plot T' profiles from each sensor/cast direction for one cast
% trying to assess which sensors are clean/noisy

clear ; close all

saveplot = 1

Project = 'IO8'

% Data paths
eval(['Load_chipod_paths_' Project])
% load deployment info
eval(['Chipod_Deploy_Info_' Project])

% You should't have to modify anything below this
%~~~~~~~~~~~~~~~~~~~~~~

xl=1*[-1 1];

% Make list of which CTD casts we have processed
CTDlist=dir([CTD_out_dir_bin '/*.mat'])
Ncasts=length(CTDlist)


%
hb=waitbar(0)

for icast = 1:Ncasts
    waitbar(icast/Ncasts,hb)
    castname = CTDlist(icast).name(1:end-4)
    
    ymax=[];
    
    for iSN=1:length(ChiInfo.SNs)
        
        try
            
            figure(1);clf
            agutwocolumn(1)
            wysiwyg
            
            % Plot downcasts
            whSN=ChiInfo.SNs{iSN};
            castdir='down';
            whsens='T1';
            dir2=fullfile(whSN,'cal');
            load(fullfile(chi_proc_path,dir2,[castname '_' whSN '_' castdir 'cast.mat']))
            ymax=[ymax nanmax(C.P)];
            
            %ax(whax)=subplot(rr,cc,iSN+iSNoffset);
            ax1 = subplot(121) ;
            plot(C.([whsens 'P']),C.P)
            xlim(xl)
            axis ij
            grid on
            xlabel([whsens ' ' castdir 'cast'])
            if strcmp(castdir,ChiInfo.(whSN).InstDir.T1)
                title(whSN,'color','g','fontweight','bold')
            else
                title(whSN)
            end
            
            gridxy
                                    
        catch
            ax1=subplot(121)
            %ax(whax)=subplot(rr,cc,iSN+iSNoffset);
            xlim(xl)
            if strcmp(castdir,ChiInfo.(whSN).InstDir.T1)
                title(whSN,'color','g','fontweight','bold')
            else
                title(whSN)
            end
        end % try
        
        % Plot upcasts
        %
        
        try
            
            clear C
            castdir='up';
            load(fullfile(chi_proc_path,dir2,[castname '_' whSN '_' castdir 'cast.mat']))
            ymax=[ymax nanmax(C.P)];
            
            %ax(whax)=subplot(rr,cc,iSN+iSNoffset+cc);
            ax2 = subplot(122);
            plot(C.([whsens 'P']),C.P)
            xlim(xl)
            axis ij
            grid on
            xlabel([whsens ' ' castdir 'cast'])
            if strcmp(castdir,ChiInfo.(whSN).InstDir.T1)
                title(whSN,'color','g','fontweight','bold')
            else
                title(whSN)
            end
            
            gridxy
            
            
            
        catch
            % ax(whax)=subplot(rr,cc,iSN+iSNoffset+cc);
            ax2=subplot(122)
            xlim(xl)
            if strcmp(castdir,ChiInfo.(whSN).InstDir.T1)
                title(whSN,'color','g','fontweight','bold')
            else
                title(whSN)
            end
        end % try
        
        if ~isempty(ymax)
            axes(ax1)
            ylim([0 nanmax(ymax)])
            axes(ax2)
            ylim([0 nanmax(ymax)])
            
        end
        
        linkaxes([ax1 ax2])
        
        if saveplot==1
            %figdir=fullfile(BaseDir,'Figures','TPprofiles_AllSN');
            figdir=fullfile(fig_path,'TPprofiles_EachSN',whSN);
            ChkMkDir(figdir)
            print( fullfile( figdir , ['TP_profs_' whSN '_' castname] ) , '-dpng' )
        end
        
        pause(0.1)
        
    end % iSN
    
end % castnum

delete(hb)
%%