function [dy, Vs, B] = model_odes(t, y, p, stim_func)
%% MODEL_ODES - Right-hand side of the dendritic neighbourhood plasticity model
%
% All quantities are vectorized over K parallel conditions (rows) and N synapses
% (columns); synapse 1 is the target.
%
% STATE (struct y)
%   y.Vd  : K x 1  branch voltage (mV)
%   y.Vs  : K x N  spine-head voltages (mV; algebraic, used as Newton warm start)
%   y.sA  : K x N  AMPA gating (0-1)
%   y.sN  : K x N  NMDA gating (0-1)
%   y.Ca  : K x N  spine calcium (normalized)
%   y.w   : K x N  synaptic weights
%   y.wE  : K x N  expressed weights used for the conductances
%   y.R   : K x 1  shared resource pool (weight units)
%
% EQUATIONS
%   C_d dV_d/dt   = g_L (E_L - V_d) + sum_i c_i g_neck (V_s,i - V_d)
%   0             = g_neck (V_d - V_s,i) + g_A,i (E_A - V_s,i) + g_N,i B(V_s,i)(E_N - V_s,i)
%   ds_A/dt       = -s_A/tau_A + I_i (1 - s_A)/tau_on
%   ds_N/dt       = -s_N/tau_Nd + I_i (1 - s_N)/tau_Nr
%   dCa_i/dt      = (Ca_rest - Ca_i)/tau_Ca + alpha_Ca g_N,i B(V_s,i) (E_Ca - V_s,i)/(E_Ca - E_L)
%   dw_i/dt       = eta_P [Ca_i - th_P]_+ (R/R0)(1 - w_i/w_max) - eta_D [Ca_i - th_D]_+ w_i
%   dR/dt         = -sum_i dw_i/dt + (R0 - R)/tau_R
%   dw_E,i/dt     = (w_i - w_E,i)/tau_E
% with g_A,i = g_AMPA w_E,i s_A,i and g_N,i = g_NMDA w_E,i s_N,i.
%
% Author: Mehdi Borjkhani
% Date: 2026 (revision)

N = size(y.sA, 2);

%% Presynaptic drive
I = stim_func(t, p);

%% Synaptic conductances (expressed weights)
gA = p.g_AMPA .* y.wE .* y.sA;
gN = p.g_NMDA .* y.wE .* y.sN;

%% Spine-head voltages (quasi-steady state)
Vs = spine_voltage(y.Vd, y.Vs, gA, gN, p);
B  = mg_block(Vs, p);

%% Branch voltage
if p.voltage_coupling
    c = ones(1, N);
else
    c = [1, zeros(1, N - 1)];            % only the target spine loads the branch
end
I_neck = p.g_neck .* (Vs - y.Vd) .* c;   % current from each spine into the branch (pA)
dy.Vd = (p.g_L .* (p.E_L - y.Vd) + sum(I_neck, 2)) ./ p.C_d;

%% Receptor gating
dy.sA = -y.sA ./ p.tau_AMPA + I .* (1 - y.sA) ./ p.tau_on;
dy.sN = -y.sN ./ p.tau_NMDA_decay + I .* (1 - y.sN) ./ p.tau_NMDA_rise;

%% Spine calcium (NMDA-receptor-mediated influx)
dy.Ca = (p.Ca_rest - y.Ca) ./ p.tau_Ca + ...
        p.alpha_Ca .* gN .* B .* (p.E_Ca - Vs) ./ (p.E_Ca - p.E_L);

%% Plasticity: conserved-resource rule
if p.use_resource
    r = y.R ./ p.R0;
else
    r = ones(size(y.R));                 % unlimited pool
end
J_LTP = p.eta_LTP .* max(y.Ca - p.theta_LTP, 0) .* r .* (1 - y.w ./ p.w_max);
J_LTD = p.eta_LTD .* max(y.Ca - p.theta_LTD, 0) .* y.w;
dy.w  = J_LTP - J_LTD;

%% Shared pool
if p.use_resource
    dy.R = -sum(dy.w, 2) + (p.R0 - y.R) ./ p.tau_R;
else
    dy.R = zeros(size(y.R));
end

%% Slow expression of weight changes in the conductances
dy.wE = (y.w - y.wE) ./ p.tau_E;

end
