% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
clear all 

%% scripts used: CRS_local_plane_difference
 
% the radius should be close to 15µm so that the moving window area is close to 900µm^2
%set your voxel size
voxel_size = 4.5;

%decide radius based on voxel size
for i=1:20 
    difference(:,i) = (abs(voxel_size*i -15));
end
minimum = min(difference)
 ind = difference == minimum;
 radius = find(ind,1,'last')
 

%select folder with surfitRes files
selpath = uigetdir('C:\', 'choose folder with surfitRes files');
files = dir(fullfile(selpath,'*surfitRes.mat'));

%testing with different radii by uncommenting lines 24-25 and 42-43
% for ii= 1:9
%     radius = ii;
 n=1
%analyze local orienation  
for i = 1:length(files)
    
    name = files(i).name
         
        disp(['calculating local orientation for sample ' num2str(n) '/' num2str(length(files))])
        n=n+1; 
        load([files(i).folder,'\',files(i).name]);
        ref1= surfitres.fitsurf;
        tar1=surfitres.simpsurf;
        res1 = CRS_local_plane_difference(ref1, tar1, radius);
       
        
        save([files(i).folder,'\',surfitres.sample,'_local_orientation_',num2str(radius*2),'_pixeldiam.mat'],'res1');
        clear res1 ref1 tar1 testres
%     else 
%     end
end





