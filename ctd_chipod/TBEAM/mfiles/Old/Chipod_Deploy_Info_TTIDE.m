%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Chipod_Deploy_Info_TTIDE.m
%
% *for leg1 only?*
%
% Info for CTD chipods deployed during T-Tide. For loading during chipod
% processing.
%
% Taking info from Chipod_log.xls
%
% 102 and 1002 have same SNs?
% 1008 and 1014 missing from excel sheet?
%
%---------------------
% May 3, 2015 - A.Pickering - apickering@coas.oregonstate.edu
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

ChiInfo=struct();
ChiInfo.Project='TTIDE';
ChiInfo.SNs={'SN102','SN1010','SN1012','SN1013','SN1002','SN1008','SN1014'}
ChiInfo.CastString='leg1';   % identifying string in CTD cast files

%102 was a mini chipod with only one sensor the entire time. it was 11-15C and it was an uplooker. 
%the time was not synced to RTC. So... for files 0-16 the logger time was behind by 7 hours and 6 seconds :( sorry about that! When I noticed this issue, I set the time, but that seemed to scramble something in the unit because it failed to log any files after that. I did not get Unit 102 up and running again until the 28th. 
%~~~~~~~~~~~~~~~~~~~
% SN 102
SN102.loggerSN='102'; % logger serial number
SN102.pcaseSN='Ti88-4;';
SN102.sensorSN='11-15C';
SN102.InstDir='up';
SN102.InstType='mini';
SN102.az_correction=1; % determined from AlignCTD plots July 14 - AP
SN102.suffix='A0102';
SN102.isbig=0;
SN102.cal.coef.T1P=0.097;
% ** Note AZ<AX for SN102 (mounted upside down?)


%~ spreadsheet gives two SNs for the replacement sensor...
%~~~~~~~~~~~~~~~~~~~
% SN 1010
SN1010.loggerSN='1010'; % logger serial number
SN1010.pcaseSN='Ti88-4';
SN1010.sensorSN='11-23D';
SN1010.az_correction=nan;
SN1010.InstDir=nan;
SN1010.InstType='mini';
SN1010.isbig=0;
SN1010.suffix='A1010';
SN1010.cal.coef.T1P=0.097;
SN1010.Note='Changed sensor and from up to down at file 25';
%~~~~~~~~~~~~~~~~~~~


%~~~~~~~~~~~~~~~~~~~
% SN 1012 
SN1012.loggerSN='1012'; % logger serial number
SN1012.pcaseSN='Ti88-3';
SN1012.sensorSN='11-21D';
SN1012.InstDir='up';
SN1012.InstType='mini';
SN1012.isbig=0; %
SN1012.az_correction=-1; %
SN1012.suffix='A1012'; % 
SN1012.cal.coef.T1P=0.097;
%~~~~~~~~~~~~~~~~~~~


%~~~~~~~~~~~~~~~~~~~
% SN 1013
SN1013.loggerSN='1013'; % logger serial number
SN1013.pcaseSN='Ti88-2';
SN1013.sensorSN='11-22D';
SN1013.InstDir='down';
SN1013.InstType='mini';
SN1013.isbig=0;
SN1013.az_correction=-1; % determined from AlignCTD plots July 14 - AP
SN1013.suffix='A1013';
SN1013.cal.coef.T1P=0.097;
%~~~~~~~~~~~~~~~~~~~


%~~~~~~~~~~~~~~~~~~~
% SN 1002 - big chipod
SN1002.loggerSN='1002'; % logger serial number
SN1002.pcaseSN='1002';
SN1002.sensorSN.T1='13-10D';
SN1002.sensorSN.T2='11-23D';
SN1002.InstDir.T1='up';
SN1002.InstDir.T2='down';
SN1002.InstType='big';
SN1002.isbig=1;
SN1002.cal.coef.T1P=0.105;
SN1002.cal.coef.T2P=0.105;
SN1002.suffix='A1002';
SN1002.az_correction=-1; % check this ?

%~~~~~~~~~~~~~~~~~~~

%we deployed Amys 2 remaining chipods (1008 and 1014) on leg 3. 
%~~~~~~~~~~~~~~~~~~~
% SN 1008 - 
SN1008.loggerSN='1008'; % logger serial number
SN1008.pcaseSN='?';
SN1008.sensorSN.T1='?';
SN1008.sensorSN.T2='?';
SN1008.InstDir.T1='?';
SN1008.InstDir.T2='?';
SN1008.cal.coef.T1P=0.097;
SN1008.suffix='A1008';
SN1008.InstType='mini';
SN1008.isbig=0;
%~~~~~~~~~~~~~~~~~~~

%~~~~~~~~~~~~~~~~~~~
% SN 1014 - 
SN1014.loggerSN='1014'; % logger serial number
SN1014.pcaseSN='?';
SN1014.sensorSN.T1='?';
SN1014.sensorSN.T2='?';
SN1014.InstDir.T1='?';
SN1014.InstDir.T2='?';
SN1014.cal.coef.T1P=0.097;
SN1014.suffix='A1014';
SN1014.InstType='mini';
SN1014.isbig=0;
%~~~~~~~~~~~~~~~~~~~

% SN 1001 - big chipod deployed on Falkor?
% get data from Amy?


ChiInfo.SN102=SN102;
ChiInfo.SN1012=SN1012;
ChiInfo.SN1013=SN1013;
ChiInfo.SN1002=SN1002;
ChiInfo.SN1008=SN1008;
ChiInfo.SN1014=SN1014;
ChiInfo.SN1010=SN1010;
ChiInfo.MakeInfo='Chipod_Deploy_Info_TTIDE.m';
%%