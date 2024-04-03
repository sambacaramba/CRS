% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
clear all 

%% used functions GetSurfNormVector


%load local orientation files to struct
selpath = uigetdir('D:', 'choose folder for local orientation files');
files = dir(fullfile(selpath,'*orientation_11_pixeldiam.mat')); %a common name for files to look for

%load surfaces to struct
selpath2 = uigetdir('D:', 'choose folder for surfitRes files');
files2 = dir(fullfile(selpath,'*surfitRes.mat')); %a common name for files to look for

%create savefolder 
savefold = ([selpath '\Orientation\']);

    A = exist(savefold)
if A == 0
mkdir(savefold)
else 
end  


%loop through surface files
for i=1:length(files2)
    
    tmp=load([files2(i).folder '\' files2(i).name]);
    name = tmp.surfitres.sample; 
    
    %match surface with orientation file based on filename
    for j= 1:length(files)
        name2 = files(j).name; 
        
        TF = contains(name2,name)
        
        if(TF) 
            close all 
            load([files(j).folder '\' files(j).name])
            
     mask = tmp.surfitres.simpsurf;
     result = res1; 
     
     Results(j).sample = name; 
     
     mask(~isnan(mask))=1;
     mask(isnan(mask))=0;
          
     %calculate average value /set zeros to NaN
     resnan = res1; 
     resnan(resnan==0) = NaN; 
     average_res = nanmean(resnan(:));
     
      Results(j).average_CRS = nanmean(resnan(:));
      Results(j).std_CRS = nanstd(resnan(:));
      Results(j).median_CRS = nanmedian(resnan(:));
      Results(j).total_area = length(~isnan(resnan(:)));
      
      Results(j).surface_normal_unit_vector = GetSurfNormVector(-tmp.surfitres.simpsurf)
      
      %percentages of degraded area with ascending thresholds
      Results(j).over5 = length(resnan(resnan>5))/length(~isnan(resnan(:)))*100;
      Results(j).over6 = length(resnan(resnan>6))/length(~isnan(resnan(:)))*100;
      Results(j).over7 = length(resnan(resnan>7))/length(~isnan(resnan(:)))*100;
      Results(j).over8 = length(resnan(resnan>8))/length(~isnan(resnan(:)))*100;
      Results(j).over9 = length(resnan(resnan>9))/length(~isnan(resnan(:)))*100;
      Results(j).over10 = length(resnan(resnan>10))/length(~isnan(resnan(:)))*100;
      Results(j).over11 = length(resnan(resnan>11))/length(~isnan(resnan(:)))*100;
      Results(j).over12 = length(resnan(resnan>12))/length(~isnan(resnan(:)))*100;
      Results(j).over13 = length(resnan(resnan>13))/length(~isnan(resnan(:)))*100;
      Results(j).over14 = length(resnan(resnan>14))/length(~isnan(resnan(:)))*100;
      Results(j).over15 = length(resnan(resnan>15))/length(~isnan(resnan(:)))*100;
      Results(j).over16 = length(resnan(resnan>16))/length(~isnan(resnan(:)))*100;
      Results(j).over17 = length(resnan(resnan>17))/length(~isnan(resnan(:)))*100;
      Results(j).over18 = length(resnan(resnan>18))/length(~isnan(resnan(:)))*100;
      Results(j).over19 = length(resnan(resnan>19))/length(~isnan(resnan(:)))*100;
      Results(j).over20 = length(resnan(resnan>20))/length(~isnan(resnan(:)))*100;

      %sum of angles exceeding ascending threshold angle
      Results(j).sum_of_angles_over5 = nansum(resnan(resnan>5));
      Results(j).sum_of_angles_over6 = nansum(resnan(resnan>6));
      Results(j).sum_of_angles_over7 = nansum(resnan(resnan>7));
      Results(j).sum_of_angles_over8 = nansum(resnan(resnan>8));
      Results(j).sum_of_angles_over9 = nansum(resnan(resnan>9));
      Results(j).sum_of_angles_over10 = nansum(resnan(resnan>10));
      Results(j).sum_of_angles_over11 = nansum(resnan(resnan>11));
      Results(j).sum_of_angles_over12 = nansum(resnan(resnan>12));
      Results(j).sum_of_angles_over13 = nansum(resnan(resnan>13));
      Results(j).sum_of_angles_over14 = nansum(resnan(resnan>14));
      Results(j).sum_of_angles_over15 = nansum(resnan(resnan>15));
      Results(j).sum_of_angles_over16 = nansum(resnan(resnan>16));
      Results(j).sum_of_angles_over17 = nansum(resnan(resnan>17));
      Results(j).sum_of_angles_over18 = nansum(resnan(resnan>18));
      Results(j).sum_of_angles_over19 = nansum(resnan(resnan>19));
      Results(j).sum_of_angles_over20 = nansum(resnan(resnan>20));
   
      
     
        else 
        end
    end
end

   

%calculate average angular difference between medial and lateral surfaces

% Assume Results is your struct with fields 'sample' and 'surface_normal_unit_vector'
numResults = numel(Results);

% Preallocate for efficiency
angleDifferences = [];

for i = 1:numResults
    for j = i+1:numResults
        sample1 = Results(i).sample;
        sample2 = Results(j).sample;
        
       cutter = max(strfind(sample1,'_'))-1;
        % Check if the samples are from the same rat but different sides
        if startsWith(sample1, sample2(1:cutter)) && ~endsWith(sample1, sample2(end-6:end))
            vector1 = Results(i).surface_normal_unit_vector;
            vector2 = Results(j).surface_normal_unit_vector;
            
            % Calculate the angular difference in degrees
            dotProduct = dot(vector1, vector2);
            angleRad = acos(dotProduct);
            angleDeg = rad2deg(angleRad);
            
            % Store the results
            angleDifferences = [angleDifferences; {sample1, sample2, angleDeg}];
            Results(i).MED_LAT_ang_diff_names = [sample1, sample2];
            Results(i).MED_LAT_angular_diff = angleDeg;
            
        end
      
    end
end

% Display the results
%disp('Angular differences between lateral and medial sides:');
%disp(angleDifferences);



 save([savefold 'Orientation_results.mat'], 'Results');
 T = struct2table(Results);
 writetable(T,[savefold 'newResultfile.txt']);

