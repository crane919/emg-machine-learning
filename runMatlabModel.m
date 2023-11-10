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
    res = 2;
    % Process data / filter it / convert it into 4x?x1 
    [dataChTimeTr, labels] = processData(data);
    
    % extract features
    includedFeatures = {'var','mav','rms','wavelength', 'iemg', 'range'}; 
    Fs = 1000;
    feature_table = getFeatures(dataChTimeTr(:,:,10),includedFeatures,Fs);
   
    % run it through the classifier
    load("latestClassifier.mat");
    selected_features = [9 10 11 12 13 14 15 16];
    X_test = feature_table(:,selected_features);
    predictions = currentClassifier.predict(X_test)
    % print out the gesture
end