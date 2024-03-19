clear all;
clc;
% close all;

% stałe
global Fh_in Fc_in Th Tc Td alpha r tau_c tau_h Fd h_pp T_pp
r = 68;
alpha = 25;

% punkt pracy
Tc = 17;
Th = 75;Td = 42;
Fc = 50;
Fh = 27;  
Fd = 15;
tau_c = 170;
tau_h = 220;
h_pp = 13.5424;
T_pp = 38.0978;
Tp = 20;

% [6 13 20 27 34 41 48]
% [21 23 25 27 29 31 33]
% [24 25 26 27 28 29 30]
for i = [24 25 26 27 28 29 30]
    Fc_in(1:400) = 50;
    Fh_in(1:400) = 27;
    
    % skok wartości
    Ts = 14000;
    Fc_in(401:Ts) = 50;
    Fh_in(401:Ts) = i;
    
    
    [h, T, t] = obiekt_ciagly(0, Ts, h_pp, T_pp);
    [h_zlin, T_zlin, t_zlin] = obiekt_ciagly(1, Ts, h_pp, T_pp);
    % [h_d, T_d] = obiekt_dyskretny(Ts/Tp, h_pp, T_pp, Tp);
    % 
    % % h = (h - h(1))/7;
    % figure(11)
    % grid on
    % plot(t,h, 'color','red');
    % title('h ciągłe');
    % legend('h');
    % 
    % % T = (T - T(1))/7;
    % figure(22)
    % grid on
    % plot(t,T, 'color','red');
    % title('T ciągłe');
    % legend('T');


    % wykresy ciagly - zline
    figure(1);
    plot(t,h, 'color','red');
    hold on;
    plot(t_zlin,h_zlin, 'color','blue');
    title('ciągłe');
    legend('h', 'h-zlin');
    grid on;
    grid minor;

    % figure(2);
    % plot(t,T, 'color','red');
    % hold on;
    % plot(t_zlin,T_zlin, 'color','blue');
    % title('ciągłe');
    % legend('T', 'Tzlin');
    % grid on;
    % grid minor;

    % %porównanie ciągły - dyskretny
    % discrete_time = 1:Tp:Ts;
    % h_d = h_d(1:length(discrete_time));
    % T_d = T_d(1:length(discrete_time));
    % figure(3)
    % grid on
    % hold on
    % plot(t_zlin,h_zlin, 'color','red');
    % stairs(discrete_time,h_d,'color','blue');
    % title('porównanie ciągłe zlin - dyskretne zlin dla zmiennej h');
    % legend('ciagly-zlin', 'dyskretny-zlin');
    % 
    % figure(4)
    % grid on
    % hold on
    % plot(t_zlin,T_zlin, 'color','red');
    % stairs(discrete_time, T_d,'color','blue');
    % title('porównanie ciągłe zlin - dyskretne zlin dla zmiennej T');
    % legend('ciagly-zlin', 'dyskretny-zlin');
end
