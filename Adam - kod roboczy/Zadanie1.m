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

Tp = 200; % czas próbkowania
Ts = 16000; % czas symulacji
steps = round(Ts/Tp);

%wartości początkowe
Fc_in(1:400) = 50;
Fh_in(1:400) = 27;

sterowanie = "Fh";
if sterowanie == "Fc"
    % skoki = [30 40 50 60 70];
    skoki = [44 46 48 50 52 54 56];
    % skoki  = [49 49.5 50 50.5 51]
else
    skoki = [24 25 26 27 28 29 30];
    % skoki = []
end


for i = skoki
    if sterowanie == "Fc"
        Fc_in(1:Ts) = i;
        Fh_in(1:Ts) = 27;
    else
        Fh_in(1:Ts) = i;
        Fc_in(1:Ts) = 50;
    end
    

    [h, T, t] = obiekt_ciagly(0, Ts, h_pp, T_pp);
    [h_zlin, T_zlin, t_zlin] = obiekt_ciagly(1, Ts, h_pp, T_pp);
    [h_d, T_d] = obiekt_dyskretny(steps, h_pp, T_pp, Tp);
    
    % % symulacja nieliniowego
    % figure(1)
    % hold on;
    % plot(t,h, 'color','red');
    % title('przebieg zmeinnej h dla skoków sterowania Fh');
    % grid on
    % legend('h');
    % 
    % figure(2);
    % hold on
    % plot(t,T, 'color','red');
    % title('przebieg zmeinnej T dla skoków sterowania Fh')
    % grid on
    % legend('T');
    
    % % porównanie liniowy nieliniowy
    % figure(3);
    % plot(t,h, 'color','red');
    % hold on;
    % plot(t_zlin,h_zlin, 'color','blue');
    % title('ciągłe');
    % legend('h', 'h-zlin');
    % grid on;
    % 
    % figure(4);
    % plot(t,T, 'color','red');
    % hold on;
    % plot(t_zlin,T_zlin, 'color','blue');
    % title('ciągłe');
    % legend('T', 'Tzlin');
    % grid on;


    %porównanie ciągły - dyskretny
    discrete_time = 1:Tp:Ts;
    h_d = h_d(1:length(discrete_time));
    T_d = T_d(1:length(discrete_time));

    figure(5)
    grid on
    hold on
    plot(t_zlin, h_zlin, 'color','red');
    stairs(discrete_time,h_d,'color','blue');
    title('porównanie ciągłe zlin - dyskretne zlin dla zmiennej h');
    legend('ciagly', 'dyskretny');

    figure(6)
    grid on
    hold on
    plot(t_zlin, T_zlin, 'color','red');
    stairs(discrete_time, T_d,'color','blue');
    title('porównanie ciągłe zlin - dyskretne zlin dla zmiennej T');
    legend('ciagly', 'dyskretny');

end

% %% porównanie ciągły zlinearyzowany

% figure(3);
% plot(t,h, 'color','red');
% hold on;
% plot(t_zlin,h_zlin, 'color','blue');
% title('ciągłe');
% legend('h', 'h-zlin');
% grid on;
% grid minor;
% 
% figure(4);
% plot(t,T, 'color','red');
% hold on;
% plot(t_zlin,T_zlin, 'color','blue');
% title('ciągłe');
% legend('T', 'Tzlin');
% grid on;
% grid minor;
