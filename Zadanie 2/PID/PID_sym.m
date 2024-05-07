clear all;
close all;
clc;

global Fh_in Fc_in Th Tc Td alpha r tau_c tau_h Fd h_pp T_pp
r = 68;
alpha = 25;

% punkt pracy
Tc = 17;
Th = 75;
Td = 42;
Fc = 50;
Fh = 27;  
Fd = 15;
tau_c = 170;
tau_h = 220;
h_pp = 13.5424;
T_pp = 38.0978;
r = 68;
alpha = 25;

Ts = 8000;
Tp = 10;
steps = round(Ts / Tp);
tau_c_steps = round(170 / Tp);
tau_h_steps = round(220 / Tp);

k_min = 1 + max(tau_c_steps, tau_h_steps);
k_max = steps;  

% p = [-1.9994   -0.0850   -1.8661    1.8631    0.0037    1.6647];
p = [-2.9998   -0.0070   -2.6678    1.9996    0.0027    1.9287];

[e, T_out, h_out, T_zad, h_zad, Fc_in, Fh_in] = PID(p);

disp(e)

figure(1)
hold on
plot(T_out(k_min:k_max))
plot(T_zad(k_min:k_max))
plot(h_out(k_min:k_max))
plot(h_zad(k_min:k_max))
hold off
legend(["T_{out}", "Tzad", "h_{out}", "hzad"])

figure(2)
hold on
plot(Fc_in(k_min:k_max))
plot(Fh_in(k_min:k_max))
hold off
legend(["Fc_{in}", "Fh_{in}"])