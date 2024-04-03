% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
clear all 
close all 
clc
%% used functions:  Universal_volumeloader_0234, Universal_roi_image_maker, func_threshold(automatic segmentation) 

%% settings for loading data 
binning = 0; %set to 0(100% size), 2(50%size), 3(33.3% size) or 4(25% size) (bins the data as it's loaded)
dataformat ='*.png' %what dataformat to look for
 
%flipping of the data is needed for some scanners (for exmaple scanco data
%must be flipped, while data from bruker scanners doesn't) 

% flipH = 1; %flip the loaded image horizontally
% flipH = 0; %dont flip the loaded image horizontally
flipH = 0;

%ThreeD = 0 ; slicewise cleaning of data (use if less RAM than 3x uncompressed datasize)
%ThreeD = 1 ; sweeping in 3D (use if sufficient memory)
ThreeD = 0;

%For Thresholding to push the low limit up. Cartilage is stained with
%a slightly higher intnsity than bone. This pushes the limit towards cartilage. 
threshold_mult = 1.3; 
 
%% choose what folder to analyze and load data (single sample or batch) 
folders = uipickfiles('FilterSpec','C:\','Output','struct')

%create savepath for the heightmaps in the parent folder of the first
%chosen sample
savepath = [folders(1).folder '\Heightmaps\']
A = exist(savepath);
if A == 0
mkdir(savepath);
else 
end  
% loop through each sample and load data


for j= 1:numel(folders)

        selpath = [folders(j).name '\']
    

%Load volume using the chosen settings
[vol, fname, real_size_XY] = Universal_volumeloader_0234(selpath,binning,j,numel(folders),dataformat,flipH);


[xs ys zs] = size(vol);

%get filename from the foldername
%test thresholding
close all 

%% test thresholding (saves outputs to folder)
Threshold_test(vol, savepath, fname, );

%% get heightmap from surface
[heightmap] = Universal_roi_image_maker(vol,ThreeD);  

save([savepath,fname '_heightmap'],'heightmap');


clear vol fname real_size_XY xs ys zs B bnum test heightmap

clc
msg = num2str((j/numel(folders))*100);
cur_dat = num2str(j);
dat_am = num2str(numel(folders));
disp([cur_dat '/' dat_am 'creating heightmaps ' msg '%'])


end