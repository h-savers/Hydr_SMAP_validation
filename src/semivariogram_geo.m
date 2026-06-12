function [gamma,h,npairs] = semivariogram_geo( ...
            Z,Latitude,Longitude)

% ==========================================================
% EXPERIMENTAL SEMIVARIOGRAM FOR VERY LARGE IRREGULAR DATASETS
%
% INPUTS
%   Z          : Nx1 variable
%   Latitude   : Nx1 degrees
%   Longitude  : Nx1 degrees
%
% OUTPUTS
%   gamma      : semivariogram
%   h          : lag centers (km)
%   npairs     : number of pairs
%
% REQUIREMENTS:
%   Statistics and Machine Learning Toolbox
%
% ==========================================================

%% PARAMETERS

maxLag      = 500;      % km
lagWidth    = 12.5;       % km
blockSize   = 10000;    % query points per block

%% CHECK

Z = Z(:);
Latitude = Latitude(:);
Longitude = Longitude(:);

N = length(Z);

if length(Latitude)~=N || length(Longitude)~=N
    error('Inputs must have same length')
end

%% LAG BINS

edges = 0:lagWidth:maxLag;

nBins = length(edges)-1;

h = edges(1:end-1) + lagWidth/2;

gammaSum = zeros(nBins,1);

npairs = zeros(nBins,1);

%% GEOGRAPHIC -> 3D CARTESIAN

R = 6371;  % km

lat = deg2rad(Latitude);
lon = deg2rad(Longitude);

X = R*cos(lat).*cos(lon);
Y = R*cos(lat).*sin(lon);
Zxyz = R*sin(lat);

coords = [X Y Zxyz];

%% KD TREE

fprintf('Building KD tree...\n')

tree = KDTreeSearcher(coords);

%% CHORD DISTANCE CORRESPONDING TO 500 km ARC

theta = maxLag/R;

searchRadius = 2*R*sin(theta/2);

%% BLOCK PROCESSING

fprintf('Processing %d points\n',N)

nBlocks = ceil(N/blockSize);

for b = 1:nBlocks

    i1 = (b-1)*blockSize + 1;
    i2 = min(b*blockSize,N);

    idxBlock = i1:i2;

    fprintf('Block %d/%d\n',b,nBlocks)

    %% NEIGHBOR SEARCH

    neigh = rangesearch(tree,...
                        coords(idxBlock,:),...
                        searchRadius);

    %% PROCESS POINTS

    for k = 1:length(idxBlock)

        i = idxBlock(k);

        ids = neigh{k};

        % eliminate self and duplicate pairs

        ids = ids(ids > i);

        if isempty(ids)
            continue
        end

        %% GREAT-CIRCLE DISTANCES

        lat1 = lat(i);
        lon1 = lon(i);

        lat2 = lat(ids);
        lon2 = lon(ids);

        dlat = lat2 - lat1;
        dlon = lon2 - lon1;

        a = sin(dlat/2).^2 + ...
            cos(lat1).*cos(lat2).*sin(dlon/2).^2;

        d = 2*R*atan2(sqrt(a),sqrt(1-a));

        keep = d <= maxLag;

        if ~any(keep)
            continue
        end

        ids = ids(keep);
        d = d(keep);

        %% SEMIVARIANCE

        sv = 0.5*(Z(i)-Z(ids)).^2;

        %% BINNING

        bin = discretize(d,edges);

        valid = ~isnan(bin);

        if ~any(valid)
            continue
        end

        bin = bin(valid);
        sv = sv(valid);

        gammaSum = gammaSum + ...
            accumarray(bin(:),sv(:),...
                      [nBins 1],@sum,0);

        npairs = npairs + ...
            accumarray(bin(:),1,...
                      [nBins 1],@sum,0);

    end
end

%% FINAL SEMIVARIOGRAM

gamma = gammaSum ./ npairs;

gamma(npairs==0) = NaN;

%% PLOT

% figure
% plot(h,gamma,'ko-','LineWidth',1.5)
% xlabel('Lag distance (km)')
% ylabel('\gamma(h)')
% title('Experimental Semivariogram')
% grid on

fprintf('Done\n')

end