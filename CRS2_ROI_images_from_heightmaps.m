% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
clear all 
close all 
clc
 
%get folder to load data from (Choose the folder where the heightmap images were saved to)
selpath = uipickfiles('FilterSpec','C:\','Output','struct')
files = dir(fullfile(selpath.name));

k=1;
%choose only files that have "heightmap" in the filename
for j=1:numel(files)

    fname=files(j).name;
remv(:,j) = contains(fname,'heightmap','IgnoreCase',1); 

end
files(~remv)= [];
clear remv

%create save directory 
savedir =  [selpath.name '\Roi_images'];

A = exist(savedir);
if A == 0
mkdir(savedir);
else 
end  
%% create images (BMP) to draw ROIs on
for j=1:numel(files)

    clearvars -except files savedir j
    close all 
    
load([files(j).folder,'\',files(j).name]);
filename = files(j).name(1:end-4);
%check if "carbage" on top or below data and choose limits more wisely
midpoint = nanmedian(heightmap(:));
hmin = nanmin(heightmap(:));
hmax = nanmax(heightmap(:));
mindiff = abs(hmin-midpoint);
maxdiff = abs(hmax-midpoint); 

if mindiff>100
    hmin = midpoint-100;
else end

if maxdiff>100
    hmax = midpoint+100;
else end

% Original image
f = figure('visible','on');
s = surface(heightmap);
set(s,'LineStyle','none');
set(gca,'Ydir','reverse');
shading(gca,'interp');
colormap;
h = light;
c = h.Color;
camlight left;
caxis([hmin hmax]);

%get colormap limits for good visualization
   mapbounds = caxis;
   numcolours = size(colormap, 1);
   mapindex = fix((heightmap-mapbounds(1)) / (mapbounds(2) - mapbounds(1)) * numcolours) + 1;
   mapindex(mapindex < 1) = 1;
   mapindex(mapindex > numcolours) = numcolours;
   img = ind2rgb(mapindex, colormap);
   im = mapindex;
   im(isnan(im))= 0;
%visualize pseudo color image for ROI drawing    
a = figure('visible','on');
   Y = imfuse(s.FaceNormals,s.VertexNormals,'blend','Scaling', 'Joint');
   XY = imfuse(im,Y,'blend');
   imshow(XY);
   imwrite(XY,[savedir,'\',filename,'.bmp']);
   clc
   msg = num2str((j/numel(files))*100);

disp([ 'creating heightmaps for ROI drawing ' msg '%'])

    
end
    
    
    
    
    