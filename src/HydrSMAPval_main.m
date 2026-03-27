function HydrSMAPval_main(init_SM_Day,final_SM_Day, configurationPath)

close all
clearvars -except init_SM_Day final_SM_Day configurationPath
pixelSMAP=964 ;
lineSMAP=406 ; 
pixelSMAP09=3856 ; 
lineSMAP09=1624 ; 
pixelSMOS=1388 ;
lineSMOS=584 ; 

f = waitbar(0,'QC-main running. Please wait...');

ex=exist('configurationPath') ;
if ex ==0
    mode="GUI" ;
    [configurationfile configurationPath] = uigetfile('./*.cfg', 'Select input configuration file') ; 
    configurationPath= [ configurationPath configurationfile]  ; 
else
    if ~isfile(configurationPath)
        throw(MException('INPUT:ERROR', "Cannot find configuration file. Please check the command line and try again."))
    end
    mode="input" ;
end

%%%%%%%  Read configuration file

[init_SM_Day,final_SM_Day,RefSatellite, ProductLevel, ProcessingSatellite, savespace, MATfileFolder, DataInputRootPath, DynamicAuxiliarySMOSRootPath,...
    DynamicAuxiliarySMAPRootPath, DynamicAuxiliarySMAP09RootPath, LogsOutputRootPath, ThresholDist, ThresholdTimeDelay,...
    ThrSameDist, ThrSameTime, Threshold09Dist, Thr09SameDist, ReportFolder, SMAPQC, sizesave] = ReadConfFile(configurationPath);

%%%%%%%  End Read configuration file
%
%

switch mode
    case "GUI" 
%
% ****** get inputs from GUI
%
    disp('GUI mode')
% *************  Start GUI 
Answer{1}= char(init_SM_Day) ;                           Answer{13}= char(DynamicAuxiliarySMOSRootPath) ;
Answer{2}= char(final_SM_Day)  ;                         Answer{14}= char(LogsOutputRootPath) ;
Answer{3}= char(RefSatellite)  ;                         Answer{15}= char(ReportFolder) ;
Answer{4}= char(ProductLevel)  ;                         Answer{18}= char(string(ThresholDist)) ;
Answer{5}= char(ProcessingSatellite)  ;                  Answer{16}= char(string(ThresholdTimeDelay)) ;
Answer{6}= char(savespace)  ;                            Answer{17}= char(string(ThrSameTime)) ;
Answer{7}= char(string(sizesave))  ;                     Answer{20}= char(string(ThrSameDist)) ;
Answer{8}= char(SMAPQC)  ;                               Answer{19}= char(string(Threshold09Dist)) ;
Answer{9}= char(MATfileFolder)  ;                        Answer{21}= char(string(Thr09SameDist)) ;                                         
Answer{10}= char(DataInputRootPath)  ;                    
Answer{11}= char(DynamicAuxiliarySMAPRootPath) ;  
Answer{12}= char(DynamicAuxiliarySMAP09RootPath) ;         

% ****** get inputs from GUI
prompt={    'First day to compare [YYYY-MM-DDThh:mm]: ', ...
            'Last day to compare [YYYY-MM-DDThh:mm]: ', ...
            'Reference MW radiometer product [SMAP/SMA09/SMOS]: ' ...
            'HydroGNSS product level [L2G/L3]: ',...
            'HydroGNSS satellite [HydroGNSS-1/HydroGNSS-2]: ', ...
            'Save computer memory [Yes/No]: ',...
            'Size of reference data blocks [N. of pixels]: ',...
            'Quality flag of SMAP [Successfull/Recommended/none] or SMOS [NonNominal/none]: ', ...
            'Folder to store M-files: ',...
            'Data Input RootPath: ',...
            'SMAP 36km RootPath: ',...
            'SMAP 9km RootPath: ',...
            'SMOS RootPath: ',...
            'Log file RootPath: ', ...
            'Output report RootPath: ', ...
            'Threshold time delay [hours]: ', ...
            'Threshold same time [hours]: ', ...     
            'Threshold distance, 36 km reference [meters]: ', ...
            'Threshold distance, 9km reference [meters]: ', ...
            'Threshold same distance, 36 km reference [meters]:'... 
            'Threshold same distance, 9 km reference [meters]:' }; 

opts.Resize='on';
opts.WindowStyle='normal';
opts.Interpreter='tex';
name='HydroGNSS vs MW radiometer validation';
numlines=[1 90; 1 90; 1 90; 1 90; 1 90; 1 90 ; 1 90; 1 90; 1 90; 1 90; 1 90; ...
1 90; 1 90; 1 90; 1 90; 1 90; 1 90 ; 1 90; 1 90; 1 90; 1 90] ; 
defaultanswer={Answer{1},Answer{2},...
                 Answer{3},Answer{4},Answer{5},Answer{6},Answer{7},...
                 Answer{8},Answer{9},Answer{10}, Answer{11},Answer{12} ...
                 Answer{13},Answer{14},Answer{15}, Answer{16} ...
                 Answer{17},Answer{18},Answer{19}, Answer{20},Answer{21} };
Answer=inputdlg(prompt,name,numlines,defaultanswer,opts);

init_SM_Day= Answer{1};
final_SM_Day= Answer{2};
RefSatellite= Answer{3};
ProductLevel= Answer{4};
ProcessingSatellite=Answer{5} ; 
savespace= Answer{6} ; 
sizesave= str2num(Answer{7}) ;
SMAPQC=   Answer{8} ; ...
MATfileFolder=   Answer{9} ;
DataInputRootPath=Answer{10} ;
DynamicAuxiliarySMAPRootPath=Answer{11} ;
DynamicAuxiliarySMAP09RootPath=Answer{12} ;
DynamicAuxiliarySMOSRootPath=Answer{13} ;
LogsOutputRootPath=Answer{14} ;
ReportFolder=Answer{15} ;
ThresholdTimeDelay=str2num(Answer{16}) ;
ThrSameTime=str2num(Answer{17}) ;
ThresholDist=str2num(Answer{18}) ;
Threshold09Dist=str2num(Answer{19}) ;
ThrSameDist=str2num(Answer{20}) ;
Thr09SameDist=str2num(Answer{21}) ;


%
% ****** Save GUI input into Input Configuration File 
% save('../conf/Configuration.mat', 'Answer', '-append') ;

