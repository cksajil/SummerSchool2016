%% ANControl Using a FxLMS Algorithm in a Virtual Simulated Room
% This example show how to apply FxLMS filters to the application of ANC in
% a virtual simulated room. This example will help us to gain insight into
% different parameters and techniques to improve ANC eficiency


%% The Noise to be Cancelled
% Typical active noise control applications involve the sounds of rotating
% machinery due to their annoying characteristics.  Here, we synthetically
% generate noise that might come from a typical electric motor.  

%% Initialization of Active Noise Control 
% The most popular adaptive algorithm for active noise control is
% the filtered-X LMS algorithm.  This algorithm uses the secondary
% path estimate to calculate an output signal whose contribution
% at the error sensor destructively interferes with the undesired
% noise.  The reference signal is a noisy version of the undesired
% sound measured near its source.  We shall use a controller filter
% length of about 44 msec and a step size of 0.0001 for these
% signal statistics.     

% FIR Filter to be used to model primary propagation path
Hfir = dsp.FIRFilter('Numerator',G.');

% Filtered-X LMS adaptive filter to control the noise
L = 350;
muW = 0.0001;
Hfx = dsp.FilteredXLMSFilter('Length',L,'StepSize',muW,...
    'SecondaryPathCoefficients',H);

% Sine wave generator to synthetically create the noise
A = [.01 .01 .02 .2 .3 .4 .3 .2 .1 .07 .02 .01]; 
La = length(A);
F0 = 80; 
k = 1:La; 
F = F0*k;
phase = rand(1,La); % Random initial phase

Hsin = dsp.SineWave('Amplitude',A,'Frequency',F,'PhaseOffset',phase,...
    'SamplesPerFrame',512,'SampleRate',Fs);

% Audio player to play noise before and after cancellation
% Hpa = dsp.AudioPlayer('SampleRate',Fs,'QueueDuration',2);

% Spectrum analyzer to show original and attenuated noise
% Hsa = dsp.SpectrumAnalyzer('SampleRate',Fs,'OverlapPercent',80,...
%       'SpectralAverages',20,'PlotAsTwoSidedSpectrum',false,...
%       'ShowLegend',true, ...
%       'ChannelNames', {'Original noisy signal', 'Attenuated noise'});

%% Create a log variable for observing error signal changes

error = [];

%% Simulation Run Length

LoopLength = 200;
BreakPoint = 100;
FrameRate  = 512;

%% Simulation of Active Noise Control Using the Filtered-X LMS Algorithm 
% Here we simulate the active noise control system. To emphasize the
% difference we run the system with no active noise control for the first
% 200 iterations. Listening to its sound at the error microphone before
% cancellation, it has the characteristic industrial "whine" of such
% motors.
%
% Once the adaptive filter is enabled, the resulting algorithm converges
% after about 5 (simulated) seconds of adaptation. Comparing the spectrum
% of the residual error signal with that of the original noise signal, we
% see that most of the periodic components have been attenuated
% considerably.  The steady-state cancellation performance may not be
% uniform across all frequencies, however. Such is often the case for
% real-world systems applied to active noise control tasks. Listening to
% the error signal, the annoying "whine" is reduced considerably.

for m = 1:LoopLength
    s = step(Hsin); % Generate sine waves with random phase
    x = sum(s,2);   % Generate synthetic noise by adding all sine waves
    d = step(Hfir,x) + ...  % Propagate noise through primary path 
        0.5*randn(size(x)); % Add measurement noise
    if m <= BreakPoint
        % No noise control till breakpoint
        e = d;
       
    else
        % Enable active noise control after breakpoint
        xhat = x + 0.1*randn(size(x));
        [y,e] = step(Hfx,xhat,d);
        
    end
    %step(Hpa,e);     % Play noise signal
    error = [error; e];
    %step(Hsa,[d,e]); % Show spectrum of original (Channel 1)
                     % and attenuated noise (Channel 2)
end
%release(Hpa); % Release audio device
%release(Hsa); % Release spectrum analyzer
%% Error Signal Plot

time = (0:(1/Fs):(LoopLength*FrameRate-1)/Fs)';
figure(4);
plot(time,error)
grid on
title('Error Microphone Signal Values')
xlabel('Time in Seconds')
ylabel('Signal Amplitude')
legend('Error Signal')


%% End of Program
