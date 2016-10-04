%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Process_CTD_hex_TTIDE_Falkor_lilC.m
%
% Script to process raw shipboard (Seabird) CTD data from Falkor cruise
% , for 'little' CTD.
%
%
%---------------------
% 12/18/15 - A.Pickering - Initial Coding. Modified from
% Process_CTD_hex_TTIDE_Leg3
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

clear ; close all

dobin=1
makeplots=1
doascii=0

% load paths
Load_chipod_paths_TTide_Falkor_lilC

% filename used to process data
this_file_name='Process_CTD_hex_Falkor_lilC.m'

addpath /Users/Andy/Cruises_Research/mixingsoftware/ctd_processing/

% ~identifying suffix (usually cruise name) in filename of CTD files
cruise='SBE19_4550'

%ctdlist = dirs(fullfile(CTD_data_dir, ['*' cruise '.hex']))
ctdlist = dirs(fullfile(CTD_data_dir,['*' cruise '*.hex']))
%%

% Loop through each cast
for icast=1%:length(ctdlist)
    
    try
        
        close all
        
        clear data1 data2 data3 data4 data5 data6 data7
        clear ctdname outname matname0 matname_bin confile cfg d
        
        % name of file we are working on now
        ctdname = fullfile(CTD_data_dir,ctdlist(icast).name)
        disp(['icast=' num2str(icast) ', file=' ctdname])
        
        % name for processed matfile
        %    outname=[sprintf([cruise '_%03d'],icast) '.mat']
        outname=ctdlist(icast).name(1:end-4);
        matname0 = fullfile(CTD_out_dir_24hz,[outname '_0.mat'])
        matname_bin=fullfile(CTD_out_dir_bin, outname);
        %    disp(['CTD file: ' ctdname])
        
        % ~ load calibration info (should be updated for each cruise)
        disp('Loading calibrations')
        
        % *** Load calibration info for CTD sensors
        %confile=upper([ctdname(1:end-3) 'XMLCON'])
        % just 1 conf file for all casts
        confile='/Users/Andy/Cruises_Research/Tasmania/Data/Falkor/ctd/lilC_data/Data/4550_20-09-2012con.xmlcon'
        cfg=MakeCtdConfigFromXMLCON(confile);
        
        % Load Raw data
        disp(['loading: ' ctdname])
        % include ch4
        d = hex_read(ctdname);
        disp(['parsing: ' ctdname ])
        %%
        data1=hex_parse_v2(d)
