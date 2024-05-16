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
% p = [-2.9027    0.0001   -9.9884    6.0960   -0.0016    9.9860];
% p = [2.8733   -0.0008   -0.0680   -1.9636    0.0001   -4.9260];
% z korekta sterowania
p = [-1.1578    0.0009    1.4876    9.9967    0.0098   -9.9912];



%% z odsprzeganiem
% p = [-1.8399   -0.0006   -4.9576    4.9826   -0.0053    4.9443];
p = [-1.8290   -0.0006   -4.9999    7.5000   -0.0053    4.9999];
% p = [1.2418   -0.0004    9.9576    2.4619   -0.0062   -9.9973];

% z korektą
% p = [-1.3799   -0.0012    6.8996    2.4393   -0.0040   -9.9961];
% p = [2.2434   -0.0027   -4.9978    1.9387   -0.0041   -4.9755];

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
ylim([10, 16])


subplot(2,1,2); 
hold on
grid on;
plot(T_out(k_min:k_max))
plot(T_zad(k_min:k_max))
title('Wyjście T');
xlabel('k');
ylabel('wyjście'); 
legend(["T", "T_{zad}"]) 
ylim([30, 45])

print("rysunki\PID_wyjscia_odsprz","-dpng","-r800")

figure(2); 
subplot(4,1,1); 
plot(Fh_in(k_min:k_max));
title('Fh');
ylabel('Sterowanie Fh');
grid on;

subplot(4,1,2); 
plot(Fc_in(k_min:k_max));
title('Fc'); % 
ylabel('Sterowanie Fc'); 
grid on; 

subplot(4,1,3); 
plot(Fd_in(k_min:k_max));
title('Fd');
ylabel('Zakłócenie Fd');
grid on;

subplot(4,1,4); 
plot(Td_in(k_min:k_max));
title('Td');
ylabel('Zakłócenie Td');
xlabel('k'); 
grid on;

print("rysunki\PID_ster_odsprz","-dpng","-r800")