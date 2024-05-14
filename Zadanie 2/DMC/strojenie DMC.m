% clear all;
% close all;
% clc;


% dolne ograniczenia
lb = [0.001, 0.001];

% gorne ograniczenia
ub = [10000, 10000];

% poczatkowe parametry
start_params =  [110, 10000];

optimal_params_PID = fmincon(@strojenie_DMC,start_params, [], [], [], [], lb, ub);
disp(optimal_params_PID)
