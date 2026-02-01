function [vv, timeproduct_sixtotOK, L3OPdataOK, DateOK] = Read_L3(numdays, L3OPfolder_sixtot, timeproduct_sixtot, ProductLevel, logfileID)
L3OPfilename='L3OP-SSM.nc' ; 
% count_sixhour=0 ; 
count_day=0 ; 
vv=figure('Units', 'centimeters', 'Position', [0 0 21 29.7]) ;
t=tiledlayout('flow') ; 
title(t,'HydroGNSS L3 SSM maps [%]')
for ii=1:numdays
    mm=0 ; 
%             icount=ii+ii*(kk-1) ; 
% icount=kk ; 
        kk=1 ;
        L3OPfolder=char(L3OPfolder_sixtot(ii)) ;
        if exist([L3OPfolder L3OPfilename]) 
        mm=mm+1 ; 
        % count_sixhour=count_sixhour+1 ; 
        if mm==1, count_day=count_day+1 ; end 
        L3OPfolderOK(count_day,kk)=string(L3OPfolder) ;
        timeproduct_sixtotOK(count_day,kk)=timeproduct_sixtot(ii) ; 
        L3OPdataOK(count_day,kk)=ReadL3OPproduct(L3OPfolder, L3OPfilename, ProductLevel) ;
        
        nexttile
        geoscatter(L3OPdataOK(count_day).DataLatitude(:), L3OPdataOK(count_day).DataLongitude(:),[10], L3OPdataOK(count_day).SoilMoisture(:), 'filled' )
        colorbar('limits', [0 50], 'LimitsMode', 'manual') ; 
        caxis([0 50]);
        DateOK(count_day)=extractBefore(string(timeproduct_sixtot(ii,1)),' ') ; 
        title(['Day ' char(extractBefore(string(timeproduct_sixtot(ii,1)),' ')) ])
        else
        disp([char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' WARNING: six hour block ' L3OPfolder ' does not exist. Program continuing']) ; 
       
        %type([char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' WARNING PROVA: no selection of multiple nearest points. Program continuing']) ; 


        % fprintf(1,[char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' WARNING: six hour block does not exist. Program continuing']) ; 
        fprintf(logfileID,[char(datetime('now','Format','yyyy-MM-dd HH:mm:ss')) ' WARNING: six hour block does not exist. Program continuing']) ; 
        fprintf(logfileID,'\n') ; 
        end

end % end of loop on the days
end