% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
function [mask_l, mask_m] = CRS_extract_imageJ_ROI(pathname,Width, Height)


[sROI] = ReadImageJROI(pathname);

for i=1:length(sROI)    
    names(i).roiname = sROI{1,i}.strName
end

for i=1:length(names)

lat_loc(i) = logical(contains(names(i).roiname,'lat'))
med_loc(i) = logical(contains(names(i).roiname,'med'))
end

lat_loc = find(lat_loc)
med_loc = find(med_loc)


roi_l = sROI{1,lat_loc(1)}.mnCoordinates
roi_m = sROI{1,med_loc(1)}.mnCoordinates



roiflp_l=flip(roi_l,1)

X_l =roiflp_l(:,1);
Y_l= roiflp_l(:,2);

roiflp_m=flip(roi_m,1)

X_m =roiflp_m(:,1);
Y_m= roiflp_m(:,2);


mask_l = poly2mask(X_l,Y_l,Height,Width);
mask_m = poly2mask(X_m,Y_m,Height,Width);

figure,
title(pathname(end-15:end))
imshowpair(mask_l,mask_m)





