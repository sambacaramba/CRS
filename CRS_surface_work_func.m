% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
function surfvals = CRS_surface_fit(vol,fn_b,savefold,res_loc,vox_siz,offset,polX,polY,option,removal_threshold);
%% used functions CRS_SurFit, MUOTO_FineTuneSurf 
res_loc=1;

 close all 

    vol = flip(vol,3);
    close all;
    [x, y, z] =  size(vol)
   
   %sweep volume
   vol = logical(vol);
   largestobject = false(x,y,z);
 object = bwconncomp(vol)
 numPixels = cellfun(@numel,object.PixelIdxList);
 [largest,idx] = max(numPixels);
    largestobject(object.PixelIdxList{idx}) = 1;
  vol = largestobject;
  clear largest idx numPixels object largestobject
  %find simple surface  
    s_height = NaN(x,y);
    r_height = NaN(x,y);

for k=1:z
        destinds = isnan(s_height);
        s_height(destinds & vol(:,:,k)) = k-1;
end  
  s_height(s_height <= 1) = NaN;
  r_height=s_height;
  [x,y] = size(r_height);
  b_surf=r_height;   
    
  figure;
  surf(-b_surf);
  shading interp;
  camlight left 
  axis equal
  view(-84, 17);
  drawnow;

    ftmp = figure;
%     [x,y]=size(b_surf);

%     pv_le=0;
%     pvect(pv_le+1,:) = [1,1];
%     pv_le=pv_le+1;
%     pvect(pv_le+1,:) = [1,x];
%     pv_le=pv_le+1;
%     pvect(pv_le+1,:) = [y,1];
%     pv_le=pv_le+1;
%     pvect(pv_le+1,:) = [y,x];
%     pv_le=pv_le+1;
%     found=1;
   
%% iterative heightmap
    heightmap_iter = -s_height;
    m = 1;
    summa = 11;
    removed = 11;
while removed > 10 
    
    FittedSurfs = CRS_SurFit( heightmap_iter, polX,polY);

    maski = s_height;
    maski(isnan(maski))= 0;
    maski(maski>0) = 1; 
    FittedSurfs(~maski) = NaN;

%Find large deviations (over 10 pixels) and remove them from the fitting surface
%Prevent the removal of deviations from the edges of the area (a border 2-3 pixels thick)
    SE = strel('rectangle',[5 5]);
    border_mask = logical(imerode(padarray(maski,[3 3],0,'both'),SE));
    borders_back = logical(padarray(maski,[3 3],0,'both')-border_mask);
%Remove edge pixels from affecting the calculation
    border_mask = border_mask(3+1:end-3,3+1:end-3); % unpad
    borders_back = borders_back(3+1:end-3,3+1:end-3); % unpad

    diff = abs(FittedSurfs.*border_mask-heightmap_iter.*border_mask);
    summa1 = diff(diff>removal_threshold);
    summa = sum(summa1(:));
    removed = numel(summa1)
    kuvaaja(m,1) = removed;
    m=m+1;

% plot(kuvaaja)
% drawnow 

    diff(diff>removal_threshold) = 0;
    diff(isnan(diff)) = 0; 
    heightmap_iter(~diff)= NaN;
%restore edges to heightmap
    heightmap_iter(borders_back) = -s_height(borders_back);
end
%% shift fitted surface on top of the cartilage by offset
    FittedSurfs_shift = FittedSurfs + offset;
    fitsurf = FittedSurfs_shift;

%% fine tuning the fitted surface from the locations where it still overlaps the actual surface
%% use a smoothed surface (median filter) for the test to remove "surface spikes" from the fit
  
    b_surf = medfilt2(padarray(b_surf,[5 5],NaN,'both'),[9 9]);
    b_surf = b_surf(5+1:end-5,5+1:end-5);
    difsurf = (fitsurf-(-b_surf));
    surfval = nanmin(nanmin(difsurf));
    meanval = nanmean(nanmean(difsurf(difsurf<0)));
    clear number
    
    if surfval < 0 
        if option == 1
    [fitsurf number]= MUOTO_FineTuneSurf(fitsurf,b_surf,fn_b,savefold);
    else 
        end 
    end

%gather stats from the fit (needed if MUOTO_Fine_TuneSurf was used)
    difsurf =(fitsurf-(-b_surf));
    surfval2 = nanmin(nanmin(difsurf));
    meanval2 = nanmean(nanmean(difsurf(difsurf<0)));

    surfvals(res_loc).name = fn_b
    surfvals(res_loc).highest_deviance = surfval
    surfvals(res_loc).highest_deviance_after_fit = surfval2
    surfvals(res_loc).mean_deviance = meanval
    surfvals(res_loc).mean_deviance_after_fit = meanval2
    surfvals(res_loc).removed_from_fit = kuvaaja;
   
    vartest  =  exist('number');
    if vartest == false
        number = 0; 
    else
    end
    surfvals(res_loc).number_of_iterations = number; 

    close(ftmp);
   



%visualize fit result
    grid = CreateSurfGrid(fitsurf+3);
    maski_NAN = maski; 
    maski_NAN(maski_NAN == 0) = NaN;
    fitsurf = fitsurf.*maski_NAN;
    grid = grid.*maski_NAN;
     
    surfitres.sample = fn_b;  
    surfitres.fitsurf = fitsurf;
    surfitres.simpsurf = -s_height;
    surfitres.mediansurf = -b_surf;
    
    save(strcat(savefold,fn_b,'_surfitRes.mat'),'surfitres');
    clear surfitres
   
    tmpsrf(:,:,1)=fitsurf+3;
    tmpsrf(:,:,2)=-s_height;
    tmpsrf(:,:,3)=grid;
    figure;
    surf(-s_height);
    hold all;
     
    camlight
    shading interp; 
    sss = surf(fitsurf);
    set(sss, 'EdgeColor', 'none');
    set(sss, 'FaceAlpha', 'flat');
    set(sss, 'FaceColor',[0.9 0.9 0.9]);
    set(sss, 'FaceAlpha', 0.5);
    surf(grid);
    axis equal
    
    view(-70, 36);
    drawnow;
%save image for inspection
    print('-dpng','-r500',[savefold 'Grid_surf_' fn_b '.png']);

end
