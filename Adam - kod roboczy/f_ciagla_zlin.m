function [X] = f_ciagla_zlin(t, X)
	global Fh_in Fc_in Fd_in Th Tc Td alpha r tau_c tau_h Fd h_pp T_pp
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
    Fh0 = 50;
    Fc0 = 27;
    
	% h_ = (1/(2*pi*r*h0 - pi*h0^2) + (2*h0-2*r)/(pi*h0^2*(h0-2*r)^2)*(h-h0)) * (Fh +Fc + Fd - alpha*(sqrt(h0) + 1/(2*sqrt(h0))*(h-h0)));

    h_ = (Fh0 +Fc0 + Fd - alpha*sqrt(h0)) / (2*pi*r*h0 - pi*h0^2) + ...
         ((alpha*sqrt(h0)*(3*h0-2*r) - 4*(h0-r)*(Fc0+Fh0+Fd)) / (2*pi*h0^2*(h0-2*r)^2)) * (h-h0) + ...
         (1/(2*pi*r*h0 - pi*h0^2))*(Fh - Fh0) + ...
         (1/(2*pi*r*h0 - pi*h0^2))*(Fc - Fc0);

    % T = (Fh*Th +Fc*Tc + Fd*Td - alpha*sqrt(h)*T) / (((pi*h^2)/3) * (3*r-h));
    T = (Fh0*Th +Fc0*Tc + Fd*Td - alpha*sqrt(h0)*T) / (((pi*h0^2)/3) * (3*r-h0)) + ...
        ((3*alpha)/(h0*sqrt(h0)*(pi*h0-3*pi*r))) * (T - T0) - ...
        ((3*Th)/(pi*h0^2*(h0-3*r))) * (Fh - Fh0) - ...
        ((3*Tc)/(pi*h0^2*(h0-3*r))) * (Fc - Fc0) + ...
        ((3*alpha*sqrt(h0)*T0*(9*r-5*h0) + 18*(h0 - 2*r)*(Fc0*Tc + Fh0*Th + Fd*Td)) / (2*pi*h0^3*(h0-3*r)^2)) *(h-h0);

    
    X = [h_; T];
    
end

