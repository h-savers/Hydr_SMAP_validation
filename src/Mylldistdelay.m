function [Idx, D, T]=Mylldistdelay(HydroLat, HydroLon, SMAPLatitude, SMAPLongitude, ...
    HydroTime, SMAPTime, ThresholDist, ThresholdTimeDelay) ;


mindist=[] ;
mindelay=[] ; 
e = referenceEllipsoid('WGS84') ;
arclen=1000.*Mylldistkm([HydroLat'; HydroLon'], [SMAPLatitude'; SMAPLongitude']) ;
pippo=isnan(arclen); 
%???????????? clear SMAPLatitude SMAPLongitude

maxpippo=max(pippo(:)) ; 
if max(pippo)==1,  pause(60), end 
% mindist(ipoint)=min(arclen) ;
clear pippo

sizearclen=size(arclen) ; 
[NearSpacerow, NearSpacecol] = find(arclen <= ThresholDist) ; 
Idxspace= sub2ind(sizearclen,NearSpacerow,NearSpacecol) ; 
arclen=arclen(Idxspace) ; 
DelayPoints=hours(repmat(datetime(HydroTime), 1,SMAPPoints)-repmat(datetime(SMAPTime)', HydroPoints,1 )) ;
%?????? clear HydroTime SMAPTime

DelayPoints=DelayPoints(Idxspace) ; 
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
elseif  size(NearPoints) == 1  ;
    SMAPSMtoplot(ii,C(ipoint))=SMAPSoilMoisture(NearPoints) ; 
    HydroSMtoplot(ii,C(ipoint))=HydroSoilMoisture(C(ipoint)) ;
    HydroSMtoplotLat(ii,C(ipoint))=HydroLat(C(ipoint)) ; 
    HydroSMtoplotLon(ii,C(ipoint))=HydroLon(C(ipoint)); 
else
        mindist(C(ipoint))=min(arclen(C(ipoint),:)) ; 
        bestpoint=find(arclen(C(ipoint),NearPoints) < mindist(C(ipoint)) + ThrSameDist & abs(DelayPoints(C(ipoint),NearPoints)) < min(abs(DelayPoints(C(ipoint),NearPoints)))+ThrSameTime) ; 

        [a b]=size(bestpoint) ; 
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
        % empty=empty+1 
        SMAPSMtoplot(ii,C(ipoint))=NaN ; 
        HydroSMtoplot(ii,C(ipoint))=NaN ;
        HydroSMtoplotLat(ii,C(ipoint))=NaN ; 
        HydroSMtoplotLon(ii,C(ipoint))=NaN; 
        disp([char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' WARNING: no selection of multiple nearest points. Program continuing']) ; 
        end

        fprintf(logfileID,[char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' WARNING: no selection of multiple nearest points. Program continuing']) ; 
        fprintf(logfileID,'\n') ;     
end
end %% end loop on number of HydroGNSS points









[C, ia, ic]=unique(NearSpaceTimecol);

b=histcounts(NearSpaceTimecol, sizearclen(2)) ; 

SMAPSMtoplot(ii,ipoint)=nan(1,) ; 
HydroSMtoplot(ii,ipoint)=HydroSoilMoisture(ipoint) ;
HydroSMtoplotLat(ii,ipoint)=HydroLat(ipoint) ; 
HydroSMtoplotLon(ii,ipoint)=HydroLon(ipoint); 