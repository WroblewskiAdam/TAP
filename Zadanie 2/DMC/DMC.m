clear
close all
clc

% parametry DMC
D = 200;
N = 200;
Nu = 50;
lambda = [50, 50];
phi = [1, 1];

% parametry symulacji 
Tp = 10;
start = D+1;
simulation_time = 10000; 
Error = 0;

% Stałe
alpha = 25;
tau_c = 170;
tau_h = 220;
r = 68;

Fc_max = 100;
Fh_max = 54;

% Punkt pracy 
Tc_pp = 17;
Th_pp = 75;
Td_pp = 42;
Fc_pp = 50;
Fh_pp = 27;
Fd_pp = 15;

h_pp = 13.5424;
T_pp = 38.0978;

% trajektorie
Fh_in(1:simulation_time) = Fh_pp;
Fc_in(1:simulation_time) = Fc_pp;
Fd_in(1:simulation_time) = Fd_pp;

h(1:simulation_time) = h_pp;
T(1:simulation_time) = T_pp;

T_zad(1:simulation_time) = T_pp;
T_zad(start:start+round((simulation_time-start)/3)) = T_pp;
T_zad(round(start+(simulation_time-start)/3):start+round(2*(simulation_time-start)/3)) = T_pp + 5;
T_zad(start+round(2*(simulation_time-start)/3):simulation_time) = T_pp - 5;

h_zad(1:simulation_time) = h_pp;
h_zad(start:start+round((simulation_time-start)/3)) = h_pp;
h_zad(round(start+(simulation_time-start)/3):start+round(2*(simulation_time-start)/3)) = h_pp - 2;
h_zad(start+round(2*(simulation_time-start)/3):simulation_time) = h_pp + 2;

% model
load("odp_skok_Tp10.mat")
S = odpowiedz_skokowa(:,:,1:D);
[ny, nu, D] = size(S);

%Macierz Lambda
Lambda = eye(nu*Nu);
for i = 1:Nu
    Lambda(i*nu-1, i*nu-1) = lambda(1);
    Lambda(i*nu, i*nu) = lambda(2);
end

%Macierz Phi
Phi = eye(ny*N);
for i = 1:N
    Phi(i*ny-1, i*ny-1) = phi(1);
    Phi(i*ny, i*ny) = phi(2);
end

%Pobranie macierzy M, MP
[M, MP] = DMCmatrices(S, N, Nu);

K = (M'*Phi*M+Lambda)^(-1)*M'*Phi;
DU_p = zeros((D-1)*nu, 1);

for k=start:simulation_time
    disp(k)

    Fd = Fd_in(k);
    [h,T] = obiekt(h, T, Fh_in, Fc_in, Fd, tau_h, tau_c, alpha, Tp, k, r);
    


    Y_zad = zeros(N*ny, 1);
    Y_zad(1:2:end) = h_zad(k);
    Y_zad(2:2:end) = T_zad(k);

    Y = zeros(N*ny, 1);
    Y(1:2:end) = h(k);
    Y(2:2:end) = T(k);

    for i=1:(D-1)
        DU_p(i*nu-1) = Fh_in(k-i) - Fh_in(k-i-1);
        DU_p(i*nu) = Fc_in(k-i) - Fc_in(k-i-1);
    end


    DU = K*(Y_zad-Y-MP*DU_p);
    Fh_in(k) = Fh_in(k-1) + DU(1);
    Fc_in(k) = Fc_in(k-1) + DU(2);

    % ograniczenia
    if Fc_in(k) > Fc_max
        Fc_in(k) = Fc_max;
    elseif Fc_in(k) < 0
        Fc_in(k) = 0;
    end

    if Fh_in(k) > Fh_max
        Fh_in(k) = Fh_max;
    elseif Fh_in(k) < 0
        Fh_in(k) = 0;
    end

    Error = Error + (T_zad(k)-T(k))^2 + (h_zad(k)-h(k))^2; 
end
disp(Error)

figure(2)
subplot(2,1,1)
hold on
stairs(Fh_in)
title("Sterowanie Fh")
legend("Fh_in")
xlabel("k")
ylabel("sterowanie")

subplot(2,1,2)
hold on
stairs(Fc_in)
title("Sterowanie Fc")
legend("Fc_in")
xlabel("k")
ylabel("sterowanie")


figure(1)
subplot(2,1,1)
hold on
stairs(h)
stairs(h_zad)
title("Wyjście h")
legend("h", "h_zad")
xlabel("k")
ylabel("wyjście")

subplot(2,1,2)
hold on
stairs(T)
stairs(T_zad)
title("Wyjście T")
legend("T", "T\_zad")
xlabel("k")
ylabel("wyjście")


