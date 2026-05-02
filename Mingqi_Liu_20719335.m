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

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
% (a) Temperature sensor connected to A0
% Temperature coefficient (TC) = 10 mV/degC = 0.01 V/degC
% Zero-degree voltage (V0) = 500 mV = 0.5 V
% Formula: Temperature = (Voltage - V0) / TC

 v = readVoltage(a, 'A0');
 temp = (v - 0.5) / 0.01;
 fprintf('Voltage: %.3f V, Temperature: %.1f C\n', v, temp);