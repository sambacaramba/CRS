% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
function [vol, fname, real_size_XY] = Universal_volumeloader_0234(selpath,binning,current_data,data_amount,datatype,flipH)

%% load images in sequence 
files = dir(fullfile(selpath,datatype));
%remove shadow projection from file list 
for j=1:numel(files)

    fname=files(j).name;
remv(:,j) = contains(fname,'spr','IgnoreCase',1); 

end
if exist('remv')

files(remv)= [];
clear remv        
end
k=1;

%find filename from folder 
fname_temp=files(10).folder;
idd = strfind(fname_temp,'\');
locc =length(idd);

fname = fname_temp(idd(locc)+1:end);

%goes through the files 4 at a time and 4 equals the resize factor
switch binning
    case 0 
        disp('binning set to zero')
% if binning == 0 
    
    fname1 =fullfile(selpath,files(2).name);
    alloc_file = uint8(imread(fname1));
    [xdim ydim] = size(alloc_file);
    zdim = numel(files);
    vol = (zeros(xdim,ydim,zdim,'uint8'));
% vol = double(vol); 

    clear fname1 alloc_file xdim ydim xdim 
    
    
    for j=1:numel(files);
fname1 =fullfile(selpath,files(j).name);
    tmp1 = uint8(imread(fname1));
    
    if flipH == 1
    vol(:,:,k) = flip(tmp1,2);
    else
    vol(:,:,k) = tmp1;
    end
    k= k+1;
clc
msg = num2str((j/numel(files))*100);
cur_dat = num2str(current_data);
dat_am = num2str(data_amount);
disp([cur_dat '/' dat_am 'loading full volume  ' msg '%'])
    end
case 4 
        disp('binning set to four')
for j=1:4:numel(files);
    
  
% test(j).fname =fullfile(selpath,files(j).name); %full path

fname1 =fullfile(selpath,files(j).name);

if j+1 || j+2 || j+3 > numel(files);

   tmp1 = uint8(imread(fname1)); 
   tmp2 = tmp1;
   tmp3 = tmp1;
   tmp4 = tmp1; 
else
    
fname2 =fullfile(selpath,files(j+1).name);
fname3 =fullfile(selpath,files(j+2).name);
fname4 =fullfile(selpath,files(j+3).name);

tmp1 = uint8(imread(fname1));
tmp2 = uint8(imread(fname2));
tmp3 = uint8(imread(fname3));
tmp4 = uint8(imread(fname4));
end



tmp = (tmp1 + tmp2 + tmp3 + tmp4)/4;

tmp = imresize(tmp,0.25);


if flipH == 1
    vol(:,:,k) = flip(tmp,2);
    else
    vol(:,:,k) = tmp;
    end


k= k+1;
clc
msg = num2str((j/numel(files))*100);
cur_dat = num2str(current_data);
dat_am = num2str(data_amount);
disp([cur_dat '/' dat_am 'loading full volume and resizing by 1/4 ' msg '%'])
end



case 3 
        disp('binning set to three')
for j=1:3:numel(files);
    
  
% test(j).fname =fullfile(selpath,files(j).name); %full path

fname1 =fullfile(selpath,files(j).name);

if j+1 || j+2 > numel(files);

   tmp1 = uint8(imread(fname1)); 
   tmp2 = tmp1;
   tmp3 = tmp1;
  
else
    
fname2 =fullfile(selpath,files(j+1).name);
fname3 =fullfile(selpath,files(j+2).name);


tmp1 = uint8(imread(fname1));
tmp2 = uint8(imread(fname2));
tmp3 = uint8(imread(fname3));

end



tmp = (tmp1 + tmp2 + tmp3)/3;

tmp = imresize(tmp,(1/3));

if flipH == 1
    vol(:,:,k) = flip(tmp,2);
    else
    vol(:,:,k) = tmp;
    end

k= k+1;
clc
msg = num2str((j/numel(files))*100);
cur_dat = num2str(current_data);
dat_am = num2str(data_amount);
disp([cur_dat '/' dat_am 'loading full volume and resizing by 1/3  ' msg '%'])
end


case 2 
        disp('binning set to two')
for j=1:2:numel(files);
    
  
% test(j).fname =fullfile(selpath,files(j).name); %full path

fname1 =fullfile(selpath,files(j).name);

if j+1 > numel(files);

   tmp1 = uint8(imread(fname1)); 
   tmp2 = tmp1;
   
else
    
fname2 =fullfile(selpath,files(j+1).name);


tmp1 = uint8(imread(fname1));
tmp2 = uint8(imread(fname2));

end



tmp = (tmp1 + tmp2)/2;

tmp = imresize(tmp,0.5);

if flipH == 1
    vol(:,:,k) = flip(tmp,2);
    else
    vol(:,:,k) = tmp;
    end

k= k+1;
clc
msg = num2str((j/numel(files))*100);
cur_dat = num2str(current_data);
dat_am = num2str(data_amount);
disp([cur_dat '/' dat_am 'loading full volume and resizing by 1/2  ' msg '%'])
end



    end
[real_x, real_y] = size(tmp1);
real_size_XY = [real_x, real_y]
clc
clear tmp1 tmp2 tmp3 tmp4 fname1 fname2 fname3 msg





 
