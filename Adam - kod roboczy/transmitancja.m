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
eqn1_sym = (Fh + Fc + Fd - alpha*sqrt(h)) / (2*pi*r*h - pi*h^2);
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


Tp = 200; % poczatkowy okres probkowania
metoda = 'zoh'; 

% petla dla roznych Tp
for i = 1:5

    % dyskretyzacja
    G_d = c2d(sys_ss, Tp, metoda);

    % odpowiedz skokowa
    figure(i); 
    step(G, G_d);
    title(['Odpowiedź skokowa dla Tp = ', num2str(Tp), 's']);
    legend('Transmitancja ciągła', ['Transmitancja dyskretna, Tp = ', num2str(Tp), 's']);
    
    Tp = Tp / 10;
end
