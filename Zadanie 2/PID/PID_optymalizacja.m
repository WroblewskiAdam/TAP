% clear all;
% close all;
% clc;

% dolne ograniczenia
lb = [-10, -10, -10, -10, -10, -10];

% gorne ograniczenia
ub = [10, 10, 10, 10, 10, 10];

% poczatkowe parametry
start_params = [1, 0, 1, 1, 0, 1];

optimal_params_PID = fmincon(@PID, start_params, [], [], [], [], lb, ub);
disp(optimal_params_PID)