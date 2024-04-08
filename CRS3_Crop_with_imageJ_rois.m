% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
%CRS analysis volumes for surface fitting (ImageJ Rois)

%% used functions: uipickfiles, CRS_extract_imageJ_ROI, CRS_cropper, Universal_roi_image_maker, CRS_saveVOI

%Create struct where volumes are located
clear all 
close all 

%% settings 
% flipH = 1; %flip the loaded image horizontally (required for scanco data) 
% flipH = 0; %dont flip the loaded image horizontally (bruker data) 
flipH = 1;
% ThreeD = 0 ; slicewise cleaning of data (use if very low memory)
% ThreeD = 1 ; sweeping in 3D (should be used now as the data is much smaller)
ThreeD = 1;

filetype = '*.png'; %what files to look for in cropping
file_extension = '.png' %what files to look for inside the folder
common_nom = 'RAT' %common nominator for filenames (excludes files that dont have this in the filename)

threshold_mult = 1.3; %For Thresholding to push the low limit up. Cartilage is stained with a slightly higher intnsity that 
%bone is seen in the images. This pushes the limit towards cartilage. 


%%
selpath = uipickfiles('FilterSpec','C:\','Output','struct','Prompt','Choose folders that need cropping') %choose the folders you want analyzed

%create folder for thresholdimages (parent foler of the first folder chosen for cropping)
savethres = [selpath(1).folder '\Threshold_Results\']
 A = exist(savethres)
if A == 0
mkdir(savethres)
else 
end  

%where to save the PATHS-file. This file used in the next phase and it has the following info
    % Thresholding value
    % Data size (X Y Z)
    % Data location (cropped data)
    % Roi file location
    % Filename
    savepath_fold = [selpath(1).folder '\Pathfile'];
savepath = [selpath(1).folder '\Pathfile\Paths.mat'];

 A = exist(savepath_fold)
if A == 0
mkdir(savepath_fold)
else 
end  

%initiate paths -file as a structure
Paths = struct([])

for j = 1:length(selpath)
    
 Paths(j).vol_folder = [selpath(j).name, '\']
 subdir = dir([selpath(j).name, '\']);
 
 for i= 1:length(subdir)
    TF(i) = contains(subdir(i).name, common_nom,'IgnoreCase',true);
    
end

subdir(not(TF)) = [];
 clear TF
 
 for i= 1:length(subdir)
    TF(i) = contains(subdir(i).name, file_extension,'IgnoreCase',true);
    
end

subdir(not(TF)) = [];
 clear TF
 
 %remove shadow projection file (if it exists)
 for i= 1:length(subdir)
    TF(i) = contains(subdir(i).name, 'spr','IgnoreCase',true);
    
 end

if exist('TF')
subdir(TF) = [];
 clear TF
end
     info = imfinfo([subdir(10).folder '\' subdir(10).name]);
     Paths(j).Width = info.Width;
     Paths(j).Height = info.Height;
    Paths(j).Depth = length(subdir);
 
end


%% add roi locations to the struct variable

selpath_r = uipickfiles('FilterSpec','C:\','Output','struct','Prompt','Choose folder where ROIs were saved (...Heightmaps/Roi_images/ as default')
folders_r = dir(fullfile(selpath_r.name));
k=1;
%choose files that have "RoiSet" in the filename
for j=1:numel(folders_r)
    fname=folders_r(j).name;
remv(:,j) = contains(fname,'RoiSet','IgnoreCase',1); 
end
folders_r(~remv)= [];
clear remv


      k=1;
 %% find matching ROI filename and pair it with the folder of the volume
for j = 1:length(Paths)

    %Use this if folders_v(j).name doesn't have _Rec at the end
         s1 = selpath(j).name;
         cutter = max(strfind(s1,'\'))+1;
         s1=s1(cutter:end);
    for i=1:length(folders_r)
    startIndex = regexp(folders_r(i).name,s1) ;
     test(:,i)=isempty(startIndex) ;
    end
    location = find(~test);
    
    
   Paths(j).roi_file = [folders_r(location).folder,'\',folders_r(location).name];
end
clear folders_r fname j k remv selpath selpath 
 %% load volumes one by one and crop based on the ROI

%sanity check for paths file (remove volume paths that don't have a roi
%paired to them)
for i=1:length(Paths)

    TF(:,i) = contains(Paths(i).roi_file,'RoiSet','IgnoreCase',true)
    
end
Paths(~TF) = []
clear TF 

 for i = 1:length(Paths)
     close all 
 [mask_l, mask_m] = CRS_extract_imageJ_ROI(Paths(i).roi_file, Paths(i).Width, Paths(i).Height);
 

 
 [lat_vol, med_vol, size_lat, size_med, lat_num, med_num] = CRS_cropper(mask_l, mask_m, Paths(i).vol_folder, Paths(i).Depth,filetype,flipH);
%get heightmap for cropped volume 

[ heightmap_lat, T_lat, latIM] = Universal_roi_image_maker(lat_vol,ThreeD,threshold_mult);  
[ heightmap_med, T_med, medIM] = Universal_roi_image_maker(med_vol,ThreeD,threshold_mult);

%save thresholdresults

figure;
t = tiledlayout(1,2,'TileSpacing','none');
nexttile
imshow(latIM);
title(['Lateral threshold: ' num2str(T_lat)]);
nexttile
imshow(medIM);
title(['Medial threshold: ' num2str(T_med)]);

% Set figure properties to remove space between subplots and add common title
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);
set(gcf, 'PaperPositionMode', 'auto');

name = Paths(i).vol_folder
loc = strfind(name, '\')
pos1 = (loc(length(loc)-1)); 
pos2 = max(loc); 
name1 = name((pos1+1):(pos2-1))
title_common = strrep(name1,'_',' ')
sgtitle([title_common ' Threshold results']);
 print('-dpng','-r600',[savethres name1 '_thresholds.png']);

%save volume to folder
CRS_saveVOI(lat_vol,heightmap_lat,Paths(i).vol_folder,'lateral',Paths(i).Depth,lat_num);

CRS_saveVOI(med_vol,heightmap_med,Paths(i).vol_folder,'medial',Paths(i).Depth,med_num);

Paths(i).lateral_crop = size_lat;
Paths(i).medial_crop = size_med;
Paths(i).lateral_threshold = T_lat; 
Paths(i).medial_threshold = T_med; 

clear T_lat T_med lat_vol med_vol size_lat size_med lat_num med_num 

 end
 
% %automatic save  
     save(savepath, 'Paths');
%User input needed
%     [file,path,indx] = uiputfile('Paths_tibias.mat','save paths file ');
%     save([path file], 'Paths');
