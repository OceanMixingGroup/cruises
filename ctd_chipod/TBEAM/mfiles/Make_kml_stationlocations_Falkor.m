%%
%
% Make_kml_stationlocations_Falkor.m
%
% Get lat/lon from CTD casts, make kml file for Google Earth image etc.
%
%
%%

clear ; clc

Load_chipod_paths_TTide_Falkor

Flist=dir(fullfile(CTD_out_dir_bin,['*FK*.mat']))

Nfiles=length(Flist)


%%

lons=nan*ones(1,Nfiles);
lats=lons;
for a=1:Nfiles
    load(fullfile(CTD_out_dir_bin,Flist(a).name));
    lons=[lons nanmean(datad.lon)];
    lats=[lats nanmean(datad.lat)];
end
%%
kmlwrite('FalkorCTDstations',lats,lons,'color','y','Name','CTD')
%kmlwrite('TYstations',lats,lons,'color','r','Name','TY')
%%