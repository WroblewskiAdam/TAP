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
k_max = steps + 22;  

%% bez odsprzegania
% metoda roznic skonczonych
% p = [-3.6741    0.0002   -4.9999    5.0000   -0.0014    4.9999];


%% z odsprzeganiem
% p = [-1.8399   -0.0006   -4.9576    4.9826   -0.0053    4.9443];
% p = [-1.8290   -0.0006   -4.9999    5.0000   -0.0053    4.9999];

[e, T_out, h_out, T_zad, h_zad, Fc_in, Fh_in, Fd_in, Td_in] = PID(p);

disp(e)

figure(1)
subplot(2,1,1); 
hold on
grid on;
plot(h_out(k_min:k_max))
plot(h_zad(k_min:k_max))
title('Wyjście h');
xlabel('k');
ylabel('wyjście'); 
legend(["h", "h_{zad}"]) 


subplot(2,1,2); 
hold on
grid on;
plot(T_out(k_min:k_max))
plot(T_zad(k_min:k_max))
title('Wyjście T');
xlabel('k');
ylabel('wyjście'); 
legend(["T", "T_{zad}"]) 

figure(2); 
subplot(4,1,1); 
plot(Fc_in(k_min:k_max));
title('Fc'); % 
ylabel('Sterowanie Fc'); 
grid on; 


subplot(4,1,2); 
plot(Fh_in(k_min:k_max));
title('Fh');
ylabel('Sterowanie Fh');
grid on;

subplot(4,1,3); 
plot(Fd_in(k_min:k_max));
title('Fd');
ylabel('Zakłócenie Fd');
grid on;

subplot(4,1,4); % Czwarty subwykres
plot(Td_in(k_min:k_max));
title('Td');
ylabel('Zakłócenie Td');
xlabel('k'); % Etykieta osi X tylko dla ostatniego wykresu
grid on;