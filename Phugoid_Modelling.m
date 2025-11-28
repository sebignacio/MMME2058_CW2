% Sebastian Ignacio, egysi3@nottingham.ac.uk
% 20682601

%% Part II: Data Analysis, Natural frequency

% Gathering the peaks and troughs from the data
time_m = out.tout;
v_tas_a = out.S_Airspeed.signals.values;
gamma = out.S_Airspeed.signals.values;

% --- FIND PEAKS AND TROUGHS ---
pks = []; max_locs = [];
ths = []; min_locs = [];

% Check if the very first point is a peak (Initial Condition case)
if v_tas_a(1) > v_tas_a(2)
    pks = [pks, v_tas_a(1)];
    max_locs = [max_locs, time_m(1)];
end

% Loop for remaining peaks
for i = 2:length(v_tas_a)-1
    % Find Peak
    if v_tas_a(i) > v_tas_a(i-1) && v_tas_a(i) > v_tas_a(i+1)
        pks = [pks, v_tas_a(i)];
        max_locs = [max_locs, time_m(i)];
    end
    % Find Trough
    if v_tas_a(i) < v_tas_a(i-1) && v_tas_a(i) < v_tas_a(i+1)
        ths = [ths, v_tas_a(i)];
        min_locs = [min_locs, time_m(i)];
    end
end

% --- CALCULATE PARAMETERS ---
% Ensure we have at least 2 peaks and 1 trough found
if length(pks) >= 2 && length(ths) >= 1
    v1 = pks(1); t1 = max_locs(1);
    v2 = ths(1); % Trough
    v3 = pks(2); t3 = max_locs(2);

    % Period
    T = t3 - t1;

    % Damping & Frequency (Using 'pi' for precision)
    delta = -log(abs((v3 - v2) / (v2 - v1)));
    zeta = delta / sqrt(pi^2 - delta^2);
    omega_n = (2 * pi) / (T * sqrt(1 - zeta^2));

    % Output
    fprintf('Period (T):        %.4f s\n', T);
    fprintf('Damping (zeta):    %.4f\n', zeta);
    fprintf('Nat. Freq (wn):    %.4f rad/s\n', omega_n);
end
% Graphing
figure('Name', 'Phugoid Time History: Increased Airspeed');

subplot(2,1,1);
plot(time_m,v_tas_a);
grid on;
title('Phugoid Response: Airspeed');
ylabel('Airspeed(m/s)');
xlabel('Time(s)');

subplot(2,1,2);
plot(time_m,gamma);
grid on;
title('Phugoid Response: Flight Path Angle');
ylabel('Flight Path Angle(rad)');
xlabel('Time(s)');

%% Part II: Data Analysis, Analysing provided data

% Extracting data
time_m = out.tout;
v_tas_m = out.Airspeed.Data;

pks = [];
max_locs = [];
ths = [];
min_locs = [];

% Finding peaks and troughs
for i = 2:length(v_tas_m)-1;
    current_val = v_tas_m(i);
    % Find Peak: Current point is higher than neighbours
    if current_val > v_tas_m(i-1) && current_val > v_tas_m(i+1)
        pks = [pks, current_val];
        max_locs = [max_locs, time_m(i)];
    end
    
    % Find Troughs: Current point is lower than neighbours
    if current_val < v_tas_m(i-1) && current_val < v_tas_m(i+1)
        ths = [ths, current_val];
        min_locs = [min_locs, time_m(i)];
    end
end

peak_labels = repmat("Peak", length(pks), 1);
trough_labels = repmat("Trough", length(ths), 1);

% 2. Combine and Force to Columns using (:)
% The (:) ensures these are vertical columns, fixing the row count error.
locs_col = [max_locs, min_locs]';   % Transpose to column
vals_col = [pks, ths]';             % Transpose to column
types_col = [peak_labels; trough_labels];

% 3. Create Temporary Table and Sort
TempTable = table(locs_col, vals_col, types_col, ...
    'VariableNames', {'CumulativeTime', 'Velocity', 'Type'});

% Sort by time so Peaks and Troughs are in correct order
TempTable = sortrows(TempTable, 'CumulativeTime');

% 4. Calculate Time Intervals
% Calculate difference between current event and previous event
time_intervals = [TempTable.CumulativeTime(1); diff(TempTable.CumulativeTime)];

% 5. Create Final Formatted Table
FinalTable = table(time_intervals, TempTable.Velocity, TempTable.Type, ...
    'VariableNames', {'Time_Interval_s', 'Velocity_kts', 'Type'});

% Display
disp(FinalTable);