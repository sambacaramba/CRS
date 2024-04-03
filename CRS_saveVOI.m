% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
function  CRS_saveVOI(volume,heightmap,pathname,anatomical_name,zs,numbering)

%volume = volume where too much excess data remains 
%heightmap = heightmap used to correct the data
%pathname = master folder of the orginal volume
%anatomical name = 'lateral' or 'medial' side
%zs = depth of the volume z plane
%numbering = image numbering from original data


%check if folder exists and delete it if previous data exists
path_tmp = [pathname,anatomical_name,'_voi','\'];
if isfolder(path_tmp)
    rmdir(path_tmp, 's')
else 
end
 mkdir(path_tmp);
 

 %%
 %remove spikes from heightmap using moving window 
 tempheightmap = heightmap;
 B = filloutliers(tempheightmap,'nearest','movmean',100,2);
 B2 = filloutliers(B,'nearest','movmean',100);
 heightmap = B2;
 %%
 
h_max = nanmax(heightmap(:));
h_min = nanmin(heightmap(:));

%add 50 pixels to the top of cartilage for safety
start = h_min-100;
stop = h_max+50;


if stop > zs 
    stop = zs;
else end
stop_map = stop;

if start < 0 
    start = 1;
else end

start_map = start;



 for k=start_map:stop_map

tmpfile = volume(:,:,k);
 tmpname = strcat(path_tmp,numbering(k).tmpname);
   imwrite(tmpfile,tmpname,'png');
    
    clc
    msg = num2str((k-start_map)/((stop_map)-(start_map))*100);
disp(['saving' ,' ',anatomical_name,' ','voi', msg, '%'])
 
end
    
    

