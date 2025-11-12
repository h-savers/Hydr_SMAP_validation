function SMOS = ReadSMOS(dayOKwithSMOS, SMOSfileOK_SD, SMOSfileOK_SA, SMOSfolderOK, pixelSMOS, lineSMOS)
SecInDay=24*60*60 ; 
for ii=dayOKwithSMOS'

% timeproduct_sixtot(ii,1)-hours(3) 
% SMOSfolder=
% SMOSfilename=
% SoilMoisture_AM_REF=ncread('SMOS_L3_SM_P_20180816_R18290_001.h5', '/Soil_Moisture_Retrieval_Data_AM/soil_moisture_dca')
% tb_time_AM_REF=ncread('SMOS_L3_SM_P_20180816_R18290_001.h5', '/Soil_Moisture_Retrieval_Data_AM/tb_time_utc')
% SoilMoisture_PM_REF=ncread('SMOS_L3_SM_P_20180816_R18290_001.h5', '/Soil_Moisture_Retrieval_Data_PM/soil_moisture_dca_pm')
% tb_time_PM_REF=ncread('SMOS_L3_SM_P_20180816_R18290_001.h5', '/Soil_Moisture_Retrieval_Data_PM/tb_time_utc_pm')

if ismissing(SMOSfolderOK(ii,1))==0 
SMOS(ii,1).SoilMoisture_AM_REF=ncread([char(SMOSfolderOK(ii,1)) char(SMOSfileOK_SD(ii,1))] , 'Soil_Moisture') ;
SMOS(ii,1).tb_time_AM_REF=ncread([char(SMOSfolderOK(ii,1)) char(SMOSfileOK_SD(ii,1))], 'Mean_Acq_Time_Days') ;
seconds=ncread([char(SMOSfolderOK(ii,1)) char(SMOSfileOK_SD(ii,1))], 'Mean_Acq_Time_Seconds') ;
SMOS(ii,1).tb_time_AM_REF=datetime(2000,1,1)+SMOS(ii,1).tb_time_AM_REF+seconds/SecInDay ; 
SMOS(ii,1).tb_time_AM_REF=string(SMOS(ii,1).tb_time_AM_REF) ; 
SMOS(ii,1).SoilMoisture_PM_REF=ncread([char(SMOSfolderOK(ii,1)) char(SMOSfileOK_SA(ii,1))], 'Soil_Moisture') ;
SMOS(ii,1).tb_time_PM_REF=ncread([char(SMOSfolderOK(ii,1)) char(SMOSfileOK_SA(ii,1))], 'Mean_Acq_Time_Days') ;
seconds=ncread([char(SMOSfolderOK(ii,1)) char(SMOSfileOK_SA(ii,1))], 'Mean_Acq_Time_Seconds') ;
SMOS(ii,1).tb_time_PM_REF=datetime(2000,1,1)+SMOS(ii,1).tb_time_PM_REF+seconds/SecInDay ; 
SMOS(ii,1).tb_time_PM_REF=string(SMOS(ii,1).tb_time_PM_REF) ; 

