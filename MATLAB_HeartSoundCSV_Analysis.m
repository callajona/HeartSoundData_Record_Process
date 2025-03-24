% --------------------------------------------------------
% MATLAB Script for Processing CSV file from Osciloscope 
% and analysing them in the frequency domain - with filtering
%       Creator: Jon Calladine
%   DateCreated: 21/03/25
% --------------------------------------------------------

clc
clear
close all

% Read data from file and seperate into voltage and time
data = csvread('test_4_c.csv',2); % Row offset to remove Labels from scope data

t = data(:,1); % Time = First Column
v = data(:,2); % Voltage = Second Column

% De noising
v_denoise = wdenoise(v);

% Filtering
fc = 20; % Cut off frequency
fs = 1000; % Sampling Frequency (fs/2 =  BW of plot)

[b,a] = butter(4,fc/(fs/2),'low'); % Calculate [b,a] for butterworth filter

%freqz(b,a,[],fs) %  Plot frequency response of filter
%subplot(2,1,1)
%ylim([-100 20])

v_filtered = filter(b,a,v);

% Plot signal and De noised signal on same plot
figure(2)
tiledlayout(2,3)

nexttile
plot(t,v)
title('Captured Signal')
ylim([-0.2 3.4])
grid on

nexttile
plot(t,v_denoise)
ylim([-0.2 3.4])
title('Denoised Signal')
grid on

nexttile
plot(t,v_filtered)
ylim([-0.2 3.4])
title('Filtered Signal')
grid on

nexttile
pspectrum(v,t,'spectrogram')
ylim([0 1])
title('Power Spectrum of raw signal - Test 4a')

nexttile
pspectrum(v_denoise,t,'spectrogram')
ylim([0 1])
title('Power Spectrum of Denoised Signal - Test 4a')

nexttile
pspectrum(v_filtered,t,'spectrogram')
ylim([0 1])
title('Power Spectrum of Filtered Signal - Test 4a')
