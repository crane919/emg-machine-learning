function [feature_table] = getFeatures(dataChTimeTr,includedFeatures, Fs)
    
    % List of channels to include (can change to only use some)
    includedChannels = 1:size(dataChTimeTr,1);
    
    % Empty feature table
    feature_table = table();

    
    for f = 1:length(includedFeatures)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Calcuate feature values for 
        % fvalues should have rows = number of trials
        % usually fvales will have coluns = number of channels (but not if
        % it is some comparison between channels)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Check the name of each feature and hop down to that part of the
        % code ("case" is like... in the case that it is this thing.. do
        % this code)
        switch includedFeatures{f}

            % Variance  
            % variance represents the average squared deviation of the
            % signal from the mean. In this case, the signal is all of the
            % timepoints for a single channel and trial.
            %(fvalues = trials x channels)
            case 'var'
                fvalues = squeeze(var(dataChTimeTr,0,2))';
            
            case 'mav'
                fvalues = squeeze(mean(abs(dataChTimeTr), 2))';
            
            case 'rms'
                fvalues = squeeze(sqrt(mean(dataChTimeTr.^2, 2)))';
            
            case 'wavelength'
                % Initialize the result array
                fvalues = zeros(size(dataChTimeTr, 1), size(dataChTimeTr, 3));
                
                % Iterate through the data and calculate the sum of amplitude changes
                for tr = 1:size(dataChTimeTr, 3)
                    for ch = 1:size(dataChTimeTr, 1)
                        signal = squeeze(dataChTimeTr(ch, :, tr));
                        amplitude_changes = abs(diff(signal));
                        fvalues(ch, tr) = sum(amplitude_changes);
                    end
                end

                fvalues = fvalues';

            case 'iemg'
                fvalues = squeeze(sum(abs(dataChTimeTr), 2))'
            
            case 'range'
                 % Initialize the result array
                fvalues = squeeze(max(dataChTimeTr, [], 2) - min(dataChTimeTr, [], 2))';
              
               

% 
% In this code:
% 
% We initialize the fvalues array to store the results, with the same dimensions as the number of channels and trials.
% 
% We use nested loops to iterate through the data for each channel and trial.
% 
% For each trial and channel, we extract the signal data using squeeze.
% 
% We calculate the maximum value of the signal using the max function.
% 
% The resulting fvalues array contains the maximum value of each channel's signal in each trial.





            otherwise
                % If you don't recognize the feature name in the cases
                % above
                disp(strcat('unknown feature: ', includedFeatures{f},', skipping....'))
                break % This breaks out of this round of the for loop, skipping the code below that's in the loop so you don't include this unknown feature
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Put feature values (fvalues) into a table with appropriate names
        % fvalues should have rows = number of trials
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % If there is only one feature, just name it the feature name
        if size(fvalues,2) == 1
            feature_table = [feature_table table(fvalues,...
                'VariableNames',string(strcat(includedFeatures{f})))];
        
        % If the number of features matches the number of included
        % channels, then assume each column is a channel
        elseif size(fvalues,2) == length(includedChannels)
            %Put data into a table with the feature name and channel number
            for  ch = includedChannels
                feature_table = [feature_table table(fvalues(:,ch),...
                    'VariableNames',string(strcat(includedFeatures{f}, '_' ,'Ch',num2str(ch))))]; %#ok<AGROW>
            end
        
        
        else
        % Otherwise, loop through each one and give a number name 
            for  v = 1:size(fvalues,2)
                feature_table = [feature_table table(fvalues(:,v),...
                    'VariableNames',string(strcat(includedFeatures{f}, '_' ,'val',num2str(v))))]; %#ok<AGROW>
            end
        end
    end



end

