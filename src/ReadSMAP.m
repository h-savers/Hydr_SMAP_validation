function SMAP = ReadSMAP(dayOKwithSMAP, SMAPfileOK, SMAPfolderOK, pixelSMAP, lineSMAP)
for ii=dayOKwithSMAP' 

% timeproduct_sixtot(ii,1)-hours(3) 
% SMAPfolder=
% SMAPfilename=
% SoilMoisture_AM_REF=h5read('SMAP_L3_SM_P_20180816_R18290_001.h5', '/Soil_Moisture_Retrieval_Data_AM/soil_moisture_dca')
% tb_time_AM_REF=h5read('SMAP_L3_SM_P_20180816_R18290_001.h5', '/Soil_Moisture_Retrieval_Data_AM/tb_time_utc')
% SoilMoisture_PM_REF=h5read('SMAP_L3_SM_P_20180816_R18290_001.h5', '/Soil_Moisture_Retrieval_Data_PM/soil_moisture_dca_pm')
% tb_time_PM_REF=h5read('SMAP_L3_SM_P_20180816_R18290_001.h5', '/Soil_Moisture_Retrieval_Data_PM/tb_time_utc_pm')

if ismissing(SMAPfileOK(ii,1))==0 
SMAP(ii,1).SoilMoisture_AM_REF=h5read([char(SMAPfolderOK(ii,1)) char(SMAPfileOK(ii,1))] , '/Soil_Moisture_Retrieval_Data_AM/soil_moisture_dca') ;
SMAP(ii,1).tb_time_AM_REF=h5read([char(SMAPfolderOK(ii,1)) char(SMAPfileOK(ii,1))], '/Soil_Moisture_Retrieval_Data_AM/tb_time_utc') ;
SMAP(ii,1).tb_time_AM_REF=extractBefore(SMAP(ii,1).tb_time_AM_REF, 24) ; 

SMAP(ii,1).SoilMoisture_PM_REF=h5read([char(SMAPfolderOK(ii,1)) char(SMAPfileOK(ii,1))], '/Soil_Moisture_Retrieval_Data_PM/soil_moisture_dca_pm') ;
SMAP(ii,1).tb_time_PM_REF=h5read([char(SMAPfolderOK(ii,1)) char(SMAPfileOK(ii,1))], '/Soil_Moisture_Retrieval_Data_PM/tb_time_utc_pm') ;
SMAP(ii,1).tb_time_PM_REF=extractBefore(SMAP(ii,1).tb_time_PM_REF, 24) ; 

SMAP(ii,1).latitude_AM=h5read([char(SMAPfolderOK(ii,1)) char(SMAPfileOK(ii,1))], '/Soil_Moisture_Retrieval_Data_AM/latitude') ;
SMAP(ii,1).longitude_AM=h5read([char(SMAPfolderOK(ii,1)) char(SMAPfileOK(ii,1))], '/Soil_Moisture_Retrieval_Data_AM/longitude') ;
SMAP(ii,1).latitude_PM=h5read([char(SMAPfolderOK(ii,1)) char(SMAPfileOK(ii,1))], '/Soil_Moisture_Retrieval_Data_PM/latitude_pm') ;
SMAP(ii,1).longitude_PM=h5read([char(SMAPfolderOK(ii,1)) char(SMAPfileOK(ii,1))], '/Soil_Moisture_Retrieval_Data_PM/longitude_pm') ;
else 
SMAP(ii,1).SoilMoisture_AM_REF=nan(pixelSMAP, lineSMAP) ; 
SMAP(ii,1).tb_time_AM_REF=nan(pixelSMAP, lineSMAP) ; 
SMAP(ii,1).SoilMoisture_PM_REF=nan(pixelSMAP, lineSMAP) ;
SMAP(ii,1).tb_time_PM_REF=nan(pixelSMAP, lineSMAP) ; 
SMAP(ii,1).latitude_AM=nan(pixelSMAP, lineSMAP) ;
SMAP(ii,1).latitude_PM=nan(pixelSMAP, lineSMAP) ;
SMAP(ii,1).longitude_AM=nan(pixelSMAP, lineSMAP) ;
SMAP(ii,1).longiture_PM=nan(pixelSMAP, lineSMAP) ;


end

if ismissing(SMAPfileOK(ii,2)) ==0
SMAP(ii,2).SoilMoisture_AM_REF=h5read([char(SMAPfolderOK(ii,2)) char(SMAPfileOK(ii,2))] , '/Soil_Moisture_Retrieval_Data_AM/soil_moisture_dca') ;
SMAP(ii,2).tb_time_AM_REF=h5read([char(SMAPfolderOK(ii,2)) char(SMAPfileOK(ii,2))], '/Soil_Moisture_Retrieval_Data_AM/tb_time_utc') ;
SMAP(ii,2).tb_time_AM_REF=extractBefore(SMAP(ii,2).tb_time_AM_REF, 24) ; 

