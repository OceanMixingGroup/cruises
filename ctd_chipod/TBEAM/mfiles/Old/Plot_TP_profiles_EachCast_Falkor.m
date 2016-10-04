%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Plot_TP_profiles_EachCast_Falkor.m
%
% Trying to write a general script/function to plot TP profiles from all
% chipods for one cast, to be used during chi-pod cruise.
%
% MakeCasts... needs to be run first
%
%-----------------
% 06/01/16 - A.Pickering - apickering@coas.oregonstate.edu
% 06/07/16 - AP - Also plot T2 for big chipods
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% Plot T' profiles from each sensor/cast direction for one cast
% trying to assess which sensors are clean/noisy

clear ; close all

saveplot=1

% *** load deployment info
Chipod_Deploy_Info_TTIDE_Falkor_Big

% % directory for processed data
Load_chipod_paths_TTide_Falkor
datdir=chi_proc_path

% Make list of which CTD casts we have processed
CTDlist=dir([CTD_out_dir_24hz '/*.mat'])
Ncasts=length(CTDlist)

% Check if we have any 'big' chipods
bc=[];
for iSN=1:length(ChiInfo.SNs);
    bc=[bc ChiInfo.(ChiInfo.SNs{iSN}).isbig];
end

%%
hb=waitbar(0)
for icast=1:Ncasts
    
    waitbar(icast/Ncasts,hb)
    castname=CTDlist(icast).name(1:end-8)
    
    % Set up figure
    figure(1);clf
    xl=0.5*[-1 1];
    agutwocolumn(1)
    wysiwyg
    set(gcf,'Name',[castname]);
    rr=2;
    if any(bc)==1
        cc=length(ChiInfo.SNs)+1;
    else
        cc=length(ChiInfo.SNs);
    end
    
    ax=nan*ones(1,2*cc);
    whax=1;
    ymax=[];
    
    iSNoffset=0
    
    for iSN=1:length(ChiInfo.SNs)
        
        clear whSN
        whSN=ChiInfo.SNs{iSN};
        
        ax(whax)=subplot(rr,cc,iSN+iSNoffset);
        try
            
            castdir='down';
            whsens='T1';
            dir2=fullfile(whSN,'cal');
            load(fullfile(datdir,dir2,[castname '_' whSN '_' castdir 'cast.mat']))
            yl=[0 nanmax(C.P)];
            ymax=[ymax nanmax(C.P)];
            
            plot(C.([whsens 'P']),C.P)
            xlim(xl)
            ylim(yl)
            axis ij
            grid on
            xlabel([whsens ' ' castdir])
            title(whSN)
            
            if iSN~=1
                ytloff
            end
            
        catch
            xlim(xl)
            
        end % try
        
        whax=whax+1;
        
        ax(whax)=subplot(rr,cc,iSN+iSNoffset+cc);
        try
            
            clear C
            castdir='up';
            % load(fullfile(datdir,dir2,['cal_cast_' castname(10:end) '_' whSN '_' castdir 'cast.mat']))
            load(fullfile(datdir,dir2,[castname '_' whSN '_' castdir 'cast.mat']))
            yl=[0 nanmax(C.P)];
            ymax=[ymax nanmax(C.P)];
            
            plot(C.([whsens 'P']),C.P)
            xlim(xl)
            ylim(yl)
            axis ij
            grid on
            xlabel([whsens ' ' castdir])
            title(whSN)
            
            
            if iSN~=1
                ytloff
            end
            
        catch
            xlim(xl)
        end % try
        
        whax=whax+1;
        
        
        if ChiInfo.(whSN).isbig==1
            iSNoffset=iSNoffset+1
            ax(whax)=subplot(rr,cc,iSN+iSNoffset);
            try
                
                castdir='down';
                whsens='T2';
                dir2=fullfile(whSN,'cal');
                %            load(fullfile(datdir,dir2,['cal_cast_' castname(10:end) '_' whSN '_' castdir 'cast.mat']))
                load(fullfile(datdir,dir2,[castname '_' whSN '_' castdir 'cast.mat']))
                yl=[0 nanmax(C.P)];
                ymax=[ymax nanmax(C.P)];
                
                plot(C.([whsens 'P']),C.P)
                xlim(xl)
                ylim(yl)
                axis ij
                grid on
                xlabel([whsens ' ' castdir])
                title(whSN)
                
                if iSN~=1
                    ytloff
                end
                
            catch
                xlim(xl)
                
            end % try
            
            whax=whax+1;
            
            ax(whax)=subplot(rr,cc,iSN+iSNoffset+cc);
            try
                
                clear C
                castdir='up';
                % load(fullfile(datdir,dir2,['cal_cast_' castname(10:end) '_' whSN '_' castdir 'cast.mat']))
                load(fullfile(datdir,dir2,[castname '_' whSN '_' castdir 'cast.mat']))
                yl=[0 nanmax(C.P)];
                ymax=[ymax nanmax(C.P)];
                
                plot(C.([whsens 'P']),C.P)
                xlim(xl)
                ylim(yl)
                axis ij
                grid on
                xlabel([whsens ' ' castdir])
                title(whSN)
                
                if iSN~=1
                    ytloff
                end
                
            catch
                xlim(xl)
            end % try
            
            whax=whax+1;
            
            
        end % isbig
        
        
    end % iSN
    
    
    if  sum(~isnan(ax))>0
        axes(ax(1))
        ylabel('Downcasts','fontsize',16)
        
        axes(ax(2))
        ylabel('Upcasts','fontsize',16)
        
        if length(ymax>1)
            yl=[0 nanmax(ymax)];
            for iax=1:length(ax)
                axes(ax(iax))
                ylim(yl)
                axis ij
            end
        end
        
        linkaxes(ax)
        
    end
    
    if saveplot==1
        BaseDir='/Users/Andy/Cruises_Research/ChiPod/Tasmania/Figures/Falkor'
        figdir=fullfile(BaseDir,'Figures','TPprofiles')
        ChkMkDir(figdir)
        print( fullfile( figdir , ['TP_profs_' castname] ) , '-dpng' )
    end
    
    pause(1)
    
end % castnum
delete(hb)
%%