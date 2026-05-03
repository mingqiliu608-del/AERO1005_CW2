function temp_monitor(a)
% TEMP_MONITOR Monitors temperature and controls LEDs in real-time.
% TEMP_MONITOR(a) reads temperature from sensor on A0 continuously,
% displays a live plot, and controls LEDs based on temperature:
% Green (D10): constant when 18-24 degC
% Yellow (D9): blinks 0.5s when below 18 degC
% Red (D7): blinks 0.25s when above 24 degC
% Press Ctrl+C to stop.

TC = 0.01;
V0 = 0.5;

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
    if temp < 18
        writeDigitalPin(a, 'D10', 0); % Close else LED
        writeDigitalPin(a, 'D7', 0);
        writeDigitalPin(a, 'D9', 1);
        pause(0.5);
        writeDigitalPin(a, 'D9', 0);
        pause(0.5);
    elseif temp > 24
        writeDigitalPin(a, 'D10', 0); % Close else LED
        writeDigitalPin(a, 'D9', 0);
        writeDigitalPin(a, 'D7', 1);
        pause(0.25);
        writeDigitalPin(a, 'D7', 0);
        pause(0.25);
    else
        writeDigitalPin(a, 'D9', 0);% Close else LED
        writeDigitalPin(a, 'D7', 0);
        writeDigitalPin(a, 'D10', 1);
        pause(1);
        writeDigitalPin(a, 'D10', 0);
    end
end
end
%Close all LED
writeDigitalPin(a, 'D9', 0);
writeDigitalPin(a, 'D7', 0);
writeDigitalPin(a, 'D10', 1);