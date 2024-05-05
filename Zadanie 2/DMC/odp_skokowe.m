clear all;
clc;
close all;

% stałe
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

Tp = 1 ; % czas próbkowania
Ts = 16000; % czas symulacji

%wartości początkowe
Fc_in(1:400) = 50;
Fh_in(1:400) = 27;

Fh_in(2:Ts) = 27;
Fc_in(2:Ts) = 50;

odpowiedzi = cell(2, 1);
odp_h = cell(1,2);
odp_T = cell(1,2);

i=1;

if i == 1
    Fc_in(2:Ts) = 75;
else
    Fh_in(2:Ts) = 41;
end

[h_d, T_d] = obiekt_dyskretny(Ts, h_pp, T_pp, Tp);

discrete_time = 1:Tp:Ts;
h_d = h_d(1:length(discrete_time));
T_d = T_d(1:length(discrete_time));


figure(1)
grid on
hold on
stairs(discrete_time,h_d,'color','blue');

figure(2)
grid on
hold on
stairs(discrete_time, T_d,'color','blue');

if i == 1
    h_skal = (h_d - h_d(1))/(Fc_in(2) - Fc_in(1));
    T_skal = (T_d - T_d(1))/(Fc_in(2) - Fc_in(1));
else
    h_skal = (h_d - h_d(1))/(Fh_in(2) - Fh_in(1));
    T_skal = (T_d - T_d(1))/(Fh_in(2) - Fh_in(1));
end

figure(3)
grid on
hold on
stairs(discrete_time, h_skal,'color','blue');

figure(4)
grid on
hold on
stairs(discrete_time, T_skal,'color','blue');


odpowiedzi_skok_Fc = [h_skal, T_skal];
% save odpowiedzi_skok_Fc.mat odpowiedzi_skok_Fc

