% close all
function L2OPdata=ReadL2OPproduct(isixcount, filefolder, filename, ProductLevel)
% path='E:\Work\HydroGNSS_PhCDE\SML2OPbeta\Outputs\HydroGNSS-1\DataRelease\L2OP-SSM\2018-08\18\H06\' ; 
% filename='L2OP-SSM.nc.1750257755.336' ; 
% filename='L2OP-SSM.nc' ; 
% global L2OPdata
% info=ncinfo([path filename]) ; 
%
% NumberOfTracks=ncreadatt([filepath filename],'/','NumberOfTracks') ; 
%
ncid = netcdf.open([filefolder filename], 'NC_NOWRITE');
trackNcids = netcdf.inqGrps(ncid);
[a b]=size(trackNcids) ; 
NumberOfTracks=b ; 
%
% for itrk=1:NumberOfTracks ;
% % [a b c]=info.Groups(itrk).Dimensions.Length ; 
% NumOfSP(itrk)=a ; 
% end
% maxsize=max(NumOfSP) ; 
% SoilMoisture=nan(maxsize, NumberOfTracks) ; 
SoilMoisture=[] ;
DataLatitude=SoilMoisture ; 
DataLongitude=SoilMoisture ;
SSMQuality=[] ;

for itrk=1:NumberOfTracks ;
% group=char(string(itrk-1)) ; 
% if itrk <= 10, group=['00000' group] ; end;
% if itrk > 10 & itrk <= 100, group=['0000' group] ; end;
% if itrk > 100 & itrk <= 100 , group=['000' group] ; end;
% if itrk > 1000, itrk <= 1000, group=['00' group] ; end;
% if itrk > 10000, group=['0' group] ; end;
% 
% a=NumOfSP(itrk) ; 


varID=netcdf.inqVarID(trackNcids(itrk), 'SoilMoisture')  ;
read=netcdf.getVar(trackNcids(itrk),varID)  ;
[a b]=size(read) ; 
SoilMoisture(1:a,itrk)=read ; 

varID=netcdf.inqVarID(trackNcids(itrk), 'DataLatitude')  ;
read=netcdf.getVar(trackNcids(itrk),varID)  ;
DataLatitude(1:a,itrk)=read ; 

varID=netcdf.inqVarID(trackNcids(itrk), 'DataLongitude')  ;
read=netcdf.getVar(trackNcids(itrk),varID)  ;
DataLongitude(1:a,itrk)=read ; 

varID=netcdf.inqVarID(trackNcids(itrk), 'SSMQuality')  ;
read=netcdf.getVar(trackNcids(itrk),varID)  ;
SSMQuality(1:a,itrk)=read ; 

varID=netcdf.inqVarID(trackNcids(itrk), 'ObservationUTCMidPointTime')  ;
read=netcdf.getVar(trackNcids(itrk),varID)  ;
ObservationUTCMidPointTime(1:a,itrk)=read ; 

varID=netcdf.inqVarID(trackNcids(itrk), 'SoilMoistureMap')  ;
read=netcdf.getVar(trackNcids(itrk),varID)  ;
[a b]=size(read) ; 
SoilMoistureMap(1:a,1:b,itrk)=read ;

% SoilMoisture(1:a,itrk)=ncread([filepath filename],['/' group '/','SoilMoisture'] ) ; 
% DataLatitude(1:a,itrk)=ncread([filepath filename],['/' group '/','DataLatitude'] ) ; 
% DataLongitude(1:a,itrk)=ncread([filepath filename],['/' group '/','DataLongitude'] ) ; 
% SSMQuality(1:a,itrk)=ncread([filepath filename],['/' group '/','SSMQuality'] ) ; 
% SoilMoist(itrk).map=ncread([filepath filename],['/' group '/','SoilMoistureMap'] ) ; 
% ObservationUTCMidPointTime(1:a,itrk)=ncread([filepath filename],['/' group '/','ObservationUTCMidPointTime'] ) ; 


% SoilMoisture(a+1:end,itrk)=NaN ; 
% DataLatitude(a+1:end,itrk)=NaN ;  
% DataLongitude(a+1:end,itrk)=NaN ;
% ObservationUTCMidPointTime(a+1:end,itrk)=NaN ;


% SSMQuality(a+1:end,itrk)=NaN ;

% find(isnan(SoilMoisture)==0)
end
L2OPdata.SoilMoisture=SoilMoisture ; 
L2OPdata.DataLatitude=DataLatitude ; 
L2OPdata.DataLongitude=DataLongitude ; 
L2OPdata.SoilMoisture=SoilMoisture ; 
L2OPdata.map.SoilMoist=SoilMoistureMap ; 
L2OPdata.ObservationUTCMidPointTime=ObservationUTCMidPointTime ; 
L2OPdata.SSMQuality=SSMQuality ; 
% 
% tiledlayout('flow')
% nexttile
% geoscatter(DataLatitude(:),DataLongitude(:),[], SoilMoisture(:) )

end


