function [time, angle] = angleresample(datafile, sf)
% angleresample converts raw steering angle data to degrees, resampels
% to the given frequency and plots the result.


data = csvread(datafile, 2, 0);                         % read datafile
data(:,1) = data(:,1)./864000000-data(1,1)./864000000;  % convert linux timestamp to sec
time_old = data(:,1);                                   % time array
blindspot = 5;                                          % degrees blindspot in sensor
angle_old = data(:,2)./1024.*(360-blindspot)+blindspot./2; % convert bitvalue into degrees

% detect high gap positions
gapup = find((angle_old(2:end)-angle_old(1:end-1))<-250); gapup = gapup+1;
gapdown = find((angle_old(2:end)-angle_old(1:end-1))>250); gapdown = gapdown+1;

% create array of multiples of 360 to add to the angle array
additive = zeros(size(angle_old));
for i=1:length(gapup)
    additive(gapup(i):end) = additive(gapup(i):end)+360;
end
for i=1:length(gapdown)
    additive(gapdown(i):end) = additive(gapdown(i):end)-360;
end

% add the additive to the raw angle array to create total angle
angle_old = angle_old+additive;


% plot angledata to create visual check of the acquired data
figure(1)
subplot(2,1,1)
plot(time_old,data(:,2))
subplot(2,1,2)
plot(time_old,angle_old)

% interpolate acquired data to the requested frequency
time = time_old(1):(1/sf):time_old(end);
angle = interp1(time_old,angle_old,time);

end