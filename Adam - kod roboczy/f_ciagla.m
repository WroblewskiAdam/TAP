function [X] = f_ciagla(t, X)
	global Fh_in Fc_in Th Tc Td alpha r tau_c tau_h Fd

    h = X(1,:);
    T = X(2,:);

    
    %opóźnienie
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

    % równania stanu
	h_ = (Fh + Fc + Fd - alpha*sqrt(h)) / (2*pi*r*h - pi*h^2);
  
    % T = (Fh*Th + Fc*Tc + Fd*Td - alpha*sqrt(h)*T - T*(Fh + Fc + Fd - alpha*sqrt(h)))/(pi*h^2*r - pi*h^3/3);
    T = (-T*(Fh+Fc+Fd) + Fh*Th + Fc*Tc + Fd*Td) /(pi*h^2*r - pi*h^3/3); 


    X = [h_; T];
end

