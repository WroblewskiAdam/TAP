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
Ts = 8000; % czas symulacji

%wartości początkowe
Fc_in(1:400) = 50;
Fh_in(1:400) = 27;

sterowanie = "Fh";
if sterowanie == "Fc"
    skoki = [25 30 35 40 45 50 55 60 65 70 75];
    % skoki = [44 46 48 50 52 54 56];
    % skoki  = [49 49.5 50 50.5 51]
    % skoki = [40];
else
    % skoki = [21 23 25 27 29 31 33];
    skoki = [6 13 20 27 34 41 48];
    % skoki = [34];
end

% interval = 10000;
% Fc_in(1:400) = 50;
% Fc_in(401:interval) = 55;
% Fc_in(interval+1:2*interval) = 45;
% Fc_in(2*interval+1:3*interval) = 60;
% Fc_in(3*interval+1:4*interval) = 40;
% Fh_in(1:Ts) = 27;

% Fh_in(1:400) = 27;
% Fh_in(401:interval) = 32;
% Fh_in(interval+1:2*interval) = 22;
% Fh_in(2*interval+1:3*interval) = 37;
% Fh_in(3*interval+1:4*interval) = 17;
% Fc_in(1:Ts) = 50;


for i = skoki
    if sterowanie == "Fc"
        Fc_in(2:Ts) = i;
        Fh_in(2:Ts) = 27;
    else
        Fh_in(2:Ts) = i;
        Fc_in(2:Ts) = 50;
    end

    [h, T, t] = obiekt_ciagly(0, Ts, h_pp, T_pp);
    [h_zlin, T_zlin, t_zlin] = obiekt_ciagly(1, Ts, h_pp, T_pp);
    [h_d, T_d] = obiekt_dyskretny(Ts, h_pp, T_pp, Tp);
    
    % % porównanie liniowy nieliniowy
    % figure(3);
    % plot(t,h, 'color','red');
    % hold on;
    % plot(t_zlin,h_zlin, 'color','blue');
    % title('Porównanie modelu liniowego i nieliniowego, zmienna h, sterowanie Fh');
    % legend('h', 'h-zlin','Location','northwest');
    % grid on;
    % % grid minor;
    % % print("rysunki/nielin-lin-h-skoki-Fc-25-5-75.png","-dpng","-r800")
    % print("rysunki/nielin-lin-h-skoki-Fh-6-7-48.png","-dpng","-r800")
    % 
    % figure(4);
    % plot(t,T, 'color','red');
    % hold on;
    % plot(t_zlin,T_zlin, 'color','blue');
    % title('Porównanie modelu liniowego i nieliniowego, zmienna T, sterowanie Fh');
    % legend('T', 'T-zlin','Location','northwest');
    % grid on;
    % % grid minor
    % % print("rysunki/nielin-lin-T-skoki-Fc-25-5-75.png","-dpng","-r800")
    % print("rysunki/nielin-lin-T-skoki-Fh-6-7-48.png","-dpng","-r800")



    discrete_time = 1:Tp:Ts;
    h_d = h_d(1:length(discrete_time));
    T_d = T_d(1:length(discrete_time));

    figure(5)
    grid on
    hold on
    plot(t_zlin, h_zlin, 'color','red');
    stairs(discrete_time,h_d,'color','blue');
    title('Porównanie modeli liniowych ciągłego i dyskretnego dla zmiennej h', 'skoki sterowania Fh, Tp = 10');
    legend('ciagly', 'dyskretny');
    print("rysunki/dyskretny-h-skoki-Fh.png","-dpng","-r400")


    figure(6)
    grid on
    hold on
    plot(t_zlin, T_zlin, 'color','red');
    stairs(discrete_time, T_d,'color','blue');
    title('Porównanie modeli liniowych ciągłego i dyskretnego dla zmiennej T','skoki sterowania Fh, Tp = 10');
    legend('ciagly', 'dyskretny');
    print("rysunki/dyskretny-T-skoki-Fh.png","-dpng","-r400")
end

% %% Symulacja nieliniowego - punkt pracy 
% figure(1)
% subplot(2,1,1)
% hold on;
% plot(t,h, 'color','red');
% axis([0 8000 13 14])
% title('Punkt pracy h');
% grid on
% legend('h');
% subplot(2,1,2)
% hold on
% plot(t,T, 'color','red');
% title('Punkt pracy T')
% grid on
% legend('T');
% axis([0 8000 38 38.2])
% print("rysunki/pkt_pracy.png","-dpng","-r400")
% 
% %% Symulacja nieliniowego - skoki sterowania Fc, Fh
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
% 
% 
% figure(2)
% subplot(2,1,1)
% plot(t,Fc_in, 'Color','blue');
% title('Sterowanie Fc');
% legend('Fc');
% grid on;
% subplot(2,1,2)
% plot(t,Fh_in, 'color','blue');
% title('Sterowanie Fh');
% grid on
% legend('Fh');
% print("rysunki/skoki sterowania Fh - sterowanie.png","-dpng","-r400")
% 

% %% porównanie ciągły - dyskretny
% discrete_time = 1:Tp:Ts;
% h_d = h_d(1:length(discrete_time));
% T_d = T_d(1:length(discrete_time));
% 
% figure(5)
% grid on
% hold on
% plot(t_zlin, h_zlin, 'color','red');
% stairs(discrete_time,h_d,'color','blue');
% title('porównanie ciągłe zlin - dyskretne zlin dla zmiennej h');
% legend('ciagly', 'dyskretny');
% 
% figure(6)
% grid on
% hold on
% plot(t_zlin, T_zlin, 'color','red');
% stairs(discrete_time, T_d,'color','blue');
% title('porównanie ciągłe zlin - dyskretne zlin dla zmiennej T');
% legend('ciagly', 'dyskretny');


    