% Sebastian Ignacio, egysi3@nottingham.ac.uk
% 20682601

%% Part II: Data Analysis, Natural frequency

% Gathering the peaks and troughs from the data
time = out.tout;
v_tas = out.S_Airspeed.signals.values;

pks = [];      % To store peak values
max_locs = []; % To store peak times
ths = [];      % To store valley values
min_locs = []; % To store valley times

for i = 2:length(v_tas)-1
    % FIND PEAKS: Current point is higher than neighbours
    if v_tas(i) > v_tas(i-1) && v_tas(i) > v_tas(i+1)
        pks = [pks, v_tas(i)];
        max_locs = [max_locs, time(i)];
    end
    
    % FIND VALLEYS: Current point is lower than neighbours
    if v_tas(i) < v_tas(i-1) && v_tas(i) < v_tas(i+1)
        ths = [ths, v_tas(i)];
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
delta = -log((v3-v2)/(v2-v1));
zeta = delta/sqrt(3.14^2 - delta^2);

omega_n = (2*3.14)/(T*sqrt(1-zeta^2));
fprintf('---------------------------------\n');
fprintf('Period (T):        %.4f s\n', T);
fprintf('Damping (zeta):    %.4f\n', zeta);
fprintf('Nat. Freq (wn):    %.4f rad/s\n', omega_n);
fprintf('---------------------------------\n');