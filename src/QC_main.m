function QC_main(init_SM_Day,final_SM_Day, configurationPath)

close all
clearvars -except init_SM_Day final_SM_Day configurationPath

f = waitbar(0,'QC-main running. Please wait...');

pixelSMAP=964 ;
lineSMAP=406 ; 
pixelSMOS=1388 ;
lineSMOS=584 ; 
% tic
% 
% global L2OPdatacQ
%
if ~isfile(configurationPath)
        throw(MException('INPUT:ERROR', "Cannot find configuration file. Please check the command line and try again."))
end
%    
%%%%%%%  Read configuration file
%
            lines = string(splitlines(fileread(configurationPath)));
%             
%%         
            ConfigRightLine= contains(lines,'RefSatellite')  ;  
            ConfigRightLine= find(ConfigRightLine==1)  ;   
            startIndex= regexp(lines(ConfigRightLine),'=') ; 
            RefSatellite= extractAfter(lines(ConfigRightLine),startIndex) ;

%%         
            ConfigRightLine= contains(lines,'ProductLevel')  ;  
            ConfigRightLine= find(ConfigRightLine==1)  ;   
            startIndex= regexp(lines(ConfigRightLine),'=') ; 
            ProductLevel= extractAfter(lines(ConfigRightLine),startIndex) ;
%%         
            ConfigRightLine= contains(lines,'ProcessingSatellite')  ;  
            ConfigRightLine= find(ConfigRightLine==1)  ;   
            startIndex= regexp(lines(ConfigRightLine),'=') ; 
            ProcessingSatellite= extractAfter(lines(ConfigRightLine),startIndex) ;
%%         
            ConfigRightLine= contains(lines,'DataInputRootPath')  ;  
            ConfigRightLine= find(ConfigRightLine==1)  ;   
            startIndex= regexp(lines(ConfigRightLine),'=') ; 
            DataInputRootPath= extractAfter(lines(ConfigRightLine),startIndex) ;
%%         
            ConfigRightLine= contains(lines,'DataOutputRootPath')  ;  
            ConfigRightLine= find(ConfigRightLine==1)  ;   
            startIndex= regexp(lines(ConfigRightLine),'=') ; 
            DataOutputRootPath= extractAfter(lines(ConfigRightLine),startIndex) ;
%%         
            ConfigRightLine= contains(lines,'DynamicAuxiliarySMOSRootPath')  ;  
            ConfigRightLine= find(ConfigRightLine==1)  ;   
            startIndex= regexp(lines(ConfigRightLine),'=') ; 
            DynamicAuxiliarySMOSRootPath= extractAfter(lines(ConfigRightLine),startIndex) ;
%%         
            ConfigRightLine= contains(lines,'DynamicAuxiliarySMAPRootPath')  ;  
            ConfigRightLine= find(ConfigRightLine==1)  ;   
            startIndex= regexp(lines(ConfigRightLine),'=') ; 
            DynamicAuxiliarySMAPRootPath= extractAfter(lines(ConfigRightLine),startIndex) ;
%%         
            ConfigRightLine= contains(lines,'LogsOutputRootPath')  ;  
            ConfigRightLine= find(ConfigRightLine==1)  ;   
            startIndex= regexp(lines(ConfigRightLine),'=') ; 
            LogsOutputRootPath= extractAfter(lines(ConfigRightLine),startIndex) ;
%%                  
            ConfigRightLine= contains(lines,'ThresholDist')  ;  
            ConfigRightLine= find(ConfigRightLine==1)  ;   
            startIndex= regexp(lines(ConfigRightLine),'=') ; 
            ThresholDist= extractAfter(lines(ConfigRightLine),startIndex) ; % max distance between SP and SMAP grid cell in meters
            ThresholDist=double(ThresholDist) ; 
%%         
            ConfigRightLine= contains(lines,'ThresholdTimeDelay')  ;  
            ConfigRightLine= find(ConfigRightLine==1)  ;   
            startIndex= regexp(lines(ConfigRightLine),'=') ; 
            ThresholdTimeDelay= extractAfter(lines(ConfigRightLine),startIndex) ; % max time delay between SP time and SMAP Sm time in hours
            ThresholdTimeDelay=double(ThresholdTimeDelay)  ; 
