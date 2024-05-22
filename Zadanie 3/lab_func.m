function [h,T] = lab_func(decomp)

Tc = 17;
Th = 75;
Td = 42;
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

for k=tauC+1:k_max
    
    Fc = Fc_in(k-tauC);
     
    if k <= tauH
       Fh = Fh_in(1);
    else
       Fh = Fh_in(k - tauH); 
    end

    if decomp == 0

    h(k) = h(k-1) + Tp * ((Fh + Fc + Fd - alpha*sqrt(h(k-1))) / (2*r*pi*h(k-1) - pi*h(k-1)^2));
    T(k) = T(k-1) + Tp* ((-T(k-1) * (Fh + Fc + Fd ) + Fh*Th + Fc*Tc + Fd*Td) / (pi*h(k-1)^2*r - pi*h(k-1)^3/3));
   
    else

    pom1 = Fh + Fc + Fd;
    pom2 = alpha*sqrt(h(k-1));
    mian1 = (2*r*pi*h(k-1) - pi*h(k-1)^2);
    mian2 = (pi*h(k-1)^2*r - pi*h(k-1)^3/3);
    mnoz1 =  Fh*Th + Fc*Tc + Fd*Td;
    
    h(k) = h(k-1) + Tp * ((pom1 - pom2) / mian1);
    T(k) = T(k-1) + Tp* ((-T(k-1) * pom1) + mnoz1) / (mian2);

    end

end

end

