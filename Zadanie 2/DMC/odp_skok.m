clear all;
clc;
close all;

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

start = 221;
Tp = 10; 
Ts = 10000+start;
steps = round(Ts/Tp);


%wartości początkowe
Fh_in(1:steps) = 27;
Fc_in(1:steps) = 50;
u1 = Fh_in;
u2 = Fc_in;


h(1:steps) = h_pp;
T(1:steps) = T_pp;


odpowiedz_skokowa(:,:,2) = zeros(2);

sterowania = ["u1", "u2"];
for i = 1:2
    sterowanie = sterowania(i);
    
    if sterowanie == "u1"
        u1(start:Ts) = 30;
        u2(start:Ts) = 50;
    end
    if sterowanie == "u2"
        u1(start:Ts) = 27;
        u2(start:Ts) = 60;
    end
    Fh_in = u1;
    Fc_in = u2;
    
    for k = start:steps+start
        [h,T] = obiekt(h, T, Fh_in, Fc_in, Fd, tau_h, tau_c,alpha, Tp, k, r);
    end
    h_d = h;
    T_d = T;
    
    % [h_d, T_d] = obiekt_dyskretny(Ts, h_pp, T_pp, Tp);
    y1 = h_d;
    y2 = T_d;
    
    discrete_time = 1:Tp:Ts-start;
    y1 = y1(start:length(discrete_time));
    y2 = y2(start:length(discrete_time));
    
    if sterowanie == "u1"
        u1_step = u1(start) - u1(start-1);
        y1_skal_u1 = (y1 - y1(1))/(u1_step);
        y2_skal_u1 = (y2 - y2(1))/(u1_step);
    else
        u2_step = u2(start) - u2(start-1);
        y1_skal_u2 = (y1 - y1(1))/(u2_step);
        y2_skal_u2 = (y2 - y2(1))/(u2_step);
    end
end

figure(1)   
grid on
stairs( y1_skal_u1,'color','blue');
title('y1 skok u1 ');

figure(2)   
grid on
stairs( y2_skal_u1,'color','blue');
title('y2 skok u1 ');

figure(3)   
grid on
stairs( y1_skal_u2,'color','blue');
title('y1 skok u2 ');

figure(4)   
grid on
stairs( y2_skal_u2,'color','blue');
title('y2 skok u2 ');


for k = 1:length(y1_skal_u1)
    if k == 24
        disp(k)
    end
    odpowiedz_skokowa(:,:,k) = [y1_skal_u1(k), y1_skal_u2(k);
                                y2_skal_u1(k), y2_skal_u2(k)];
end

% save('odp_skok_Tp10.mat', 'odpowiedz_skokowa')

