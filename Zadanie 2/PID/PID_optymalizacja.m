clear all;
close all;
clc;

% dolne ograniczenia
lb = [-3, -2, -3, -2, -2 -2];

% gorne ograniczenia
ub = [2, 2, 2, 2, 2, 2];

% poczatkowe parametry
start_params = [-1.5, 0, 0, 1.5, 0, 0];

optimal_params_PID = fmincon(@PID,start_params, [], [], [], [], lb, ub);
disp(optimal_params_PID)