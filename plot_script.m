%% Setup parameters

% Set up sample frequency and timescale
fs = 10000;             % sampling frequency
T = 10;                 % duration in seconds
n = randn(fs*T, 1);     % some random vector (white noise)

% Find length of vector
len_n_samples = length(n);      % in samples
len_n_s = length(n) / fs;       % in time

% calculate the frequency vector
T0 = length(n) / fs;    % duration of the signal in seconds
delta_f = 1 / T0;       % frequency resolution

%% Initial analysis

% Split positive and negative frequencies
f_pos = 0:delta_f:fs/2;         % positive frequencies up to fs/2 (Nyquist)
f_neg = -fs/2+delta_f:delta_f:-delta_f;  % negative frequencies from -fs/2 to 0

% Fourier transform of the vector
Y = fft(n);

% Take only positive frequencies (single-sided spectrum)
Y_pos = Y(1:floor(length(Y)/2) + 1);

% Test plot of white noise frequency spectrum
% figure;
% plot(f_pos, 20*log10(abs(Y_pos)));
% xlabel('Frequency [Hz]');
% ylabel('Magnitude [dB]');
% grid on;

%% Clean signal for comparison

% Function to generate a sinusoid
function [time_vector, signal] = generate_sinusoid(a, f, phi, fs, T_s)

    time_vector = 0:1/fs:T_s-1/fs;
    signal = a * cos(2 * pi * f * time_vector + phi);
end

% Sinusoidal signal
[x_values, y_values] = generate_sinusoid(1, 184, 0, fs, 0.5);

% Call make_spectrum for sinusoid
[Y_clean, freq_clean] = make_spectrum(y_values, fs);

%% Analyze voice recording

% Load audio file
[signal, fs] = audioread('humanVoice.wav');

% Convert stereo to mono by only considering one channel
if size(signal, 2) == 2
    signal(:,2) = [];
end

% make_spectrum of the voice signal
[Y_voice, freq_voice] = make_spectrum(signal(end-24000+1:end), fs);

%% Combined Stem Plot of Clean Sinusoid and Voice Signal

figure;

% Stem plot of clean sinusoid
stem(freq_clean, abs(Y_clean), 'r');
hold on;

% Stem plot of human voice signal
stem(freq_voice, abs(Y_voice), 'b');

% Set axes limits and labels
xlim([-3000 3000]);
ylim([-0.100 0.500]);
xlabel('Frequency [Hz]');
ylabel('Magnitude [a.u.]');
title('Stem Plot: Clean Sinusoid vs Human Voice');
grid on;

% Zoomed in inset for human voice peak at 184 Hz
zoom_x = [179 189];  % Zoom range around 184 Hz
zoom_y = [0 0.05];   % Zoom magnitude range

% Create inset
axes('Position', [0.67 0.65 0.2 0.2]);  % Adjust the position and size of inset
box on;

stem(freq_voice, abs(Y_voice), 'b', 'LineWidth', 1.5);  % Zoomed-in stem plot for human voice
xlim(zoom_x);
ylim(zoom_y);
title('Peak at 184 Hz');
grid on;
hold on;

%% Decibel magnitude plot of human voice and clean sinusoid for comparison

figure;
% Plot decibel magnitude of clean sinusoid
plot(freq_clean, 20*log10(abs(Y_clean)), 'r');
hold on;

% Plot decibel magnitude of human voice
plot(freq_voice, 20*log10(abs(Y_voice)), 'b');

% Set axes limits and labels
xlim([-3000 3000]);
xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');
title('Spectrum plot of the two signals (dB scale)');
grid on;
