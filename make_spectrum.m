function [Y, freq] = make_spectrum(signal, fs)
% This function was written collaboratively in group 23

    % Compute the FFT of the signal (complex-valued)
    Y = fft(signal);
    
    % Normalize the FFT by the length of the signal
    Y = Y / length(Y);    

    % Frequency resolution
    N = length(signal);           % Number of samples
    T0 = N / fs;                  % Duration of signal in seconds
    delta_f = 1 / T0;             % Frequency resolution

    % Frequency vector (positive and negative frequencies)
    if mod(N, 2) == 0
        % FOR EVEN NUMBER OF SAMPLES
        f_pos = 0:delta_f:fs/2;    % Positive frequencies up to fs/2
        f_neg = -fs/2+delta_f:delta_f:-delta_f; % Negative frequencies
    else
        % FOR ODD NUMBER OF SAMPLES
        f_pos = 0:delta_f:(floor(N/2) * delta_f); % Up to just below Nyquist
        f_neg = -(floor(N/2)) * delta_f:delta_f:-delta_f; % Negative frequencies
    end

    % Combine positive and negative frequencies
    freq = [f_pos f_neg];

    % Convert FFT result to decibels if needed
    % Y = 20 * log10(abs(Y));  % Optionally apply dB scale here

    % Convert to column vectors if necessary
    Y = Y(:);
    freq = freq(:);
end