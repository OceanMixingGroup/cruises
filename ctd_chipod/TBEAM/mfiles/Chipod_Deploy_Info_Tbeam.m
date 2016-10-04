%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Chipod_Deploy_Info_TTIDE_Falkor_Big.m
%
% Info for CTD chipods deployed during T-Tide Falkor cruise. For loading during chipod
% processing.
%
% For 'Big' CTD
%
% Data folders were orginally labeled by pressure case; corresonding logger
% SNs are :
% Ti24-1 = SN1011
% Ti24-2 = SN1008
% Ti24-3 = SN1014
% Ti24-4 = SN1006

%
%--------------------------
% 06/30/15 - A.Pickering - apickering@coas.oregonstate.edu
% 02/02/16 - Add SN1001 (big chipod)
% 02/11/16 - AP - add SN1011
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

ChiInfo=struct();
ChiInfo.Project='Tbeam';
ChiInfo.Cruise='Tbeam'
ChiInfo.Note='BigCTD'
ChiInfo.CastString='FK150117'
ChiInfo.SNs={'SN1001','SN1006','SN1008','SN1014'}

%~~~~~~~~~~~~~~~~~~~
% SN 1001  (big?)
clear S
S.loggerSN='1001'; 
S.pcaseSN='?';
S.sensorSN.T1='?';
S.sensorSN.T2='?';
S.InstDir.T1='down';
S.InstDir.T2='up';
S.InstType='big';
S.isbig=1;
S.cal.coef.T1P=0.105;
S.cal.coef.T2P=0.105;
S.suffix='A1001';
S.az_correction=-1; 
SN1001=S;clear S


%~~~~~~~~~~~~~~~~~~~
% SN 1006
clear S
S.loggerSN='1006'; % logger serial number
S.pcaseSN='Ti24-4;';
S.sensorSN='?';
S.InstDir.T1='up';
S.InstType='mini';
S.isbig=0;
S.az_correction=-1; % * check
S.suffix='A1006';
S.cal.coef.T1P=0.097;
SN1006=S;
clear S

% 
% SN1011 was on little CTD
% %~~~~~~~~~~~~~~~~~~~
% % SN 1011
% clear S
% S.loggerSN='1011'; % logger serial number
% S.pcaseSN='';
% S.sensorSN='?';
% S.InstDir='?';
% S.InstType='mini';
% S.isbig=0; %
% S.az_correction=1; % *check
% S.suffix='A1011'; % suffix for data filenames
% S.cal.coef.T1P=0.097;
% SN1011=S;clear S
% %~~~~~~~~~~~~~~~~~~~



%~~~~~~~~~~~~~~~~~~~
% SN 1008 
clear S
S.loggerSN='1008'; % logger serial number
S.pcaseSN='Ti24-2';
S.sensorSN='?';
S.InstDir.T1='down';
S.InstType='mini';
S.isbig=0; %
S.az_correction=1; % *check
S.suffix='A1008'; % suffix for data filenames
S.cal.coef.T1P=0.097;
SN1008=S;clear S
%~~~~~~~~~~~~~~~~~~~


%~~~~~~~~~~~~~~~~~~~
% SN 1014
clear S
S.loggerSN='1014'; % logger serial number
S.pcaseSN='Ti24-3';
S.sensorSN='?';
S.InstDir.T1='up'; %?
S.InstType='mini';
S.isbig=0; %
S.az_correction=1; % *check
S.suffix='A1014'; % suffix for data filenames
S.cal.coef.T1P=0.097;
SN1014=S;clear S
%~~~~~~~~~~~~~~~~~~~


ChiInfo.SN1001=SN1001;
ChiInfo.SN1006=SN1006;
ChiInfo.SN1008=SN1008;
ChiInfo.SN1014=SN1014;

clear SN1006 SN1008 SN1001 SN1014 SN1011
ChiInfo.MakeInfo='Chipod_Deploy_Info_TTIDE_Falkor_Big.m';
%%