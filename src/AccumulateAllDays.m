function [HydroSoilMoisturetot, HydroTimetot, HydroLattot, HydroLontot, HydroSSMQualitytot]=AccumulateAllDays(L2OPdataOK, Numdays) ;
HydroSoilMoisturetot=[] ;
HydroTimetot=[] ;  
HydroLattot=[] ;  
HydroLontot=[] ;  
HydroSSMQualitytot=[] ; 
for n=1:25 
for ii=1:Numdays
    for kk=1:4 
% HydroSoilMoisture=[L2OPdataOK(ii,1).SoilMoisture(:,n); L2OPdataOK(ii,2).SoilMoisture(:,n);L2OPdataOK(ii,3).SoilMoisture(:,n);L2OPdataOK(ii,4).SoilMoisture(:,n)] ;
% HydroTime=[L2OPdataOK(ii,1).ObservationUTCMidPointTime(:,n); L2OPdataOK(ii,2).ObservationUTCMidPointTime(:,n);L2OPdataOK(ii,3).ObservationUTCMidPointTime(:,n);L2OPdataOK(ii,4).ObservationUTCMidPointTime(:,n)] ;
% HydroLat=[L2OPdataOK(ii,1).DataLatitude(:,n); L2OPdataOK(ii,2).DataLatitude(:,n);L2OPdataOK(ii,3).DataLatitude(:,n);L2OPdataOK(ii,4).DataLatitude(:,n)] ;
% HydroLon=[L2OPdataOK(ii,1).DataLongitude(:,n); L2OPdataOK(ii,2).DataLongitude(:,n);L2OPdataOK(ii,3).DataLongitude(:,n);L2OPdataOK(ii,4).DataLongitude(:,n)] ;
% HydroSSMQuality=[L2OPdataOK(ii,1).SSMQuality(:,n); L2OPdataOK(ii,2).SSMQuality(:,n);L2OPdataOK(ii,3).SSMQuality(:,n);L2OPdataOK(ii,4).SSMQuality(:,n)] ;

if isempty(L2OPdataOK(ii,kk).SoilMoisture(:)) ~= 1 ; 
HydroSoilMoisturetot=[HydroSoilMoisturetot;L2OPdataOK(ii,kk).SoilMoisture(:,n)] ;  
HydroTimetot=[HydroTimetot;L2OPdataOK(ii,kk).ObservationUTCMidPointTime(:,n)] ;  
HydroLattot=[HydroLattot;L2OPdataOK(ii,kk).DataLatitude(:,n)] ;  
HydroLontot=[HydroLontot;L2OPdataOK(ii,kk).DataLongitude(:,n)] ;  
HydroSSMQualitytot=[HydroSSMQualitytot;L2OPdataOK(ii,kk).SSMQuality(:,n)] ;  
end
    end
end
end
end