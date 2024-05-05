function e = PID(p)

Kp1 = p(1);
Ki1 = p(2);
Kd1 = p(3);
Kp2 = p(4);
Ki2 = p(5);
Kd2 = p(6);

% stale

global Fh_in Fc_in Th Tc Td alpha r tau_c tau_h Fd h_pp T_pp
r = 68;
alpha = 25;

% punkt pracy
Tc = 17;
Th = 75;
Td = 42;
Fc = 50;
Fh = 27;  
Fd = 15;
tau_c = 170;
tau_h = 220;
h_pp = 13.5424;
T_pp = 38.0978;
r = 68;
alpha = 25;

t_sim = 8000;
Tp = 10;
steps = round(t_sim / Tp);
tau_c_steps = round(170 / Tp);
tau_h_steps = round(220 / Tp);

k_min = 1 + max(tau_c_steps, tau_h_steps);
k_max = steps;  

Fc_in = Fc * ones(1, k_max + tau_c_steps);
Fh_in = Fh * ones(1, k_max + tau_h_steps);

h = h_pp * ones(1, k_max);
T = T_pp * ones(1, k_max);

h_out(1:k_max) = h_pp;
T_out(1:k_max) = T_pp;

h_zad(1:round(k_max/3)) = h_pp;
h_zad(round(k_max/3):round(2*k_max/3)) = h_pp + 2;
h_zad(round(2*k_max/3):k_max) = h_pp - 2;

T_zad(1:round(k_max/3)) = T_pp;
T_zad(round(k_max/3):round(2*k_max/3)) = T_pp + 5;
T_zad(round(2*k_max/3):k_max) = T_pp - 5;


e1(1:k_max) = 0;
e2(1:k_max) = 0;
e = 0;

r0_1 = Kp1 + Ki1 * Tp + Kd1 / Tp;
r1_1 = Kp1 + 2*Kd1 / Tp;
r2_1 = Kd1 / Tp;

r0_2 = Kp2 + Ki2 * Tp + Kd2 / Tp;
r1_2 = Kp2 + 2 * Kd2 / Tp;
r2_2 = Kd2 / Tp;

for k = k_min:k_max

    e1(k) = T_zad(k) - T_out(k-1);
    Fc_in(k) = Fc_in(k-1) + r0_1*e1(k) - r1_1*e1(k-1) + r2_1*e1(k-2);
    if Fc_in(k) < 0
        Fc_in(k) = 0;
    end

    e2(k) = h_zad(k) - h_out(k-1);
    Fh_in(k) = Fh_in(k-1) + r0_2*e2(k) - r1_2*e2(k-1) + r2_2*e2(k-2);
    if Fh_in(k) < 0
        Fh_in(k) = 0;
    end

    e = e + abs(e1(k)) + abs(e2(k));
end

[h_out, T_out] = obiekt_dyskretny_pid(t_sim, h(1), T(1), Tp);

figure(1)
hold on
plot(T_out(k_min:k_max))
plot(T_zad(k_min:k_max))
plot(h_out(k_min:k_max))
plot(h_zad(k_min:k_max))
hold off
legend(["T_{out}", "T_{zad}", "h_{out}", "h_{zad}"])

figure(2)
hold on
plot(Fc_in(k_min:k_max))
plot(Fh_in(k_min:k_max))
hold off
legend(["Fcin", "Fh"])
end

