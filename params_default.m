function p = params_default()
%% PARAMS_DEFAULT - Default parameters for neighborhood plasticity model
%
% UNITS CONVENTION:
%   - Time: milliseconds (ms)
%   - Voltage: millivolts (mV)
%   - Calcium: normalized units (0-1 scale, ~0.1 = resting, ~1 = strong activation)
%   - Conductance: normalized (dimensionless)
%   - Weights: normalized (0 to w_max)
%   - Resource: normalized (0 to 1)
%
% Author: Mehdi Borjkhani
% Date: 2025

%% ==================== Simulation Parameters ====================
p.dt = 0.1;              % Time step (ms)
p.T_total = 500;         % Total simulation time (ms)

%% ==================== Network Structure ====================
p.N_syn = 2;             % Number of synapses [can be increased for N>2 simulations]
p.w_init = 0.5;          % Initial weight (scalar, applied to all synapses)

%% ==================== Dendritic Compartment ====================
% Single-compartment model for the dendritic branch
p.C_d = 1.0;             % Membrane capacitance (µF/cm², normalized)
p.g_L = 0.05;            % Leak conductance (mS/cm², normalized)
p.E_L = -70;             % Leak reversal potential (mV)
p.V_rest = -70;          % Resting potential (mV)

%% ==================== AMPA Receptor Kinetics ====================
% First-order kinetics: ds/dt = -s/tau + I_stim
p.g_AMPA = 0.5;          % AMPA max conductance (normalized)
p.E_AMPA = 0;            % AMPA reversal potential (mV)
p.tau_AMPA = 5;          % AMPA decay time constant (ms)
                         % Based on: Jonas et al., 1993; tau_decay ~ 2-10 ms

%% ==================== NMDA Receptor Kinetics ====================
% Dual-exponential kinetics with voltage-dependent Mg2+ block
p.g_NMDA = 0.5;          % NMDA max conductance (normalized)
p.E_NMDA = 0;            % NMDA reversal potential (mV)
p.tau_NMDA_rise = 5;     % NMDA rise time constant (ms)
p.tau_NMDA_decay = 100;  % NMDA decay time constant (ms)
                         % Based on: Lester et al., 1990; tau_decay ~ 50-150 ms

% Mg2+ block parameters (Jahr & Stevens, 1990)
p.Mg_conc = 1.0;         % Extracellular Mg2+ concentration (mM)
p.V_half_Mg = -25;       % Half-activation voltage for Mg block (mV)
p.k_Mg = 10;             % Slope factor for Mg block (mV)
                         % B(V) = 1 / (1 + [Mg]*exp(-(V-V_half)/k))

%% ==================== Calcium Dynamics ====================
% Simplified calcium model: influx through NMDA, first-order decay
p.tau_Ca = 30;           % Calcium decay time constant (ms)
                         % Based on: Sabatini et al., 2002; spine Ca decay ~ 10-100 ms
p.Ca_rest = 0.1;         % Resting calcium level (normalized, ~50-100 nM)
p.alpha_Ca = 0.8;        % Ca influx scaling factor (normalized)
                         % Converts NMDA current to calcium influx

%% ==================== Plasticity Rule ====================
% BCM-like calcium threshold rule (Shouval et al., 2002)
% LTD: theta_LTD < Ca < theta_LTP
% LTP: Ca >= theta_LTP
p.theta_LTD = 0.40;      % LTD threshold (normalized Ca)
p.theta_LTP = 0.65;      % LTP threshold (normalized Ca)
p.eta_LTD = 0.003;       % LTD learning rate (1/ms)
p.eta_LTP = 0.10;        % LTP learning rate (1/ms)

% Weight bounds (prevents runaway potentiation/depression)
p.w_min = 0.0;           % Minimum synaptic weight
p.w_max = 2.0;           % Maximum synaptic weight (2x initial)

%% ==================== Shared Resource Dynamics ====================
% Branch-level resource representing:
% - Plasticity-related proteins (PRPs)
% - Local translation capacity
% - AMPAR trafficking machinery
% - Available phosphorylation sites

p.R_max = 1.0;           % Maximum resource level (normalized)
p.R_init = 1.0;          % Initial resource level
p.tau_R = 500;           % Resource recovery time constant (ms)
                         % Fast local limiting factor; for PRPs use 60000 ms (minutes)
p.kappa = 0.02;          % Resource consumption rate per unit plasticity
p.R_threshold = 0.05;    % Minimum resource for plasticity to occur

%% ==================== Stimulation Protocol ====================
p.stim_times = [100, 150, 200];  % Stimulation times (ms) - 3 pulses at 50 Hz
p.stim_strength = 0.5;          % Default stimulation strength (normalized)
p.stim_duration = 2;            % Pulse duration (ms)

% For timing experiments
p.neighbor_delay = 0;           % Delay of neighbor relative to target (ms)

%% ==================== Coupling Parameters ====================
% These can be toggled for ablation experiments
p.use_Mg_block = true;          % Enable voltage-dependent Mg block
p.use_resource = true;          % Enable shared resource dynamics
p.voltage_coupling = true;      % Neighbors contribute to shared Vd

%% ==================== Distance Attenuation (optional) ====================
p.lambda_space = 100;    % Space constant (µm)
p.distance = 20;         % Distance between synapses (µm)
p.use_distance_atten = false;

end
