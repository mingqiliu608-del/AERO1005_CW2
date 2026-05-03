function temp_monitor(a)
% TEMP_MONITOR Monitors temperature and controls LEDs in real-time.
% TEMP_MONITOR(a) reads temperature from sensor on A0 continuously,
% displays a live plot, and controls LEDs based on temperature:
% Green (D10): constant when 18-24 deg
% Yellow (D9): blinks 0.5s when below 18 deg
% Red (D7): blinks 0.25s when above 24 deg
% Press Ctrl+C to stop the live plot.

TC = 0.01;
V0 = 0.5;
GREEN  = 'D10';
YELLOW = 'D9';
RED    = 'D7';

% Set up live plot
figure;
hPlot = plot(NaN, NaN, 'b-');
xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Live Temperature Monitor');
grid on;

time_data = [];
temp_data = [];
i = 0;
startTime = tic;

% Main loop
try % Try-catch for Ctrl+C to stop the live plot 
while true
    i = i + 1;
    voltage = readVoltage(a, 'A0');
    temp = (voltage - V0) / TC;
    time_data(i) = toc(startTime);
    temp_data(i) = temp;

    % Update live plot
    set(hPlot, 'XData', time_data, 'YData', temp_data);
    xlim([0, max(time_data(end), 10)]);
    ylim([min(temp_data)-2, max(temp_data)+2]);
    drawnow;

    % LED control
    if temp < 18 % Low teamperature: Blink yellow, Red/green OFF
        writeDigitalPin(a, 'D10', 0); % Close else LED
        writeDigitalPin(a, 'D7', 0);
        writeDigitalPin(a, 'D9', 1);
        pause(0.5);
        writeDigitalPin(a, 'D9', 0);
        pause(0.5);
    elseif temp > 24 % High temperature: Blink red, yellow/green OFF
        writeDigitalPin(a, 'D10', 0); % Close else LED
        writeDigitalPin(a, 'D9', 0);
        writeDigitalPin(a, 'D7', 1);
        pause(0.25);
        writeDigitalPin(a, 'D7', 0);
        pause(0.25);
    else % 18 <= temp <= 24 green ON, yellow/red OFF
        writeDigitalPin(a, 'D9', 0);% Close else LED
        writeDigitalPin(a, 'D7', 0);
        writeDigitalPin(a, 'D10', 1);
        pause(1);
    end
end
catch
    % Turn off all LEDs and exit
    writeDigitalPin(a, GREEN,  0);
    writeDigitalPin(a, YELLOW, 0);
    writeDigitalPin(a, RED,    0);
    disp('Monitoring stopped. All LEDs turned off.');
end
end