buffer=ncread([char(SMOSfolderOK(ii,1)) char(SMOSfileOK_SD(ii,1))], 'lat') ;
SMOS(ii,1).latitude_AM=repmat(buffer',pixelSMOS,1) ;
buffer=ncread([char(SMOSfolderOK(ii,1)) char(SMOSfileOK_SD(ii,1))], 'lon') ;
SMOS(ii,1).longitude_AM=repmat(buffer,1,lineSMOS);
buffer=ncread([char(SMOSfolderOK(ii,1)) char(SMOSfileOK_SA(ii,1))], 'lat') ;
SMOS(ii,1).latitude_PM=repmat(buffer',pixelSMOS,1) ;
buffer=ncread([char(SMOSfolderOK(ii,1)) char(SMOSfileOK_SA(ii,1))], 'lon') ;
SMOS(ii,1).longitude_PM=repmat(buffer,1,lineSMOS); 
else 
SMOS(ii,1).SoilMoisture_AM_REF=nan(pixelSMOS, lineSMOS) ; 
SMOS(ii,1).tb_time_AM_REF=nan(pixelSMOS, lineSMOS) ; 
SMOS(ii,1).SoilMoisture_PM_REF=nan(pixelSMOS, lineSMOS) ;
SMOS(ii,1).tb_time_PM_REF=nan(pixelSMOS, lineSMOS) ; 
SMOS(ii,1).latitude_AM=nan(pixelSMOS, lineSMOS) ;
SMOS(ii,1).latitude_PM=nan(pixelSMOS, lineSMOS) ;
SMOS(ii,1).longitude_AM=nan(pixelSMOS, lineSMOS) ;
SMOS(ii,1).longiture_PM=nan(pixelSMOS, lineSMOS) ;


end
% % Check to plot the Soil Moistue map in geo ccordinate
% pippo=repmat(SMOS(ii,1).latitude_AM',1388,1) ;
% pluto=repmat(SMOS(ii,1).longitude_AM,1,584); 
% SSM=SMOS(ii,1).SoilMoisture_AM_REF; 
% figure, geoscatter(pippo(:) , pluto(:) , SSM(:)+0.1) ;
% %

if ismissing(SMOSfolderOK(ii,2)) ==0
SMOS(ii,2).SoilMoisture_AM_REF=ncread([char(SMOSfolderOK(ii,2)) char(SMOSfileOK_SD(ii,2))] , 'Soil_Moisture') ;
SMOS(ii,2).tb_time_AM_REF=ncread([char(SMOSfolderOK(ii,2)) char(SMOSfileOK_SD(ii,2))], 'Mean_Acq_Time_Days') ;
seconds=ncread([char(SMOSfolderOK(ii,2)) char(SMOSfileOK_SD(ii,2))], 'Mean_Acq_Time_Seconds') ;
SMOS(ii,2).tb_time_AM_REF=datetime(2000,1,1)+SMOS(ii,2).tb_time_AM_REF+seconds/SecInDay ; 
SMOS(ii,2).tb_time_AM_REF=string(SMOS(ii,2).tb_time_AM_REF) ; 
SMOS(ii,2).SoilMoisture_PM_REF=ncread([char(SMOSfolderOK(ii,2)) char(SMOSfileOK_SA(ii,2))], 'Soil_Moisture') ;
SMOS(ii,2).tb_time_PM_REF=ncread([char(SMOSfolderOK(ii,2)) char(SMOSfileOK_SA(ii,2))], 'Mean_Acq_Time_Days') ;
seconds=ncread([char(SMOSfolderOK(ii,2)) char(SMOSfileOK_SA(ii,2))], 'Mean_Acq_Time_Seconds') ;
SMOS(ii,2).tb_time_PM_REF=datetime(2000,1,1)+SMOS(ii,2).tb_time_PM_REF+seconds/SecInDay ; 
SMOS(ii,2).tb_time_PM_REF=string(SMOS(ii,2).tb_time_PM_REF) ; 

buffer=ncread([char(SMOSfolderOK(ii,2)) char(SMOSfileOK_SD(ii,2))], 'lat') ;
SMOS(ii,2).latitude_AM=repmat(buffer',pixelSMOS,1) ;
buffer=ncread([char(SMOSfolderOK(ii,2)) char(SMOSfileOK_SD(ii,2))], 'lon') ;
SMOS(ii,2).longitude_AM=repmat(buffer,1,lineSMOS);
buffer=ncread([char(SMOSfolderOK(ii,2)) char(SMOSfileOK_SA(ii,2))], 'lat') ;
SMOS(ii,2).latitude_PM=repmat(buffer',pixelSMOS,1) ;
buffer=ncread([char(SMOSfolderOK(ii,2)) char(SMOSfileOK_SA(ii,2))], 'lon') ;
SMOS(ii,2).longitude_PM=repmat(buffer,1,lineSMOS); 
else
SMOS(ii,2).SoilMoisture_AM_REF=nan(pixelSMOS, lineSMOS) ; 
SMOS(ii,2).tb_time_AM_REF=nan(pixelSMOS, lineSMOS) ; 
SMOS(ii,2).SoilMoisture_PM_REF=nan(pixelSMOS, lineSMOS) ;
SMOS(ii,2).tb_time_PM_REF=nan(pixelSMOS, lineSMOS) ; 
SMOS(ii,2).latitude_AM=nan(pixelSMOS, lineSMOS) ;
SMOS(ii,2).latitude_PM=nan(pixelSMOS, lineSMOS) ;
SMOS(ii,2).longitude_AM=nan(pixelSMOS, lineSMOS) ;
SMOS(ii,2).longiture_PM=nan(pixelSMOS, lineSMOS) ;
end 

if ismissing(SMOSfolderOK(ii,3)) ==0
SMOS(ii,3).SoilMoisture_AM_REF=ncread([char(SMOSfolderOK(ii,3)) char(SMOSfileOK_SD(ii,3))] , 'Soil_Moisture') ;
SMOS(ii,3).tb_time_AM_REF=ncread([char(SMOSfolderOK(ii,3)) char(SMOSfileOK_SD(ii,3))], 'Mean_Acq_Time_Days') ;
seconds=ncread([char(SMOSfolderOK(ii,3)) char(SMOSfileOK_SD(ii,3))], 'Mean_Acq_Time_Seconds') ;
SMOS(ii,3).tb_time_AM_REF=datetime(2000,1,1)+SMOS(ii,3).tb_time_AM_REF+seconds/SecInDay ; 
SMOS(ii,3).tb_time_AM_REF=string(SMOS(ii,3).tb_time_AM_REF) ; 
SMOS(ii,3).SoilMoisture_PM_REF=ncread([char(SMOSfolderOK(ii,3)) char(SMOSfileOK_SA(ii,3))], 'Soil_Moisture') ;
SMOS(ii,3).tb_time_PM_REF=ncread([char(SMOSfolderOK(ii,3)) char(SMOSfileOK_SA(ii,3))], 'Mean_Acq_Time_Days') ;
seconds=ncread([char(SMOSfolderOK(ii,3)) char(SMOSfileOK_SA(ii,3))], 'Mean_Acq_Time_Seconds') ;
SMOS(ii,3).tb_time_PM_REF=datetime(2000,1,1)+SMOS(ii,3).tb_time_PM_REF+seconds/SecInDay ; 
SMOS(ii,3).tb_time_PM_REF=string(SMOS(ii,3).tb_time_PM_REF) ; 

buffer=ncread([char(SMOSfolderOK(ii,3)) char(SMOSfileOK_SD(ii,3))], 'lat') ;
SMOS(ii,3).latitude_AM=repmat(buffer',pixelSMOS,1) ;
buffer=ncread([char(SMOSfolderOK(ii,3)) char(SMOSfileOK_SD(ii,3))], 'lon') ;
SMOS(ii,3).longitude_AM=repmat(buffer,1,lineSMOS);
buffer=ncread([char(SMOSfolderOK(ii,3)) char(SMOSfileOK_SA(ii,3))], 'lat') ;
SMOS(ii,3).latitude_PM=repmat(buffer',pixelSMOS,1) ;
buffer=ncread([char(SMOSfolderOK(ii,3)) char(SMOSfileOK_SA(ii,3))], 'lon') ;
SMOS(ii,3).longitude_PM=repmat(buffer,1,lineSMOS); 
else
SMOS(ii,3).SoilMoisture_AM_REF=nan(pixelSMOS, lineSMOS) ; 
SMOS(ii,3).tb_time_AM_REF=nan(pixelSMOS, lineSMOS) ; 
SMOS(ii,3).SoilMoisture_PM_REF=nan(pixelSMOS, lineSMOS) ;
SMOS(ii,3).tb_time_PM_REF=nan(pixelSMOS, lineSMOS) ; 
SMOS(ii,3).latitude_AM=nan(pixelSMOS, lineSMOS) ;
SMOS(ii,3).latitude_PM=nan(pixelSMOS, lineSMOS) ;
SMOS(ii,3).longitude_AM=nan(pixelSMOS, lineSMOS) ;
SMOS(ii,3).longitude_PM=nan(pixelSMOS, lineSMOS) ;
end 


end
end