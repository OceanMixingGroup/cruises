%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Chipod_Deploy_Info_FLEAT.m
%
% Deployment info for CTD chipods. For loading during chipod
% processing.
%
% Notes:
%
% (1) The sign of az_correction is not always consistent with the
% chipod deployment direction (some units are wired oppositely);
% the correct sign needs to be determined from aligning the chipod and 
% CTD (AlignChipodCTD.m in the processing script).
%
%
%---------------
% 09/30/16 - A.Pickering - andypicke@gmail.com
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

ChiInfo=struct();
ChiInfo.Project='FLEAT';           % Project name
ChiInfo.SNs={'SN2014','SN2002','SN1013'}; % List of chipod SNs
ChiInfo.CastString='fleat16';       % Identifying string in CTD cast files

%%~~~~~~~~~~~~~~~~~~~
% SN 1013 
clear S SN
SN='1013';
S.loggerSN=SN;       % logger serial number
S.pcaseSN='Ti44-11'; % pressure case SN
S.sensorSN='14-34D'; % sensor SN
S.InstDir.T1='up';      % mounting direction (of sensor) on CTD
S.InstType='mini';   % Instrument type ('mini' or 'big')
S.isbig=0;           % 1 for 'big' chipods
S.az_correction=-1;  % See note above
S.suffix='mlg';      % suffix for chipod raw data filenames
S.cal.coef.T1P=0.097;% TP calibration coeff (time constant)
ChiInfo.(['SN' SN])=S;clear S

%
clear S SN
SN='2002';
S.loggerSN=SN;       % logger serial number
S.pcaseSN='Ti44-11'; % pressure case SN
S.sensorSN='14-34D'; % sensor SN
S.InstDir.T1='down';      % mounting direction (of sensor) on CTD
S.InstType='mini';   % Instrument type ('mini' or 'big')
S.isbig=0;           % 1 for 'big' chipods
S.az_correction=1;  % See note above
S.suffix='mlg';      % suffix for chipod raw data filenames
S.cal.coef.T1P=0.097;% TP calibration coeff (time constant)
ChiInfo.(['SN' SN])=S;clear S

% 
clear S SN
SN='2014';
S.loggerSN=SN;       % logger serial number
S.pcaseSN='Ti44-11'; % pressure case SN
S.sensorSN='14-34D'; % sensor SN
S.InstDir.T1='up';      % mounting direction (of sensor) on CTD
S.InstType='mini';   % Instrument type ('mini' or 'big')
S.isbig=0;           % 1 for 'big' chipods
S.az_correction=1;  % See note above
S.suffix='mlg';      % suffix for chipod raw data filenames
S.cal.coef.T1P=0.097;% TP calibration coeff (time constant)
ChiInfo.(['SN' SN])=S;clear S

% ***
ChiInfo.MakeInfo='Chipod_Deploy_Info_FLEAT.m';
%%
