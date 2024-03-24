function dx = f_ciagla_lin(t, X)
	global Fh_in Fc_in Th Tc Td alpha r tau_c tau_h Fd h0

    Fd = 15;

	h = X(1,:);
    T = X(2,:);
    dx = zeros(2,1);

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


    beta = Fh + Fc + Fd;
    gamma = Fh*Th + Fc*Tc + Fd*Td;

    aqrh0 = alpha*sqrt(h0);

	dx(1) = (beta - aqrh0)/(2*pi*r*h0-pi*h0^2) - (alpha/(2*sqrt(h0)*(2*r*h0-h0^2)) + (beta - aqrh0)*(-1/(h0^2*(2*r-h0^2)) + 1/((2*r-h0^2)^2)))*(h - h0);
    dx(2) = (gamma - aqrh0*T)/(pi*r*h0^2 + pi*h0^3/3) - beta + aqrh0 + (-alpha*T/(2*sqrt(h0)*(pi*h0^2*r-pi*h0^3/3)) +(gamma-aqrh0*T)*(9*(h0-2*r)/(pi*h0^3*(h0-3*r)^2)))*(h-h0);
end