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
% Temperature coefficient (TC) = 10 mV/deg = 0.01 V/deg
% Zero-degree voltage (V0) = 500 mV = 0.5 V
% Temperature = (Voltage - V0) / TC

 v = readVoltage(a, 'A0');
 temp = (v - 0.5) / 0.01;
 fprintf('Voltage: %.3f V, Temperature: %.1f C\n', v, temp);

 % (b) Acquire temperature data for 10 minutes

duration = 600;          % Acquisition time (s)
TC = 0.01;               % Temperature coefficient (V/deg)
V0 = 0.5;                % Voltage at 0 deg (V)

% Initialise arrays to store data

time_data = zeros(1, duration);
voltage_data = zeros(1, duration);
temp_data = zeros(1, duration);

% Read temperature every 1 second for 10 minutes

for i = 1:duration
    voltage_data(i) = readVoltage(a, 'A0');        % Read voltage from sensor
    temp_data(i) = (voltage_data(i) - V0) / TC;    
    time_data(i) = i - 1;                          
    pause(1);                                      % 1 second intervals
end

% Calculate three quantities

min_temp = min(temp_data);
max_temp = max(temp_data);
avg_temp = mean(temp_data);