% WriteConfig(configurationPath, ProcessingSatellite, DataInputRootPath, DataOutputRootPath, LogsOutputRootPath, Outfileprefix, LatSouth, LatNorth, LonWest, LonEast, Dayinit, Dayfinal, DDM);

WriteConfig2(configurationPath, init_SM_Day,final_SM_Day,RefSatellite, ProductLevel, ProcessingSatellite, savespace, MATfileFolder, DataInputRootPath, DynamicAuxiliarySMOSRootPath,...
    DynamicAuxiliarySMAPRootPath, DynamicAuxiliarySMAP09RootPath, LogsOutputRootPath, ThresholDist, ThresholdTimeDelay,...
    ThrSameDist, ThrSameTime, Threshold09Dist, Thr09SameDist, ReportFolder, SMAPQC, sizesave) ; 


% switch mode
    case "input" 
    disp('input mode')
[init_SM_Day,final_SM_Day,RefSatellite, ProductLevel, ProcessingSatellite, savespace, MATfileFolder, DataInputRootPath, DynamicAuxiliarySMOSRootPath,...
    DynamicAuxiliarySMAPRootPath, DynamicAuxiliarySMAP09RootPath, LogsOutputRootPath, ThresholDist, ThresholdTimeDelay,...
    ThrSameDist, ThrSameTime, Threshold09Dist, Thr09SameDist, ReportFolder, SMAPQC, sizesave] = ReadConfFile(configurationPath);
%
 end
%
%%%%%%% Open log file
if ~exist(LogsOutputRootPath)
        throw(MException('INPUT:ERROR', "Cannot find configuration file. Please check the command line and try again."))
end
%
logfile= datetime('now','Format','yyyyMMdd_HHmmss') ; 
logfile=char(logfile) ;
namelogfile=['ValidationOut_' logfile '.log'] ; 
logfileID = fopen([char(LogsOutputRootPath) '\' namelogfile], 'a+') ; 
%
%%%%%%% End open log file

% Inizio di QC_mail
% Dayinit = datetime(Dayinit, 'InputFormat', 'yyyy-MM-dd''T''HH:mm') ;
% Dayfinal = datetime(Dayfinal, 'InputFormat', 'yyyy-MM-dd''T''HH:mm') ;


% 

% if ProductLevel~='L2G' & ProductLevel~='L3' 
    if string(ProductLevel)~="L2G" & string(ProductLevel)~="L3" 

        disp([char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' ERROR: Wrong product level. Program exiting']) ; 
        % fprintf(1,[char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' ERROR: Wrong product level. Program exiting']) ; 
        % fprintf(1,'\n') ; 

        fprintf(logfileID,[char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' ERROR: Wrong product level. Program exiting']) ; 
        fprintf(logfileID,'\n') ; 
        return
end
%
% if ~isfile(configurationPath)
%     disp([char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) '  ERROR, Cannot find configuration file. Please check the command line and try again.']) ; 
%         fprintf(logfileID,[char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) '  ERROR, Cannot find configuration file. Please check the command line and try again.']) ; 
%         fprintf(logfileID,'\n') ; 
%         return
%         % throw(MException('INPUT:ERROR', "Cannot find configuration file. Please check the command line and try again."))
% end
%
% *********   Init reading Auxiliary files
%
try
startDate = datetime(init_SM_Day, 'InputFormat', 'yyyy-MM-dd''T''HH:mm', 'Format',['yyyy-MM-dd' ' ' 'HH:mm']) ;
% startDate = datetime(init_SM_Day, 'InputFormat', 'yyyy-MM-dd') ;
catch
        throw(MException('INPUT:ERROR', "Wrong start date format. Please check the command line and try again."))
end
%
try
endDate = datetime(final_SM_Day, 'InputFormat', 'yyyy-MM-dd''T''HH:mm',  'Format',['yyyy-MM-dd' ' ' 'HH:mm']) ;
% endDate = datetime(final_SM_Day, 'InputFormat', 'yyyy-MM-dd') ;
catch
        throw(MException('INPUT:ERROR', "Wrong end date format. Please check the command line and try again."))
end
%
%%%%%%% Identify L2OP_SSM product folders in the PDGS

% endDate=endDate+hours(3) ; % Needed since the six hour block H00 starts on the previous day at 23:00:00
% startDate=startDate+hours(3) ;
% numdays=ceil(juliandate(endDate)-juliandate(startDate)+1) ; %devo mettere +1 ???????
numdays=ceil(juliandate(endDate)-juliandate(startDate)) ; %devo mettere +1 ???????

%%%% find out HydroGNSS file folder and names for the specified time frame
for ii=1:numdays
timeproduct=startDate+ii-1 ; 
   switch ProductLevel
   case "L2G"
