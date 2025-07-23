% N-segment injector with Tsu-Esaki current calculation

clear all;
clf;

% Constants and parameters
a = 1e-9;
nbarrier = 2;
bx = 1 * a;
wx = 1 * a;
V0 = 0.5;
m0 = 9.109382e-31;
meff_B = 1;
meff_W = 1;
sample_spacing = 0.1e-9;
hbar = 1.05457159e-34;
echarge = 1.6021764e-19;

% Potential structure
N = (2 * nbarrier) + 1;
for j = 1:2:(2 * nbarrier)
    dL(j) = wx;   V(j) = 0;
    dL(j + 1) = bx; V(j + 1) = V0;
    m(j) = meff_W * m0;
    m(j + 1) = meff_B * m0;
end
dL(N) = wx; V(N) = 0;
m(N) = meff_W * m0;

% Interpolate for finer sampling
N_new = nbarrier * floor(bx / sample_spacing) + (nbarrier + 1) * floor(wx / sample_spacing);
dL_new = zeros(1, N_new);
V_new = zeros(1, N_new);
index = 1;
space_buffer = dL(1);

for j = 1:N_new
    space_index = sample_spacing * j;
    if space_index > space_buffer
        index = index + 1;
        space_buffer = space_buffer + dL(index);
    end
    dL_new(j) = space_index;
    V_new(j) = V(index);
end

m = ones(1, N_new) * meff_W * m0;

% Tsu-Esaki setup
Emin = pi * 1e-6;
Emax = 0.005; % Fermi level
nEpoints = 150; 
E = linspace(Emin, Emax, nEpoints);
dE = (Emax - Emin) / nEpoints;

voltages = linspace(0, 0.8, 100);
current = zeros(size(voltages));

for v = 1:length(voltages)
    Vext = voltages(v);

    V = V_new;
    dL = dL_new;
    N = N_new;

    % Apply external voltage slope
    startPoint = ((wx / sample_spacing) + 1) * sample_spacing;
    endPoint = (N_new - (wx / sample_spacing)) * sample_spacing;
    slope = -Vext / (endPoint - startPoint);

    for j = (wx / sample_spacing) + 2 : (N_new - (wx / sample_spacing))
        V(j) = V_new(j) + slope * (dL(j) - dL((wx / sample_spacing) + 2));
    end

    for j = (N_new - (wx / sample_spacing)) + 1 : N_new
        V(j) = -Vext;
    end

    % Calculate transmission for all E at this Vext
    Trans = zeros(size(E));
    for j = 1:length(E)
        Ej = E(j);
        bigP = eye(2);
        for i = 1:N
            k(i) = sqrt(2 * echarge * m(i) * (Ej - V(i))) / hbar;
        end
        for n = 1:N - 1
            p11 = 0.5 * (1 + m(n) * k(n + 1) / (m(n + 1) * k(n))) * exp(-1i * k(n) * dL(n));
            p12 = 0.5 * (1 - m(n) * k(n + 1) / (m(n + 1) * k(n))) * exp(-1i * k(n) * dL(n));
            p21 = 0.5 * (1 - m(n) * k(n + 1) / (m(n + 1) * k(n))) * exp(1i * k(n) * dL(n));
            p22 = 0.5 * (1 + m(n) * k(n + 1) / (m(n + 1) * k(n))) * exp(1i * k(n) * dL(n));
            p = [p11, p12; p21, p22];
            bigP = bigP * p;
        end
        Trans(j) = abs(1 / bigP(1,1))^2;
    end

    % Apply simplified Tsu-Esaki integral
    integrand = Trans .* sqrt(E);
    current(v) = sum(integrand) * dE;
end

% Plot I-V diagram
figure;
plot(voltages, current, 'r', 'LineWidth', 1.5);
xlabel('External Voltage (V)');
ylabel('Transmission Current (arb. units)');
title('I-V diagram using simplified Tsu-Esaki formula');
grid on;

% Optional: plot potential and transmission for one Vext
% Re-run last Vext for transmission plotting
figure;

subplot(1,2,1);
plot(dL, V, 'b')
xlabel('Position (m)');
ylabel('Potential Energy (eV)');
title('Potential Profile');

subplot(1,2,2);
plot(Trans, E, 'b');
xlabel('Transmission Coefficient');
ylabel('Energy (eV)');
title('Transmission vs Energy');
