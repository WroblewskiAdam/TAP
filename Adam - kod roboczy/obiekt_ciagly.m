function [h_out, T_out, t] = obiekt_ciagly(zlin, Ts, h_0, T_0)

if zlin == 0
    [t, out] = ode45(@(t, X) f_ciagla(t,X), [0 Ts], [h_0 T_0]);
else
    [t, out] = ode45(@(t, X) f_ciagla_zlin(t,X), [0 Ts], [h_0 T_0]);
end
%zakres czasu i punkty początkowe
h_out = out(:,1);
T_out = out(:,2);
end