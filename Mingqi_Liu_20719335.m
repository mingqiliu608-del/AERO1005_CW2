% Mingqi LIU
% ssyml13@nottingham.edu.cn

%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]

% Clear any existing Arduino connection and establish a new one
clear a
a = arduino('/dev/tty.usbserial-1140', 'Uno');
writeDigitalPin(a, 'D10', 1);

for i = 1:10
    writeDigitalPin(a, 'D10', 1);  % Turn LED on
    pause(0.5);                     % 0.5 seconds intervals
    writeDigitalPin(a, 'D10', 0);  % Turn LED off
    pause(0.5);                     % 0.5 seconds intervals
end