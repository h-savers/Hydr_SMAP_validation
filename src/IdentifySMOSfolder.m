function [dayOK, dayOKwithSMOS, SMOSfolderOK, SMOSfileOK_SD, SMOSfileOK_SA] = IdentifySMOSfolder(L2OPdataOK, timeproduct_sixtotOK, DynamicAuxiliarySMOSRootPath)

[dayOK, sixhour]= size(L2OPdataOK) ; 
% SMOSfolderOK=[] ;
SMOSfileOK="" ; 
SMOSfolderOK="" ; 
daySMOS=0 ; 
dayOKwithSMOS=zeros(dayOK,1) ;

for ii=1:dayOK
% timeproduct_sixtotOK(ii,3)   
[tyear1, tmonth1, tday1]=ymd(timeproduct_sixtotOK(ii,:)-1) ; 
tday1=unique(tday1); tday1=tday1(1) ;
tmonth1=unique(tmonth1); tmonth1=tmonth1(1) ;
tyear1=unique(tyear1); tyear1=tyear1(1) ;
[tyear2, tmonth2, tday2]=ymd(timeproduct_sixtotOK(ii,:)) ; 
tday2=unique(tday2); tday2=tday2(1) ;
tmonth2=unique(tmonth2); tmonth2=tmonth2(1) ;
tyear2=unique(tyear2); tyear2=tyear2(1) ;

[tyear3, tmonth3, tday3]=ymd(timeproduct_sixtotOK(ii,:)+1) ; 
tday3=unique(tday3); tday3=tday3(1) ;
tmonth3=unique(tmonth3); tmonth3=tmonth3(1) ;
tyear3=unique(tyear3); tyear3=tyear3(1) ;


SMOSfolderOK(ii,1)=string([char(DynamicAuxiliarySMOSRootPath) '\' char(string(tyear1)) '\' char(string(tmonth1)) '\' char(string(tday1)) '\']) ; 
SMOSfolderOK(ii,2)=string([char(DynamicAuxiliarySMOSRootPath) '\' char(string(tyear2)) '\' char(string(tmonth2)) '\' char(string(tday2)) '\']) ;
SMOSfolderOK(ii,3)=string([char(DynamicAuxiliarySMOSRootPath) '\' char(string(tyear3)) '\' char(string(tmonth3)) '\' char(string(tday3)) '\']) ;

    if exist(SMOSfolderOK(ii,1))~=0 % HydroLat0  ;
    % daySMOS=daySMOS+1 ; 
    content=dir(SMOSfolderOK(ii,1))  ; [a b]=size(content) ; 
    for zz=1:a 
        if contains(string(content(zz).name), ".nc")==1 & contains(string(content(zz).name), "CLF3SD")==1 , SMOSfileOK_SD(ii,1)=string(content(zz).name); 
        dayOKwithSMOS(ii)=ii ;
        elseif contains(string(content(zz).name), ".nc")==1 & contains(string(content(zz).name), "CLF3SA")==1 , SMOSfileOK_SA(ii,1)=string(content(zz).name); 
        dayOKwithSMOS(ii)=ii ;
        % else, throw(MException('INPUT:ERROR', "SMOS file non available in existing folder. Program exiting.")) ;
        end
    end
    else SMOSfolderOK(ii,1)=NaN ; SMOSfileOK(ii,1)=NaN ; 
    end
    
    if  exist(SMOSfolderOK(ii,2))~=0;
    content=dir(SMOSfolderOK(ii,2))  ; [a b]=size(content) ; 
    for zz=1:a
        if contains(string(content(zz).name), ".nc")==1 & contains(string(content(zz).name), "CLF3SD")==1 , SMOSfileOK_SD(ii,2)=string(content(zz).name); 
        dayOKwithSMOS(ii)=ii ; 
        elseif contains(string(content(zz).name), ".nc")==1 & contains(string(content(zz).name), "CLF3SA")==1 , SMOSfileOK_SA(ii,2)=string(content(zz).name); 
        dayOKwithSMOS(ii)=ii ; 
        % else, throw(MException('INPUT:ERROR', "SMOS file non available in existing folder. Program exiting.")) ;
        end
    end     
    else SMOSfolderOK(ii,2)=NaN ; SMOSfileOK(ii,2)=NaN ;
    end

    if  exist(SMOSfolderOK(ii,3))~=0;
        content=dir(SMOSfolderOK(ii,3))  ; [a b]=size(content) ; 
    for zz=1:a
        if contains(string(content(zz).name), ".nc")==1 & contains(string(content(zz).name), "CLF3SD")==1 , SMOSfileOK_SD(ii,3)=string(content(zz).name); 
        dayOKwithSMOS(ii)=ii ; 
        elseif contains(string(content(zz).name), ".nc")==1 & contains(string(content(zz).name), "CLF3SA")==1 , SMOSfileOK_SA(ii,3)=string(content(zz).name); 
        dayOKwithSMOS(ii)=ii ; 
        % else, throw(MException('INPUT:ERROR', "SMOS file non available in existing folder. Program exiting.")) ;
 
        end
    end
    else SMOSfolderOK(ii,3)=NaN ; SMOSfileOK(ii,3)=NaN ;
    end


end

dayOKwithSMOS=dayOKwithSMOS(find(dayOKwithSMOS>0)) ;
end