SMAP(ii,2).SoilMoisture_PM_REF=h5read([char(SMAPfolderOK(ii,2)) char(SMAPfileOK(ii,2))], '/Soil_Moisture_Retrieval_Data_PM/soil_moisture_dca_pm') ;
SMAP(ii,2).tb_time_PM_REF=h5read([char(SMAPfolderOK(ii,2)) char(SMAPfileOK(ii,2))], '/Soil_Moisture_Retrieval_Data_PM/tb_time_utc_pm') ;
SMAP(ii,2).tb_time_PM_REF=extractBefore(SMAP(ii,2).tb_time_PM_REF, 24) ; 

SMAP(ii,2).latitude_AM=h5read([char(SMAPfolderOK(ii,2)) char(SMAPfileOK(ii,2))], '/Soil_Moisture_Retrieval_Data_AM/latitude') ;
SMAP(ii,2).longitude_AM=h5read([char(SMAPfolderOK(ii,2)) char(SMAPfileOK(ii,2))], '/Soil_Moisture_Retrieval_Data_AM/longitude') ;
SMAP(ii,2).latitude_PM=h5read([char(SMAPfolderOK(ii,2)) char(SMAPfileOK(ii,2))], '/Soil_Moisture_Retrieval_Data_PM/latitude_pm') ;
SMAP(ii,2).longitude_PM=h5read([char(SMAPfolderOK(ii,2)) char(SMAPfileOK(ii,2))], '/Soil_Moisture_Retrieval_Data_PM/longitude_pm') ;
else
SMAP(ii,2).SoilMoisture_AM_REF=nan(pixelSMAP, lineSMAP) ; 
SMAP(ii,2).tb_time_AM_REF=nan(pixelSMAP, lineSMAP) ; 
SMAP(ii,2).SoilMoisture_PM_REF=nan(pixelSMAP, lineSMAP) ;
SMAP(ii,2).tb_time_PM_REF=nan(pixelSMAP, lineSMAP) ; 
SMAP(ii,2).latitude_AM=nan(pixelSMAP, lineSMAP) ;
SMAP(ii,2).latitude_PM=nan(pixelSMAP, lineSMAP) ;
SMAP(ii,2).longitude_AM=nan(pixelSMAP, lineSMAP) ;
SMAP(ii,2).longiture_PM=nan(pixelSMAP, lineSMAP) ;
end 

if ismissing(SMAPfileOK(ii,3)) ==0
SMAP(ii,3).SoilMoisture_AM_REF=h5read([char(SMAPfolderOK(ii,3)) char(SMAPfileOK(ii,3))] , '/Soil_Moisture_Retrieval_Data_AM/soil_moisture_dca') ;
SMAP(ii,3).tb_time_AM_REF=h5read([char(SMAPfolderOK(ii,3)) char(SMAPfileOK(ii,3))], '/Soil_Moisture_Retrieval_Data_AM/tb_time_utc') ;
SMAP(ii,3).tb_time_AM_REF=extractBefore(SMAP(ii,3).tb_time_AM_REF, 24) ; 

SMAP(ii,3).SoilMoisture_PM_REF=h5read([char(SMAPfolderOK(ii,3)) char(SMAPfileOK(ii,3))], '/Soil_Moisture_Retrieval_Data_PM/soil_moisture_dca_pm') ;
SMAP(ii,3).tb_time_PM_REF=h5read([char(SMAPfolderOK(ii,3)) char(SMAPfileOK(ii,3))], '/Soil_Moisture_Retrieval_Data_PM/tb_time_utc_pm') ;
SMAP(ii,3).tb_time_PM_REF=extractBefore(SMAP(ii,3).tb_time_PM_REF, 24) ; 

SMAP(ii,3).latitude_AM=h5read([char(SMAPfolderOK(ii,3)) char(SMAPfileOK(ii,3))], '/Soil_Moisture_Retrieval_Data_AM/latitude') ;
SMAP(ii,3).longitude_AM=h5read([char(SMAPfolderOK(ii,3)) char(SMAPfileOK(ii,3))], '/Soil_Moisture_Retrieval_Data_AM/longitude') ;
SMAP(ii,3).latitude_PM=h5read([char(SMAPfolderOK(ii,3)) char(SMAPfileOK(ii,3))], '/Soil_Moisture_Retrieval_Data_PM/latitude_pm') ;
SMAP(ii,3).longitude_PM=h5read([char(SMAPfolderOK(ii,3)) char(SMAPfileOK(ii,3))], '/Soil_Moisture_Retrieval_Data_PM/longitude_pm') ;
else
SMAP(ii,3).SoilMoisture_AM_REF=nan(pixelSMAP, lineSMAP) ; 
SMAP(ii,3).tb_time_AM_REF=nan(pixelSMAP, lineSMAP) ; 
SMAP(ii,3).SoilMoisture_PM_REF=nan(pixelSMAP, lineSMAP) ;
SMAP(ii,3).tb_time_PM_REF=nan(pixelSMAP, lineSMAP) ; 
SMAP(ii,3).latitude_AM=nan(pixelSMAP, lineSMAP) ;
SMAP(ii,3).latitude_PM=nan(pixelSMAP, lineSMAP) ;
SMAP(ii,3).longitude_AM=nan(pixelSMAP, lineSMAP) ;
SMAP(ii,3).longitude_PM=nan(pixelSMAP, lineSMAP) ;
end 


end
end