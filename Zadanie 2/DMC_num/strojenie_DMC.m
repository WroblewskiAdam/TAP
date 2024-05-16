function [Error] = strojenie_DMC(wektor)

D = wektor(1);
N = wektor(2);
if N>D
    N = D;
end
Nu = wektor(3);
lambda = wektor(4);
if Nu>N
    Nu = N;
end
D = round(D);
N = round(N);
Nu = N;

load("odp_skok_Tp10.mat")
S = odpowiedz_skokowa(:,:,1:D);

[ny, nu, D] = size(S);

M=zeros(N*ny, Nu*nu);
for i=1:N
   M((i-1)*ny+1:(i-1)*ny+ny, 1:nu) = S(:, :,min(i, D)); 
end
for i=2:Nu
   M(:, (i-1)*nu+1:(i-1)*nu+nu) = [zeros((i-1)*ny, nu); M(1:(N-i+1)*ny,1:nu)];
end
 
Mp=zeros(ny*N, nu*(D-1));
  
for i=1:D-1
   for j=1:N
      Mp((j-1)*ny+1:j*ny,(i-1)*nu+1:i*nu)=S(:,:,min(i+j,D))-S(:,:,i);
   end
end

L = eye(nu*Nu)*lambda;
J = zeros(nu*Nu, nu*Nu);
J(1:2:Nu*nu, 1:2:Nu*nu) = 1;
J(2:2:Nu*nu, 2:2:Nu*nu) = 1;
J = tril(J);
% Parametry

Ts = 10000;
Tp = 10; 
k_max = Ts/Tp;
tau_h = 220/Tp;
tau_c = 170/Tp;

h0 = 13.5424;
T0 = 38.0978;
alpha = 25;
r = 68;

dumax = 10;
dumin = -10;
umin = 0;
u1max = 54;
u2max = 100;
ymin = 0;
ymax = 60;

dUmax = ones(nu*N)*dumax;
dUmin = ones(nu*N)*dumin;
Umin = zeros(nu*Nu, 1)*umin;

Umax = zeros(nu*Nu, 1);
Umax(1:2:end) = u1max;
Umax(2:2:end) = u2max;  

Ymin = ones(nu*N, 1)*ymin;
Ymax = ones(nu*N, 1)*ymax;

Fh0 = 27;
Fc0 = 50;
Fd0 = 15;
Th = 75;
Tc = 17;
Td = 42;

% Inicjalizacja zmiennych

Fh = Fh0;
Fc = Fc0;

h(1:k_max) = h0;
T(1:k_max) = T0;

Fh_in(1:k_max) = Fh0;
Fc_in(1:k_max) = Fc0;
Fd_in(1:k_max/2) = Fd0;
Fd_in(k_max/2+1:k_max) = Fd0*1.1;

duk = 0;
dUk = zeros(nu*(Nu-1), 1);

dUp = zeros(nu*(D-1), 1);

% Yzad
h_zad = zeros(1, k_max);
h_zad(1:D) = h0;
h_zad(D+1:660) = h0+2;
h_zad(661:1000) = h0-2;

T_zad = zeros(1, k_max);
T_zad(1:D) = T0;
T_zad(D+1:660) = T0+5;
T_zad(661:1000) = T0-5;

Error = 0;

for k=D+1:k_max
   disp(k)

   Fh = Fh_in((k-tau_h));
   Fc = Fc_in((k-tau_c));
   Fd = Fd_in(k);

   h(k) = h(k-1) + Tp * ((Fh + Fc + Fd - alpha*sqrt(h(k-1))) / (2*r*pi*h(k-1) - pi*h(k-1)^2));
   T(k) = T(k-1) + Tp* ((-T(k-1) * (Fh + Fc + Fd ) + Fh*Th + Fc*Tc + Fd*Td) / (pi*h(k-1)^2*r - pi*h(k-1)^3/3));
 
    for i=1:(D-1)
        dUp(i*nu-1) = Fh_in(k-i) - Fh_in(k-i-1);
        dUp(i*nu) = Fc_in(k-i) - Fc_in(k-i-1);
    end

% programowanie kwadratowe

   Uk = zeros(Nu*ny, 1);
   Uk(1:2:end) = Fh_in(k-1);
   Uk(2:2:end) = Fc_in(k-1);

   Yk = zeros(N*ny, 1);
   Yk(1:2:end) = h(k);
   Yk(2:2:end) = T(k);

   Y0kpom = Mp*dUp;
   Y0k = Yk + Y0kpom;

   Yzad = zeros(N*ny, 1);
   Yzad(1:2:end) = h_zad(k);
   Yzad(2:2:end) = T_zad(k);

   H = 2*(M'*M + L);
   A = [-J; J; -M; M];
   f = -2*M'*(Yzad - Yk - Mp*dUp);
   b = [-Umin + Uk; 
        Umax - Uk;
        -Ymin + Y0k;
        Ymax - Y0k];
   lb = dUmin(1:nu*Nu, 1);
   ub = dUmax(1:nu*Nu, 1);

  [dUk, fval] = quadprog(H,f,A,b, [], [], lb, ub);

  du1k = dUk(1);
  du2k = dUk(2);
   
  Fh_in(k) = Fh_in(k-1) + du1k;
  Fc_in(k) = Fc_in(k-1) + du2k;

  Error = Error + (T_zad(k)-T(k))^2 + (h_zad(k)-h(k))^2; 
end
disp(Error)

figure(2)
subplot(3,1,1)
hold on
stairs(Fh_in)
title("Sterowanie Fh")
legend("Fh_in")
xlabel("k")
ylabel("sterowanie")

subplot(3,1,2)
hold on
stairs(Fc_in)
title("Sterowanie Fc")
legend("Fc_in")
xlabel("k")
ylabel("sterowanie")

subplot(3,1,3)
hold on
stairs(Fd_in)
title("Zakłócenie Fd")
legend("Fd")
xlabel("k")
ylabel("zakłócenie")

figure(1)
subplot(2,1,1)
hold on
stairs(h)
stairs(h_zad)
title("Wyjście h")
legend("h", "h\_zad")
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
disp([D, N, lambda])
end

