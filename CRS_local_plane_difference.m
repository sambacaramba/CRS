function [res1] = CRS_local_plane_difference(ref, tar, radius)  
% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
%% functions used:  ParforProgressbar, GetSurfNormVector

offset = radius+1;

B = smoothdata(tar,'gaussian',[radius radius]);

%pad surface edges 
res1= zeros(size(ref));
%loop through the surface to create local normal difference
L = size(ref,1)-offset;
L2 = size(ref,2)-offset;


numIterations=L;
  ppm = ParforProgressbar(numIterations);

parfor i = offset:L

    for j = offset:L2
        
        test_ref=ref([i-radius:i+radius],[j-radius:j+radius]);
         test_tar=B([i-radius:i+radius],[j-radius:j+radius]);
         
         t_ref = max(max(isnan(test_ref)));
         t_tar = max(max(isnan(test_tar)));
         
         if ~max([t_ref,t_tar]);
         
        
         
         a = GetSurfNormVector(-test_ref);
         b = GetSurfNormVector(-test_tar);
         
    
        
         %calculate angle between two unit vectors
         %[θ=arccos(u⃗ ⋅v⃗ )/(|u⃗ |*|v⃗ |)]
         angle_diff = acos((a(1) * b(1) + a(2) * b(2) + a(3) * b(3)) / (sqrt(a(1)^2 + a(2)^2 + a(3)^2) * sqrt(b(1)^2 + b(2)^2 + b(3)^2)));
         
         angle_diff =rad2deg(angle_diff);
         res1(i,j) =angle_diff;
         else 
         end

    end
   
   
 % increment counter to track progress
        ppm.increment();
end

delete(ppm);
