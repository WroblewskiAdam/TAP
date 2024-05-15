clear;
close all;
clc;

% dolne ograniczenia
lb = [50, 20, 1, 1, 1, 1 ];

% gorne ograniczenia
ub = [300, 300, 100, 100, 100, 100];

% poczatkowe parametry
start_params =  [100, 50, 1,1,1,1];

optimal_params_PID = fmincon(@strojenie_DMC,start_params, [], [], [], [], lb, ub);
disp(optimal_params_PID)
