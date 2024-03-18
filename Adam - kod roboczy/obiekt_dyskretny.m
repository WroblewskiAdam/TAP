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


   % if h1(k)<= 0
   %     h1(k) = 0.0001;
   % end
   % if h2(k)<= 0
   %     h2(k) = 0.0001;
   % end
	

    h0 = h_pp;
	h(k) = h(k-1) + Tp * ((1/(2*pi*r*h0 - pi*h0^2) + (2*h0-2*r)/(pi*h0^2*(h0-2*r)^2)*(h(k-1)-h0)) * (Fh +Fc + Fd - alpha*(sqrt(h0) + 1/(2*sqrt(h0))*(h(k-1)-h0))));
    
    T(k) = T(k-1) + Tp * ((Fh*Th +Fc*Tc + Fd*Td - alpha*sqrt(h(k-1))*T(k-1)) / (((pi*h(k-1)^2)/3) * (3*r-h(k-1))));


	
   
end
% h = h';
% T = T';
% h_mod1(1:620) = h_pp; 
% h_mod2 = repelem(h(620:end),Tp);
% h_mod = [h_mod1, h_mod2];
% 
% T_mod1(1:620) = T_pp; 
% T_mod2 = repelem(T(620:end),Tp);
% T_mod = [T_mod1, T_mod2];
% 
% h_out = h_mod(1:start+t_sim);
% T_out = T_mod(1:start+t_sim);


h_out = h(1:end);
T_out = T(1:end);
end