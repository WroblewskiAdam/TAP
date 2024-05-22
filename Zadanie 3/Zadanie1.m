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

Tp = 10 ; % czas próbkowania
Ts = 10000; % czas symulacji

%wartości początkowe
Fc_in(1:221) = 50;
Fh_in(1:221) = 27;

sterowanie = "Fh";
if sterowanie == "Fc"
    % skoki = [25 30 35 40 45 50 55 60 65 70 75];
    % skoki = [44 46 48 50 52 54 56];
    % skoki  = [49 49.5 50 50.5 51]
    skoki = [40];
else
    % skoki = [21 23 25 27 29 31 33];
    % skoki = [6 13 20 27 34 41 48];
    skoki = [30];
end

for i = skoki
    if sterowanie == "Fc"
        Fc_in(2:Ts) = i;
        Fh_in(2:Ts) = 27;
    else
        Fh_in(2:Ts) = i;
        Fc_in(2:Ts) = 50;
    end

     [h, T, t] = obiekt_ciagly(0, Ts, h_pp, T_pp);
%     [h_zlin, T_zlin, t_zlin] = obiekt_ciagly(1, Ts, h_pp, T_pp);
%     [h_d, T_d] = obiekt_dyskretny(Ts, h_pp, T_pp, Tp);
%     
    
end

h2 = h(1:Tp:end);
T2 = T(1:Tp:end);


[h_lab, T_lab] = lab_func();

figure(1)
plot(h2, 'color','red');
hold on
plot(h_lab, 'color','blue');


figure(2)
plot(t,T);




% 
% figure(1)
% subplot(2,1,1)
% hold on;
% plot(t,h, 'color','red');
% title('przebieg zmeinnej h dla skoków sterowania Fh');
% grid on
% legend('h');
% subplot(2,1,2)
% hold on
% plot(t,T, 'color','red');
% title('przebieg zmeinnej T dla skoków sterowania Fh')
% grid on
% legend('T');
% print("rysunki/skoki sterowania Fh - przebiegi.png","-dpng","-r400")

