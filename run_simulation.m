function [t, sol, rec] = run_simulation(p, stim_func, verbose)
%% RUN_SIMULATION - Run the neighborhood plasticity model
%
% Supports N >= 2 synapses with full state recording.
%
% Inputs:
%   p         - Parameters struct
%   stim_func - Stimulation function handle (default: @stim_protocol)
%   verbose   - Print results (default: false)
%
% Outputs:
%   t   - Time vector (ms)
%   sol - Full solution matrix
%   rec - Struct with parsed variables and summary statistics
%
% Author: Mehdi Borjkhani
% Date: 2025

if nargin < 2 || isempty(stim_func)
    stim_func = @stim_protocol;
end
if nargin < 3
    verbose = false;
end

N = p.N_syn;

%% ==================== Initialize State Vector ====================
% Layout: [V_d, s_AMPA(1:N), s_NMDA(1:N), Ca(1:N), w(1:N), R]
n_states = 4*N + 2;
y0 = zeros(n_states, 1);

y0(1) = p.V_rest;                           % Dendritic voltage
y0(2:N+1) = 0;                              % AMPA activation
y0(N+2:2*N+1) = 0;                          % NMDA activation
y0(2*N+2:3*N+1) = p.Ca_rest;                % Calcium

% Initial weights (scalar or vector)
if isscalar(p.w_init)
    y0(3*N+2:4*N+1) = p.w_init * ones(N, 1);
else
    y0(3*N+2:4*N+1) = p.w_init(:);
end

y0(4*N+2) = p.R_init;                       % Resource

%% ==================== Run Simulation (Euler) ====================
t_span = 0:p.dt:p.T_total;
n_steps = length(t_span);

sol = zeros(n_steps, n_states);
sol(1, :) = y0';

y = y0;
for i = 2:n_steps
    dydt = model_odes(t_span(i-1), y, p, stim_func);
    y = y + dydt * p.dt;
    
    % Enforce bounds
    y(3*N+2:4*N+1) = max(p.w_min, min(p.w_max, y(3*N+2:4*N+1)));  % Weights
    y(4*N+2) = max(0, min(p.R_max, y(4*N+2)));                      % Resource
    y(2*N+2:3*N+1) = max(0, y(2*N+2:3*N+1));                        % Calcium (non-negative)
    
    sol(i, :) = y';
end

t = t_span';

%% ==================== Parse Results ====================
rec.V_d = sol(:, 1);
rec.s_AMPA = sol(:, 2:N+1);
rec.s_NMDA = sol(:, N+2:2*N+1);
rec.Ca = sol(:, 2*N+2:3*N+1);
rec.w = sol(:, 3*N+2:4*N+1);
rec.R = sol(:, 4*N+2);

% Compute Mg-block over time
if p.use_Mg_block
    rec.B_Mg = 1 ./ (1 + p.Mg_conc * exp(-(rec.V_d - p.V_half_Mg)/p.k_Mg));
else
    rec.B_Mg = ones(size(rec.V_d));
end

% Summary statistics
if isscalar(p.w_init)
    w_init_vec = p.w_init * ones(N, 1);
else
    w_init_vec = p.w_init(:);
end
rec.dw_final = rec.w(end, :)' - w_init_vec;
rec.Ca_peak = max(rec.Ca, [], 1)';
rec.R_final = rec.R(end);
rec.R_min = min(rec.R);

% Store parameters for reference
rec.params = p;
rec.N_syn = N;

%% ==================== Print Summary ====================
if verbose
    fprintf('Simulation complete (N=%d synapses).\n', N);
    fprintf('  Target (syn 1): Δw = %.4f, Peak Ca = %.3f\n', rec.dw_final(1), rec.Ca_peak(1));
    if N > 1
        fprintf('  Neighbors:      Δw = [');
        fprintf('%.3f ', rec.dw_final(2:end));
        fprintf(']\n');
    end
    fprintf('  Resource:       R_final = %.4f, R_min = %.4f\n', rec.R_final, rec.R_min);
end

end
