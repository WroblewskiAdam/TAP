% clear all;
% close all;
% clc;

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

Ts = 10000;
Tp = 10;
steps = round(Ts / Tp);
tau_c_steps = round(170 / Tp);
tau_h_steps = round(220 / Tp);

k_min = 1 + max(tau_c_steps, tau_h_steps);
k_max = steps;  

%% bez odsprzegania
% metoda roznic skonczonych
% p = [3.2419   -0.0009   -9.8430    10    0.0164    3];
p = [0.6426    0.0659   -4.9959   -5.0000    1.1975   -5.0000];


%% z odsprzeganiem
% p = [1.7309   -0.0031   -3.9315    7.8976   -0.0069    0.3743];
% p = [1.7276   -0.0030    8.1169    7.9134   -0.0070    0.3589];
% p = [3.4059   -0.0037   -9.8133    9.9798   -0.0084    4.9129];
% p = [3.4846   -0.0039  -19.7988   10.4474   -0.0088    4.6916];

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