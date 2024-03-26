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
% 38.0978260869565

Tp = 200;

Ts = 8000;
Fc_skoki = 20:1:80;
Fh_skoki = 7:1:47;
skoki_h = [];
skoki_T = [];

% [6 13 20 27 34 41 48]
% [21 23 25 27 29 31 33]
% [24 25 26 27 28 29 30]
% [35 40 45 50 55 60 65]
% [44 46 48 50 52 54 56]
% [25.5 26 26.5 27.5 28 29.5]
for i = [24 25 26 27 28 29 30]
    Fc_in(1:400) = 50;
    Fh_in(1:400) = 27;
  

    % % skok wartości
    % settle_time = 10000;
    % Ts = 4*settle_time;
    % Fh_in(401:settle_time) = 32;
    % Fh_in(settle_time+1:2*settle_time) = 22;
    % Fh_in(2*settle_time+1:3*settle_time) = 37;
    % Fh_in(3*settle_time+1:Ts) = 17;

    Fc_in(401:Ts) = 50;
    Fh_in(401:Ts) = i;
    
    [h, T, t] = obiekt_ciagly(0, Ts, h_pp, T_pp);
    [h_zlin, T_zlin, t_zlin] = obiekt_ciagly(1, Ts, h_pp, T_pp);
    [h_d, T_d] = obiekt_dyskretny(Ts/Tp, h_pp, T_pp, Tp);

    % skoki_h = [skoki_h, h(end)];
    % skoki_T = [skoki_T, T(end)];
    
    % figure(1)
    % subplot(2,1,1)
    % plot(t,h, 'color','red');
    % title('przebieg zmeinnej h dla skoków sterowania Fh');
    % grid on
    % legend('h');
    % 
    % subplot(2,1,2)
    % plot(t,T, 'color','red');
    % title('przebieg zmeinnej T dla skoków sterowania Fh')
    % grid on
    % legend('T');
    % print("rysunki/skoki sterowania Fh - przebiegi.png","-dpng","-r400")
    
    
    % figure(2)
    % subplot(2,1,1)
    % plot(t,Fc_in, 'Color','blue');
    % title('Sterowanie Fc');
    % legend('Fc');
    % grid on;
    % 
    % subplot(2,1,2)
    % plot(t,Fh_in, 'color','blue');
    % title('Sterowanie Fh');
    % grid on
    % legend('Fh');
    % print("rysunki/skoki sterowania Fh - sterowanie.png","-dpng","-r400")


    % % % 
    % % % % % h = (h - h(1))/7;
    % % % subplot(2,1,1)
    % figure(1)
    % hold on
    % grid on
    % plot(t,h, 'color','red');
    % title('punkt pracy');
    % legend('h');
    % % % axis([0 8000 13 14])
    % 
    % % T = (T - T(1))/7;
    % % subplot(2,1,2)
    % figure(2)
    % hold on
    % grid on
    % plot(t,T, 'color','red');
    % title('punkt pracy');
    % legend('T');
    % % print("rysunki/pkt_pracy.png","-dpng","-r400")
    % % axis([0 8000 37.9 38.2])

    

    % wykresy ciagly - zline
    figure(1);
    plot(t,h, 'color','red');
    hold on;
    plot(t_zlin,h_zlin, 'color','blue');
    title('ciągłe');
    legend('h', 'h-zlin');
    grid on;
    grid minor;

    figure(2);
    plot(t,T, 'color','red');
    hold on;
    plot(t_zlin,T_zlin, 'color','blue');
    title('ciągłe');
    legend('T', 'Tzlin');
    grid on;
    grid minor;

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

% figure(1)
% hold on
% plot(Fh_skoki,skoki_h, 'color','red');
% title('Charakterystyka statyczna toru Fd - h');
% xlabel('Fc')
% ylabel('h')
% grid on;
% print("rysunki/char_stat toru Fd-h.png","-dpng","-r400")
% 
% 
% figure(2)
% hold on
% plot(Fh_skoki,skoki_T, 'color','red');
% title('Charakterystyka statyczna toru Fd - T');
% xlabel('Fc')
% ylabel('T')
% grid on;
% print("rysunki/char_stat toru Fd-T.png","-dpng","-r400")


