% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
function [lat_vol, med_vol, size_lat, size_med,lat_num, med_num] = CRS_cropper(latmask, medmask, selpath, depth, filetype,flipH)



%latmask = lateral mask
%medmask = medial mask 
%selpath = path for the folder of the full volume
%depth = amount of crossectional images in the dataset

files = dir(fullfile(selpath,filetype));
%remove shadow projection from file list 
for j=1:numel(files)

    fname=files(j).name;
remv = contains(fname,'spr','IgnoreCase',1); 
if remv == true ;
    files(j) = [];
else 
    end
end
        
%find coordinates for cropping of the data
[row,left_l,v]= find(latmask,1,'first')
[row,right_l,v]= find(latmask,1,'last')
[row,top_l,v]= find((imrotate(latmask,90)),1,'first')
[row,bottom_l,v]= find((imrotate(latmask,90)),1,'last')

size_lat = [left_l right_l top_l bottom_l]


clear j row v hmap_lat_rs 



%save lateral VOI
 kk= 1;
lat_vol = zeros((bottom_l-top_l+1),(right_l-left_l+1),depth,'uint8');

for k=1:depth
     
    fname1 =fullfile(selpath,files(k).name);

    if flipH == 1
        tmp1 = uint8(imread(fname1));
        tmp = flip(tmp1,2);
    else
        tmp = uint8(imread(fname1));
 end

%maski*temp
tmp= tmp.*uint8(latmask);
%crop the tmp-file   [xmin ymin width height],
tmp_crop = imcrop(tmp,[(left_l) (top_l) (right_l-left_l) (bottom_l-top_l)]);

%save cropped volume straight to the created subfolder
num = max(strfind(fname1,'\'));
fn = fname1(num+1:end);
 lat_num(k).tmpname = fn;
%   imwrite(tmp_crop,tmpname,'bmp');
lat_vol(:,:,kk) = tmp_crop;
clc
msg = num2str((k-(1))/((depth)-(1))*100);
disp(['cropping lateral VOI ' msg '%'])

kk = kk+1;
end

clear tmpname fn num tmp_crop tmp fname1  

%get coordinates for cropping
[row,left_m,v]= find(medmask,1,'first')
[row,right_m,v]= find(medmask,1,'last')
[row,top_m,v]= find((imrotate(medmask,90)),1,'first')
[row,bottom_m,v]= find((imrotate(medmask,90)),1,'last')

size_med = [left_m right_m top_m bottom_m]

%save medial VOI
kk = 1;
med_vol = zeros((bottom_m-top_m+1),(right_m-left_m+1),depth,'uint8');

for k=1:depth
    

fname1 =fullfile(selpath,files(k).name);

if flipH == 1
    tmp1 = uint8(imread(fname1));
    tmp = flip(tmp1,2);
    else
    tmp = uint8(imread(fname1));
    end

%maski*temp
tmp= tmp.*uint8(medmask);
%crop the tmp-file   [xmin ymin width height],
tmp_crop = imcrop(tmp,[(left_m) (top_m) (right_m-left_m) (bottom_m-top_m)]);

%save cropped volume straight to the created subfolder
num = max(strfind(fname1,'\'));
fn = fname1(num+1:end);
 med_num(k).tmpname = fn;
%   imwrite(tmp_crop,tmpname,'bmp');
med_vol(:,:,kk) = tmp_crop;
clc
msg = num2str((k-(1))/((depth)-(1))*100);
disp(['cropping medial VOI ' msg '%'])

kk = kk+1;
end

clc
disp(['volumes cropped succesfully'])







