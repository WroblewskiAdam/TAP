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
Fh0 = 50;
Fc0 = 27;

eqn1_sym = (Fh0 +Fc0 + Fd - alpha*sqrt(h0)) / (2*pi*r*h0 - pi*h0^2) + ...
         ((3*alpha*h0^(3/2) - 2*alpha*sqrt(h0)*r + 4*Fc0*(h0-r) + 4*Fd*(h0-r) + 4*h0*Fh0 - 4*Fh0*r) / (2*pi*h0^2*(h0-2*r)^2)) * (h-h0) + ...
         (1/(2*pi*h0*r - pi*h0^2))*(Fh - Fh0) + ...
         (1/(2*pi*h0*r - pi*h0^2))*(Fc - Fc0);
eqn2_sym = (Fh*Th + Fc*Tc + Fd*Td - alpha*sqrt(h)*T) / (((pi*h^2)/3) * (3*r-h));

% macierz jacobiego dla stanow
J_A = jacobian([eqn1_sym, eqn2_sym], [h, T]);

% macierz jacobiego dla wejsc
J_B = jacobian([eqn1_sym, eqn2_sym], [Fh, Fc]);

% podstawienie punktu pracy
A = double(subs(J_A, [h, T, Fh, Fc], [h_pp, T_pp, Fh_pp, Fc_pp]));
B = double(subs(J_B, [h, T, Fh, Fc], [h_pp, T_pp, Fh_pp, Fc_pp]));
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
