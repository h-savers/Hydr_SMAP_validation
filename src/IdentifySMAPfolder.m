function [dayOK, dayOKwithSMAP, SMAPfolderOK, SMAPfileOK] = IdentifySMAPfolder(L2OPdataOK, timeproduct_sixtotOK, DynamicAuxiliarySMAPRootPath)

[dayOK, sixhour]= size(L2OPdataOK) ; 
% SMAPfolderOK=[] ;SMAPfolderOK
SMAPfileOK="" ; 
SMAPfolderOK="" ; 
daySMAP=0 ; 
dayOKwithSMAP=zeros(dayOK,1) ;

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


SMAPfolderOK(ii,1)=string([char(DynamicAuxiliarySMAPRootPath) '\' char(string(tyear1)) '\' char(string(tmonth1)) '\' char(string(tday1)) '\']) ; 
SMAPfolderOK(ii,2)=string([char(DynamicAuxiliarySMAPRootPath) '\' char(string(tyear2)) '\' char(string(tmonth2)) '\' char(string(tday2)) '\']) ;

SMAPfolderOK(ii,3)=string([char(DynamicAuxiliarySMAPRootPath) '\' char(string(tyear3)) '\' char(string(tmonth3)) '\' char(string(tday3)) '\']) ;

    if exist(SMAPfolderOK(ii,1))~=0 % HydroLat0  ;
    % daySMAP=daySMAP+1 ; 
    content=dir(SMAPfolderOK(ii,1))  ;
    SMAPfileOK(ii,1)=string(content(3).name) ; 
        if contains(SMAPfileOK(ii,1),"SMAP_L3_SM_P_")==1 ;
        SMAPfileOK(ii,1)=string(content(3).name) ; 
        dayOKwithSMAP(ii)=ii ; 
        else, throw(MException('INPUT:ERROR', "SMAP file non available in existing folder. Program exiting.")) ;
        end
    else SMAPfolderOK(ii,1)=NaN ; SMAPfileOK(ii,1)=NaN ; 
    end
    if  exist(SMAPfolderOK(ii,2))~=0;
    content=dir(SMAPfolderOK(ii,2))  ;
    SMAPfileOK(ii,2)=string(content(3).name) ; 

        if contains(SMAPfileOK(ii,2),"SMAP_L3_SM_P_")==1 ; 
        SMAPfileOK(ii,2)=content(3).name ; 
        dayOKwithSMAP(ii)=ii ; 
        else,  throw(MException('INPUT:ERROR', "SMAP file non available in existing folder. Program exiting.")) ;
        end
    else SMAPfolderOK(ii,2)=NaN ; SMAPfileOK(ii,2)=NaN ; 
    end

    if  exist(SMAPfolderOK(ii,3))~=0;
    content=dir(SMAPfolderOK(ii,3))  ;
    SMAPfileOK(ii,3)=string(content(3).name) ; 

        if contains(SMAPfileOK(ii,3),"SMAP_L3_SM_P_")==1 ; 
        SMAPfileOK(ii,3)=content(3).name ; 
        dayOKwithSMAP(ii)=ii ; 
        else,  throw(MException('INPUT:ERROR', "SMAP file non available in existing folder. Program exiting.")) ;
        end
    else SMAPfolderOK(ii,3)=NaN ; SMAPfileOK(ii,3)=NaN ; 
    end

end

dayOKwithSMAP=dayOKwithSMAP(find(dayOKwithSMAP>0)) ;
end