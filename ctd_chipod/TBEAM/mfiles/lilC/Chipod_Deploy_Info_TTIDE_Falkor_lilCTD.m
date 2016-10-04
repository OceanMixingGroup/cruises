%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Chipod_Deploy_Info_TTIDE_Falkor_lilCTD.m
%
% Info for CTD chipods deployed during T-Tide Falkor cruise. For loading during chipod
% processing.
%
% For 'lil' CTD
%
% Data folders were orginally labeled by pressure case; corresonding logger
% SNs are :
% Ti24-1 = SN1011
% Ti24-2 = SN1008
% Ti24-3 = SN1014
% Ti24-4 = SN1006
%
%
%--------------------------
% 12/17/15 - A.Pickering - apickering@coas.oregonstate.edu
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%%

ChiInfo=struct();
ChiInfo.Project='TTIDE';
ChiInfo.Cruise='Falkor'
ChiInfo.Note='lilCTD'
ChiInfo.CastString='FK150117'
ChiInfo.SNs={'SN1006','SN1011','SN1014'}

%~~~~~~~~~~~~~~~~~~~
% % SN 1006
clear S
S.loggerSN='1006'; % logger serial number
S.pcaseSN='Ti24-4;';
S.sensorSN='?';
S.InstDir='down';
S.InstType='mini';
S.isbig=0;
S.az_correction=-1; % * check
S.suffix='A1006';
S.cal.coef.T1P=0.097;
SN1006=S;
clear S
% 

% %~~~~~~~~~~~~~~~~~~~
% % SN 1011
clear S
S.loggerSN='1011'; % logger serial number
S.pcaseSN='Ti24-1';
S.sensorSN='?';
S.az_correction=-1; % *check
S.InstDir='up';
S.isbig=0;
S.InstType='mini';
S.suffix='A1011';
S.cal.coef.T1P=0.097;
SN1011=S; clear S
% %~~~~~~~~~~~~~~~~~~~


% %~~~~~~~~~~~~~~~~~~~
% SN 1014
clear S
S.loggerSN='1014'; % logger serial number
S.pcaseSN='Ti24-3';
S.sensorSN='11-22D';
S.InstDir='up';
S.InstType='mini';
S.isbig=0;
S.az_correction=-1; % *check
S.suffix='A1014';
S.cal.coef.T1P=0.097;
SN1014=S;clear S
%~~~~~~~~~~~~~~~~~~~


ChiInfo.SN1006=SN1006;
ChiInfo.SN1011=SN1011;
ChiInfo.SN1014=SN1014;

ChiInfo.MakeInfo='Chipod_Deploy_Info_TTIDE_Falkor_lilCTD.m';
%%