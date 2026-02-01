function d1km =Mylldistkm2(latlon1,latlon2)
% format: [d1km d2km]=lldistkm(latlon1,latlon2)
% Distance:
% d1km: distance in km based on Haversine formula
% (Haversine: http://en.wikipedia.org/wiki/Haversine_formula)
% d2km: distance in km based on Pythagoras’ theorem
% (see: http://en.wikipedia.org/wiki/Pythagorean_theorem)
% After:
% http://www.movable-type.co.uk/scripts/latlong.html
%
% --Inputs:
%   latlon1: latlon of origin point [lat lon]
%   latlon2: latlon of destination point [lat lon]
%
% --Outputs:
%   d1km: distance calculated by Haversine formula
%   d2km: distance calculated based on Pythagoran theorem
%
% --Example 1, short distance:
%   latlon1=[-43 172];
%   latlon2=[-44  171];
%   [d1km d2km]=distance(latlon1,latlon2)
%   d1km =
%           137.365669065197 (km)
%   d2km =
%           137.368179013869 (km)
%   %d1km approximately equal to d2km
%
% --Example 2, longer distance:
%   latlon1=[-43 172];
%   latlon2=[20  -108];
%   [d1km d2km]=distance(latlon1,latlon2)
%   d1km =
%           10734.8931427602 (km)
%   d2km =
%           31303.4535270825 (km)
%   d1km is significantly different from d2km (d2km is not able to work
%   for longer distances).
%
% First version: 15 Jan 2012
% Updated: 17 June 2012
%--------------------------------------------------------------------------

radius=6371;
latlon1=latlon1.*pi./180;
latlon2=latlon2.*pi./180;

size1 = size(latlon1,2) ; 
size2 = size(latlon2,2) ;
lat1all=repmat(latlon1(1,:)', 1,size2) ;
lat2all=repmat(latlon2(1,:), size1,1) ; 

lon1all=repmat(latlon1(2,:)', 1,size2) ;
lon2all=repmat(latlon2(2,:), size1,1) ; 


deltaLat=lat2all-lat1all;
deltaLon=lon2all-lon1all;

clear latlon1  latlon2 lon1all  lon2all 
a=sin((deltaLat)/2).^2 + cos(lat1all).*cos(lat2all).* sin(deltaLon/2).^2;
clear deltaLat lat1all lat2all deltaLon 
c=2.*atan2(sqrt(a),sqrt(1-a));
clear a 
d1km=radius.*c;    %Haversine distance
clear c
%%% remove second method
d2km=0 ; 
% x=deltaLon.*cos((lat1all+lat2all)./2);
% % y=deltaLat;
% clear lat1all lat2all 
% d2km=radius.*sqrt(x.*x + deltaLat.*deltaLat); %Pythagoran distance
% clear x deltaLat
end