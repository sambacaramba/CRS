% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
clear all 
%load paths file
%% used functions, FillHoles3D, CRS_surface_fit
%% important parameters
%isotropic pixels size of the data
voxel_size=4.5;
% how far (in pixels) from the surface the estimated surface is fitted (20-30 µm is a good value)
% used only for visualization
offset_value=8;
%what type of images to search for
IMAGETYPE = '*.png';
%Surfacefit poly count
polX = 5;
polY = 5;
%Choose if you want to use finetuning of surface fit (1=use, 0= don't use)
%(useful only for depthwise difference calculation... can cause edge artefacts in the fit)
finetune = 0;
%choose the threshold for removal of outliers from iterative fit (10 is default for 2.8µm resolution data
%increase for higher resolution and decrease for lower to get best results)
removal_threshold = 10; 
%fill holes less than ("holefill" / voxel size) 
holefill = 150000; 


%%
%load PATHS file 
[baseFileName, folder] = uigetfile('*.mat');
fullFileName = fullfile(folder, baseFileName);
if exist(fullFileName, 'file')
    % Normal situation - they picked an existing file.
 load(fullFileName);
    % Now do something with storedStructure, like extract fields into new variables or whatever you want.
else
    % Error: Would only get here if they typed in a name of a non-existant file
    % instead of picking one from the folder.
    warningMessage = sprintf('Warning: mat file does not exist:\n%s', fullFileName);
    uiwait(errordlg(warningMessage));
    return;
end

%save results to parent folder of PATHS file and create a results folder
%there
ind = strfind(folder, '\');
loc = length(ind)-1;
savefold = [folder(1:ind(loc)) 'Results\'];

A = exist(savefold);
if A == 0
mkdir(savefold);
else 
end  


for i = 1:length(Paths)
    B = exist('surfvals');
if  B == 0
    surfvals = struct([]);
else 
end
    res_loc=length(surfvals)
    if  res_loc == 0 
        res_loc=1;
    else        
    end 
    Paths(i).vol_folder

% Change Disk letter from paths file if it has been changed (in case another computer is now used)
% Paths(i).vol_folder= strrep(Paths(i).vol_folder, 'W:','Z:');

lat_dir = dir(fullfile([Paths(i).vol_folder,'lateral_voi\'],IMAGETYPE));
%%
lat_info = imfinfo([lat_dir(10).folder,'\',lat_dir(10).name]);
lat_vol = zeros((lat_info.Height),(lat_info.Width),length(lat_dir),'uint8');

for k=1:length(lat_dir)
    

fname1 =fullfile([lat_dir(k).folder,'\',lat_dir(k).name]);
tmp2 = uint8(imread(fname1));

%binarize image
tmp=  imbinarize(tmp2,((Paths(i).lateral_threshold)/255));

lat_vol(:,:,k) = tmp;

end
[lat_vol, holes_filled] = FillHoles3D(lat_vol, round(holefill/voxel_size));
lat_vol_perm = permute(lat_vol,[1 3 2]);

holes_filled

%morphological operations to smooth binarized result   
for ijk = 1:size(lat_vol_perm,3)
SE = strel('rectangle',[3 3]);
tmp = ~lat_vol_perm(:,:,ijk); 
tmp = imopen(tmp,SE);
 tmp = bwareaopen(tmp,3);
 
 tmp=~tmp;
 tmp = imopen(tmp,SE);
 lat_vol_perm(:,:,ijk) = tmp;
 
end
   lat_vol =  permute(lat_vol_perm,[1 3 2]);

num = max(strfind(fname1,'\'));
num2 = max(strfind(fname1,'_'));
fn = fname1(num+1:num2);
fn = [fn,'lateral'];
%% surface fitting 
surfvals = CRS_surface_fit(lat_vol,fn, savefold,res_loc,voxel_size,offset_value,polX,polY,finetune,removal_threshold);
%%

save(strcat(savefold,['surfvals_',fn '.mat']),'surfvals');

res_loc = res_loc+1;
clear lat_vol lat_vol_perm

%%
Paths(i).vol_folder




med_dir = dir(fullfile([Paths(i).vol_folder,'medial_voi\'],IMAGETYPE));
%%
med_info = imfinfo([med_dir(10).folder,'\',med_dir(10).name]);
med_vol = zeros((med_info.Height),(med_info.Width),length(med_dir),'uint8');

for k=1:length(med_dir)
    

fname1 =fullfile([med_dir(k).folder,'\',med_dir(k).name]);
tmp = uint8(imread(fname1));

%binärisöi kuva
tmp=  imbinarize(tmp,((Paths(i).medial_threshold)/255));
med_vol(:,:,k) = tmp;

end
[med_vol holes_filled] = FillHoles3D(med_vol, round(holefill/voxel_size));
holes_filled
med_vol_perm = permute(med_vol,[1 3 2]);



for ijk = 1:size(med_vol_perm,3)
SE = strel('rectangle',[3 3]);
tmp = ~med_vol_perm(:,:,ijk); 
tmp = imopen(tmp,SE);
 tmp = bwareaopen(tmp,3);
 
 tmp=~tmp;
 tmp = imopen(tmp,SE);
 med_vol_perm(:,:,ijk) = tmp;
 
end
   med_vol =  permute(med_vol_perm,[1 3 2]);

num = max(strfind(fname1,'\'));
num2 = max(strfind(fname1,'_'));
fn = fname1(num+1:num2);
fn = [fn,'medial'];
%% surface fitting
surfvals = CRS_surface_fit(med_vol,fn, savefold,res_loc,voxel_size,offset_value,polX,polY,finetune,removal_threshold);
%%
save(strcat(savefold,['surfvals_',fn '.mat']),'surfvals');

res_loc = res_loc+1;
clear med_vol med_vol_perm

end





