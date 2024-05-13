%%% DMC numeryczny  %%%
%%% Zadanie 2, TST %%%

DMC_param;

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
umax = 200;
ymin = 0;
ymax = 50;

dUmax = ones(nu*N)*dumax;
dUmin = ones(nu*N)*dumin;
Umin = ones(nu*Nu, 1)*umin;
Umax = ones(nu*Nu, 1)*umax;
Ymin = ones(nu*N, 1)*ymin;
Ymax = ones(nu*N, 1)*ymax;

Fh0 = 27;
Fc0 = 50;
Fd = 15;
Th = 75;
Tc = 17;
Td = 42;

% Inicjalizacja zmiennych

Fh = Fh0;
Fc = Fc0;

h(1:k_max) = h0;
T(1:k_max) = T0;

u1(1:k_max) = Fh0;
u2(1:k_max) = Fc0;

duk = 0;
dUk = zeros(nu*(Nu-1), 1);

dUp = zeros(nu*(D-1), 1);

% Yzad
h_zad = zeros(1, k_max);
h_zad(1:330) = 20;
h_zad(331:660) = 10;
h_zad(661:1000) = 17;

T_zad = zeros(1, k_max);
T_zad(1:330) = 30;
T_zad(331:660) = 40;
T_zad(661:1000) = 50;
% --- %
T_zad(1: k_max) = T0;

for k=(tau_h+1):k_max

   Fh = u1((k-tau_h));
   Fc = u2((k-tau_c));

   h(k) = h(k-1) + Tp * ((Fh0 +Fc0 + Fd - alpha*sqrt(h0)) / (2*pi*r*h0 - pi*h0^2) - ...
             ((alpha*sqrt(h0)*(3*h0-2*r) - 4*(h0-r)*(Fc0+Fh0+Fd)) / (2*pi*h0^2*(h0-2*r)^2)) * (h(k-1)-h0) + ...
             (1/(2*pi*r*h0 - pi*h0^2))*(Fh - Fh0) + ...
             (1/(2*pi*r*h0 - pi*h0^2))*(Fc - Fc0));
    
    
   T(k) = T(k-1) + Tp * ((Fh0*Th + Fc0*Tc + Fd*Td - alpha*sqrt(h0)*T0 - T0*(Fh0 + Fc0 + Fd - alpha*sqrt(h0))) / (pi*h0^2*r - (pi*h0^3)/3) + ...
            (3*(Fc0 + Fh0 + Fd) / (pi*h0^2*(h0-3*r))) * (T(k-1) - T0) + ...
            (3*(T0 - Th) / (pi*h0^2*(h0-3*r))) * (Fh - Fh0) + ...
            (3*(T0 - Tc) / (pi*h0^2*(h0-3*r))) * (Fc - Fc0) + ...
            ((9*(h0-2*r) * (Fc0*(Tc - T0) + Fh0*(Th-T0) + Fd*(Td-T0))) / (pi*h0^3*(h0 - 3*r)^2)) * (h(k-1) - h0));

   for n=D-1:-1:2 
      dUp(n)=dUp(n-1);
   end
   dUp(1)=duk;

% programowanie kwadratowe

   Uk = [ones(Nu, 1)*u1(k-1); ones(Nu, 1)*u2(k-1)];

   Yk = [ones(N, 1)*h(k-1); ones(N, 1)*T(k-1)];
   Y0kpom = Mp*dUp;
   Y0k = Yk + Y0kpom;

   Yzad = [h_zad(k)*ones(N, 1); T_zad(k)*ones(N, 1)];

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
  du2k = dUk(1+Nu);
   
  u1(k) = u1(k-1) + du1k;
  u2(k) = u2(k-1) + du2k;

end
figure(1)
subplot(2,1,1)
plot(h);hold on;
grid on;
stairs(h_zad,'--');
title('DMC num, h');
hold off
subplot(2,1,2)
plot(T);hold on;
grid on;
stairs(T_zad,'--');
title("DMC num, T");
hold off
% subplot(2,1,2)
% stairs(0:k, [F1in wyu]);
% title('DMC num, U');
% grid on;