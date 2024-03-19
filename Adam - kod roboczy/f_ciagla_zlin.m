function [X] = f_ciagla_zlin(t, X)
	global Fh_in Fc_in Fd_in Th Tc Td alpha r tau_c tau_h Fd h_pp
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
    Fh0 = 50;
    Fc0 = 27;
	% h_ = (1/(2*pi*r*h0 - pi*h0^2) + (2*h0-2*r)/(pi*h0^2*(h0-2*r)^2)*(h-h0)) * (Fh +Fc + Fd - alpha*(sqrt(h0) + 1/(2*sqrt(h0))*(h-h0)));
    h_ = (Fh0 +Fc0 + Fd - alpha*sqrt(h0)) / (2*pi*r*h0 - pi*h0^2) + ...
         ((3*alpha*h0^(3/2) - 2*alpha*sqrt(h0)*r + 4*Fc0*(h0-r) + 4*Fd*(h0-r) + 4*h0*Fh0 - 4*Fh0*r) / (2*pi*h0^2*(h0-2*r)^2)) * (h-h0) + ...
         (1/(2*pi*h0*r - pi*h0^2))*(Fh - Fh0) + ...
         (1/(2*pi*h0*r - pi*h0^2))*(Fc - Fc0);


    T = (Fh*Th +Fc*Tc + Fd*Td - alpha*sqrt(h)*T) / (((pi*h^2)/3) * (3*r-h));
    X = [h_; T];
    
end

