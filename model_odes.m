function dydt = model_odes(t, y, p, stim_func)
%% MODEL_ODES - Differential equations for neighborhood plasticity model
%
% Supports N>=2 synapses with toggleable mechanisms for ablation studies.
%
% STATE VECTOR LAYOUT (for N synapses):
%   y(1)              : V_d (shared dendritic voltage, mV)
%   y(2:N+1)          : s_AMPA_i (AMPA activation, dimensionless 0-1)
%   y(N+2:2N+1)       : s_NMDA_i (NMDA activation, dimensionless 0-1)
%   y(2N+2:3N+1)      : Ca_i (local calcium, normalized)
%   y(3N+2:4N+1)      : w_i (synaptic weights, normalized)
%   y(4N+2)           : R (shared resource, normalized 0-1)
%
% KINETICS:
%   AMPA: ds/dt = -s/tau_AMPA + I_stim * (1-s)
%   NMDA: ds/dt = -s/tau_NMDA_decay + I_stim * (1-s) / tau_NMDA_rise
%   (saturating kinetics prevent s > 1)
%
% Author: Mehdi Borjkhani
% Date: 2025

N = p.N_syn;

%% ==================== Unpack State Vector ====================
V_d = y(1);
s_AMPA = y(2:N+1);
s_NMDA = y(N+2:2*N+1);
Ca = y(2*N+2:3*N+1);
w = y(3*N+2:4*N+1);
R = y(4*N+2);

%% ==================== Get Stimulation Input ====================
I_stim = stim_func(t, p);  % Returns N×1 vector of stimulation for each synapse

%% ==================== Initialize Derivatives ====================
dydt = zeros(size(y));

%% ==================== Synaptic Activation Kinetics ====================
for i = 1:N
    % AMPA: fast kinetics with saturation
    % ds/dt = -s/tau + I*(1-s) ensures s stays in [0,1]
    dydt(1+i) = -s_AMPA(i)/p.tau_AMPA + I_stim(i)*(1 - s_AMPA(i));
    
    % NMDA: slower kinetics with dual exponential approximation
    % Rise phase driven by input, decay phase passive
    dydt(N+1+i) = -s_NMDA(i)/p.tau_NMDA_decay + I_stim(i)*(1 - s_NMDA(i))/p.tau_NMDA_rise;
end

%% ==================== NMDA Mg2+ Block ====================
if p.use_Mg_block
    % Voltage-dependent block (Jahr & Stevens, 1990)
    B_Mg = 1 / (1 + p.Mg_conc * exp(-(V_d - p.V_half_Mg)/p.k_Mg));
else
    % Ablation: remove voltage dependence
    B_Mg = 1.0;
end

%% ==================== Synaptic Currents ====================
I_AMPA_total = 0;
I_NMDA_total = 0;

for i = 1:N
    % Distance attenuation (optional)
    if p.use_distance_atten && i > 1
        atten = exp(-(i-1)*p.distance / p.lambda_space);
    else
        atten = 1.0;
    end
    
    % AMPA current (fast, voltage-independent)
    I_AMPA_i = p.g_AMPA * w(i) * s_AMPA(i) * (p.E_AMPA - V_d) * atten;
    
    % NMDA current (slow, voltage-dependent via Mg block)
    I_NMDA_i = p.g_NMDA * w(i) * s_NMDA(i) * B_Mg * (p.E_NMDA - V_d) * atten;
    
    % Voltage coupling control
    if p.voltage_coupling || i == 1
        % All synapses contribute to Vd (or only target if coupling disabled)
        I_AMPA_total = I_AMPA_total + I_AMPA_i;
        I_NMDA_total = I_NMDA_total + I_NMDA_i;
    end
end

%% ==================== Dendritic Voltage Dynamics ====================
I_leak = p.g_L * (p.E_L - V_d);
dydt(1) = (I_leak + I_AMPA_total + I_NMDA_total) / p.C_d;

%% ==================== Calcium Dynamics ====================
for i = 1:N
    % Calcium influx proportional to NMDA current (through NMDA-gated Ca channels)
    Ca_influx = p.alpha_Ca * p.g_NMDA * w(i) * s_NMDA(i) * B_Mg;
    
    % First-order decay to resting level
    dydt(2*N+1+i) = (p.Ca_rest - Ca(i))/p.tau_Ca + Ca_influx;
end

%% ==================== Plasticity Rule ====================
% Calcium-threshold rule with resource gating

% Effective resource level
if p.use_resource
    R_eff = R;
else
    % Ablation: unlimited resource
    R_eff = 1.0;
end

for i = 1:N
    dw = 0;
    
    if R_eff > p.R_threshold
        if Ca(i) > p.theta_LTD && Ca(i) < p.theta_LTP
            % LTD zone: moderate calcium
            dw = -p.eta_LTD * (Ca(i) - p.theta_LTD) * R_eff;
        elseif Ca(i) >= p.theta_LTP
            % LTP zone: high calcium
            dw = p.eta_LTP * (Ca(i) - p.theta_LTP) * R_eff;
        end
    end
    
    % Enforce weight bounds (soft bounds via clipping)
    w_new = w(i) + dw * p.dt;
    if w_new < p.w_min
        dw = (p.w_min - w(i)) / p.dt;
    elseif w_new > p.w_max
        dw = (p.w_max - w(i)) / p.dt;
    end
    
    dydt(3*N+1+i) = dw;
end

%% ==================== Resource Dynamics ====================
if p.use_resource
    % Resource consumption proportional to plasticity activity
    consumption = 0;
    for i = 1:N
        if Ca(i) > p.theta_LTD
            consumption = consumption + p.kappa * abs(Ca(i) - p.theta_LTD);
        end
    end
    
    % Recovery toward maximum + consumption
    dydt(4*N+2) = (p.R_max - R)/p.tau_R - consumption;
else
    dydt(4*N+2) = 0;
end

end
