clear all;

% stałe
global Fh_in Fc_in Th Tc Td alpha r tau_c tau_h Fd h_pp T_pp h0;
r = 68;
alpha = 25;

% punkt pracy
Tc = 17;
Th = 75;Td = 42;  
Fd = 15;
tau_c = 170;
tau_h = 220;
h_pp = 13.5424;
T_pp = 38.0978;

Tp = 20;

Ts = 8000;

h0 = 13.5424;

Fc_in(1:400) = 50;
Fh_in(1:400) = 27;
Fc_in(400:Ts) = 50;

Fcins = [24 25 26 27 28 29 30];

for i=1:length(Fcins)
    
    Fh_in(401:Ts) = Fcins(i);

    [h, T, t] = obiekt_ciagly(0, Ts, h_pp, T_pp);
    [h_lin, T_lin, t_lin] = obiekt_ciagly(1, Ts, h_pp, T_pp);

    subplot(2,1,1)
    stairs(h, "m");
    hold on
    subplot(2,1,2)
    stairs(T, "m");
    hold on

    subplot(2,1,1)
    stairs(h_lin, "b");
    xlabel("t"); ylabel("h");
    title("Przebieg h");
    legend("nlin", "lin")
    hold on
    subplot(2,1,2)
    stairs(T_lin, "b");
    xlabel("t"); ylabel("T");
    title("Przebieg T");
    legend("nlin", "lin")
    hold on
end
