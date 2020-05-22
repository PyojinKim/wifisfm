clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;


%% 1) load RoNIN IO data

% choose dataset path
datasetPath = '../data';
datasetList = dir(datasetPath);
datasetList(1:2) = [];


% load unique WiFi RSSID Map
load([datasetPath '/uniqueWiFiAPsBSSID.mat']);


% load RoNIN IO data
numDatasetList = 55;
datasetRoninIO = cell(1,numDatasetList);
for k = 1:numDatasetList
    
    % extract RoNIN data
    datasetDirectory = [datasetPath '\' datasetList(k).name];
    roninInterval = 200;          % 1 Hz
    roninYawRotation = 0;       % degree
    RoninIO = extractRoninCentricData(datasetDirectory, roninInterval, roninYawRotation, 25.0, uniqueWiFiAPsBSSID);
    
    
    % save RoNIN IO
    datasetRoninIO{k} = RoninIO;
    k
end


% unify Google FLP inertial frame in meter
datasetRoninIO = unifyRoninIOGoogleFLPMeterFrame(datasetRoninIO);


% Google FLP visualization
for k = 1:numDatasetList
    
    % current RoNIN IO data
    RoninIO = datasetRoninIO{k};
    RoninIOLocation = [RoninIO.FLPLocationMeter];
    
    
    % plot RoNIN IO location
    distinguishableColors = distinguishable_colors(numDatasetList);
    figure(10); hold on; grid on; axis equal; axis tight;
    plot(RoninIOLocation(1,:),RoninIOLocation(2,:),'*-','color',distinguishableColors(k,:),'LineWidth',1.5); grid on; axis equal;
    xlabel('X [m]','FontName','Times New Roman','FontSize',15);
    ylabel('Y [m]','FontName','Times New Roman','FontSize',15);
    set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure
end


%% 2) optimize each RoNIN IO against Google FLP

% initial 2D rigid body transformation w.r.t. Google FLP
for k = 1:numDatasetList
    
    % current RoNIN IO data
    RoninIO = datasetRoninIO{k};
    
    
    % nonlinear optimization with RoNIN drift correction model
    [RoninIO] = optimizeEachRoninIO(RoninIO);
    datasetRoninIO{k} = RoninIO;
end


% save the variables
save('datasetRoninIO.mat','datasetRoninIO');


% optimized RoNIN IO visualization
for k = 1:numDatasetList
    
    % current RoNIN IO data
    RoninIO = datasetRoninIO{k};
    RoninIOLocation = [RoninIO.location];
    
    
    % plot RoNIN IO location
    distinguishableColors = distinguishable_colors(numDatasetList);
    figure(10); hold on; grid on; axis equal; axis tight;
    plot(RoninIOLocation(1,:),RoninIOLocation(2,:),'-','color',distinguishableColors(k,:),'LineWidth',1.5); grid on; axis equal;
    xlabel('X [m]','FontName','Times New Roman','FontSize',15);
    ylabel('Y [m]','FontName','Times New Roman','FontSize',15);
    set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure
end







