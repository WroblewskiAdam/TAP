function [G, G_d] = transmitancja(Tp, metoda)
% zmienne
global Th Tc Td alpha r tau_c tau_h Fd

% parametry
r = 68; 
alpha = 25;
tau_c = 170; 
tau_h = 220; 
Fd = 15; 
Th = 75; 
Tc = 17; 
Td = 42; 
h_pp = 13.54; 
T_pp = 38.10; 
Fh_pp = 27; 
Fc_pp = 50; 

syms h T Fh Fc

% rownania stanu
h0 = h_pp;
T0 = T_pp;
Fh0 = 27;
Fc0 = 50;

eqn1_sym = (Fh0 +Fc0 + Fd - alpha*sqrt(h0)) / (2*pi*r*h0 - pi*h0^2) - ...
         ((alpha*sqrt(h0)*(3*h0-2*r) - 4*(h0-r)*(Fc0+Fh0+Fd)) / (2*pi*h0^2*(h0-2*r)^2)) * (h-h0) + ...
         (1/(2*pi*r*h0 - pi*h0^2))*(Fh - Fh0) + ...
         (1/(2*pi*r*h0 - pi*h0^2))*(Fc - Fc0);


eqn2_sym = (Fh0*Th + Fc0*Tc + Fd*Td - alpha*sqrt(h0)*T0 - T0*(Fh0 + Fc0 + Fd - alpha*sqrt(h0))) / (pi*h0^2*r - (pi*h0^3)/3) + ...
        (3*(Fc0 + Fh0 + Fd) / (pi*h0^2*(h0-3*r))) * (T - T0) + ...
        (3*(T0 - Th) / (pi*h0^2*(h0-3*r))) * (Fh - Fh0) + ...
        (3*(T0 - Tc) / (pi*h0^2*(h0-3*r))) * (Fc - Fc0) + ...
        ((9*(h0-2*r) * (Fc0*(Tc - T0) + Fh0*(Th-T0) + Fd*(Td-T0))) / (pi*h0^3*(h0 - 3*r)^2)) * (h - h0);

% % macierz jacobiego dla stanow
% J_A = jacobian([eqn1_sym, eqn2_sym], [h, T]);
% 
% % macierz jacobiego dla wejsc
% J_B = jacobian([eqn1_sym, eqn2_sym], [Fh, Fc]);

% podstawienie punktu pracy
% A = double(subs(J_A, [h, T, Fh, Fc], [h_pp, T_pp, Fh_pp, Fc_pp]));
% B = double(subs(J_B, [h, T, Fh, Fc], [h_pp, T_pp, Fh_pp, Fc_pp]));

A = [- ((alpha*sqrt(h0)*(3*h0-2*r) - 4*(h0-r)*(Fc0+Fh0+Fd)) / (2*pi*h0^2*(h0-2*r)^2)) 0; ((9*(h0-2*r) * (Fc0*(Tc - T0) + Fh0*(Th-T0) + Fd*(Td-T0))) / (pi*h0^3*(h0 - 3*r)^2)) (3*(Fc0 + Fh0 + Fd) / (pi*h0^2*(h0-3*r)))];
B = [(1/(2*pi*r*h0 - pi*h0^2)) (1/(2*pi*r*h0 - pi*h0^2)); (3*(T0 - Th) / (pi*h0^2*(h0-3*r))) (3*(T0 - Tc) / (pi*h0^2*(h0-3*r)))];
C = eye(2);
D = zeros(2, 2);

% model przestrzeni stanow
sys_ss = ss(A, B, C, D);

G = tf(sys_ss);

% Wyświetlenie odpowiedzi skokowej dla modelu przestrzeni stanów
figure;
step(sys_ss);
title('Odpowiedź skokowa modelu przestrzeni stanów');

% Wyświetlenie odpowiedzi skokowej dla transmitancji
figure;
step(G);
title('Odpowiedź skokowa transmitancji');

Tp = 200; % poczatkowy okres probkowania
metoda = 'zoh'; 

% petla dla roznych Tp
for i = 1:4

    % dyskretyzacja
    sys_d = c2d(sys_ss, Tp, metoda);
    G_d = c2d(G, Tp, metoda);

    % odpowiedz skokowa
    figure(i); 
    step(sys_d, G_d);
    title(['Odpowiedź skokowa dla Tp = ', num2str(Tp), 's']);
    legend('Model przestrzeni stanów', ['Transmitancja dyskretna, Tp = ', num2str(Tp), 's']);
    filename = ['trans-sys-dys-tp', num2str(Tp), '.png'];
    print(filename, '-dpng', '-r400');

    % figure(i); 
    % step(G, G_d);
    % title(['Odpowiedź skokowa dla Tp = ', num2str(Tp), 's']);
    % legend('Transmitancja ciągła', ['Transmitancja dyskretna, Tp = ', num2str(Tp), 's']);
    % filename = ['trans-ciag-dys-tp', num2str(Tp), '.png'];
    % print(filename, '-dpng', '-r400');
    
    Tp = Tp / 2;
end
end
