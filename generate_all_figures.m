%% GENERATE_ALL_FIGURES - Reproduce every figure of the revised manuscript
%
% Runs in MATLAB (R2020b+) and GNU Octave (>= 8). Total run time is roughly
% 10-20 minutes. Numbers quoted in the manuscript are printed to the console
% (and to results_log.txt) and stored in results_main.mat / results_supp.mat.
%
% Author: Mehdi Borjkhani
% Date: 2026 (revision)

clear; close all; clc;
diary('results_log.txt');
fprintf('Dendritic neighbourhood plasticity model - revised figures (%s)\n\n', datestr(now));
generate_main_figures;
generate_supp_figures;
convergence_check;
diary off;
