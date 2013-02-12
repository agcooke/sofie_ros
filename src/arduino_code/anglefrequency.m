function [time, angle, f, Y] = anglefrequency(datafile)
% angleresample converts raw steering angle data to degrees, resampels
% to the given frequency and plots the result.
% acquire data with: rostopic echo -p /angle > filename.csv
%% usage: [time, angle, f, Y] = anglefrequency(datafile)


data = csvread(datafile, 2, 0);                         % read datafile
data(:,1) = data(:,1)./864000000-data(1,1)./864000000;  % convert linux timestamp to sec
time = data(:,1);                                   % time array
blindspot = 5;                                          % degrees blindspot in sensor
angle = data(:,2)./1024.*(360-blindspot)+blindspot./2; % convert bitvalue into degrees

% detect high gap positions
gapup = find((angle(2:end)-angle(1:end-1))<-250); gapup = gapup+1;
gapdown = find((angle(2:end)-angle(1:end-1))>250); gapdown = gapdown+1;

% create array of multiples of 360 to add to the angle array
additive = zeros(size(angle));
for i=1:length(gapup)
    additive(gapup(i):end) = additive(gapup(i):end)+360;
end
for i=1:length(gapdown)
    additive(gapdown(i):end) = additive(gapdown(i):end)-360;
end

% add the additive to the raw angle array to create total angle
angle = angle+additive;


% plot angledata to create visual check of the acquired data
figure(1)
subplot(2,1,1)
plot(time,data(:,2))
xlabel('time [s]'); ylabel('potentiometer angle [deg]');
subplot(2,1,2)
plot(time,angle)
xlabel('time [s]'); ylabel('total angle [deg]');

L = length(angle);
Fs = L/time(end);
T = 1/Fs;
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(angle,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
figure(2)
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

end