function [dataChTimeTr,labels] = processData(data)
%PROCESSDATA Summary of this function goes here

% change the file path if you have a different setup
    addpath('~/emg-machine-learning/analysis/')
    addpath('~/emg-machine-learning/dataCollection/rawData/')
    
    %load(data);

    %     % Initialize the variables to store the data
    % dataChTimeTr = [];
    % labels = [];
    % 
    % format the data 
    [dataChTimeTr, labels] = preprocessData(data)
    
    % Change the name of the data file
    save("test_data.mat","dataChTimeTr","labels");
end

