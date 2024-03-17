% stałe
global Fh_in Fc_in Fd_in Th Tc Td alpha r tau_c tau_h Fd h_pp T_pp
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

% [6 13 20 27 44 51 58];
for i = [6 13 20 27 34 41 48]
    Fc_in(1:400) = 50;
    Fh_in(1:400) = 27;
    
    % skok wartości
    Ts = 16000;
    Fc_in(401:Ts) = 50;
    Fh_in(401:Ts) = i;
    
    
    [h, T, t] = obiekt_ciagly(0, Ts, h_pp, T_pp);
    [h_zlin, T_zlin, t_zlin] = obiekt_ciagly(1, Ts, h_pp, T_pp);
    
    
    % wykresy ciagly
    figure(1)
    grid on
    plot(t,h, 'color','red');
    hold on
    plot(t_zlin,h_zlin, 'color','blue');
    title('ciągłe');
    legend('h', 'h_zlin');
end

% figure(2)
% grid on
% plot(t,T);
% title('Nieliniowe');
% legend('T');
% 
% figure(3)
% grid on
% plot(t_zlin,h_zlin);
% title('linearyzacja');
% legend('h');
% 
% figure(4)
% grid on
% plot(t_zlin,T_zlin);
% title('linearyzacja');
% legend('T');
