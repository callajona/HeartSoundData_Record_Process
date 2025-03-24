% --------------------------------------------------------
% MATLAB Script for Processing CSV file from Osciloscope
%       Creator: Jon Calladine
%          Date: 29/01/25
% --------------------------------------------------------

clc
clear
close all

% Read data from file and seperate into voltage and time
data1 = csvread('test_4_c.csv',2); % Row offset to remove Labels from scope data
data2 = csvread('test_6_a.csv',2); % Row offset to remove Labels from scope data
data3 = csvread('test_7.csv',2); % Row offset to remove Labels from scope data

t1 = data1(:,1); % Time = First Column
v1 = data1(:,2); % Voltage = Second Column

t2 = data2(:,1); % Time = First Column
v2 = data2(:,2); % Voltage = Second Column

t3 = data3(:,1); % Time = First Column
v3 = data3(:,2); % Voltage = Second Column

% Find Max and Min Values of Each Waveform
v1Max = max(v1);
v2Max = max(v2);
v3Max = max(v3);

v1Min = min(v1);
v2Min = min(v2);
v3Min = min(v3);

% Use Max and Min values to determine Y-Axis range
offset = 0.1;
yLim_v1_bottom = v1Min - offset; 
yLim_v2_bottom = v2Min - offset; 
yLim_v3_bottom = v3Min - offset;

yLim_v1_top = v1Max + offset; 
yLim_v2_top = v2Max + offset; 
yLim_v3_top = v3Max + offset; 

% Plot Graph
% -------------------------------------------------
% Set Graph Parameters
% - Set Y axis range
yLim_bottom = -0.2;
yLim_top = 3.5;

% Line weight and colour
graphColour = 'm';
lineWidth = 0.5;
yAxisLabel = 'Voltage / V';
xAxisLabel = 'Time / s';

scaledAxis = 0; % Toggled scaled axis (0 = same scale, 1 = different scales)

if scaledAxis == 1
    graphColour = 'b'; % Blue graphs for different scales
end

titlePlot1 = 'Test 4c: Weak Seal, Max gain';
titlePlot2 = 'Test 6a: Improved Seal, Max Gain';
titlePlot3 = 'Test 7: Improved Seal, Calibrated Gain';

% Define Tiled Layout
tiles = tiledlayout(3,1);
title(tiles,'Comparison of Tests - Stethoscope with different seal qualities and different gain')

% --------- Plot 1 ---------
nexttile
plot(t1,v1,graphColour,'LineWidth',lineWidth)
title(titlePlot1)
ylabel(yAxisLabel)
xlabel(xAxisLabel)
grid on 

if scaledAxis == 0
    ylim([yLim_bottom yLim_top])
else
    ylim([yLim_v1_bottom yLim_v1_top])
end

% --------- Plot 2 ---------
nexttile
plot(t2,v2,graphColour,'LineWidth',lineWidth)
title(titlePlot2)
ylabel(yAxisLabel)
xlabel(xAxisLabel)
grid on 
if scaledAxis == 0
    ylim([yLim_bottom yLim_top])
else
    ylim([yLim_v2_bottom yLim_v2_top])
end

% --------- Plot 3 ---------
nexttile
plot(t3,v3,graphColour,'LineWidth',lineWidth)
title(titlePlot3)
ylabel(yAxisLabel)
xlabel(xAxisLabel)
grid on 

if scaledAxis == 0
    ylim([yLim_bottom yLim_top])
else
    ylim([yLim_v3_bottom yLim_v3_top])
end
