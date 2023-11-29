function predictions = runMatlabModel(data)
    %%%
    % This is starter code for where you should add your MATLAB model.
    % You can place this wherever you want, but keep the function name
    % This function should take in a bunch of data from the EMG sensor
    % and return rock, paper, and scissors, based on what your model
    % predicts. 
    %%%
    addpath('~/emg-machine-learning/dataCollection/')
    disp(data)
    % Process data / filter it / convert it into 4x?x1 
    dataChTimeTr = live_preprocessData(data);
    
    % extract features
    includedFeatures = {'var','mav','rms','wavelength', 'iemg', 'range'}; 
    Fs = 1000;
    feature_table = getFeatures(dataChTimeTr(:,:,1),includedFeatures,Fs);
   
    % run it through the classifier
    load("latestClassifier.mat");
    X_test = feature_table(:,selected_features);
    predictions = currentClassifier.predict(X_test)
    % print out the gesture
end

function [epochedData] = live_preprocessData(data)
%preprocessData Filter and epoch the data   
Fs = 1000;
numCh = 4;
epochedData =[];
  
% filter data (best to filter before chopping up to reduce artifacts)
% First check to make sure Fs (samping frequency is correct)
actualFs = 1/mean(diff(data(:,1)));
if abs(diff(actualFs - Fs )) > 50
    warning("Actual Fs and Fs are quite different. Please check sampling frequency.")
end

filtered_lsl_data = [];
filtered_lsl_data(:,1) = data(:,1);
for ch = 1:numCh
    x = highpass(data(:,ch+1),5,Fs);
    x = bandstop(x,[58 62],Fs);
    x = bandstop(x,[118 122],Fs);
    filtered_lsl_data(:,ch) = bandstop(x,[178 182],Fs);
end

epochedData = filtered_lsl_data';
end