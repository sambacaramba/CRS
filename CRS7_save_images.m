clear all 
% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
%create images from local orientation analysis
%% needed files: mycolormap_orientation.mat

%% settings
radname ='_5_'; %radius in pixels that was used in the analyses 
Low_limit = 10; %Lower limit for showing angles (healthy vs. damaged threshold)
High_limit = 45; %Upper limit for showing angles (decrease to ipmrove dynamic range for smaller angles)
%%

LL= num2str(Low_limit); %low limit in string format
HL= num2str(High_limit); %high lmiit in string format

%load local orientation files to struct (Change name accordingly (*_orientation_X_pixeldiam.mat))
selpath = uigetdir('D:\', 'choose folder for local orientation files');
files = dir(fullfile(selpath,'*_orientation_10_pixeldiam.mat'));

%load surfaces to struct
selpath2 = uigetdir('D:\', 'choose folder for surfitres files');
files2 = dir(fullfile(selpath,'*surfitRes.mat'));

savefold = [selpath '\Orientation\images\' LL 'to' HL '\'];


    A = exist(savefold)
if A == 0
mkdir(savefold)
else 
end  



map = load('mycolormap_orientation.mat');
scr_siz = get(0,'ScreenSize') ;
figuresize=floor([scr_siz(3)/4 scr_siz(4)/4 scr_siz(3)/2 scr_siz(4)/2]);

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
            
            f=figure
            f.Position = figuresize
            surf(tmp.surfitres.simpsurf,res1)
            shading interp 
            axis equal 
            caxis([Low_limit High_limit])
            colormap(map.mycolormap_orientation)
            camlight('left')
            c=colorbar
            c.Title.String = 'Degrees';
            c.Color='black'

            view(180, 90)
            titlename = replace(name,'_',' ')
            titlerad = replace(radname,'_',' ');
            title([titlename ' radius=' titlerad '  orientation ',LL '-' HL ' degrees']);
            set(gca, 'XDir','reverse');
            
           
           print('-dpng','-r600',[savefold name radname '_orientation.png']);
           
        else 
        end
    end
end