%%         
            ConfigRightLine= contains(lines,'ThrSameDist')  ;  
            ConfigRightLine= find(ConfigRightLine==1)  ;   
            startIndex= regexp(lines(ConfigRightLine),'=') ; 
            ThrSameDist= extractAfter(lines(ConfigRightLine),startIndex) ; % max time delay between SP time and SMAP Sm time in hours
            ThrSameDist=double(ThrSameDist)  ; % Distance tolerance for which two SMAP data can be considered equivalent

%%         
            ConfigRightLine= contains(lines,'ThrSameTime')  ;  
            ConfigRightLine= find(ConfigRightLine==1)  ;   
            startIndex= regexp(lines(ConfigRightLine),'=') ; 
            ThrSameTime= extractAfter(lines(ConfigRightLine),startIndex) ; % max time delay between SP time and SMAP Sm time in hours
            ThrSameTime=double(ThrSameTime)  ; % time tolerance for which two SMAP data can be considered equivalent

%%         
            ConfigRightLine= contains(lines,'ReportFolder')  ;  
            ConfigRightLine= find(ConfigRightLine==1)  ;   
            startIndex= regexp(lines(ConfigRightLine),'=') ; 
            ReportFolder= extractAfter(lines(ConfigRightLine),startIndex) ; % max time delay between SP time and SMAP Sm time in hours

%%%%%%%  End Read configuration file
%
%%%%%%% Open log file
if ~exist(LogsOutputRootPath)
        throw(MException('INPUT:ERROR', "Cannot find configuration file. Please check the command line and try again."))