for kk=1:4
    timeproductsix=timeproduct+hours((kk-1)*6) ; 
    timeproduct_sixtot(ii, kk)=timeproductsix ; 
    [tyear, tmonth, tday]=ymd(timeproductsix) ; 
    [thour, tmin, tsec]=hms(timeproductsix) ;

    six=6*fix(thour/6) ;
    sixhour=char(string(six)) ; 
        if tday< 10, charday=['0' char(string(tday))] ; else charday= char(string(tday)); end
        if tmonth< 10, charmonth=['0' char(string(tmonth))] ; else charmonth= char(string(tmonth)); end

        if six >= 12 
        L2OPfoldername=[char(DataInputRootPath) '\' char(ProcessingSatellite) '\DataRelease\L2OP-SSM\' char(string(tyear)) '-' charmonth '\' charday '\H' sixhour '\'] ;
        else
        L2OPfoldername=[char(DataInputRootPath) '\' char(ProcessingSatellite) '\DataRelease\L2OP-SSM\' char(string(tyear)) '-' charmonth '\' charday '\H0' sixhour '\'] ;
        end
   % L2OPfolder_sixtot(ii+ii*(kk-1))=string(L2OPfoldername) ; % vector with full folder path of L2OP product files
    L2OPfolder_sixtot(ii, kk)=string(L2OPfoldername) ; % matrix [num of days x 4 six hour block per day] vector with full folder path of L2OP product files

    % end 
end  % end loop on the 6 six hour bloch per day
    case "L3"
    kk=1 ; 
    timeproductsix=timeproduct+hours((kk-1)*6) ; 
    timeproduct_sixtot(ii, kk)=timeproductsix ; 
    [tyear, tmonth, tday]=ymd(timeproductsix) ; 
    [thour, tmin, tsec]=hms(timeproductsix) ;
        if tday< 10, charday=['0' char(string(tday))] ; else charday= char(string(tday)); end
        if tmonth< 10, charmonth=['0' char(string(tmonth))] ; else charmonth= char(string(tmonth)); end
    L2OPfoldername=[char(DataInputRootPath) '\DataRelease\L3OP-SSM\' char(string(tyear)) '-' charmonth '\' charday '\'] ;
    L2OPfolder_sixtot(ii, kk)=string(L2OPfoldername) ; % vector with full folder path of L2OP L3 product files
    end
end  % % end loop on the days
%
   switch ProductLevel
   case "L2G"
%%%%%%% Reading L2OP product for each six hour block and all days 
[vv, timeproduct_sixtotOK, L2OPdataOK, DateOK] = Read_L2G(numdays, L2OPfolder_sixtot, timeproduct_sixtot, ProductLevel, logfileID);
%% Fill structure L2OPdataOK with [] in case its size is less than 4 (i.e., the last six hour block never appeared
[a b]=size(L2OPdataOK) ; for ii=b+1:4;  L2OPdataOK(1,ii).ObservationUTCMidPointTime=[] ; end
   case "L3"
%%%%%%% Reading L3 product for each day 
[vv, timeproduct_sixtotOK, L2OPdataOK, DateOK] = Read_L3(numdays, L2OPfolder_sixtot, timeproduct_sixtot, ProductLevel, logfileID);
   end


%%%%% identify and read Reference Satellite data 
 if RefSatellite=="SMAP"      
%% Identify SMAP product folders in the PDGS for day OK
 [dayOK, dayOKwithSMAP, SMAPfolderOK, SMAPfileOK] = IdentifySMAPfolder(L2OPdataOK, timeproduct_sixtotOK, DynamicAuxiliarySMAPRootPath);
%% read SMAP 36 km data
 SMAP = ReadSMAP(dayOKwithSMAP, SMAPfileOK, SMAPfolderOK, pixelSMAP, lineSMAP);

 elseif RefSatellite=="SMAP09"
 ThresholDist=Threshold09Dist ;
 [dayOK, dayOKwithSMAP, SMAPfolderOK, SMAPfileOK] = IdentifySMAPfolder(L2OPdataOK, timeproduct_sixtotOK, DynamicAuxiliarySMAP09RootPath);
%% read SMAP 9 km data
 SMAP = ReadSMAP(dayOKwithSMAP, SMAPfileOK, SMAPfolderOK, pixelSMAP09, lineSMAP09);

 elseif RefSatellite=="SMOS"
% Identify SMOS product folders in the PDGS for day OK
 [dayOKSMOS, dayOKwithSMOS, SMOSfolderOK, SMOSfileOK_SD, SMOSfileOK_SA] = IdentifySMOSfolder(L2OPdataOK, timeproduct_sixtotOK, DynamicAuxiliarySMOSRootPath) ; 

%% read SMOS data
 SMAP = ReadSMOS(dayOKwithSMOS, SMOSfileOK_SD, SMOSfileOK_SA, SMOSfolderOK, pixelSMOS, lineSMOS); 
 dayOKwithSMAP=dayOKwithSMOS ; 
 dayOK=dayOKSMOS ; 

%%
 end

% SMAPSoilMoisture=[] ; SMAPTime=[]; SMAPLatitude=[] ; SMAPLongitude=[] ;
% [C, ia, ic]=unique(SMAPfileOK) ; 
% for ll=ia' , SMAPSoilMoisture=[SMAPSoilMoisture; SMAP(ll).SoilMoisture_AM_REF(:); SMAP(ll).SoilMoisture_PM_REF(:)];  end
% for ll=ia' , SMAPTime=[SMAPTime; SMAP(ll).tb_time_AM_REF(:)];  end
% for ll=ia' , SMAPLatitude=[SMAPLatitude; SMAP(ll).latitude_AM(:); SMAP(ll).latitude_PM(:)];  end
% for ll=ia' , SMAPLongitude=[SMAPLongitude; SMAP(ll).longitude_AM(:); SMAP(ll).longitude_PM(:)];  end
SMAPSMtoplot=[] ;  
HydroSMtoplot=[] ; 
HydroSMtoplotLat=[] ; 
HydroSMtoplotLon=[] ; 

% prepare figure with SMAP/SMOS maps
vvvvv=figure('Units', 'centimeters', 'Position', [0 0 21 29.7]) ;
tt=tiledlayout('flow') ; 
title(tt, [char(RefSatellite) ' SSM maps [%]'])
%
for ii=dayOKwithSMAP' 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for L3 we should considere one single day 
switch ProductLevel
    case "L2G" 
SMAPSoilMoisture=[SMAP(ii,1).SoilMoisture_AM_REF(:); SMAP(ii,2).SoilMoisture_AM_REF(:); SMAP(ii,3).SoilMoisture_AM_REF(:) ;...
    SMAP(ii,1).SoilMoisture_PM_REF(:); SMAP(ii,2).SoilMoisture_PM_REF(:); SMAP(ii,3).SoilMoisture_PM_REF(:) ] ;
SMAPTime=[SMAP(ii,1).tb_time_AM_REF(:); SMAP(ii,2).tb_time_AM_REF(:) ; SMAP(ii,3).tb_time_AM_REF(:);...
    SMAP(ii,1).tb_time_PM_REF(:); SMAP(ii,2).tb_time_PM_REF(:); SMAP(ii,3).tb_time_PM_REF(:)] ;
SMAPLatitude=[SMAP(ii,1).latitude_AM(:); SMAP(ii,2).latitude_AM(:); SMAP(ii,3).latitude_AM(:);...
    SMAP(ii,1).latitude_PM(:); SMAP(ii,2).latitude_PM(:); SMAP(ii,3).latitude_PM(:)] ;
SMAPLongitude=[SMAP(ii,1).longitude_AM(:); SMAP(ii,2).longitude_AM(:); SMAP(ii,3).longitude_AM(:);...
    SMAP(ii,1).longitude_PM(:); SMAP(ii,2).longitude_PM(:); SMAP(ii,3).longitude_PM(:)] ;
SMAPretrieval_qual_flag=[SMAP(ii,1).retrieval_qual_flag_AM_REF(:); SMAP(ii,2).retrieval_qual_flag_AM_REF(:); SMAP(ii,3).retrieval_qual_flag_AM_REF(:) ;...
    SMAP(ii,1).retrieval_qual_flag_PM_REF(:); SMAP(ii,2).retrieval_qual_flag_PM_REF(:); SMAP(ii,3).retrieval_qual_flag_PM_REF(:) ] ;

% clear SMAP

HydroSoilMoisture=[L2OPdataOK(ii,1).SoilMoisture(:); L2OPdataOK(ii,2).SoilMoisture(:);L2OPdataOK(ii,3).SoilMoisture(:);L2OPdataOK(ii,4).SoilMoisture(:)] ;
HydroTime=[L2OPdataOK(ii,1).ObservationUTCMidPointTime(:); L2OPdataOK(ii,2).ObservationUTCMidPointTime(:);L2OPdataOK(ii,3).ObservationUTCMidPointTime(:);L2OPdataOK(ii,4).ObservationUTCMidPointTime(:)] ;
HydroLat=[L2OPdataOK(ii,1).DataLatitude(:); L2OPdataOK(ii,2).DataLatitude(:);L2OPdataOK(ii,3).DataLatitude(:);L2OPdataOK(ii,4).DataLatitude(:)] ;
HydroLon=[L2OPdataOK(ii,1).DataLongitude(:); L2OPdataOK(ii,2).DataLongitude(:);L2OPdataOK(ii,3).DataLongitude(:);L2OPdataOK(ii,4).DataLongitude(:)] ;
HydroSSMQuality=[L2OPdataOK(ii,1).SSMQuality(:); L2OPdataOK(ii,2).SSMQuality(:);L2OPdataOK(ii,3).SSMQuality(:);L2OPdataOK(ii,4).SSMQuality(:)] ;
% clear L2OPdataOK
    
    case "L3"
SMAPSoilMoisture=[SMAP(ii,2).SoilMoisture_AM_REF(:); SMAP(ii,2).SoilMoisture_PM_REF(:)]; 
SMAPTime=[SMAP(ii,2).tb_time_AM_REF(:) ; SMAP(ii,2).tb_time_PM_REF(:)] ;
SMAPLatitude=[SMAP(ii,2).latitude_AM(:); SMAP(ii,2).latitude_PM(:)] ;
SMAPLongitude=[SMAP(ii,2).longitude_AM(:); SMAP(ii,2).longitude_PM(:)] ;
SMAPretrieval_qual_flag=[SMAP(ii,2).retrieval_qual_flag_AM_REF(:); SMAP(ii,2).retrieval_qual_flag_PM_REF(:)]; 

HydroSoilMoisture=L2OPdataOK(ii,1).SoilMoisture(:) ;
HydroTime=L2OPdataOK(ii,1).ObservationUTCMidPointTime(:) ;
HydroLat=L2OPdataOK(ii,1).DataLatitude(:); 
HydroLon=L2OPdataOK(ii,1).DataLongitude(:);
HydroSSMQuality=L2OPdataOK(ii,1).SSMQuality(:); 

end


HydroLat=single(HydroLat) ; 
HydroLon=single(HydroLon) ; 
Nomissed=find(ismissing(HydroTime)==0) ; 

HydroSoilMoisture=HydroSoilMoisture(Nomissed) ;
HydroTime=HydroTime(Nomissed) ;
HydroLat=HydroLat(Nomissed) ;
HydroLon=HydroLon(Nomissed)  ; 
HydroSSMQuality=HydroSSMQuality(Nomissed) ; 
clear Nomissed
PercSMnan(ii)=100*size(find(isnan(HydroSoilMoisture)>0))/size(HydroSoilMoisture) ; % Percentage of NaN in output HydroGNNS L2 product
IndexRetrieved=find(isnan(HydroSoilMoisture)==0) ; 
PercSMretrieve(ii)=100*length(IndexRetrieved)/length(HydroSoilMoisture) ; % Percentage of retrievals in output HydroGNNS L2 product 
for ff=1:32, Flag(ii,ff)=length(find(bitget(HydroSSMQuality(IndexRetrieved),ff)==1)); end 
PercSM_Flag1_good(ii)=100*length(find(bitget(HydroSSMQuality(IndexRetrieved),1)==0))/length(find(isnan(HydroSoilMoisture)==0)) ; % Percentage of retrievals in output HydroGNNS L2 product 
clear IndexRetrieved
Hydrononan=find(isnan(HydroSoilMoisture)==0) ;
HydroSoilMoisture=HydroSoilMoisture(Hydrononan) ;
HydroTime=HydroTime(Hydrononan) ;
HydroLat=HydroLat(Hydrononan) ;
HydroLon=HydroLon(Hydrononan)  ; 

SMAPTime(contains(SMAPTime, "N/A")==1)="NaT" ;  % needed as the first element of SMAP UTC time in SMAP 09 km is "N/A" 
% SMAPnonan=find(SMAPSoilMoisture ~= -9999 & isnan(SMAPSoilMoisture)==0) ;
% SMAPnonan=find(SMAPSoilMoisture ~= -9999 & isnan(SMAPSoilMoisture)==0 & datetime(SMAPTime, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSS') > min(datetime(HydroTime))- ThresholdTimeDelay/24 ...
%     & datetime(SMAPTime, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSS') < max(datetime(HydroTime))+ ThresholdTimeDelay/24) ;

SMAPnonan=find(SMAPSoilMoisture ~= -9999 & isnan(SMAPSoilMoisture)==0 & datetime(SMAPTime) > min(datetime(HydroTime))- ThresholdTimeDelay/24 ...
    & datetime(SMAPTime) < max(datetime(HydroTime))+ ThresholdTimeDelay/24) ;

if (RefSatellite=="SMAP" | RefSatellite=="SMAP09") &  SMAPQC=="Recommended" % This sis for SMAP data
goodRecommended=find(bitget(SMAPretrieval_qual_flag, 1)==0) ;
SMAPnonan = intersect(SMAPnonan,goodRecommended) ; 
elseif (RefSatellite=="SMAP" | RefSatellite=="SMAP09") &  SMAPQC=="Successfull" % This is for SMAP data
goodSuccessfull=find(bitget(SMAPretrieval_qual_flag, 3)==0) ;
SMAPnonan = intersect(SMAPnonan,goodSuccessfull) ; 
elseif RefSatellite=="SMOS" & SMAPQC=="NonNominal"  % This sis for SMOS data
goodRecommended=find(bitget(SMAPretrieval_qual_flag, 1)==0) ;
SMAPnonan = intersect(SMAPnonan,goodRecommended) ; 
else
disp('WARNING: No MW radiometer QC filtering')  
end

SMAPSoilMoisture=SMAPSoilMoisture(SMAPnonan) ; 
SMAPTime=SMAPTime(SMAPnonan) ; 
SMAPLatitude=SMAPLatitude(SMAPnonan) ;
SMAPLongitude=SMAPLongitude(SMAPnonan) ;
SMAPretrieval_qual_flag=SMAPretrieval_qual_flag(SMAPnonan) ;
% clear SMAPnonan HydroSSMQuality Hydrononan DelayPoints SMAPtimeAll arclen pippo
clear SMAPnonan HydroSSMQuality Hydrononan goodRecommended goodSuccessfull

[HydroPoints b]=size(HydroSoilMoisture)  ;
SMAPSMtoplot(ii,1:HydroPoints)=NaN(1,HydroPoints) ; 
HydroSMtoplot(ii,1:HydroPoints)=NaN(1,HydroPoints) ;
HydroSMtoplotLat(ii,1:HydroPoints)=NaN(1,HydroPoints) ; 
HydroSMtoplotLon(ii,1:HydroPoints)=NaN(1,HydroPoints) ; 
[SMAPPoints b]=size(SMAPSoilMoisture)  ;
HydroGNSSnumber(ii)=HydroPoints ; 
disp([char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' INFO: selection of SMAP and HydroGNSS files on day ' char(string(ii)) ' to be colocated terminated. Program continuing']) ; 
        fprintf(logfileID,[char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' INFO: selection of SMAP and HydroGNSS files on day ' char(string(ii)) ' to be colocated terminated. Program continuing']) ; 
        fprintf(logfileID,'\n') ; 
%         waitbar(ii/dayOK-0.1,f, 'QC-main progressing ....');
waitbar(ii/dayOK-0.1,f);


figure(vvvvv) ; nexttile ; geoscatter(SMAPLatitude, SMAPLongitude, [5] , 100.*SMAPSoilMoisture, 'filled')
colorbar ; 
% % if RefSatellite=="SMOS"
% %     title(['Day ' char(extractBefore(string(SMAPTime(ii,1)),' ')) ])
% % else
% %     title(['Day ' char(extractBefore(string(SMAPTime(ii,1)),'T')) ])
pos=find(char(SMAPfileOK(ii,2))=='2') ; title(['Day ' char(insertAfter(insertAfter(extractBetween(char(SMAPfileOK(ii,2)), pos(1), pos(1)+7),4, '-'), 7, '-')) ]) ; 
% % end

mindist=[] ;
mindelay=[] ; 
e = referenceEllipsoid('WGS84') ;
% if savespace=='Yes', mfile = matfile([MATfileFolder '\myFile.mat'],'Writable',true); end

if savespace=='Yes'
mfile = matfile([MATfileFolder '\myFile.mat'],'Writable',true); 
numsplits=fix(SMAPPoints/sizesave) ; 
if numsplits ==0
    myfile.arclen=1000.*Mylldistkm([HydroLat'; HydroLon'], [SMAPLatitude'; SMAPLongitude']) ;  
else
    myfile.arclen=[] ; 
    for isplit=1:sizesave:sizesave*numsplits    
%         isplit
% myfile.arclen=1000*Mylldistkm([HydroLat'; HydroLon'], [SMAPLatitude(isplit:isplit-1+step)'; SMAPLongitude(isplit:isplit-1+step)']) ; 
    myfile.arclen=[myfile.arclen, 1000*Mylldistkm([HydroLat'; HydroLon'], [SMAPLatitude(isplit:isplit-1+sizesave)'; SMAPLongitude(isplit:isplit-1+sizesave)']) ] ; 
end
    myfile.arclen=[myfile.arclen, 1000*Mylldistkm([HydroLat'; HydroLon'], [SMAPLatitude(isplit+sizesave:end)'; SMAPLongitude(isplit+sizesave:end)']) ] ; 
end 

% myfile.arclen=1000.*Mylldistkm([HydroLat'; HydroLon'], [SMAPLatitude'; SMAPLongitude']) ;    
sizearclen=size(myfile.arclen) ; 
[NearSpacerow, NearSpacecol] = find(myfile.arclen <= ThresholDist) ;
Idxspace= sub2ind(sizearclen,NearSpacerow,NearSpacecol) ; 
arclen=myfile.arclen(Idxspace) ; 
myfile.DelayPoints=hours(repmat(datetime(HydroTime(NearSpacerow)), 1,length(NearSpacerow))-repmat(datetime(SMAPTime(NearSpacecol))', length(NearSpacerow),1 )) ;
IdxDelay= sub2ind(size(myfile.DelayPoints),[1:1:length(NearSpacerow)]',[1:1:length(NearSpacerow)]') ;
DelayPoints=myfile.DelayPoints(IdxDelay) ;
else
arclen=1000.*Mylldistkm([HydroLat'; HydroLon'], [SMAPLatitude'; SMAPLongitude']) ;
sizearclen=size(arclen) ; 
[NearSpacerow, NearSpacecol] = find(arclen <= ThresholDist) ;
Idxspace= sub2ind(sizearclen,NearSpacerow,NearSpacecol) ; 
arclen=arclen(Idxspace) ; 
% DelayPoints=repmat(datetime(HydroTime), 1,SMAPPoints) ; 
% DelayPoints=hours(DelayPoints-repmat(datetime(SMAPTime)', HydroPoints,1 )) ;
% DelayPoints=DelayPoints(Idxspace) ; 
DelayPoints=hours(repmat(datetime(HydroTime(NearSpacerow)), 1,length(NearSpacerow))-repmat(datetime(SMAPTime(NearSpacecol))', length(NearSpacerow),1 )) ;
IdxDelay= sub2ind(size(DelayPoints),[1:1:length(NearSpacerow)]',[1:1:length(NearSpacerow)]') ;
DelayPoints=DelayPoints(IdxDelay) ;
end
% pippo=isnan(arclen); 
clear SMAPLatitude SMAPLongitude
clear HydroTime SMAPTime
% maxpippo=max(pippo(:)) ; 
% if max(pippo)==1,  pause(60), end 
% % mindist(ipoint)=min(arclen) ;
% clear pippo
%
Idxtime=find(abs(DelayPoints) <= ThresholdTimeDelay) ;
arclen=arclen(Idxtime) ; DelayPoints=DelayPoints(Idxtime) ; 
NearSpaceTime=Idxspace(Idxtime) ; 
D=arclen ; T= DelayPoints ; 
[NearSpaceTimerow,NearSpaceTimecol] = ind2sub(sizearclen,NearSpaceTime)  ;

[C, ia, ic]=unique(NearSpaceTimerow);
empty=0 ; 
for ipoint=1:length(C)
disp(['Colocate HydroGNSS point ' num2str(ipoint) ' of ' num2str(length(C)) ' under threshold']) 
NearPoints=NearSpaceTimecol(find(NearSpaceTimerow==C(ipoint))) ; 
if isempty(NearPoints)==1 ;
    SMAPSMtoplot(ii,C(ipoint))=NaN ; 
    HydroSMtoplot(ii,C(ipoint))=NaN ;
    HydroSMtoplotLat(ii,C(ipoint))=NaN ; 
    HydroSMtoplotLon(ii,C(ipoint))=NaN ; 
elseif  length(NearPoints) == 1  ;
    SMAPSMtoplot(ii,C(ipoint))=SMAPSoilMoisture(NearPoints) ; 
    HydroSMtoplot(ii,C(ipoint))=HydroSoilMoisture(C(ipoint)) ;
    HydroSMtoplotLat(ii,C(ipoint))=HydroLat(C(ipoint)) ; 
    HydroSMtoplotLon(ii,C(ipoint))=HydroLon(C(ipoint)); 
elseif length(NearPoints)>1 
    mindist=ThresholDist+1; 
    mindelay=ThresholdTimeDelay ; 
    indbest=[] ; 
    for jj=1: length(NearPoints)
        indNearPoints=find(Idxspace(Idxtime)==sub2ind(sizearclen,C(ipoint),NearPoints(jj))) ; 
        mindist=min(mindist, arclen(find(Idxspace(Idxtime)==sub2ind(sizearclen,C(ipoint),NearPoints(jj))))) ; 
        mindelay=min(mindelay, abs(DelayPoints(indNearPoints))) ; 
        indbest=[indbest, find(Idxspace(Idxtime)==sub2ind(sizearclen,C(ipoint),NearPoints(jj)))] ; 
    end
    bestpoint=find(arclen(indbest) < mindist + ThrSameDist & abs(DelayPoints(indbest)) < mindelay+ThrSameTime) ; 

        b=length(bestpoint) ; 
        if b ==1 ;
        SMAPSMtoplot(ii,C(ipoint))=SMAPSoilMoisture(NearPoints(bestpoint)) ; 
        HydroSMtoplot(ii,C(ipoint))=HydroSoilMoisture(C(ipoint)) ;
        HydroSMtoplotLat(ii,C(ipoint))=HydroLat(C(ipoint)) ; 
        HydroSMtoplotLon(ii,C(ipoint))=HydroLon(C(ipoint)); 
        elseif b > 1 ; 
        SMAPSMtoplot(ii,C(ipoint))=mean(SMAPSoilMoisture(NearPoints(bestpoint))) ; 
        HydroSMtoplot(ii,C(ipoint))=HydroSoilMoisture(C(ipoint)) ;
        HydroSMtoplotLat(ii,C(ipoint))=HydroLat(C(ipoint)) ; 
        HydroSMtoplotLon(ii,C(ipoint))=HydroLon(C(ipoint)); 
        else
        % empty=empty+1 n
        SMAPSMtoplot(ii,C(ipoint))=NaN ; 
        HydroSMtoplot(ii,C(ipoint))=NaN ;
        HydroSMtoplotLat(ii,C(ipoint))=NaN ; 
        HydroSMtoplotLon(ii,C(ipoint))=NaN; 
        disp([char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' WARNING: no selection of multiple nearest points. Program continuing']) ; 
        fprintf(logfileID,[char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' WARNING: no selection of multiple nearest points. Program continuing']) ; 
        fprintf(logfileID,'\n') ;     
        end
end
end %% end loop on number of HydroGNSS points
%
NumberColocation(ii)=length(find(isnan(HydroSMtoplot(ii,1:HydroPoints))==0)) ;
PercNoColocation(ii)=100*size(find(isnan(HydroSMtoplot(ii,1:HydroPoints))==1),2)/HydroPoints ; % Percentage of HydroGNNS L2 product without SMAP colocation
PercNoSaturations(ii)=100*size(find(HydroSMtoplot(ii,1:HydroPoints)==0 | HydroSMtoplot(ii,1:HydroPoints)==50),2)/HydroPoints ; % Percentage of HydroGNNS L2 product without SMAP colocation
%
end  % end look on number of days
SMAPSMtoplot_perc=100.*SMAPSMtoplot ; 
clear SMAPSMtoplot
errorTOT=[] ; HydroSMtoplotTOT=[];  SMAPSMtoplot_percTOT=[] ;
%%% computation and plot of figure with map of errors
vvvv=figure('Units', 'centimeters', 'Position', [0 0 21 29.7]) ;
hold on
ax1 = axes('Position',[0 0 1 1]); ax1.TickDir='out' ; 
ax2 = axes('Position',[0.1 0.25 0.8 0.5]); 
for ii=dayOKwithSMAP'
error= SMAPSMtoplot_perc(ii,1:HydroGNSSnumber(ii))- HydroSMtoplot(ii,1:HydroGNSSnumber(ii)) ; 
errorTOT=[errorTOT error] ;
noerrornan=find(isnan(error)==0) ; 
error=error(noerrornan) ; 
BIAS(ii)=mean(error) ; 
UbRMSE(ii)=std(error) ;
RMSE(ii)=sqrt(UbRMSE(ii)^2+BIAS(ii)^2) ; 
RMSE2(ii)=sqrt(mean(error.^2)) ; 
pippo=HydroSMtoplot(ii,1:HydroGNSSnumber(ii)) ;
HydroSMtoplotTOT=[HydroSMtoplotTOT pippo] ; 
pluto=SMAPSMtoplot_perc(ii,1:HydroGNSSnumber(ii)) ; 
SMAPSMtoplot_percTOT=[SMAPSMtoplot_percTOT pluto] ; 
% corrcoe(ii)=corrcoef(HydroSMtoplot(ii,1:HydroGNSSnumber(ii)), SMAPSMtoplot_perc(ii,1:HydroGNSSnumber(ii))) ; 
R=corrcoef(pippo(noerrornan), pluto(noerrornan)) ; 
corrcoe(ii)=R(1,2) ; 
corrcoe2(ii)=mean((pippo(noerrornan)-mean(pippo(noerrornan))).*(pluto(noerrornan)-mean(pluto(noerrornan))))./std(pluto(noerrornan))/std(pippo(noerrornan)) ;
geoscatter(HydroSMtoplotLat(ii,noerrornan),HydroSMtoplotLon(ii,noerrornan), 50, error, 'filled')
ax2=gca ; 
end
clear SMAP

c=colorbar('southoutside')
c.Label.String = 'SSM error [%]';
title('Map of SSM errors (Reference minus HydroGNSS) [%]')
%%% end of computation and plot of figure with map of errors

for ii=dayOKwithSMAP'
 
report1(ii)=string(['Percentage of retrievals in  HydroGNNS L2 product = ' char(string(round(PercSMretrieve(ii),2))) ' %']) ; 
report2(ii)=string(['Percentage of NaN in  HydroGNNS L2 product  = '       char(string(round(PercSMnan(ii),2))) ' %']) ;
report3(ii)=string(['Percentage of HydroGNNS L2 product without reference colocation  = ' char(string(round(PercNoColocation(ii),2))) ' %']) ;
report4(ii)=string(['Percentage of saturated (i.e., 0 or 50%) HydroGNNS L2 Soil Moisture  = ' char(string(round(PercNoSaturations(ii),2))) ' %']) ;
report9(ii)=string(['Percentage of retrievals with optimal quality = '           char(string(round(PercSM_Flag1_good(ii),2))) ' %']) ;
report5(ii)=string(['Root Mean Square Error  RMSE = '                      char(string(round(RMSE(ii),2))) ' %']) ;
report6(ii)=string(['Unbiased Root Mean Square Error  UbRMSE = '           char(string(round(UbRMSE(ii),2))) ' %']) ;
report7(ii)=string(['Bias = ' char(string(BIAS(ii))) ' %']) ;
report8(ii)=string(['Correlation coefficient R= '                      char(string(round(corrcoe(ii),2))) ' %']) ;

end

%%%
%legendtxt="" ; 
for ii=dayOKwithSMAP'
%pippo=string(['Day ' char(string(ii)) ': ' char(DateOK(ii)) '-' char(string(month(timeproduct_sixtot(ii,1)))) '-' char(string(year(timeproduct_sixtot(ii,1))))]) ; 
pippo=string(['Day ' char(string(ii)) ': ' char(DateOK(ii))]) ;
legendtxt(ii)=pippo ; 
end
% tiledlayout(2,1) ;

%% figures with maps of Soil moisture from HydroGNSS and histograms of flags
for ii=dayOKwithSMAP' 
figure(vv) ; nexttile ;
bar(Flag(ii,:)) ; 
xticks([1:2:32]); 
title(['L2 Flags on ' char(DateOK(ii))])
xlabel('Flag 32 bits')
end
%%% end of figures with maps of Soil moisture from HydroGNSS and histograms of flags

%%% figure with overall scatterplot of HydroGNSS vs reference
% vvv=figure('Units', 'centimeters', 'Position', [0 0 21 29.7]) ;
vvv=figure('Units', 'centimeters', 'Position', [0 0 21 29.7]) ;
tt=tiledlayout(4,1) ; 
title(tt, ['Entire time period comparison with ' char(RefSatellite) ' reference'])
nexttile(1, [2 1])
%  ax1 = axes('Position',[0 0 1 1]); ax1.TickDir='out' ; 
%  ax2 = axes('Position',[0.2 0.15 0.7 0.6]); 
for ii=dayOKwithSMAP'
plot(SMAPSMtoplot_perc(ii,1:HydroGNSSnumber(ii)), HydroSMtoplot(ii,1:HydroGNSSnumber(ii)), '.') ; 
hold on 
end
xlim([-5 55]) ;
ylim([-5 55]) ;
title(['HydrGNSS vs ' char(RefSatellite) ' reference SSM'])
ylabel(['HydroGNSS ' char(ProductLevel) ' Soil Moisture [%]'])
xlabel([char(RefSatellite) ' L3 Soil Moisture [%]'])
legend(legendtxt',"AutoUpdate","on", 'Location', 'eastoutside', 'FontSize', 12)

figure(vvv), nexttile
% ax1 = axes('Position',[0 0 1 1]); ax1.TickDir='out' ; 
% ax2 = axes('Position',[0 0 0.3 0.3]); 
plot(dayOKwithSMAP, RMSE, 'o-')
xlabel('Day of colocation count') ; ylabel('Soil Moisture RMSE [%]')
xlim([dayOKwithSMAP(1)-0.2, dayOKwithSMAP(end)+0.2]) ;
xticks(dayOKwithSMAP) ; 
ylim([round(min(RMSE), 0)-1, round(max(RMSE), 0)+1] );

figure(vvv), nexttile
% ax1 = axes('Position',[0 0 1 1]); ax1.TickDir='out' ; 
% ax2 = axes('Position',[0 0 0.3 0.3]); 
plot(dayOKwithSMAP, corrcoe, 'o')
xlabel('Day of colocation count') ; ylabel('Soil Moisture corr. coeff.')
xlim([dayOKwithSMAP(1)-0.2, dayOKwithSMAP(end)+0.2]) ;
xticks(dayOKwithSMAP) ;
ylim([0, 1] );

%%% end of figure with overall scatterplot of HydroGNSS vs reference

%%% figure with overall text report of performances
v=figure('Units', 'centimeters', 'Position', [0 0 21 29.7]) ;
ax1 = axes('Position',[1.1 0. 0.1 0.1]); 
xlim([0 10]) ;
ylim([0 10]) ;
vert=98 ;
indent=-100 ;
sizefontLarge=15 ;
sizefontSmall=12 ;
text(indent,vert, ['\fontsize{12} SSM QC report on ' char(datetime)] ) ; 
vert=vert-3 ; 
text(indent,vert, ['\fontsize{10} Reference:' char(RefSatellite) '. Time period: ' init_SM_Day ' to ' final_SM_Day] )
for ii=dayOKwithSMAP'
vert=vert-4 ; 
text(indent,vert, ['\fontsize{10} Day ' char(string(ii)) ':    Number of colocations= ' char(string(NumberColocation(ii)))] ) 
vert=vert-2 ; 
text(indent+6.4,vert, ['\fontsize{10} Root Mean Square Error= ' char(string(round(RMSE(ii),2))) ' %'] ) 
vert=vert-2 ; 
text(indent+6.4,vert, ['\fontsize{10} Unbiased Root Mean Square Error= ' char(string(round(UbRMSE(ii),2))) ' %'] ) 
vert=vert-2 ; 
text(indent+6.4,vert, ['\fontsize{10} Bias= ' char(string(round(BIAS(ii),2))) ' %'] ) 
vert=vert-2 ; 
text(indent+6.4,vert, ['\fontsize{10} R= ' char(string(round(corrcoe(ii),2))) ' %'] ) 
vert=vert-1 ;
text(indent+7,vert,['\fontsize{10} ' report1(ii)])
vert=vert-2 ; 
text(indent+7,vert, ['\fontsize{10} ' report2(ii)])
vert=vert-2 ; 
text(indent+7,vert,['\fontsize{10} ' report3(ii)])
vert=vert-2 ; 
text(indent+7,vert,['\fontsize{10} ' report4(ii)])
vert=vert-2 ; 
text(indent+7,vert,['\fontsize{10} ' report9(ii)])
end
%%% figure with overall text report of performances

reportfile=[char(ReportFolder) '\HydroGNSSQCreport_' char(datetime('now','Format','yy-MM-dd_HH-mm')) '.pdf'] ;

Title=['SSM QC report: HydroGNSS vs ' char(RefSatellite)] ;
str1=['Time of issue: ' char(datetime) '. Reference: ' char(RefSatellite)] ; 
str11= ['First day: ' char(init_SM_Day) '. Final day: ' char(final_SM_Day)] ;
% C = {} ;
C = {Title, str1, str11} ;
for ii=dayOKwithSMAP'
str0=['Day ' char(string(ii)) ': '   char(DateOK(ii))] ; 
str1 = ['        Number of colocations: ', char(string(NumberColocation(ii)))] ;
str2 = ['        Percentage of SP with retrievals: ', char(string(round(PercSMretrieve(ii),2))) ' %'] ;
str3 = ['        Percentage of HydroGNNS product without reference colocation: ',  char(string(round(PercNoColocation(ii),2))) ' %'] ;
str4 = ['        Percentage of saturated (i.e., 0/50%) HydroGNNS L2 Soil Moisture: ',  char(string(round(PercNoSaturations(ii),2))) ' %'] ;
str9 = ['        Percentage of retrievals with optimal quality: ',  char(string(round(PercSM_Flag1_good(ii),2))) ' %'] ;
str5=['        Root mean square error:                  RMSE=' char(string(round(RMSE(ii),2))), ' m^3/m^3' ] ; 
str6=['        Unbiased root mean square error:   UbRMSE=' char(string(round(UbRMSE(ii),2))), ' m^3/m^3' ] ; 
str7=['        Bias:                                                 B=' char(string(round(BIAS(ii),2))), ' m^3/m^3' ] ; 
str8=['        Correlation coefficient:                     R=' char(string(round(corrcoe(ii),2)))] ;
C = [C {str0, str1, str2 , str3, str4, str9, str5, str6, str7, str8}] ; 
end

% Compute and print overall statistics
noerrornan=find(isnan(errorTOT)==0) ; 
errorTOT=errorTOT(noerrornan) ; 
BIAStot=mean(errorTOT) ; 
UbRMSEtot=std(errorTOT) ;
RMSEtot=sqrt(UbRMSEtot^2+BIAStot^2) ; 
RMSE2tot(ii)=sqrt(mean(errorTOT.^2)) ; 
% pippo=HydroSMtoplot(ii,1:HydroGNSSnumber(ii)) ;
% pluto=SMAPSMtoplot_perc(ii,1:HydroGNSSnumber(ii)) ; 
% corrcoe(ii)=corrcoef(HydroSMtoplot(ii,1:HydroGNSSnumber(ii)), SMAPSMtoplot_perc(ii,1:HydroGNSSnumber(ii))) ; 
R=corrcoef(HydroSMtoplotTOT(noerrornan), SMAPSMtoplot_percTOT(noerrornan)) ; 
corrcoeTOT=R(1,2) ; 
corrcoe2TOT=mean((HydroSMtoplotTOT(noerrornan)-mean(HydroSMtoplotTOT(noerrornan))).*(SMAPSMtoplot_percTOT(noerrornan)-mean(SMAPSMtoplot_percTOT(noerrornan))))./std(SMAPSMtoplot_percTOT(noerrornan))/std(HydroSMtoplotTOT(noerrornan)) ;
% text in the odf repoort
str0=['All days from ' char(DateOK(1)) ' to ' char(DateOK(end))] ; 
str5=['        Root mean square error:                  RMSE=' char(string(round(RMSEtot,2))), ' m^3/m^3' ] ; 
str6=['        Unbiased root mean square error:   UbRMSE=' char(string(round(UbRMSEtot,2))), ' m^3/m^3' ] ; 
str7=['        Bias:                                                 B=' char(string(round(BIAStot,2))), ' m^3/m^3' ] ; 
str8=['        Correlation coefficient:                     R=' char(string(round(corrcoeTOT,2)))] ;
C = [C {str0, str5, str6, str7, str8}] ; 
%% print on screen 
vert=vert-4 ; 
text(indent,vert, ['\fontsize{12} All days from ' char(DateOK(1)) ' to ' char(DateOK(end))] ) 
vert=vert-2 ; 
text(indent+6.4,vert, ['\fontsize{10} Root Mean Square Error= ' char(string(round(RMSEtot,2))) ' %'] ) 
vert=vert-2 ; 
text(indent+6.4,vert, ['\fontsize{10} Unbiased Root Mean Square Error= ' char(string(round(UbRMSEtot,2))) ' %'] ) 
vert=vert-2 ; 
text(indent+6.4,vert, ['\fontsize{10} Bias= ' char(string(round(BIAStot,2))) ' %'] ) 
vert=vert-2 ; 
text(indent+6.4,vert, ['\fontsize{10} R= ' char(string(round(corrcoeTOT,2)))] ) 
%%
ok = text2pdf(reportfile,C,0) ; 
exportgraphics(vv,reportfile, 'Append', true) ;
exportgraphics(vvv,reportfile, 'Append', true) ;
exportgraphics(vvvv,reportfile, 'Append', true) ;

 disp([char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' INFO: End of program']) ; 
 fprintf(logfileID,[char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' INFO: End of program']) ; 
 fprintf(logfileID,'\n') ; 

waitbar(1,f, 'End of program');
close(f) ;

end
