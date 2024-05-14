function [e] = strojenie_DMC(wektor)


lambda1 = 1;
lambda2 = 1;
% lambda1 = wektor(1);
% lambda2 = wektor(2);
phi1 = wektor(1);
phi2 = wektor(2);


% function [E, h1, h2, h2_zad, F1, Fd]=DMC(wektor, zaklocenia, rysowanie)

% clear all
% close all

Tp = 10;% Krok symulacji (sekundy)
D = 100;

start = D+1;
simulation_time = 10000; % Czas symulacji (sekundy)
poczatek = start; %chwila k w której zmienia sie wartość zadana
N = 50;
Nu = 20;
lambda = [lambda1, lambda2];
phi = [phi1, phi2];

% Stałe
alpha = 25;
tau_C = 170;
tau_H = 220;
r = 68;


% Punkt pracy - wejścia procesu
T_Cpp = 17;
T_Hpp = 75;
T_Dpp = 42;
F_Cpp = 50;
F_Hpp = 27;
F_Dpp = 15;

% Punkt pracy - wyjścia procesu
h_pp = 13.5424;
T_pp = 38.0978;

tau_H_steps = tau_H / Tp;
tau_C_steps = tau_C / Tp;

% Trajektorie wejść procesu
T_H(1:simulation_time) = T_Hpp;
T_C(1:simulation_time) = T_Cpp;
T_D(1:simulation_time) = T_Dpp;
F_H(1:simulation_time) = F_Hpp;
F_Cin(1:simulation_time) = F_Cpp;
F_Hin(1:simulation_time) = F_Hpp;
F_D(1:simulation_time) = F_Dpp;

T_zad(1:simulation_time) = T_pp;
T_zad(start:start+round((simulation_time-start)/3)) = T_pp;
T_zad(round(start+(simulation_time-start)/3):start+round(2*(simulation_time-start)/3)) = T_pp + 5;
T_zad(start+round(2*(simulation_time-start)/3):simulation_time) = T_pp - 5;

h_zad(1:simulation_time) = h_pp;
h_zad(start:start+round((simulation_time-start)/3)) = h_pp;
h_zad(round(start+(simulation_time-start)/3):start+round(2*(simulation_time-start)/3)) = h_pp + 2;
h_zad(start+round(2*(simulation_time-start)/3):simulation_time) = h_pp - 2;

% Stan i wyjścia procesu przed rozpoczęciem symulacji
F_H(1:simulation_time) = F_Hpp;
F_C(1:simulation_time) = F_Cpp;
h(1:simulation_time) = h_pp;
T(1:simulation_time) = T_pp;

e = 0;

load("odp_skok_Tp10__minus.mat")
S = odpowiedz_skokowa(:,:,1:D);
[ny, nu, D] = size(S);

lambda_mat = [lambda(1), 0; 0, lambda(2)];
LAMBDA = kron(eye(Nu), lambda_mat);

phi_mat = [phi(1), 0; 0, phi(2)];
PHI = kron(eye(N), phi_mat);

[M, MP] = DMCmatrices(S, N, Nu);
% Sz = DMCstepmatricesZ(Tp, timefinal);
% MzP = DMCmatrixMzP(Sz, N);

K = (M'*PHI*M+LAMBDA)^(-1)*M'*PHI;

DU_p = zeros((D-1)*nu, 1);
for k=start:simulation_time
    % disp(k)
    %symulacja obiektu
    % [F_C, V, VT, T, F, h, T_out] = obiekt(F_Cin, F_H, F_D, F_C, T_H, T_C, T_D, T_out, h, C, alpha, tau_C_steps, tau_steps, V, VT, T, F, Tp, k);
    [h,T] = obiekt2(F_Cin,F_Hin, F_H, F_D, F_C, T_H, T_C, T_D, h, alpha, tau_C_steps, tau_H_steps, r, T, Tp, k);
    % [h,T] = obiekt_dyskretny(h, T, Tp, k, F_Hin, F_Cin, F_D(k),r, T_H(k), T_C(k), T_D(k), tau_H, tau_C, alpha);
    %Obliczenie DU_p
    for d=1:(D-1)
        DU_p(2*d-1) = F_Cin(k-d) - F_Cin(k-d-1);
        DU_p(2*d) = F_H(k-d) - F_H(k-d-1);
    end

    %Pomiar wyjścia
    Y = ones(N*ny, 1);
    Y(1:2:end) = Y(1:2:end) * T(k);
    Y(2:2:end) = Y(2:2:end) * h(k);

    Y_zad = ones(N*ny, 1);
    Y_zad(1:2:end) = Y_zad(1:2:end) * T_zad(k);
    Y_zad(2:2:end) = Y_zad(2:2:end) * h_zad(k);

    %Obliczenie sterowania
    DU = K*(Y_zad-Y-MP*DU_p);

    F_Cin(k) = F_Cin(k-1) + DU(1);

    % if F_Cin(k) > F_Cpp*1.2
    %     F_Cin(k) = F_Cpp*1.2;
    % elseif F_Cin(k) < F_Cpp*0.8
    %     F_Cin(k) = F_Cpp*0.8;
    % end
    % 
    % F_H(k) = F_H(k-1) + DU(2);
    % 
    % if F_H(k) > F_Hpp*1.2
    %     F_H(k) = F_Hpp*1.2;
    % elseif F_H(k) < F_Hpp*0.8
    %     F_H(k) = F_Hpp*0.8;
    % end


    e = e + (T_zad(k)-T(k))^2 + (h_zad(k)-h(k))^2; 
end

e

% figure(2)
% subplot(2,1,1)
% hold on
% stairs(h(1:end))
% plot(h_zad(1:end))
% stairs(T(1:end))
% plot(T_zad(1:end))
% title("Wyjście")
% legend("Wyjście h", "h zadana", "Wyjscie T", "t zadana")
% xlabel("chwila k")
% ylabel("wartość wyjścia")
% hold off
% 
% subplot(2,1,2)
% hold on
% stairs(F_Cin(1:end))
% stairs(F_H(1:end))
% legend("sterowanie Fc", "sterowanie Fh")
% xlabel("chwila k")
% ylabel("wartość sterowania")
% title("Sterowanie")




end

