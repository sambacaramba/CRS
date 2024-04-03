% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
function [ FittedSurfs, dummy] = CRS_SurFit( SurfaceData, xpoly, ypoly,robust)
%robust is off if not mentioned in the input
warning('off', 'all');
if nargin ==3
    robust='off';
end
%prepare data for fit
[x, y, z] = size(SurfaceData);
xlabs = 1:x;
ylabs = 1:y;
%initialize a meshgrid 
[mgx, mgy] = meshgrid(1:y,1:x);
%initialize fitted surface
FittedSurfs = zeros(x,y,z);
%type of fit: poly with varying polynomials
ft = fittype( ['poly' int2str(xpoly) int2str(ypoly)] );
%options for the fit
opts = fitoptions( ft );
opts.Robust = robust;
opts.Lower = [-Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf];
opts.Upper = [Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf Inf];
%if fit is for a square, swap x and y. otherwise keep as it is. run surface fit
for k=1:z
    if(x == y)
       [yi,xi,zi]= prepareSurfaceData(xlabs,ylabs,SurfaceData(:,:,k));
       [fit1, dummy] = fit([xi,yi],zi,ft,opts);
       FittedSurfs(:,:,k) = fit1(mgy,mgx);
    else
       [xi,yi,zi]= prepareSurfaceData(xlabs,ylabs,SurfaceData(:,:,k));
       [fit1, dummy] = fit([xi,yi],zi,ft,opts);
       FittedSurfs(:,:,k) = fit1(mgy,mgx);
    end
end

end

