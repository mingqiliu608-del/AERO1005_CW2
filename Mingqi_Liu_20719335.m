% Mingqi LIU
% ssyml13@nottingham.edu.cn

%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]

% Clear any existing Arduino connection and establish a new one
clear a
a = arduino('COM4', 'Uno');
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

% (c) Create temperature/time plot
figure;
plot(time_data, temp_data, 'b-');
xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Capsule Temperature Over Time');
grid on;
saveas(gcf, 'temperature_plot.png');  % Save plot as image

% (d) Print formatted data to screen using sprintf
output = '';  % Initialize output as an empty string
output = [output, sprintf('\n')];  % blank line
output = [output, sprintf('Data logging initiated - %s\n', datestr(now, 'dd/mm/yyyy'))];
output = [output, sprintf('Location - Nottingham\n')];  % The format of the header
output = [output, sprintf('\n')];  

% Print temperature at each minute
for min = 0:10
    idx = min * 60 + 1;              % 0 sec → index 1, 60 sec → 61, ..., 600 sec → 601
    if idx > length(temp_data)
        idx = length(temp_data);     % safety in case of mismatched array length
    end
    output = [output, sprintf('Minute\t%d\tTemperature\t%.2f C\n', min, temp_data(idx))];
end

output = [output, sprintf('\n')];  % blank line
output = [output, sprintf('Max temp\t%.2f C\n', max_temp)];
output = [output, sprintf('Min temp\t%.2f C\n', min_temp)];
output = [output, sprintf('Average temp\t%.2f C\n', avg_temp)];  % Summary of quantities
output = [output, sprintf('\n')];
output = [output, sprintf('Data logging terminated\n')];

fprintf('%s', output);  % Display the complete string

% (e) Write same data to capsule_temperature.txt

fid = fopen('capsule_temperature.txt', 'w');
fprintf(fid, '%s', output);
fclose(fid);

% Verify the file by reading it back using fopen
fid = fopen('capsule_temperature.txt', 'r');
file_content = fread(fid, '*char')';
disp(file_content);
fclose(fid);

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
% (a) Flowchart included in Word

temp_monitor(a);

%% TASK 3 - ALGORITHMS - TEMPERATURE PREDICTION [30 MARKS]

% (a) Flowchart included in Word

temp_prediction(a);

%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]
% included in word 