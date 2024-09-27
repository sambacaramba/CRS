% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
function createSettingsFile()
    % Open or create a text file to write settings
    fid = fopen('settings.txt', 'w');
    if fid == -1
        error('Failed to open file for writing.');
    end
    
    % Define default settings for various CRS configurations
    fprintf(fid, 'CRS1.binning = 0\n');
    fprintf(fid, 'CRS1.dataformat = *.png\n');
    fprintf(fid, 'CRS1.flipH = 0\n');
    fprintf(fid, 'CRS1.ThreeD = 0\n');
    fprintf(fid, 'CRS1.threshold_mult = 1.3\n');
    
    fprintf(fid, 'CRS3.flipH = 0\n');
    fprintf(fid, 'CRS3.ThreeD = 1\n');
    fprintf(fid, 'CRS3.filetype = *.png\n');
    fprintf(fid, 'CRS3.file_extension = .png\n');
    fprintf(fid, 'CRS3.common_nom = RAT\n');

    fprintf(fid, 'CRS4.voxel_size = 2.8\n');
    fprintf(fid, 'CRS4.polX = 5\n');
    fprintf(fid, 'CRS4.polY = 5\n');
    fprintf(fid, 'CRS4.removal_threshold = 10\n');
    fprintf(fid, 'CRS4.holefill = 150000\n');
 
    fprintf(fid, 'CRS6.Low_limit = 10\n');
    fprintf(fid, 'CRS6.High_limit = 45\n');

    % Close the file
    fclose(fid);
end