%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Plot_raw_chipod_Falkor.m
%
% Quickly plot raw chipod data from Falkor (TTide)
%
% Trying to make general for use w/ any cruise
%
% Modified from plot_all_mini_chipod_data.m
%
%------------------
% 11/18/15 - AP
% 02/02/16 - AP - add option to plot big chi pod too
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear all ; close all

saveplots=1

Load_chipod_paths_TTide_Falkor

Chipod_Deploy_Info_TTIDE_Falkor_Big
%%
t_step=36000;

if t_step==10
    x_tick='HH:MM';
elseif t_step==3600*5
    x_tick='MM';
else x_tick='SS';
end

for iSN=1%1:length(ChiInfo.SNs)
    
    clear whSN chi_path D figdir
    whSN=ChiInfo.SNs{iSN}
    if strcmp(whSN,'SN1001')
%        chi_path='/Users/Andy/Cruises_Research/ChiPod/Tasmania/Data/Falkor/chipod/1001'
         chi_path='/Users/Andy/Cruises_Research/ChiPod/Tasmania/Data/Falkor/chipod/channel123_wHead/'
    else
    chi_path=fullfile(chi_data_path,whSN)
    end
    D=dir(fullfile(chi_path,['*.' ChiInfo.(whSN).suffix '*']))
    isbig=strcmp('big',ChiInfo.(whSN).InstType)
    
    if saveplots==1
        figdir= fullfile('/Users/Andy/Cruises_Research/ChiPod/Tasmania/Data/Falkor/raw_pngs/',whSN)
        ChkMkDir(figdir)
    end
    
    for whfile=1:length(D)
        close all
        clear fname
        fname=fullfile(chi_path,D(whfile).name)
        
        try
            
            if isbig
                [data head]=raw_load_chipod(fname);
                chidat.datenum=data.datenum;
                len=length(data.datenum);
                if mod(len,2)
                    len=len-1; % for some reason datenum is odd!
                end
                chidat.T1=makelen(data.T1(1:(len/2)),len);
                chidat.T1P=data.T1P;
                chidat.T2=makelen(data.T2(1:(len/2)),len);
                chidat.T2P=data.T2P;
                chidat.AX=makelen(data.AX(1:(len/2)),len);
                chidat.AY=makelen(data.AY(1:(len/2)),len);
                chidat.AZ=makelen(data.AZ(1:(len/2)),len);
            else
                % its a minichipod
                
                try
                    [out,counter]=load_mini_chipod(fname);
                catch
                    try
                        [out,counter]=load_mini_chipod(fname,8400);
                    catch
                    end
                end
                chidat.datenum=counter;
                chidat.T1=out(:,2);
                chidat.T1P=out(:,1);
                chidat.AX=3*out(:,4);
                chidat.AZ=3*out(:,3);
                
                
            end
            
            if isbig==1
                figure(1);clf
                agutwocolumn(1)
                wysiwyg
                ax = MySubplot(0.1, 0.03, 0.02, 0.06, 0.1, 0.08, 1,4);
                
                axes(ax(1))
                plot(chidat.datenum,chidat.T1)
                datetick('x',15)
                title(D(whfile).name,'interpreter','none')
                %        ylim([0 3.5])
                grid on
                SubplotLetterMW('T1')
                
                axes(ax(2))
                plot(chidat.datenum,chidat.T2)
                datetick('x',15)
                %        ylim([0 3.5])
                grid on
                SubplotLetterMW('T2')
                
                axes(ax(3))
                plot(chidat.datenum,chidat.T1P)
                datetick('x',15)
                ylim([2 2.1])
                grid on
                SubplotLetterMW('T1P')
                
                axes(ax(4))
                plot(chidat.datenum,chidat.T2P)
                datetick('x',15)
                xlabel(['Time on ' datestr(floor(chidat.datenum(1)))])
                ylim([2 2.1])
                grid on
                SubplotLetterMW('T2P')
                
                linkaxes(ax,'x')
                
            else
                figure(1);clf
                agutwocolumn(1)
                wysiwyg
                ax = MySubplot(0.1, 0.03, 0.02, 0.06, 0.1, 0.05, 1,3);
                
                axes(ax(1))
                plot(chidat.datenum,chidat.T1)
                datetick('x',15)
                title(D(whfile).name,'interpreter','none')
                %        ylim([0 3.5])
                grid on
                SubplotLetterMW('T1')
                %
                axes(ax(2))
                plot(chidat.datenum,chidat.T1P)
                datetick('x',15)
                ylim([2 2.1])
                grid on
                SubplotLetterMW('T1P')
                
                axes(ax(3))
                plot(chidat.datenum,chidat.AX)
                hold on
                plot(chidat.datenum,chidat.AZ)
                %            gridxy
                grid on
                datetick('x')
                xlabel(['Time on ' datestr(floor(chidat.datenum(1)))])
                
                legend('AX','AZ','location','best')
                
                linkaxes(ax,'x')
                
            end % isbig
            
            
            if saveplots==1
                print( fullfile(figdir,[D(whfile).name '.png']),'-dpng','-r100')
            end
            
        catch
            disp('problem')
        end
        
        %        pause(1)
        
    end % each file
    
end % iSN

%%

