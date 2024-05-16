clear
close all
clc

% parametry DMC
D = 300;
N = 100;
Nu = 50;
lambda = [70, 70];
phi = [1, 1];

% parametry symulacji 

Tp = 10;
start = D+1;
Ts = 10000;
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
Fh_in(1:Ts) = Fh_pp;
Fc_in(1:Ts) = Fc_pp;
Fd_in(1:Ts) = Fd_pp;
Td_in(1:Ts) = Td_pp;

h(1:Ts) = h_pp;
T(1:Ts) = T_pp;


Fd_in(Ts/2 : end) = Fd_pp*1.1;
Td_in(Ts/2 :end) = Td_pp*1.1;

h_zad(1:round(Ts/3)) = h_pp;
h_zad(round(Ts/3+1):round(2*Ts/3)) = h_pp + 2;
h_zad(round(2*Ts/3+1):Ts) = h_pp - 2;

T_zad(1:round(Ts/3)) = T_pp;
T_zad(round(Ts/3+1):round(2*Ts/3)) = T_pp + 5;
T_zad(round(2*Ts/3+1):Ts) = T_pp - 5;

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

for k=start:Ts
    Fd = Fd_in(k);
    Td = Td_in(k);
    [h,T] = obiekt(h, T, Fh_in, Fc_in, Fd, Td, tau_h, tau_c, alpha, Tp, k, r);
    
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

    Error = Error + (T_zad(k)-T(k))^2;
    Error = Error + (h_zad(k)-h(k))^2;
end
disp(Error)

figure(2)
subplot(4,1,1)
hold on
grid on
stairs(Fh_in)
title("Sterowanie Fh")
legend("Fh\_in")
xlabel("k")
ylabel("Fh")

subplot(4,1,2)
hold on
grid on
stairs(Fc_in)
title("Sterowanie Fc")
legend("Fc\_in")
xlabel("k")
ylabel("Fc")

subplot(4,1,3)
hold on
grid on
stairs(Fd_in)
title("Zakłócenie Fd")
legend("Fd")
xlabel("k")
ylabel("Fd")

subplot(4,1,4)
hold on
grid on
stairs(Fd_in)
title("Zakłócenie Td")
legend("Td")
xlabel("k")
ylabel("Td")

% print("rysunki\DMC_ster_best","-dpng","-r800")


figure(1)
subplot(2,1,1)
hold on
grid on
stairs(h)
stairs(h_zad)
title("Wyjście h")
legend("h", "h\_zad")
xlabel("k")
ylabel("wyjście")

subplot(2,1,2)
hold on
grid on
stairs(T)
stairs(T_zad)
title("Wyjście T")
legend("T", "T\_zad")
xlabel("k")
ylabel("wyjście")
% print("rysunki\DMC_wyjscia_best","-dpng","-r800")