%        data1=h
 
        % check for modcount errors
        clear dmc mmc fmc
        dmc = diff(data1.modcount);
        mmc = mod(dmc, 256);
        %figure; plot(mmc); title('mod diff modcount')
        fmc = find(mmc - 1);
        if ~isempty(fmc);
            disp(['Warning: ' num2str(length(dmc(mmc > 1))) ' bad modcounts']);
            disp(['Warning: ' num2str(sum(mmc(fmc))) ' missing scans']);
        end
        
        % check for time errors
        clear dt ds np mds
        dt = data1.time(end) - data1.time(1); % total time range of cast (seconds?)
        ds = dt*24; % # expected samples at 24Hz ?
        np = length(data1.p); % # samples
        mds = np - ds;  % difference between expected and actual # samples
        if abs(mds) >= 24; disp(['Warning: ' num2str(mds) ' difference in time scans']); end
        
        % time is discretized
        clear nt time0
        nt=length(data1.time);
        time0=data1.time(1):1/24:data1.time(end);
        
        % convert freq, volatage data
        disp('converting to physical units:')
        data2 = physicalunits(data1, cfg);
        
        % Plot raw profiles of temp and cond.
        h=PlotRawCTDprofiles(data2,ctdlist,icast);
        print('-dpng',fullfile(CTD_out_dir_figs,[ctdlist(icast).name(1:end-4) '_Raw_Temp_Cond_vsP']))
        %%
        % add correct time to data
        tlim=now+5*365;
        if data2.time > tlim
            tmp=linspace(data2.time(1),data2.time(end),length(data2.time));
            data2.datenum=tmp'/24/3600+datenum([1970 1 1 0 0 0]);
        end
        
        % output raw data
        disp(['saving raw data as ' matname0])
        save(matname0, 'data2')
        
        % specify the depth range over which t-c lag fitting is done. For deep
        % stations, use data below 500 meters, otherwise use the entire depth
        % range.
        
        if max(data2.p)>800
            data2.tcfit=[500 max(data2.p)];
        else
            data2.tcfit=[200 max(data2.p)];
        end
        
        %%
        disp('cleaning:')
        data3 = ctd_cleanup(data2, icast);
        
        %%
        disp('correcting:')
        % ***include ch4
        [datad4, datau4] = ctd_correction_updn(data3); % T lag, tau; lowpass T, C, oxygen
        %%
        disp('calculating:')
        % *** despike oxygen
        datad5 = swcalcs(datad4, cfg); % calc S, theta, sigma, depth
        datau5 = swcalcs(datau4, cfg); % calc S, theta, sigma, depth
        
        %%
        disp('removing loops:')
        % *** Might need to modify based on CTD setup
        wthresh = 0.15  ;
        datad6 = ctd_rmloops(datad5, wthresh, 1);
        datau6 = ctd_rmloops(datau5, wthresh, 0);
        
        %% despike
        
        datad7 = ctd_cleanup2(datad6);
        datau7 = ctd_cleanup2(datau6);
        
        %% compute epsilon now, as a test
        doeps=0;
        if doeps
            sigma_t=0.0042; sigma_rho=0.0011;
            disp('Calculating epsilon:')
            [Epsout,Lmin,Lot,runlmax,Lttot]=compute_overturns2(datad6.p,datad6.t1,datad6.s1,nanmean(datad6.lat),0,3,sigma_t,1);
            %[epsilon]=ctd_overturns(datad6.p,datad6.t1,datad6.s1,33,5,5e-4);
            datad6.epsilon1=Epsout;
            datad6.Lot=Lot;
        end
        
        %% 1-m binning
        
        if dobin
            disp('doing 1m binning:')
            dzbin = 1; % m
            zmin = 0; % surface
            [zmax, imax] = max([max(datad7.depth) max(datau7.depth)]);
            zmax = ceil(zmax); % full depth
            datad_1m = ctd_bincast(datad7, zmin, dzbin, zmax);
            datau_1m = ctd_bincast(datau7, zmin, dzbin, zmax);
            datad_1m.datenum=datad_1m.time/24/3600+datenum([1970 1 1 0 0 0]);
            datau_1m.datenum=datau_1m.time/24/3600+datenum([1970 1 1 0 0 0]);
            
            datad_1m.MakeInfo=['Made ' datestr(now) ' w/ ' this_file_name  ' in ' version]
            datau_1m.MakeInfo=['Made ' datestr(now) ' w/ ' this_file_name  ' in ' version]
            
            datad_1m.source=ctdname;
            datau_1m.source=ctdname;
            
            datad_1m.confile=confile;
            datau_1m.confile=confile;
            
            datad_1m.wthresh=wthresh;
            datau_1m.wthresh=wthresh;
            
            disp(['saving 1m binned data to: ' matname_bin])
            save(matname_bin, 'datad_1m', 'datau_1m')
            
        end
        
        %% Plot binned profiles
        
        h=PlotBinnedCTDprofiles(datad_1m,datau_1m,ctdlist,icast);
        print('-dpng',fullfile(CTD_out_dir_figs,[ctdlist(icast).name(1:end-4) '_binned_Temp_Sal_vsP']))
        
        %% save as a text file for use by LADCP processing
        
        if doascii
            % a little  too high resolution in time, stalls ladcp processing
            % try to reduce a bit
            data3b = swcalcs(data3, cfg); % calc S, theta, sigma, depth
            
            sec=data3b.time-min(data3b.time);
            p=data3b.p;
            t=data3b.t1;
            s=data3b.s1;
            lat=data3b.lat;
            lon=data3b.lon;
            
            
            dataout=[sec p t s lat lon];
            ig=find(~isnan(mean(dataout,2))); dataout=dataout(ig,:);
            %save([CTD_out_dir_bin outname(1:end-4) '.cnv'],'dataout','-ascii','-tabs')
            save(fullfile(CTD_out_dir_bin,[outname(1:end-4) '.cnv']),'dataout','-ascii','-tabs')
        end
        %
    catch
        disp(['Error on ' ctdname])
    end % try
end % cast #
%%

%%