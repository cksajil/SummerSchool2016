%% Program to plot the Power Spectral Density(PSD) 
%  before and after cancellation

%% Split the data into ANCON and ANCOFF

errorANCOFF = error(1:FrameRate*BreakPoint);
errorANCON = error((FrameRate*BreakPoint+1):end);

%% PSD Plotting Part

N1 = length(errorANCOFF);
xdft1 = fft(errorANCOFF);
xdft1 = xdft1(1:N1/2+1);
psdx1 = (1/(Fs*N1)) * abs(xdft1).^2;
psdx1(2:end-1) = 2*psdx1(2:end-1);
freq1 = 0:Fs/length(errorANCOFF):Fs/2;

N2 = length(errorANCON);
xdft2 = fft(errorANCON);
xdft2 = xdft2(1:N2/2+1);
psdx2 = (1/(Fs*N2)) * abs(xdft2).^2;
psdx2(2:end-1) = 2*psdx2(2:end-1);
freq2 = 0:Fs/length(errorANCON):Fs/2;

ANCOFFdB = 10*log10(psdx1);
ANCONdB  = 10*log10(psdx2);

figure(5);
plot(freq1(1:10000),ANCOFFdB(1:10000),'--',...
    freq2(1:10000),ANCONdB(1:10000));

grid on
title('Power Spectral Density Before and After Cancellation')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')
legend('ANCOFF','ANCON')

