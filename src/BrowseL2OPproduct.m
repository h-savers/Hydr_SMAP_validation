% close all
path='E:\Work\HydroGNSS_PhCDE\SML2OPbeta\Outputs\HydroGNSS-1\DataRelease\L2OP-SSM\2018-08\18\H06\' ; 
filename='L2OP-SSM.nc.1750257755.336' ; 
% filename='L2OP-SSM.nc' ; 

info=ncinfo([path filename]) ; 


NumberOfTracks=ncreadatt([path filename],'/','NumberOfTracks') ; 

for itrk=1:NumberOfTracks ;
[a b c]=info.Groups(itrk).Dimensions.Length ; 
NumOfSP(itrk)=a ; 
end
maxsize=max(NumOfSP) ; 
SoilMoisture=nan(maxsize, NumberOfTracks) ; 
DataLatitude=SoilMoisture ; 
DataLongitude=SoilMoisture ;
SSMQuality=[] ;
for itrk=1:NumberOfTracks ;
group=char(string(itrk-1)) ; 
if itrk <= 10, group=['00000' group] ; end;
if itrk > 10 & itrk <= 100, group=['0000' group] ; end;
if itrk > 100 & itrk <= 100 , group=['000' group] ; end;
if itrk > 1000, itrk <= 1000, group=['00' group] ; end;
if itrk > 10000, group=['0' group] ; end;
a=NumOfSP(itrk) ; 
SoilMoisture(1:a,itrk)=ncread([path filename],['/' group '/','SoilMoisture'] ) ; 
DataLatitude(1:a,itrk)=ncread([path filename],['/' group '/','DataLatitude'] ) ; 
DataLongitude(1:a,itrk)=ncread([path filename],['/' group '/','DataLongitude'] ) ; 
SSMQuality(1:a,itrk)=ncread([path filename],['/' group '/','SSMQuality'] ) ; 
SoilMoist(itrk).map=ncread([path filename],['/' group '/','SoilMoistureMap'] ) ; 

SoilMoisture(a+1:end,itrk)=NaN ; 
DataLatitude(a+1:end,itrk)=NaN ;  
DataLongitude(a+1:end,itrk)=NaN ;
% SSMQuality(a+1:end,itrk)=NaN ;

% find(isnan(SoilMoisture)==0)
end
figure
geoscatter(DataLatitude(:),DataLongitude(:),[], SoilMoisture(:) )


