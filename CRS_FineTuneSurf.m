% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
function [ output number] = CRS_FineTuneSurf(fittedsurf, simplesurf, filename, fold)
AA = exist('F1');
if AA == 1
close(F1)
end

    A = exist(fold)
if A == 0
mkdir(fold)
else 
end  
%get surfaces
tmp_fitsurf = fittedsurf;
tmp_b_surf = -simplesurf;

x_size = size(tmp_fitsurf,1);
y_size = size(tmp_fitsurf,2);
%make a difference matrix 
diff_surf =  tmp_fitsurf-tmp_b_surf ;
%take only the values that are below zero as these are the places where
%surfaces overlap
neg_surf = diff_surf;
neg_surf(neg_surf >.0) = 0;

maxd = max(abs(neg_surf(:)));
mind = min(abs(neg_surf(:)));

F1 = figure;
    screensize = get( groot, 'Screensize' );
pos_fig1 = [40 40 screensize(3)*0.50 screensize(4)*0.50];
set(F1,'Position',pos_fig1); 
    
subplot(3,1,1)
surf(abs(neg_surf))
axis equal; view([-6 13]);
shading interp
title('before correction')
colormap jet
colorbar 
caxis([mind maxd]);

[val1,ind] = min(diff_surf(:));

neg_surf_nan = diff_surf;
neg_surf_nan(neg_surf_nan >.0) = NaN;
meanval = nanmean(neg_surf_nan(:));
meanval2 =meanval;
meanval_prev = meanval;
val = val1
val_prev = val1*2;
number = 1;
mod_fitsurf = tmp_fitsurf;
while val <= val1/4 &&not(abs(val_prev-val)<0.001)&&not(number>300) &&not(meanval2>(meanval/5)) &&not(meanval2<meanval_prev)
    
    neg_surf = diff_surf;
neg_surf(neg_surf >.0) = 0;
 [ testsurf, gof] = MUOTO_SurFitFix( neg_surf, 5, 5);   
   
 testsurf(testsurf >.0) = 0;
 mod_fitsurf= mod_fitsurf - testsurf;
diff_surf = mod_fitsurf - tmp_b_surf;

neg_surf_nan = diff_surf;
neg_surf_nan(neg_surf_nan >.0) = NaN;
meanval_prev = meanval2;
meanval2 = nanmean(neg_surf_nan(:));

val_prev = val;
[val,ind] = min(diff_surf(:));
number = number+1;
[number (abs(val_prev-val)) val1 val meanval meanval2]
end

diff_real_surf = (mod_fitsurf -fittedsurf);

%F2= figure
subplot(3,1,2)
surf(abs(diff_real_surf))
axis equal; view([-6 13]);
shading interp
title('modsurf')
colormap hot
colorbar

%F3= figure
subplot(3,1,3)
surf(abs(neg_surf))
axis equal; view([-6 13]);
shading interp
title('after correction')
colormap jet
colorbar
caxis([mind maxd]);
print('-dpng','-r300',[fold filename 'finetuning_surface' '.png']);

output = mod_fitsurf;
