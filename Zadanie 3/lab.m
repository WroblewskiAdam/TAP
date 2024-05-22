
Tc = 17;
Th = 75;
Td = 42;
Fc = 50;
Fh = 27;
Fd = 15;
tauC = 170;
tauH = 220;

Tp = 10;
Ts = 10000;


k_max = Ts/Tp;
tauC = tauC/Tp;
tauH = tauH/Tp;

hpp= 13.54;
Tpp = 38.10;
r = 68;
alpha = 25;



h(1:k_max) = hpp;
T(1:k_max) = Tpp;


Fh_in(1:k_max) = 27;
Fc_in(1:k_max) = 50;

Fh_in(tauH:k_max) = 30;
Fc_in(tauC:k_max) = 50;

Fh(1:tauH) = Fh_in(1);
Fc(1:tauC) = Fc_in(1);

for k=tauC+1:k_max
    
    Fc = Fc_in(k-tauC);
     
    if k <= tauH
       Fh = Fh_in(1);
    else
       Fh = Fh_in(k - tauH); 
    end
    
    h(k+1) = h(k) + Tp * ((Fh + Fc + Fd - alpha*sqrt(h(k))) / (2*r*pi*h(k) - pi*h(k)^2));
    T(k+1) = T(k) + Tp* ((-T(k) * (Fh + Fc + Fd ) + Fh*Th + Fc*Tc + Fd*Td) / (pi*h(k)^2*r - pi*h(k)^3/3));
    
end

figure(1)
plot(h)
figure(2)
plot(T)
