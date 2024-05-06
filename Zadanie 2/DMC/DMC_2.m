clear;
close all;
clc;

load("odpowiedzi_skokowe_Tp25.mat")

Ts=10000; %koniec symulacji
Tp = 25;
nu = 2;
ny = 2;

D = 640;
start= D+1;
N = D;
N_u = D;
lambda = 1;
phi = 1;

s = odpowiedzi;
S = cell(1, D);

for i=1:D
    S_temp = zeros(ny, nu);
    for y=1:ny
        for u=1:nu
            S_temp(y, u) = s{y}{u}(i);
        end
    end
    S{i} = S_temp;
end

%warunki początkowe
global Fh_in Fc_in Th Tc Td alpha r tau_c tau_h Fd h_pp T_pp
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

Fh_in(1:Ts) = 27;
Fc_in(1:Ts) = 50;
h(1:Ts) = h_pp;
T(1:Ts) = T_pp;

%skok wartości zadanej
hzad(1:400) = h_pp; 
hzad(401:Ts) = 16;

Tzad(1:400) = T_pp; 
Tzad(401:Ts) = T_pp;

E=0;

%Obliczenie części macierzy DMC
Phi = eye(ny*N)*phi;
Lambda = eye(nu*N_u)*lambda;


M = cell(ny*N, nu*N_u);
for row =1:N
    for column = 1:N_u
        SS = zeros(ny,nu);
        if row - column + 1 > 1
           SS = S{row - column + 1};
            M{row,column} = SS;
        else
            M{row,column} = SS;
        end
    end
end
M = cell2mat(M);

K = ((M'*Phi*M+Lambda)^-1)*M'*Phi;

M_p = cell(ny*N, nu*(D-1));
for column=1:(D-1)
    for row=1:N
        if row + column > D
            M_p{row, column} = S{D} - S{D-1};
        else
            M_p{row, column} = S{row + column} - S{column};
        end
    end
end
M_p = cell2mat(M_p);

for k=start:Ts
    %symulacja obiektu
    [h(k),T(k)] = obiekt_dyskretny(Ts, h_pp, T_pp, Tp);

    %Obliczenie DU_p
    DU_p = [];
    for d=1:(D-1)
        DU_p = cat(1, Fh_in(k-d) - Fh_in(k-d-1), DU_p);
        DU_p = cat(1, Fc_in(k-d) - Fc_in(k-d-1), DU_p);
    end

    %Pomiar wyjścia
    Y = ones(ny*N, 1);
    Y(1:ny:end) = h(k);
    Y(2:ny:end) = T(k);
    
    %Obliczenie Y_0
    yo = M_p* DU_p + Y;

    Y_zad = ones(ny*N, 1);
    Y_zad(1:ny:end) = hzad(k);
    Y_zad(2:ny:end) = Tzad(k);
   

    %Obliczenie sterowania
    DU = K * (Y_zad - yo- M_p*DU_p);
    Fh_in(k) = Fh_in(k-1) + DU(1);
    Fc_in(k) = Fc_in(k-1) + DU(2);

    % E = E + (yzad1(k)-y1(k))^2;
    % E = E + (yzad2(k)-y2(k))^2;
    % 
end

figure(10)
hold on
stairs(h)
stairs(T)
stairs(hzad)
legend("wyjście1","wyjście2","wartość zadana")
title("Wyjście")

figure(11)
hold on
stairs(Fc_in)
stairs(Fh_in)
legend("Sterowanie1", "Sterowanie2")