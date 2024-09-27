% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
function appendSettingsFile(rad)
    % Define the filename
    filename = 'settings.txt';
    
    % Try to open the file for reading
    fid = fopen(filename, 'r');
    
    if fid == -1
        % If the file doesn't exist, create it and write the entry
        fid = fopen(filename, 'w');
        if fid == -1
            error('Failed to open file for writing.');
        end
        fprintf(fid, 'CRS5.radius = %f\n', rad);
        fclose(fid);
        return;
    end
    
    % Read the file contents
    fileContents = textscan(fid, '%s', 'Delimiter', '\n');
    fclose(fid);
    
    % Check if 'CRS5.radius' exists
    entryExists = false;
    for i = 1:length(fileContents{1})
        if contains(fileContents{1}{i}, 'CRS5.radius')
            entryExists = true;
            fileContents{1}{i} = ['CRS5.radius = ' num2str(rad)];
            break;
        end
    end
    
    % Open the file for writing
    fid = fopen(filename, 'w');
    if fid == -1
        error('Failed to open file for writing.');
    end
    
    % Write the updated contents back to the file
    for i = 1:length(fileContents{1})
        fprintf(fid, '%s\n', fileContents{1}{i});
    end
    
    % If the entry doesn't exist, append it
    if ~entryExists
        fprintf(fid, 'CRS5.radius = %f\n', rad);
    end
    
    % Close the file
    fclose(fid);
end