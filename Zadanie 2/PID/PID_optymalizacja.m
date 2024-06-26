% clear all;
% close all;
% clc;

% dolne ograniczenia
lb = [-5, -5, -5, -5, -5, -5];

% gorne ograniczenia
ub = [5, 5, 5, 5, 5, 5];

% poczatkowe parametry
start_params = [-1, 1, 1, 1, 1, 1];

optimal_params_PID = fmincon(@PID, start_params, [], [], [], [], lb, ub);
disp(optimal_params_PID)