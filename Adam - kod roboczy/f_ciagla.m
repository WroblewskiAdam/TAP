function [X] = f_ciagla(t, X)
	global Fh_in Fc_in Fd_in Th Tc Td alpha r tau_c tau_h Fd
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

	h_ = (Fh +Fc + Fd - alpha*sqrt(h)) / (2*pi*r*h - pi*h^2);
  
    T = (Fh*Th + Fc*Tc + Fd*Td - alpha*sqrt(h)*T-(Fh + Fc + Fd - alpha*sqrt(h))*T)/(pi*h^2*r + pi*h^3/3);

    X = [h_; T];
    
end

