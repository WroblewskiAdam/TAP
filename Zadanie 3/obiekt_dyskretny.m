function [h_out, T_out] = obiekt_dyskretny(t_sim, h_0, T_0, Tp)
global Fh_in Fc_in Th Tc Td alpha r tau_c tau_h Fd h_pp T_pp

steps = round(t_sim/Tp);
tau_h_steps = round(tau_h/Tp); 
tau_c_steps = round(tau_c/Tp);

%startowe h, T
h = zeros(t_sim,1);
h(1) = h_0;
T = zeros(t_sim,1);
T(1) = T_0;

h0 = h_pp;
T0 = T_pp;
Fh0 = 27;
Fc0 = 50;

for k = 2:steps+2

    if k - tau_h_steps < 1
       Fh = Fh_in(1);
    else
       Fh = Fh_in((k-tau_h_steps)*Tp);
    end
    

    if k - tau_c_steps < 1 
       Fc = Fc_in(1);
    else
       Fc = Fc_in((k-tau_c_steps)*Tp);
    end
    
     h(k) = h(k-1) + Tp * ((Fh + Fc + Fd - alpha*sqrt(h(k-1))) / (2*r*pi*h(k-1) - pi*h(k-1)^2));
     T(k) = T(k-1) + Tp* ((-T(k-1) * (Fh + Fc + Fd ) + Fh*Th + Fc*Tc + Fd*Td) / (pi*h(k-1)^2*r - pi*h(k-1)^3/3));
end
h_out = h(1:end);
T_out = T(1:end);
end