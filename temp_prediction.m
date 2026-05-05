function temp_prediction(a)
% TEMP_PREDICTION  Predicts temperature and warns for fast changes.
% temp_prediction(a) reads temperature from A0, computes
% smoothed rate of change, predicts the temperature in 5 minutes, and
% indicated in LEDs: steady green for stable, red if heating >4°C/min,
% yellow if cooling >4°C/min. 
% Press Ctrl+C to stop.

TC = 0.01; V0 = 0.5;
rate_limit = 4/60; % °C/s  (4°C/min)
i = 0;

% buffers for smoothing
timeBuf = []; tempBuf = [];
Nbuf = 60;   % window size (seconds)
sampleTimer = tic;
startTime = tic;

% Main loop
try % Try-catch for Ctrl+C to stop the live plot 
    while true
        if  toc(sampleTimer) >= 1
            sampleTimer = tic;
            voltage = readVoltage(a, 'A0');
            T = (voltage - V0) / TC;
            % Reject physically impossible readings (noise or loose connection)
            if T < -40 || T > 100
                fprintf('Bad reading ignored: V=%.2f, T=%.1f\n', voltage, T);
                if ~isempty(tempBuf)
                    T = tempBuf(end);        % keep last good temperature
                else
                    T = 20;                  % safe default before any data
                end
            end
            % Update buffer
            i = i + 1;
            t_now = toc(startTime);
            timeBuf(i) = t_now;
            tempBuf(i) = T;
            if length(timeBuf) > Nbuf
                timeBuf(1) = [];
                tempBuf(1) = [];
            end
            
            % Compute rate by linear fit over buffer
            if length(timeBuf) >= 2
                p = polyfit(timeBuf - timeBuf(1), tempBuf, 1);
                dTdt = p(1);  % dTdt is the slope of the linear fit to the recent temperature history
            else
                dTdt = 0;
            end
            
            Tpred = T + dTdt * 300; % Convert min to sec
            
            fprintf('Current: %.2f C, Rate: %+.4f C/s, Predicted in 5 min: %.2f C\n', ...
                T, dTdt, Tpred);
            
            % LED control
            writeDigitalPin(a, 'D10', 0); 
            writeDigitalPin(a, 'D9', 0); 
            writeDigitalPin(a, 'D7', 0); % Close all LEDs
            
            if dTdt > rate_limit % Heating fast, red ON
                writeDigitalPin(a, 'D7', 1);
            elseif dTdt < -rate_limit % Cooling fast, yellow ON
                writeDigitalPin(a, 'D9', 1);
            else % Stable, steady green
                writeDigitalPin(a, 'D10', 1);
            end
        end
        pause(0.05);
    end
catch
    % Turn off all LEDs and exit
    writeDigitalPin(a, 'D10', 0); 
    writeDigitalPin(a, 'D9', 0); 
    writeDigitalPin(a, 'D7', 0);
    disp('Monitoring stopped. All LEDs turned off.');
end
end