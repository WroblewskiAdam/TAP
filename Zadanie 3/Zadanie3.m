clear all;
clc;
close all;

% stałe
global Fh_in Fc_in Th Tc Td alpha r tau_c tau_h Fd h_pp T_pp

% punkt pracy
Tc = 17;
Th = 75;
Td = 42;
Fd = 15;
tau_c = 170;
tau_h = 220;
h_pp = 13.5424;
T_pp = 38.0978;
r = 68;
alpha = 25;

Tp = 10 ; % czas próbkowania
Ts = 10000; % czas symulacji

Fh_in(1:Ts) = 27;
Fc_in(1:Ts) = 50;

Fh_in(tau_h:Ts) = 30;
Fc_in(tau_c:Ts) = 50;

[h, T, t] = obiekt_ciagly(0, Ts, h_pp, T_pp);

h = h(1:Tp:end);
T = T(1:Tp:end);

% czy dekompozycja pod ovation?
decomp = 1;
[h_lab, T_lab] = lab_func(decomp);

figure(1)
plot(h, 'color','red');
title("Wyjście h")
hold on
stairs(h_lab, 'color','blue');
legend(["ciągły", "dyskretny"]);
xlabel("k")
ylabel("h")


figure(2)
plot(T, 'Color', 'red');
title("Wyjście T")
xlabel("k")
ylabel("T")
hold on
stairs(T_lab, 'Color', 'blue');
legend(["ciągły", "dyskretny"]);