end
%
logfile= datetime('now','Format','yyyyMMdd_HHmmss') ; 
logfile=char(logfile) ;
namelogfile=['QCout_' logfile '.log'] ; 
logfileID = fopen([char(LogsOutputRootPath) '\' namelogfile], 'a+') ; 
%
%%%%%%% End open log file
%
% if ProductLevel~='L2G' & ProductLevel~='L3' 
    if ProductLevel~='L2G' 

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
startDate = datetime(init_SM_Day, 'InputFormat', 'yyyy-MM-dd''T''HH:mm') ;
% startDate = datetime(init_SM_Day, 'InputFormat', 'yyyy-MM-dd') ;
catch
        throw(MException('INPUT:ERROR', "Wrong start date format. Please check the command line and try again."))
end
%
try
endDate = datetime(final_SM_Day, 'InputFormat', 'yyyy-MM-dd''T''HH:mm') ;
% endDate = datetime(final_SM_Day, 'InputFormat', 'yyyy-MM-dd') ;
catch
        throw(MException('INPUT:ERROR', "Wrong end date format. Please check the command line and try again."))
end
%
%%%%%%% Identify L2OP_SSM product folders in the PDGS

endDate=endDate+hours(3) ; % Needed since the six hour block H00 starts on the previous day at 21:00:00
startDate=startDate+hours(3) ;
numdays=ceil(juliandate(endDate)-juliandate(startDate)+1) ; %devo mettere +1 ???????

%%%% find out HydroGNSS file folder and names for the specified time frame
for ii=1:numdays
timeproduct=startDate+ii-1 ; 
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
    end
end

%%%%%%% Reading L2OP product for each six hour block 


L2OPfilename='L2OP-SSM.nc' ; 
count_sixhour=0 ; 
count_day=0 ; 
vv=figure('Units', 'centimeters', 'Position', [0 0 21 29.7]) ;
t=tiledlayout('flow') ; 
title(t,'HydroGNSS L2G SSM maps')
for ii=1:numdays
    mm=0 ; 
    for kk=1:4

%             icount=ii+ii*(kk-1) ; 
% icount=kk ; 
        L2OPfolder=char(L2OPfolder_sixtot(ii,kk)) ;
        if exist([L2OPfolder L2OPfilename]) 
        mm=mm+1 ; 
        count_sixhour=count_sixhour+1 ; 
        if mm==1, count_day=count_day+1 ; end 
        L2OPfolderOK(count_day,kk)=string(L2OPfolder) ;
        timeproduct_sixtotOK(count_day,kk)=timeproduct_sixtot(ii, kk) ; 
        L2OPdataOK(count_day,kk)=ReadL2OPproduct(count_sixhour, L2OPfolder, L2OPfilename, ProductLevel) ;
        
        nexttile
        geoscatter(L2OPdataOK(count_day,kk).DataLatitude(:), L2OPdataOK(count_day,kk).DataLongitude(:),[], L2OPdataOK(count_day,kk).SoilMoisture(:) )
        
        DateOK(count_day)=extractBefore(string(timeproduct_sixtot(ii,1)),' ') ; 
        title(['Day ' char(extractBefore(string(timeproduct_sixtot(ii,1)),' ')) ' - Six hour block ' char(string(kk))])
        else
        disp([char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' WARNING: six hour block ' L2OPfolder ' does not exist. Program continuing']) ; 
       
        %type([char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' WARNING PROVA: no selection of multiple nearest points. Program continuing']) ; 


        % fprintf(1,[char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' WARNING: six hour block does not exist. Program continuing']) ; 
        fprintf(logfileID,[char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' WARNING: six hour block does not exist. Program continuing']) ; 
        fprintf(logfileID,'\n') ; 
        end

    end
end
%%%%% identify and read Reference Satellite data 
 if RefSatellite=="SMAP"      
%% Identify SMAP product folders in the PDGS for day OK
 [dayOK, dayOKwithSMAP, SMAPfolderOK, SMAPfileOK] = IdentifySMAPfolder(L2OPdataOK, timeproduct_sixtotOK, DynamicAuxiliarySMAPRootPath);
%% read SMAP data
 SMAP = ReadSMAP(dayOKwithSMAP, SMAPfileOK, SMAPfolderOK, pixelSMAP, lineSMAP);

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

for ii=dayOKwithSMAP' 

SMAPSoilMoisture=[SMAP(ii,1).SoilMoisture_AM_REF(:); SMAP(ii,2).SoilMoisture_AM_REF(:); SMAP(ii,3).SoilMoisture_AM_REF(:) ;...
    SMAP(ii,1).SoilMoisture_PM_REF(:); SMAP(ii,2).SoilMoisture_PM_REF(:); SMAP(ii,3).SoilMoisture_PM_REF(:) ] ;
SMAPTime=[SMAP(ii,1).tb_time_AM_REF(:); SMAP(ii,2).tb_time_AM_REF(:) ; SMAP(ii,3).tb_time_AM_REF(:);...
    SMAP(ii,1).tb_time_PM_REF(:); SMAP(ii,2).tb_time_PM_REF(:); SMAP(ii,3).tb_time_PM_REF(:)] ;
SMAPLatitude=[SMAP(ii,1).latitude_AM(:); SMAP(ii,2).latitude_AM(:); SMAP(ii,3).latitude_AM(:);...
    SMAP(ii,1).latitude_PM(:); SMAP(ii,2).latitude_PM(:); SMAP(ii,3).latitude_PM(:)] ;
SMAPLongitude=[SMAP(ii,1).longitude_AM(:); SMAP(ii,2).longitude_AM(:); SMAP(ii,3).longitude_AM(:);...
    SMAP(ii,1).longitude_PM(:); SMAP(ii,2).longitude_PM(:); SMAP(ii,3).longitude_PM(:)] ;


HydroSoilMoisture=[L2OPdataOK(ii,1).SoilMoisture(:); L2OPdataOK(ii,2).SoilMoisture(:);L2OPdataOK(ii,3).SoilMoisture(:);L2OPdataOK(ii,4).SoilMoisture(:)] ;
HydroTime=[L2OPdataOK(ii,1).ObservationUTCMidPointTime(:); L2OPdataOK(ii,2).ObservationUTCMidPointTime(:);L2OPdataOK(ii,3).ObservationUTCMidPointTime(:);L2OPdataOK(ii,4).ObservationUTCMidPointTime(:)] ;
HydroLat=[L2OPdataOK(ii,1).DataLatitude(:); L2OPdataOK(ii,2).DataLatitude(:);L2OPdataOK(ii,3).DataLatitude(:);L2OPdataOK(ii,4).DataLatitude(:)] ;
HydroLon=[L2OPdataOK(ii,1).DataLongitude(:); L2OPdataOK(ii,2).DataLongitude(:);L2OPdataOK(ii,3).DataLongitude(:);L2OPdataOK(ii,4).DataLongitude(:)] ;
HydroSSMQuality=[L2OPdataOK(ii,1).SSMQuality(:); L2OPdataOK(ii,2).SSMQuality(:);L2OPdataOK(ii,3).SSMQuality(:);L2OPdataOK(ii,4).SSMQuality(:)] ;

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

Hydrononan=find(isnan(HydroSoilMoisture)==0) ;
HydroSoilMoisture=HydroSoilMoisture(Hydrononan) ;
HydroTime=HydroTime(Hydrononan) ;
HydroLat=HydroLat(Hydrononan) ;
HydroLon=HydroLon(Hydrononan)  ; 

% SMAPnonan=find(SMAPSoilMoisture ~= -9999 & isnan(SMAPSoilMoisture)==0) ;
SMAPnonan=find(SMAPSoilMoisture ~= -9999 & isnan(SMAPSoilMoisture)==0 & datetime(SMAPTime) > min(datetime(HydroTime))- ThresholdTimeDelay/24 ...
    & datetime(SMAPTime) < max(datetime(HydroTime))+ ThresholdTimeDelay/24) ;

SMAPSoilMoisture=SMAPSoilMoisture(SMAPnonan) ; 
SMAPTime=SMAPTime(SMAPnonan) ; 
SMAPLatitude=SMAPLatitude(SMAPnonan) ;
SMAPLongitude=SMAPLongitude(SMAPnonan) ;
clear SMAPnonan HydroSSMQuality Hydrononan DelayPoints SMAPtimeAll arclen pippo
[HydroPoints b]=size(HydroSoilMoisture)  ;
[SMAPPoints b]=size(SMAPSoilMoisture)  ;
HydroGNSSnumber(ii)=HydroPoints ; 
disp([char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' INFO: selection of SMAP and HydroGNSS files on day ' char(string(ii)) ' to be colocated terminated. Program continuing']) ; 
        fprintf(logfileID,[char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' INFO: selection of SMAP and HydroGNSS files on day ' char(string(ii)) ' to be colocated terminated. Program continuing']) ; 
        fprintf(logfileID,'\n') ; 
        waitbar(ii/dayOK-0.1,f, 'QC-main progressing ....');

mindist=[] ;
mindelay=[] ; 
e = referenceEllipsoid('WGS84') ;
% for ipoint=1: HydroPoints
% arclen2= distance(HydroLat(ipoint),HydroLon(ipoint), SMAPLatitude, SMAPLongitude,e) ;
[arclen, pippo]= Mylldistkm([HydroLat'; HydroLon'], [SMAPLatitude'; SMAPLongitude']) ;
arclen=arclen*1000 ; 
pippo=isnan(arclen); 
maxpippo=max(pippo(:)) ; 
if max(pippo)==1,  pause(60), end 
% mindist(ipoint)=min(arclen) ;
clear pippo
HydrotimeAll=repmat(datetime(HydroTime), 1,SMAPPoints) ;
% % if RefSatellite=="SMAP", SMAPtimeAll=repmat(datetime(extractBefore(SMAPTime, 'Z'))', HydroPoints,1 ) ;
% % else SMAPtimeAll=repmat(datetime(SMAPTime)', HydroPoints,1 ) ;
% % end
SMAPtimeAll=repmat(datetime(SMAPTime)', HydroPoints,1 ) ;
DelayPoints=HydrotimeAll-SMAPtimeAll ; 
clear HydrotimeAll HydrotimeAll ; 
% datetime(repmat(HydroTime, 1,SMAPPoints))- repmat(datetime(extractBefore(SMAPTime, 'Z'))', HydroPoints,1 ) ;
% mindelay(ipoint)=min(abs(hours(DelayPoints))) ; 
empty=0 ; 
for ipoint=1: HydroPoints
NearPoints=find(arclen(ipoint,:) < ThresholDist & abs(hours(DelayPoints(ipoint,:))) <= ThresholdTimeDelay) ;
    if isempty(NearPoints)==1 ;
    SMAPSMtoplot(ii,ipoint)=NaN ; 
    HydroSMtoplot(ii,ipoint)=NaN ;
    HydroSMtoplotLat(ii,ipoint)=NaN ; 
    HydroSMtoplotLon(ii,ipoint)=NaN ; 
        % empty=empty+1 
% DelayPoints=datetime(HydroTime(ipoint))- datetime(extractBefore(SMAPTime(NearPoints), 'Z')) ;
% if  size(NearPoints) == 1 & abs(hours(DelayPoints)) <= ThresholdTimeDelay ;
    elseif  size(NearPoints) == 1  ;
    SMAPSMtoplot(ii,ipoint)=SMAPSoilMoisture(NearPoints) ; 
    HydroSMtoplot(ii,ipoint)=HydroSoilMoisture(ipoint) ;
    HydroSMtoplotLat(ii,ipoint)=HydroLat(ipoint) ; 
    HydroSMtoplotLon(ii,ipoint)=HydroLon(ipoint); 
    else
    % ClosestTimeIndex=find(abs(DelayPoints)==min(abs(DelayPoints))) 
    [a b]=size(NearPoints) ;
    mindist(ipoint)=min(arclen(ipoint,:)) ; 
    bestpoint=find(arclen(ipoint,NearPoints) < mindist(ipoint) + ThrSameDist & abs(hours(DelayPoints(ipoint,NearPoints))) < min(abs(hours(DelayPoints(ipoint,NearPoints))))+ThrSameTime) ; 
        [a b]=size(bestpoint) ; 
        if b ==1 ;
        SMAPSMtoplot(ii,ipoint)=SMAPSoilMoisture(NearPoints(bestpoint)) ; 
        HydroSMtoplot(ii,ipoint)=HydroSoilMoisture(ipoint) ;
        HydroSMtoplotLat(ii,ipoint)=HydroLat(ipoint) ; 
        HydroSMtoplotLon(ii,ipoint)=HydroLon(ipoint); 
        elseif b > 1 ; 
        SMAPSMtoplot(ii,ipoint)=mean(SMAPSoilMoisture(NearPoints(bestpoint))) ; 
        HydroSMtoplot(ii,ipoint)=HydroSoilMoisture(ipoint) ;
        HydroSMtoplotLat(ii,ipoint)=HydroLat(ipoint) ; 
        HydroSMtoplotLon(ii,ipoint)=HydroLon(ipoint); 
        else
        % empty=empty+1 
        SMAPSMtoplot(ii,ipoint)=NaN ; 
        HydroSMtoplot(ii,ipoint)=NaN ;
        HydroSMtoplotLat(ii,ipoint)=NaN ; 
        HydroSMtoplotLon(ii,ipoint)=NaN; 
        disp([char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' WARNING: no selection of multiple nearest points. Program continuing']) ; 
        

        fprintf(logfileID,[char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' WARNING: no selection of multiple nearest points. Program continuing']) ; 
        fprintf(logfileID,'\n') ;     
        end

    end
 end
PercNoColocation(ii)=100*size(find(isnan(HydroSMtoplot(ii,1:HydroPoints))==1),2)/HydroPoints ; % Percentage of HydroGNNS L2 product without SMAP colocation
PercNoSaturations(ii)=100*size(find(HydroSMtoplot(ii,1:HydroPoints)==0 | HydroSMtoplot(ii,1:HydroPoints)==50),2)/HydroPoints ; % Percentage of HydroGNNS L2 product without SMAP colocation


end

vvvv=figure('Units', 'centimeters', 'Position', [0 0 21 29.7]) ;
hold on
ax1 = axes('Position',[0 0 1 1]); ax1.TickDir='out' ; 
ax2 = axes('Position',[0.1 0.25 0.8 0.5]); 

for ii=dayOKwithSMAP'
error= SMAPSMtoplot(ii,1:HydroGNSSnumber(ii))- HydroSMtoplot(ii,1:HydroGNSSnumber(ii)) ; 
noerrornan=find(isnan(error)==0) ; 

error=error(noerrornan) ; 
BIAS(ii)=mean(error) ; 
UbRMSE(ii)=std(error) ;
RMSE(ii)=sqrt(UbRMSE(ii)^2+BIAS(ii)^2) ; 
RMSE2(ii)=sqrt(mean(error.^2)) ; 
pippo=HydroSMtoplot(ii,1:HydroGNSSnumber(ii)) ;
pluto=SMAPSMtoplot(ii,1:HydroGNSSnumber(ii)) ; 
% corrcoe(ii)=corrcoef(HydroSMtoplot(ii,1:HydroGNSSnumber(ii)), SMAPSMtoplot(ii,1:HydroGNSSnumber(ii))) ; 
R=corrcoef(pippo(noerrornan), pluto(noerrornan)) ; 
corrcoe(ii)=R(1,2) ; 
corrcoe2(ii)=mean((pippo(noerrornan)-mean(pippo(noerrornan))).*(pluto(noerrornan)-mean(pluto(noerrornan))))./std(pluto(noerrornan))/std(pippo(noerrornan)) ;

geoscatter(HydroSMtoplotLat(ii,noerrornan),HydroSMtoplotLon(ii,noerrornan), [], error)
ax2=gca ; 
end
colorbar('southoutside')
title('Map of SSM errors (Reference minus HydroGNSS) [%]')

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

%legendtxt="" ; 
for ii=dayOKwithSMAP'
%pippo=string(['Day ' char(string(ii)) ': ' char(DateOK(ii)) '-' char(string(month(timeproduct_sixtot(ii,1)))) '-' char(string(year(timeproduct_sixtot(ii,1))))]) ; 
pippo=string(['Day ' char(string(ii)) ': ' char(DateOK(ii))]) ;
legendtxt(ii)=pippo ; 
end
% tiledlayout(2,1) ;

for ii=dayOKwithSMAP' 
figure(vv) ; nexttile ;
bar(Flag(ii,:)) ; 
xticks([1:2:32]); 
title(['L2 Flags on ' char(DateOK(ii))])
xlabel('Flag 32 bits')
end

% figure(vv) ; nexttile ; 
% for ii=dayOKwithSMAP'
% 
% plot(100.*SMAPSMtoplot(ii,1:HydroGNSSnumber(ii)), HydroSMtoplot(ii,1:HydroGNSSnumber(ii)), '.') ; 
% hold on 
% % legend([legendtxt(1) legendtxt(2) legendtxt(3)],"AutoUpdate","on")
% 
% end
% legend(legendtxt',"AutoUpdate","on", 'Location', 'southoutside')
% xlim([-5 55]) ;
% ylim([-5 55]) ;
% title('HydrGNSS vs SMAP')
% ylabel(['HydroGNSS ' char(ProductLevel) ' SSM [%]'])
% xlabel('SMAP L3 SSM [%]')
%
vvv=figure('Units', 'centimeters', 'Position', [0 0 21 29.7]) ;
ax1 = axes('Position',[0 0 1 1]); ax1.TickDir='out' ; 

ax2 = axes('Position',[0.2 0.15 0.7 0.6]); 
for ii=dayOKwithSMAP'
plot(100.*SMAPSMtoplot(ii,1:HydroGNSSnumber(ii)), HydroSMtoplot(ii,1:HydroGNSSnumber(ii)), '.') ; 
hold on 
% legend([legendtxt(1) legendtxt(2) legendtxt(3)],"AutoUpdate","on")

end
% end plot scatter of retrievals
%
% % init plot of map of errors
% vvvv=figure('Units', 'centimeters', 'Position', [0 0 21 29.7]) ;
% ax1 = axes('Position',[0 0 1 1]); ax1.TickDir='out' ; 
% ax2 = axes('Position',[0.2 0.15 0.7 0.6]); 
% for ii=dayOKwithSMAP'
% plot(100.*SMAPSMtoplot(ii,1:HydroGNSSnumber(ii)), HydroSMtoplot(ii,1:HydroGNSSnumber(ii)), '.') ; 
% hold on 
% % legend([legendtxt(1) legendtxt(2) legendtxt(3)],"AutoUpdate","on")
% 
% end
% % end plot map of errore



xlim([-5 55]) ;
ylim([-5 55]) ;
title(['HydrGNSS vs ' char(RefSatellite) ' reference SSM'])
ylabel(['HydroGNSS ' char(ProductLevel) ' Soil Moisture [%]'])
xlabel([char(RefSatellite) ' L3 Soil Moisture [%]'])
legend(legendtxt',"AutoUpdate","on", 'Location', 'southoutside', 'FontSize', 12)


v=figure('Units', 'centimeters', 'Position', [0 0 21 29.7]) ;

% ax1 = axes('Position',[0.2 0.2 0.6 0.3*29.7/21]);
% ax1 = axes('Position',[0.2 0.05 0.6 0.3*29.7/21]); 
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
text(indent,vert, ['\fontsize{10} Day ' char(string(ii)) ':    Root Mean Square Error= ' char(string(round(RMSE(ii),2))) ' %'] ) 
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

reportfile=[char(ReportFolder) '\HydroGNSSQCreport_' char(datetime('now','Format','yy-MM-dd_HH-mm')) '.pdf'] ;

Title=['SSM QC report: HydroGNSS vs ' char(RefSatellite)] ;
str1=['Time of issue: ' char(datetime) '. Reference: ' char(RefSatellite)] ; 
str11= ['First day: ' char(init_SM_Day) '. Final day: ' char(final_SM_Day)] ;
% C = {} ;
C = {Title, str1, str11} ;
for ii=dayOKwithSMAP'
str0=['Day ' char(string(ii)) ': '   char(DateOK(ii))] ; 
str2 = ['        Percentage of SP with retrievals: ', char(string(round(PercSMretrieve(ii),2))) ' %'] ;
str3 = ['        Percentage of HydroGNNS product without reference colocation: ',  char(string(round(PercNoColocation(ii),2))) ' %'] ;
str4 = ['        Percentage of saturated (i.e., 0/50%) HydroGNNS L2 Soil Moisture: ',  char(string(round(PercNoSaturations(ii),2))) ' %'] ;
str9 = ['        Percentage of retrievals with optimal quality: ',  char(string(round(PercSM_Flag1_good(ii),2))) ' %'] ;
str5=['        Root mean square error:                  RMSE=' char(string(round(RMSE(ii),2))), ' m^3/m^3' ] ; 
str6=['        Unbiased root mean square error:   UbRMSE=' char(string(round(UbRMSE(ii),2))), ' m^3/m^3' ] ; 
str7=['        Bias:                                                 B=' char(string(round(BIAS(ii),2))), ' m^3/m^3' ] ; 
str8=['        Correlation coefficient:                     R=' char(string(round(corrcoe(ii),2)))] ;
C = [C {str0, str2 , str3, str4, str9, str5, str6, str7, str8}] ; 
end
ok = text2pdf(reportfile,C,0) ; 

 % exportgraphics(v,reportfile) ;
%exportgraphics(v,reportfile, 'Append', true) ;
% exportgraphics(vv,reportfile, 'Append', true, 'Padding', figure) ;
exportgraphics(vv,reportfile, 'Append', true) ;
exportgraphics(vvv,reportfile, 'Append', true) ;
exportgraphics(vvvv,reportfile, 'Append', true) ;

 disp([char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' INFO: End of program']) ; 
 fprintf(logfileID,[char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' INFO: End of program']) ; 
 fprintf(logfileID,'\n') ; 

f = waitbar(1,f, 'End of program');

end




