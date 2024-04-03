% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
function [ heightmap, T, C ] = Universal_roi_image_maker(vol,dimension,mult)  

 %heightmap = simple heightmap from the input data (vol)  
 %T = chosen threshold for the data
 %C = fused image from thresholded and original data
 %vol = input data as volume (8bit) 
 %dimension = (0):clean data in 2D or (1): sweep data in 3D
 
%% scripts needed: func_threshold(automatic segmentation) 

% Script loads images as a volume, then automatically binarizes them and finds the simple surface.

                  

[xs ys zs] =size(vol);
vol = uint8(vol);
%% binarize images

T = func_threshold(vol)
T= T*mult;

vol_bin = imbinarize(vol,(T/256));
vol_bin = bwmorph3(vol_bin,'clean');
%BINARIZATION RESULT

im= permute(vol(:,floor(ys/3),:),[1 3 2]);
imBW=permute(vol_bin(:,floor(ys/3),:),[1 3 2]);
clear vol 
C = imfuse(im,imBW*128,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
figure,
imshow(C)

if dimension == 0 
%% 2D solution
 %remove excess in 2d
 vol_bin= permute(vol_bin,[1 3 2]);
 
 for iii=1:size(vol_bin,3)
 BW2 = bwareaopen(vol_bin(:,:,iii), 1000);
 
 vol_bin(:,:,iii)=BW2;
 end
 vol_bin= permute(vol_bin,[1 3 2]);
%% find simple surface

heightmap = NaN(xs,ys);
 for k=zs:-1:1
% for k=1:zs
        tmp = vol_bin(:,:,k);    
        destinds = isnan(heightmap);
        heightmap(destinds & tmp) = k-1;
       
end 

else
 %% 3D if enough memory
largestobject = false(xs,ys,zs);
object = bwconncomp(vol_bin)
numPixels = cellfun(@numel,object.PixelIdxList);
[largest,idx] = max(numPixels);
   largestobject(object.PixelIdxList{idx}) = 1;
    
clear vol_bin object numPixels 

% find simple surface

heightmap = NaN(xs,ys);
 for k=zs:-1:1
% for k=1:zs
        tmp = largestobject(:,:,k);    
        destinds = isnan(heightmap);
        heightmap(destinds & tmp) = k-1;
       
end
end
%cut low points from heightmap to visualize better







