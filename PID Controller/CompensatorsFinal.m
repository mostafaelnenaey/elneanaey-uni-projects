% Define the open-loop transfer function G(s)
s = tf('s');
G = tf(1245.09,[1 77 5259 0 0]);

% Define the compensators
% Lead compensator (example values)
K_lead = 350; 
z_lead = 0.1; % Zero of the lead compensator
p_lead = 10; % Pole of the lead compensator
C_lead = K_lead * (s + z_lead)/(s + p_lead);

% Closed-loop transfer functions
T_lead = feedback(C_lead * G, 1);

% Time vector for simulation
t = 0:0.1:100;

% Inputs: step, ramp, and parabolic
step_input = ones(size(t));          % Step input
ramp_input = t;                      % Ramp input
parabola_input = t.^2;               % Parabolic input

% Simulate the system response for each input
[y_lead_step, t_out] = lsim(T_lead, step_input, t);
stepinfo(T_lead)

% Plot step input and output for Lead, Lag, Lead-Lag compensators
figure;
plot(t, step_input, 'r', 'DisplayName', 'Input (Step)');
hold on;
plot(t_out, y_lead_step, 'b', 'DisplayName', 'Output (Lead Compensator)');
xlabel('Time (s)');
ylabel('Amplitude');
title('Lead Compensator Response (Step Input)');
legend;
grid on;

% Now we plot for Ramp input
[y_lead_ramp, ~] = lsim(T_lead, ramp_input, t);

figure;
plot(t, ramp_input, 'r', 'DisplayName', 'Input (Ramp)');
hold on;
plot(t_out, y_lead_ramp, 'b', 'DisplayName', 'Output (Lead Compensator)');
xlabel('Time (s)');
ylabel('Amplitude');
title('Lead Compensator Response (Ramp Input)');
legend;
grid on;


% Plot for Parabolic input
[y_lead_parabola, ~] = lsim(T_lead, parabola_input, t);

figure;
plot(t, parabola_input, 'r', 'DisplayName', 'Input (Parabola)');
hold on;
plot(t_out, y_lead_parabola, 'b', 'DisplayName', 'Output (Lead Compensator)');
xlabel('Time (s)');
ylabel('Amplitude');
title('Lead Compensator Response (Parabola Input)');
legend;
grid on;

