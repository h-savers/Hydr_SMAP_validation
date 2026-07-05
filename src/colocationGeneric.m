function [SMAPSMtoplot, HydroSMtoplot, HydroSMtoplotLat, HydroSMtoplotLon] = colocationGeneric(savespace, MATfileFolder, SMAPPoints, sizesave, HydroLat, HydroLon, SMAPLatitude, SMAPLongitude, ThresholDist, HydroTime, SMAPTime, ThresholdTimeDelay, SMAPSMtoplot, ii, HydroSMtoplot, HydroSMtoplotLat, HydroSMtoplotLon, SMAPSoilMoisture, HydroSoilMoisture, ThrSameDist, ThrSameTime, logfileID)
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
end