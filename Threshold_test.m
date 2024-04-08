% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
function Threshold_test(vol_a, savepath, filename, mult)

tresh_isodata = round(isodata(vol_a)*256)
tresh_otsu = round(graythresh(vol_a)*256)
tresh_func_threshold = round(func_threshold(vol_a))

tresh = (tresh_func_threshold/256)*mult;

level = tresh_func_threshold*mult;
%bin the data to reduce memory requirements
   vol_f = imresize3(vol_a, 0.5, 'Method', 'linear');
    clear vol_a
[xdim, ydim, zdim] = size(vol_f);
 slice_z = floor(zdim/2);
 slice_x = floor(xdim/2);
 slice_y = floor(ydim/3.5);
f = figure;

s_size = get(0,'screensize');
f.Position = [round((s_size(3)/5)/2),round((s_size(4)/5)/2),s_size(3)-round((s_size(3)/5)),s_size(4)-round((s_size(4)/5))]


K=1;
 for L=level-20:10:level+20
    nm = length(level-20:10:level+20);
J_ = imbinarize(vol_f,(L/255));

slice = vol_f(:,:,slice_z);
slice_BW = J_(:,:,slice_z);

 ax(K) = subplot(nm,3,K)
C = imfuse(slice,slice_BW);
imshow(C);
title(['threshold:' num2str(L) ' z-plane']);
K=K+1;

perm_vol = permute(vol_f,[3 2 1]);
perm_BW = permute(J_,[3 2 1]);
slice = perm_vol(:,:,slice_x);
slice_BW = perm_BW(:,:,slice_x);

ax(K) = subplot(nm,3,K)
C = imfuse(slice,slice_BW);
imshow(C);
title(['threshold:' num2str(L) ' x-plane']);
K=K+1;

perm_vol = permute(vol_f,[1 3 2]);
perm_BW = permute(J_,[1 3 2]);
slice = perm_vol(:,:,slice_y);
slice_BW = perm_BW(:,:,slice_y);

ax(K) = subplot(nm,3,K)
C = imfuse(slice,slice_BW);
imshow(C);
title(['threshold:' num2str(L) ' y-plane']);
K=K+1;

 end
 titlename = replace(filename, '_',' ');
 sgtitle([titlename ' chosen threshold level= ' num2str(round(tresh*256))])

% f.Padding = 'tight'; % remove white space around the figure
% f.Spacing = [0.02 0.02]; % set the spacing between subplots

% Adjust axis positions to fill the entire subplot
for i=1:(nm*3)
    pos = get(ax(i), 'Position');
    pos(1) = (pos(1)-0.01)*1.01;
    pos(2) = (pos(2)-0.01)*1.01;
    pos(3) = pos(3)*0.99;
    pos(4) = pos(4)*0.99;
    set(ax(i), 'Position', pos)
end

 drawnow 
 
 
   print('-dpng','-r300',[savepath '\' filename '_thresholds.png']);
 