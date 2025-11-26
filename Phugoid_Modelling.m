% Sebastian Ignacio, egysi3@nottingham.ac.uk
% 20682601

%% Part II: Data Analysis, Natural frequency

% Gathering the peaks and troughs from the data
time = out.tout;
v_tas_a = out.S_Airspeed.signals.values;
gamma = out.S_FlightPathAngle.signals.values;

pks = [];      % To store peak values
max_locs = []; % To store peak times
ths = [];      % To store valley values
min_locs = []; % To store valley times

for i = 2:length(v_tas_a)-1
    % Find Peak: Current point is higher than neighbours
    if v_tas_a(i) > v_tas_a(i-1) && v_tas_a(i) > v_tas_a(i+1)
        pks = [pks, v_tas_a(i)];
        max_locs = [max_locs, time(i)];
    end
    
    % Find Troughs: Current point is lower than neighbours
    if v_tas_a(i) < v_tas_a(i-1) && v_tas_a(i) < v_tas_a(i+1)
        ths = [ths, v_tas_a(i)];
        min_locs = [min_locs, time(i)];
    end
end
v1 = pks(1);
t1 = max_locs(1);
v2 = ths(1);
t2 = min_locs(1);
v3 = pks(2);
t3 = max_locs(2);

% Time period
T = t3 - t1;

% Calculating damping and frequency
delta = -log(abs((v3-v2)/(v2-v1)));
zeta = delta/sqrt(3.14^2 - delta^2);

omega_n = (2*3.14)/(T*sqrt(1-zeta^2));

fprintf('Period (T):        %.4f s\n', T);
fprintf('Damping (zeta):    %.4f\n', zeta);
fprintf('Nat. Freq (wn):    %.4f rad/s\n', omega_n);

% Graphing
figure('Name', 'Phugoid Time History: Increased Airspeed');

subplot(2,1,1);
plot(time,v_tas_a);
grid on;
title('Phugoid Response: Airspeed');
ylabel('Airspeed(m/s)');
xlabel('Time(s)');

subplot(2,1,2);
plot(time,gamma);
grid on;
title('Phugoid Response: Flight Path Angle');
ylabel('Flight Path Angle(rad)');
xlabel('Time(s)');

