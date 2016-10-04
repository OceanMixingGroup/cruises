%%

clear ; close all

datadir='/Users/Andy/Cruises_Research/ChiPod/Tasmania/Data/Falkor/ctd/ctd_processed/raw/'

D=dir(fullfile(datadir,'*.mat'))
%
for icast=1:length(D)
    try
        load(fullfile(datadir,D(icast).name))
        figure(1);clf
        plot(1:length(data2.p),data2.p)
        axis ij
        title(D(icast).name,'interpreter','none')
        ylim([0 2100])
        pause(1)
    end
end
%%