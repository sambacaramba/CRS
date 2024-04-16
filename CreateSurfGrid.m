function [output] = CreateSurfGrid(surface, resolution)




[x y] = size(surface);

fitgrid = surface;

if x>y 
    perc= floor(y*0.1);
elseif x<=y
    perc= floor(x*0.1);
end

A = exist('resolution');

if A == true;
%grid is 200x200 micrometers

perc = round((1/resolution)*200);
end


perc

   fitgrid(2:size(fitgrid,1)-1,2:size(fitgrid,2)-1)=NaN;
percx = perc;
   while percx < x
       fitgrid(percx,:) = surface(percx,:);
   percx = percx+perc;
   end
 
   percy = perc;
   while percy < y
       fitgrid(:,percy) = surface(:,percy);
   percy = percy+perc;
   end
   
output = fitgrid;   

