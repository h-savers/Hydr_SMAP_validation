function [vv, timeproduct_sixtotOK, L2OPdataOK, DateOK] = Read_L2G(numdays, L2OPfolder_sixtot, timeproduct_sixtot, ProductLevel, logfileID)
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
end