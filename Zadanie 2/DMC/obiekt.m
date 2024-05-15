function [h, T] = obiekt(h, T, Fh_in, Fc_in, Fd, tau_h, tau_c, alpha, Tp, k, r)
    Tc = 17;
    Th = 75;
    Td = 42;

    tau_h_steps = tau_h / Tp;
    tau_c_steps = tau_c / Tp;

    Fc = Fc_in(k - tau_c_steps);    
    Fh = Fh_in(k - tau_h_steps);    
    
    h(k) = h(k-1) + Tp * ((Fh + Fc + Fd - alpha*sqrt(h(k-1))) / (2*r*pi*h(k-1) - pi*h(k-1)^2));
    T(k) = T(k-1) + Tp* ((-T(k-1) * (Fh + Fc + Fd ) + Fh*Th + Fc*Tc + Fd*Td) / (pi*h(k-1)^2*r - pi*h(k-1)^3/3));
end


