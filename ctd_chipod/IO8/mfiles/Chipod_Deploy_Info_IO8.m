%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Chipod_Deploy_Info_I08.m
%
% Deployment info for CTD chipods on I08 cruise. For loading during chipod
% processing.
%
%
%---------------
% May 20, 2016 - A.Pickering - apickering@coas.oregonstate.edu
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

ChiInfo=struct();
ChiInfo.Project='IO8';          % Description of project
ChiInfo.SNs={'SN1013','SN2020','SN2014','SN2009','SN2004','SN2003','SN2002','SN2001'}; % list of chipod SNs
ChiInfo.CastString='I08S';   % identifying string in CTD cast files

%%~~~~~~~~~~~~~~~~~~~
% SN 1013 
clear S SN
SN='1013';
S.loggerSN=SN;   % logger serial number
S.pcaseSN='Ti44-11';  % pressure case SN
S.sensorSN='14-34D'; % sensor SN
S.InstDir.T1='up';      % mounting direction (of sensor) on CTD
S.InstType='mini';   % Instrument type ('mini' or 'big')
S.isbig=0; %
S.az_correction=-1;  % See note above
S.suffix='mlg';    % suffix for chipod raw data filenames
S.cal.coef.T1P=0.097;% TP calibration coeff (time constant)
ChiInfo.(['SN' SN])=S;clear S

%%~~~~~~~~~~~~~~~~~~~
% SN 2020 
% ** AX/AZ flipped **
clear S SN
SN='2020';
S.loggerSN=SN;   % logger serial number
S.pcaseSN='Ti44-4';  % pressure case SN
S.sensorSN='14-28D'; % sensor SN
S.InstDir.T1='up';      % mounting direction (of sensor) on CTD
S.InstType='mini';   % Instrument type ('mini' or 'big')
S.isbig=0; %
S.az_correction=1;  % See note above
S.suffix='mlg';    % suffix for chipod raw data filenames
S.cal.coef.T1P=0.097;% TP calibration coeff (time constant)
ChiInfo.(['SN' SN])=S;clear S

%%~~~~~~~~~~~~~~~~~~~
% SN 2014
clear S SN
SN='2014';
S.loggerSN=SN;   % logger serial number
S.pcaseSN='Ti44-8';  % pressure case SN
S.sensorSN='10-06MP'; % sensor SN
S.InstDir.T1='up';      % mounting direction (of sensor) on CTD
S.InstType='mini';   % Instrument type ('mini' or 'big')
S.isbig=0; %
S.az_correction=-1;  % See note above
S.suffix='mlg';    % suffix for chipod raw data filenames
S.cal.coef.T1P=0.097;% TP calibration coeff (time constant)
ChiInfo.(['SN' SN])=S;clear S


%%~~~~~~~~~~~~~~~~~~~
% SN 2009 
clear S SN
SN='2009';
S.loggerSN=SN;   % logger serial number
S.pcaseSN='Ti44-14';  % pressure case SN
S.sensorSN='11-25D'; % sensor SN
S.InstDir.T1='up';      % mounting direction (of sensor) on CTD
S.InstType='mini';   % Instrument type ('mini' or 'big')
S.isbig=0; %
S.az_correction=1;  % See note above
S.suffix='mlg';    % suffix for chipod raw data filenames
S.cal.coef.T1P=0.097;% TP calibration coeff (time constant)
ChiInfo.(['SN' SN])=S;clear S

%%~~~~~~~~~~~~~~~~~~~
% SN 2004
clear S SN
SN='2004';
S.loggerSN=SN;   % logger serial number
S.pcaseSN='Ti44-13';  % pressure case SN
S.sensorSN='13-02D'; % sensor SN
S.InstDir.T1='down';      % mounting direction (of sensor) on CTD
S.InstType='mini';   % Instrument type ('mini' or 'big')
S.isbig=0; %
S.az_correction=1;  % See note above
S.suffix='mlg';    % suffix for chipod raw data filenames
S.cal.coef.T1P=0.097;% TP calibration coeff (time constant)
ChiInfo.(['SN' SN])=S;clear S


%%~~~~~~~~~~~~~~~~~~~
% SN 2003 
clear S SN
SN='2003';
S.loggerSN=SN;   % logger serial number
S.pcaseSN='Ti44-9';  % pressure case SN
S.sensorSN='11-24D'; % sensor SN
S.InstDir.T1='up';      % mounting direction (of sensor) on CTD
S.InstType='mini';   % Instrument type ('mini' or 'big')
S.isbig=0; %
S.az_correction=1;  % See note above
S.suffix='mlg';    % suffix for chipod raw data filenames
S.cal.coef.T1P=0.097;% TP calibration coeff (time constant)
ChiInfo.(['SN' SN])=S;clear S


%%~~~~~~~~~~~~~~~~~~~
% SN 2002 
% Note sensor changed during cruise
clear S SN
SN='2002';
S.loggerSN=SN;   % logger serial number
S.pcaseSN='Ti44-12';  % pressure case SN
S.sensorSN='13-05D'; % sensor SN
S.InstDir.T1='down';      % mounting direction (of sensor) on CTD
S.InstType='mini';   % Instrument type ('mini' or 'big')
S.isbig=0; %
S.az_correction=1;  % See note above
S.suffix='mlg';    % suffix for chipod raw data filenames
S.cal.coef.T1P=0.097;% TP calibration coeff (time constant)
ChiInfo.(['SN' SN])=S;clear S

%%~~~~~~~~~~~~~~~~~~~
% SN 2001 
clear S SN
SN='2001';
S.loggerSN=SN;   % logger serial number
S.pcaseSN='Ti44-10';  % pressure case SN
S.sensorSN='10-01MP'; % sensor SN
S.InstDir.T1='down';      % mounting direction (of sensor) on CTD
S.InstType='mini';   % Instrument type ('mini' or 'big')
S.isbig=0; %
S.az_correction=1;  % See note above
S.suffix='mlg';    % suffix for chipod raw data filenames
S.cal.coef.T1P=0.097;% TP calibration coeff (time constant)
ChiInfo.(['SN' SN])=S;clear S


ChiInfo.MakeInfo='Chipod_Deploy_Info_I08.m';
%%