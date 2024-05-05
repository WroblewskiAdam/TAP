clear all;
close all;
clc;

% dolne ograniczenia
lb = [-4, -4, 0, -4, -4, 0];

% gorne ograniczenia
ub = [4, 2, 4, 4, 2, 4];

% poczatkowe parametry
start_params = [-1.5, 0, 0, 1.5, 0, 0];

optimal_params_PID = fmincon(@PID,start_params, [], [], [], [], lb, ub);
disp(optimal_params_PID)