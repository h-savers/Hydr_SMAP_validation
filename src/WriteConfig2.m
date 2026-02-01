function WriteConfig2(configurationPath, init_SM_Day,final_SM_Day,RefSatellite, ProductLevel, ProcessingSatellite, savespace, MATfileFolder, DataInputRootPath, DynamicAuxiliarySMOSRootPath,...
    DynamicAuxiliarySMAPRootPath, DynamicAuxiliarySMAP09RootPath, LogsOutputRootPath, ThresholDist, ThresholdTimeDelay,...
    ThrSameDist, ThrSameTime, Threshold09Dist, Thr09SameDist, ReportFolder, SMAPQC, sizesave) ; 
conffileID = fopen(configurationPath, 'W') ; 

fprintf(conffileID,'%s',['init_SM_Day=' init_SM_Day] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID,'%s',['final_SM_Day=' final_SM_Day] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID,'%s',['RefSatellite=' RefSatellite] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID,'%s',['ProductLevel=' ProductLevel] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID,'%s',['ProcessingSatellite=' ProcessingSatellite] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID,'%s',['savespace=' savespace] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID, ['sizesave=' char(string(sizesave))] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID,'%s',['SMAPQC=' SMAPQC] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID,'%s',['MATfileFolder=' MATfileFolder] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID,'%s', ['DataInputRootPath=' DataInputRootPath] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID,'%s',['DynamicAuxiliarySMAPRootPath=' DynamicAuxiliarySMAPRootPath] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID,'%s',['DynamicAuxiliarySMAP09RootPath=' DynamicAuxiliarySMAP09RootPath] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID,'%s',['DynamicAuxiliarySMOSRootPath=' DynamicAuxiliarySMOSRootPath] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID,'%s',['LogsOutputRootPath=' LogsOutputRootPath] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID,'%s',['ReportFolder=' ReportFolder] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID,['ThresholDist=' char(string(ThresholDist))] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID,['ThresholdTimeDelay=' char(string(ThresholdTimeDelay))] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID,['ThrSameTime=' char(string(ThrSameTime))] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID,['ThrSameDist=' char(string(ThrSameDist))] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID,['Threshold09Dist=' char(string(Threshold09Dist))] ); fprintf(conffileID,'\n') ; 
fprintf(conffileID,['Thr09SameDist=' char(string(Thr09SameDist))] ); fprintf(conffileID,'\n') ; 

fclose(conffileID) ;
end


