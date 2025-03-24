% --------------------------------------------------------
% MATLAB Script for Processing CSV file from Osciloscope
%           Creator: Jon Calladine
%       DateCreated: 29/01/25
%      DateImproved: 18/03/25        
% --------------------------------------------------------

clc
clear
close all

% --------- Parameters To Specify ---------
testFiles = {'test_9_a.csv','test_9_b.csv','test_9_c.csv'}; % Specify file names
% ,'test_5_f.csv','test_6_c.csv'

% --- Plotting Parameters ---
figureTitle = 'Same test repeated three times to observe the consistency between Measurements';

% Toggle parameters
toggleCursours =   0; % Toggled cursors (0 = off, 1 = on)
toggleLegend =     0; % Toggled Legend (0 = off, 1 = on)
toggleScaledAxis = 1; % Toggled scaled axis (0 = same scale, 1 = different scales)

% Axis Limits Parameters
scaleldAxisoffset = 0.1; %Offset for scaled axis (added to max and min values)
fixedAxisLimit = [-0.2 3.3]; % Max and Min Values for axis limits

% Line weight and colour & Axis Titles
graphColour = 'r';
lineWidth = 0.5;
yAxisLabel = 'Voltage / V';
xAxisLabel = 'Time / s';

% ===========================================================================
%  All Parameters Specified - Nothing else needs changing beyond this point
% ===========================================================================

% Initialise variables for data storage
numFiles = length(testFiles); % Calculate length of file
t = zeros(50000,numFiles); % Matrix to store time data
v = zeros(50000,numFiles); % Matrix to store all voltage data
vMinMax = zeros(2,numFiles); % Matrix to store maximum and minimum values
varAxisLim = zeros(2,numFiles); % Matrix to store variable axis limits
lowerCursor = zeros(50000,numFiles); % Matrix to store lower cursors values
upperCursor = zeros(50000,numFiles); % Matrix to store upper cursors values
plotTitles = {}; % Define array fro storing plot tities
testTitles = readcell('TestTitles.csv'); % Read file that stores titles for each test

% Read data from file and seperate into voltage and time for each file
% Calculate the max and min values for each data set 
% use Min Max values to find scaled axis limits
for n = 1:numFiles
    data = csvread(testFiles{n},2); % Row offset to remove Labels from scope data
    
    t(:,n) = data(:,1); % Time = First Column
    v(:,n) = data(:,2); % Voltage = Second Column
    
    vMinMax(1,n) = min(v(:,n)); % Find min voltage value
    vMinMax(2,n) = max(v(:,n)); % Find max voltage value
    
    varAxisLim(1,n) = vMinMax(1,n) - scaleldAxisoffset; % Lower limit
    varAxisLim(2,n) = vMinMax(2,n) + scaleldAxisoffset; % Upper Limit
    
    % Create cursours - Fill each column with same value to create a plotable cursor
    lowerCursor(:,n) = vMinMax(1,n); % Min value for lower cursor
    upperCursor(:,n) = vMinMax(2,n); % Max value for upper cursor
    
    % Get title from file and add to plotTitles array if CSV file name matches
    for i = 2:length(testTitles) % Read each line 
        if strcmp(testTitles{i,1},testFiles{n}) == 1 % Compare file names to specified files
            plotTitles{n} = testTitles{i,2}; % Write title from file to plotTitles array
        end
    end
end

% Conditional Plotting Variables
if toggleScaledAxis == 1
    graphColour = 'b'; % Blue graphs for different scales
end

% Define Tiled Layout
tiles = tiledlayout(numFiles,1); % Set number of tiles based on number of tests
title(tiles,figureTitle); % Provide overall title if one provided

% Plot Graph
for n = 1:numFiles % Loop function for each graph
    nexttile % Create next tile for tiled layout
    plot(t(:,n),v(:,n),graphColour,'LineWidth',lineWidth) % Plot each plot with parameters specified
    title(plotTitles{n}) % Add plot title
    ylabel(yAxisLabel) % Add Y axis label
    xlabel(xAxisLabel) % Add X axis label
    grid on % Turn grid on
    
    if toggleCursours == 1
        % Display Cursors - Hold on used to plot them on the same graph
        hold on
        plot(t(:,n),lowerCursor(:,n),'k--',t(:,n),upperCursor(:,n),'k--')
        hold off
        
        if toggleLegend == 1
            % Display legend with Min and Max values 
            numDP = 3; % Number of Decimal Places to Round to 
            lowerCursorText = strcat('Lower Cursor:',num2str(round(vMinMax(1,n),numDP)),'V');
            upperCursorText = strcat('Upper Cursor:',num2str(round(vMinMax(2,n),numDP)),'V');
            legend('Signal',lowerCursorText,upperCursorText)
        end 
    end
    
    if toggleScaledAxis == 0
        ylim([fixedAxisLimit(1) fixedAxisLimit(2)])
    else
        ylim([varAxisLim(1,n) varAxisLim(2,n)])
    end
end

%plotTitles = {'Test 6a: Auscultation Location - Mitrial','Test 6b: Auscultation Location - Aortic','Test 6c: Auscultation Location - Non-Ideal'};
