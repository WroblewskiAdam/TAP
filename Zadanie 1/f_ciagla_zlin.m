function [X] = f_ciagla_zlin(t, X)
	global Fh_in Fc_in  Th Tc Td alpha r tau_c tau_h Fd h_pp T_pp
	Fd = 15;
	h = X(1,:);
    T = X(2,:);


    if floor(t) - tau_h < 1
		Fh = Fh_in(1);
	else
    	Fh = Fh_in(floor(t) - tau_h);
    end
    
    if floor(t) - tau_c < 1
		Fc = Fc_in(1);
	else
    	Fc = Fc_in(floor(t) - tau_c);
    end

    h0 = h_pp;
    T0 = T_pp;
    Fh0 = 27;
    Fc0 = 50;

    h_ = (Fh0 +Fc0 + Fd - alpha*sqrt(h0)) / (2*pi*r*h0 - pi*h0^2) - ...
         ((alpha*sqrt(h0)*(3*h0-2*r) - 4*(h0-r)*(Fc0+Fh0+Fd)) / (2*pi*h0^2*(h0-2*r)^2)) * (h-h0) + ...
         (1/(2*pi*r*h0 - pi*h0^2))*(Fh - Fh0) + ...
         (1/(2*pi*r*h0 - pi*h0^2))*(Fc - Fc0);


    T = (Fh0*Th + Fc0*Tc + Fd*Td - alpha*sqrt(h0)*T0 - T0*(Fh0 + Fc0 + Fd - alpha*sqrt(h0))) / (pi*h0^2*r - (pi*h0^3)/3) + ...
        (3*(Fc0 + Fh0 + Fd) / (pi*h0^2*(h0-3*r))) * (T - T0) + ...
        (3*(T0 - Th) / (pi*h0^2*(h0-3*r))) * (Fh - Fh0) + ...
        (3*(T0 - Tc) / (pi*h0^2*(h0-3*r))) * (Fc - Fc0) + ...
        ((9*(h0-2*r) * (Fc0*(Tc - T0) + Fh0*(Th-T0) + Fd*(Td-T0))) / (pi*h0^3*(h0 - 3*r)^2)) * (h - h0);

    X = [h_; T];
    
end

