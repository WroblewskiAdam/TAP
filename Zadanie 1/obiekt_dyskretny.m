function [h_out, T_out] = obiekt_dyskretny(t_sim, h_0, T_0, Tp)
global Fh_in Fc_in Th Tc Td alpha r tau_c tau_h Fd h_pp T_pp

start = 2;

%startowe h, T
h = zeros(start+t_sim,1);
h(1) = h_0;
T = zeros(start+t_sim,1);
T(1) = T_0;

% Tp = 1;


for k=start:start+t_sim

    if k - tau_h < 1 || length(Fh_in) < 221
       Fh = Fh_in(1);
    else
       Fh = Fh_in(k-tau_h);
    end
    
    if k - tau_c < 1 || length(Fc_in) < 171
       Fc = Fc_in(1);
    else
       Fc = Fc_in(k-tau_c);
    end
	
    h0 = h_pp;
    T0 = T_pp;
    Fh0 = 27;
    Fc0 = 50;

    h(k) = h(k-1) + Tp * ((Fh0 +Fc0 + Fd - alpha*sqrt(h0)) / (2*pi*r*h0 - pi*h0^2) - ...
         ((alpha*sqrt(h0)*(3*h0-2*r) - 4*(h0-r)*(Fc0+Fh0+Fd)) / (2*pi*h0^2*(h0-2*r)^2)) * (h(k-1)-h0) + ...
         (1/(2*pi*r*h0 - pi*h0^2))*(Fh - Fh0) + ...
         (1/(2*pi*r*h0 - pi*h0^2))*(Fc - Fc0));


    T(k) = T(k-1) + Tp * ((Fh0*Th + Fc0*Tc + Fd*Td - alpha*sqrt(h0)*T0 - T0*(Fh0 + Fc0 + Fd - alpha*sqrt(h0))) / (pi*h0^2*r - (pi*h0^3)/3) + ...
        (3*(Fc0 + Fh0 + Fd) / (pi*h0^2*(h0-3*r))) * (T(k-1) - T0) + ...
        (3*(T0 - Th) / (pi*h0^2*(h0-3*r))) * (Fh - Fh0) + ...
        (3*(T0 - Tc) / (pi*h0^2*(h0-3*r))) * (Fc - Fc0) + ...
        ((9*(h0-2*r) * (Fc0*(Tc - T0) + Fh0*(Th-T0) + Fd*(Td-T0))) / (pi*h0^3*(h0 - 3*r)^2)) * (h(k-1) - h0));

	
   
end
h_out = h(1:end);
T_out = T(1:end);
end