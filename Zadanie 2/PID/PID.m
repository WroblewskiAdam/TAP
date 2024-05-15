% function [e, T_out, h_out, T_zad, h_zad, Fc_in, Fh_in] = PID(p)
function [e] = PID(p)
% aby uzyc PID_optymalizacja zamienic na function [e] = PID(p)

Kp1 = p(1);
Ki1 = p(2);
Kd1 = p(3);
Kp2 = p(4);
Ki2 = p(5);
Kd2 = p(6);

% K1 = p(1);
% Ti1 = p(2);
% Td1 = p(3);
% K2 = p(4);
% Ti2 = p(5);
% Td2 = p(6);


% stale

global Fh_in Fc_in Th Tc Td alpha r tau_c tau_h Fd h_pp T_pp
r = 68;
alpha = 25;

% punkt pracy
Tc = 17;
Th = 75;
Td_pp = 42;
Fc = 50;
Fh = 27;  
Fd_pp = 15;
tau_c = 170;
tau_h = 220;
h_pp = 13.5424;
T_pp = 38.0978;
r = 68;
alpha = 25;

Ts = 10000;
Tp = 10;
steps = round(Ts / Tp);
tau_c_steps = round(170 / Tp);
tau_h_steps = round(220 / Tp);

k_min = 1 + max(tau_c_steps, tau_h_steps);
k_max = steps;  

% warunki poczatkowe
Fc_in = Fc * ones(1, k_max + tau_c_steps);
Fh_in = Fh * ones(1, k_max + tau_h_steps);

h = h_pp * ones(1, k_max);
T = T_pp * ones(1, k_max);

[h_out, T_out] = obiekt_dyskretny_pid(Ts, h(1), T(1), Tp);

h_zad(1:round(k_max/3)) = h_pp;
h_zad(round(k_max/3+1):round(2*k_max/3)) = h_pp + 2;
h_zad(round(2*k_max/3+1):k_max) = h_pp - 2;

T_zad(1:round(k_max/3)) = T_pp;
T_zad(round(k_max/3+1):round(2*k_max/3)) = T_pp + 5;
T_zad(round(2*k_max/3+1):k_max) = T_pp - 5;

% k_ht = -0.1;  % wplyw T na h
% k_th = -0.054; % wplyw h na T 

k_ht = -0.1;  % wplyw T na h
k_th = -0.054; % wplyw h na T 

e1(1:k_max) = 0;
e2(1:k_max) = 0;
e = 0;

%% metoda roznic skonczonych
r0_1 = Kp1 + Ki1 * Tp + Kd1 / Tp;
r1_1 = Kp1 + 2*Kd1 / Tp;
r2_1 = Kd1 / Tp;

r0_2 = Kp2 + Ki2 * Tp + Kd2 / Tp;
r1_2 = Kp2 + 2 * Kd2 / Tp;
r2_2 = Kd2 / Tp;

%% metoda roznic wstecznych
% r0_1 = K1 * (1 + (Tp/(2*Ti1)) + (Td1/Tp));
% r1_1 = K1 * ((Tp/(2*Ti1)) - 2 * (Td1/Tp) - 1);
% r2_1 = K1 * Td1 / Tp;
% 
% r0_2 = K2 * (1 + (Tp/(2*Ti2)) + (Td2/Tp));
% r1_2 = K2 * ((Tp/(2*Ti2)) - 2 * (Td2/Tp) - 1);
% r2_2 = K2 * Td2 / Tp;

for k = k_min:k_max

    if k < round(k_max/3)
        Fd = Fd_pp;
        Td = Td_pp;
    end

    if k > round(k_max/3)-1 && k < round(2*k_max/3)
       Fd = Fd_pp - 0.1 * Fd_pp;
       Td = Td_pp + 0.1 * Td_pp;
    end

    if k > round(2*k_max/3)-1
       Fd = Fd_pp + 0.1 * Fd_pp ;
       Td = Td_pp - 0.1 * Td_pp;
    end

    [h_out, T_out] = obiekt_dyskretny_pid(Ts, h(1), T(1), Tp, Fd, Td);

    %% bez odsprzegania

    % e1(k) = T_zad(k) - T_out(k-);
    % Fc_in(k) = Fc_in(k-1) + r0_1*e1(k) + r1_1*e1(k-1) + r2_1*e1(k-2);
    % if Fc_in(k) < 0
    %     Fc_in(k) = 0;
    % end
    % 
    % e2(k) = h_zad(k) - h_out(k);
    % Fh_in(k) = Fh_in(k-1) + r0_2*e2(k) + r1_2*e2(k-1) + r2_2*e2(k-2);
    % if Fh_in(k) < 0
    %     Fh_in(k) = 0;
    % end
    % 
    % e = e + (e1(k))^2 + (e2(k))^2;

    %% z odsprzeganiem

    e1(k) = T_zad(k) - T_out(k);
    Fc_in(k) = Fc_in(k-1) + r0_1*e1(k) + r1_1*e1(k-1) + r2_1*e1(k-2) - k_ht * e2(k);

    if Fc_in(k) < 0
        Fc_in(k) = 0;
    end

    e2(k) = h_zad(k) - h_out(k);
    Fh_in(k) = Fh_in(k-1) + r0_2*e2(k) + r1_2*e2(k-1) + r2_2*e2(k-2) - k_th * e1(k);

    if Fh_in(k) < 0
        Fh_in(k) = 0;
    end

    e = e + (e1(k))^2 + (e2(k))^2;
end

% disp(e)

% figure(1)
% hold on
% plot(T_out(k_min:k_max))
% plot(T_zad(k_min:k_max))
% plot(h_out(k_min:k_max))
% plot(h_zad(k_min:k_max))
% hold off
% legend(["T_{out}", "Tzad", "h_{out}", "hzad"])
% 
% figure(2)
% hold on
% plot(Fc_in(k_min:k_max))
% plot(Fh_in(k_min:k_max))
% hold off
% legend(["Fc_{in}", "Fh_{in}"])

end

