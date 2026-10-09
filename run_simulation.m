function [t, rec] = run_simulation(p, stim_func, opts)
%% RUN_SIMULATION - Forward-Euler integration of the neighbourhood plasticity model
%
%   [t, rec] = run_simulation(p)
%   [t, rec] = run_simulation(p, @stim_protocol, struct('record', true, 'verbose', true))
%
% p.stim_strengths may be 1xN (one condition) or KxN (K conditions simulated in
% parallel, vectorized). p.w_init may be scalar, 1xN or KxN; p.R_init scalar or Kx1.
%
% Outputs
%   t   : time vector (ms)
%   rec : summary statistics (always) and target-synapse traces (opts.record)
%     rec.dw        K x N  final weight change
%     rec.w_final   K x N  final weights
%     rec.R_final   K x 1  final pool content
%     rec.R_min     K x 1  minimum pool content
%     rec.Ca_peak   K x N  peak spine calcium
%     rec.Vs_peak   K x N  peak spine-head voltage
%     rec.Vd_peak   K x 1  peak branch voltage
%     rec.total0 / rec.total_final : sum(w) + R before / after (conservation check)
%   traces (nT x K, target synapse unless noted): rec.Vd, rec.Vs, rec.Ca, rec.w, rec.R, rec.B
%
% Author: Mehdi Borjkhani
% Date: 2026 (revision)

if nargin < 2 || isempty(stim_func), stim_func = @stim_protocol; end
if nargin < 3, opts = struct(); end
if ~isfield(opts, 'record'),  opts.record  = false; end
if ~isfield(opts, 'verbose'), opts.verbose = false; end

S = p.stim_strengths;
[K, N] = size(S);

%% ==================== Initial state ====================
y.Vd = p.E_L * ones(K, 1);
y.Vs = p.E_L * ones(K, N);
y.sA = zeros(K, N);
y.sN = zeros(K, N);
y.Ca = p.Ca_rest * ones(K, N);
y.w  = expand_to(p.w_init, K, N);
if isfield(p, 'wE_init') && ~isempty(p.wE_init)
    y.wE = expand_to(p.wE_init, K, N);   % expressed weights carried over from a previous epoch
else
    y.wE = y.w;
end
y.R  = expand_to(p.R_init, K, 1);
w0 = y.w;

%% ==================== Integration ====================
t = (0:p.dt:p.T_total)';
nT = numel(t);

rec.Ca_peak = y.Ca;
rec.Vs_peak = y.Vs;
rec.Vd_peak = y.Vd;
rec.R_min   = y.R;
rec.total0  = sum(y.w, 2) + y.R;

if opts.record
    rec.Vd = zeros(nT, K); rec.Vs = zeros(nT, K); rec.Ca = zeros(nT, K);
    rec.w  = zeros(nT, K); rec.R  = zeros(nT, K); rec.B  = zeros(nT, K);
end

for k = 1:nT
    [dy, Vs, B] = model_odes(t(k), y, p, stim_func);
    y.Vs = Vs;

    if opts.record
        rec.Vd(k, :) = y.Vd'; rec.Vs(k, :) = Vs(:, 1)'; rec.Ca(k, :) = y.Ca(:, 1)';
        rec.w(k, :)  = y.w(:, 1)'; rec.R(k, :) = y.R'; rec.B(k, :) = B(:, 1)';
    end
    if k == nT, break; end

    % Euler step with bounds
    y.Vd = y.Vd + p.dt .* dy.Vd;
    y.sA = y.sA + p.dt .* dy.sA;
    y.sN = y.sN + p.dt .* dy.sN;
    y.Ca = max(0, y.Ca + p.dt .* dy.Ca);
    y.wE = y.wE + p.dt .* dy.wE;
    y.w  = min(p.w_max, max(p.w_min, y.w + p.dt .* dy.w));
    y.R  = max(0, y.R + p.dt .* dy.R);

    rec.Vd_peak = max(rec.Vd_peak, y.Vd);
    rec.Vs_peak = max(rec.Vs_peak, Vs);
    rec.Ca_peak = max(rec.Ca_peak, y.Ca);
    rec.R_min   = min(rec.R_min, y.R);
end

%% ==================== Summary ====================
rec.w_final  = y.w;
rec.wE_final = y.wE;
rec.dw       = y.w - w0;
rec.R_final  = y.R;
rec.total_final = sum(y.w, 2) + y.R;
rec.params   = p;

if opts.verbose
    fprintf('Simulation complete (K = %d conditions, N = %d synapses).\n', K, N);
    for c = 1:min(K, 10)
        fprintf('  [%d] target dw = %+.4f | peak Ca = %.3f | peak V_d = %.1f mV | R_final = %.3f\n', ...
            c, rec.dw(c, 1), rec.Ca_peak(c, 1), rec.Vd_peak(c), rec.R_final(c));
    end
end

end

function X = expand_to(x, K, N)
% Expand scalar / row / column / full input to a K x N matrix
if isscalar(x)
    X = x * ones(K, N);
elseif isequal(size(x), [1, N])
    X = repmat(x, K, 1);
elseif isequal(size(x), [K, 1])
    X = repmat(x, 1, N);
else
    X = x;
end
end
