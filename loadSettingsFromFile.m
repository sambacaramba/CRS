% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
function settings = loadSettingsFromFile()
    % Open the settings file for reading
    fid = fopen('settings.txt', 'r');
    if fid == -1
        error('Failed to open settings file.');
    end
    
    settings = struct();
    % Read each line from the file
    while ~feof(fid)
        line = fgetl(fid);
        if line == -1
            break;
        end
        % Parse the line using regular expressions
        tokens = regexp(line, '([^=]+)=(.*)', 'tokens');
        if isempty(tokens)
            continue; % Skip lines that do not match
        end
        tokens = tokens{1};
        key = strtrim(tokens{1});
        value = strtrim(tokens{2});
        
        % Convert numeric values from strings to numbers
        numericValue = str2double(value);
        if ~isnan(numericValue)
            value = numericValue;
        end
        
        % Dynamically create fields in the settings structure
        eval(['settings.' key ' = value;']);
    end
    
    % Close the file
    fclose(fid);
end