function p = params_default()
%% PARAMS_DEFAULT - Default parameters for the dendritic neighbourhood plasticity model
%
% Revised model (v2.0). Main changes relative to v1.0:
%   * Each synapse sits on a spine head (quasi-steady-state compartment) that
%     is coupled to a shared dendritic-branch compartment through a spine-neck
%     conductance. Conductances are calibrated so that a single input produces a
%     ~17 mV spine-head EPSP and a ~1.4 mV branch EPSP (Harnett et al., 2012;
%     Magee, 2000), instead of the ~29 mV branch EPSP of v1.0.
%   * NMDA Mg2+ block uses the Jahr & Stevens (1990) expression.
%   * The shared resource R is a conserved pool (in weight units): LTP moves
%     resource from R into the synaptic weight, LTD returns it to R. LTD is
%     proportional to w_i, LTP to R/R0 and to (1 - w_i/w_max) (soft bounds).
%   * The depression process is active whenever Ca > theta_LTD (also above
%     theta_LTP), as in Graupner & Brunel (2012); there is no hard R threshold.
%   * Synaptic conductances use the *expressed* weight w_E, which follows w
%     with a slow expression time constant tau_E (minutes), so that weight
%     changes do not feed back into the induction currents within milliseconds.
%
% UNITS
%   time ms | voltage mV | conductance nS | capacitance pF | current pA
%   calcium: normalized (resting = 0.1) | weights and resource: weight units
%
% Author: Mehdi Borjkhani
% Date: 2026 (revision)

%% ==================== Simulation ====================
p.dt      = 0.1;          % Euler time step (ms)
p.T_total = 400;          % Total simulation time (ms)

%% ==================== Branch structure ====================
p.N_syn   = 21;           % Synapses on the branch segment: 1 target + 20 neighbours
p.w_init  = 0.5;          % Initial weight (scalar, 1xN or KxN)

%% ==================== Dendritic branch compartment ====================
p.C_d   = 100;            % Effective branch capacitance (pF)
p.g_L   = 5;              % Effective branch input conductance (nS) -> R_in = 200 MOhm
p.E_L   = -70;            % Resting / leak reversal potential (mV); tau_d = C_d/g_L = 20 ms

%% ==================== Spine compartments ====================
p.g_neck = 2;             % Spine-neck conductance (nS) -> R_neck = 500 MOhm (Harnett et al., 2012)
p.newton_iter = 4;        % Newton iterations for the quasi-steady-state spine voltage

%% ==================== AMPA receptors ====================
p.g_AMPA   = 2;           % Maximal AMPA conductance per unit weight (nS)
p.E_AMPA   = 0;           % Reversal potential (mV)
p.tau_AMPA = 5;           % Decay time constant (ms) (Jonas et al., 1993)
p.tau_on   = 1;           % Reference activation time constant (ms): AMPA activation rate = s_i/tau_on

%% ==================== NMDA receptors ====================
p.g_NMDA         = 6;     % Maximal NMDA conductance per unit weight (nS)
p.E_NMDA         = 0;     % Reversal potential (mV)
p.tau_NMDA_rise  = 5;     % Rise (binding) time constant (ms)
p.tau_NMDA_decay = 100;   % Decay time constant (ms) (Lester et al., 1990)
% Mg2+ block, Jahr & Stevens (1990): B(V) = 1/(1 + [Mg]/3.57 * exp(-0.062 V))
p.Mg_conc = 1.0;          % Extracellular [Mg2+] (mM)
p.Mg_K    = 3.57;         % (mM)
p.Mg_a    = 0.062;        % (1/mV)

%% ==================== Spine calcium ====================
p.tau_Ca   = 30;          % Decay time constant (ms) (Sabatini et al., 2002)
p.Ca_rest  = 0.1;         % Resting calcium (normalized)
p.alpha_Ca = 0.2;         % Influx scaling (normalized Ca per nS per ms, i.e. nS^-1 ms^-1)
p.E_Ca     = 130;         % Effective Ca reversal used for the driving-force factor (mV)

%% ==================== Plasticity rule ====================
% dw_i/dt = J_LTP,i - J_LTD,i
%   J_LTP,i = eta_LTP [Ca_i - theta_LTP]_+ (R/R0) (1 - w_i/w_max)
%   J_LTD,i = eta_LTD [Ca_i - theta_LTD]_+  w_i
p.theta_LTD = 0.35;       % Depression threshold (normalized Ca)
p.theta_LTP = 0.60;       % Potentiation threshold (normalized Ca)
p.eta_LTD   = 0.01;       % Depression rate (1/ms per unit Ca)
p.eta_LTP   = 0.20;       % Potentiation rate (1/ms per unit Ca)
p.w_min     = 0.0;        % Lower weight bound
p.w_max     = 2.0;        % Upper weight bound (soft bound in J_LTP)
p.tau_E     = 600000;     % Expression time constant of the conductance weight w_E (ms; 10 min)

%% ==================== Shared resource pool ====================
% dR/dt = -sum_i dw_i/dt + (R0 - R)/tau_R   =>   d(R + sum_i w_i)/dt = (R0 - R)/tau_R
% R is expressed in weight units; R + sum_i w_i is conserved on time scales << tau_R.
% R0 is the resting level, not a hard capacity: LTD can transiently raise R above R0.
p.R0     = 4.0;           % Resting (reference) pool content of the branch segment (weight units)
p.R_init = 4.0;           % Initial pool content (scalar or Kx1)
p.tau_R  = 60000;         % Slow replenishment (synthesis / trafficking) time constant (ms)

%% ==================== Stimulation ====================
p.stim_times     = [100, 150, 200];   % Presynaptic pulse times (ms): 3 pulses at 20 Hz
p.stim_duration  = 2;                 % Pulse duration (ms)
p.stim_strengths = [0.5, zeros(1, 20)]; % 1xN or KxN dimensionless drive s_i (0 = inactive synapse)
p.neighbor_delay = 0;                 % Delay of synapses 2..N relative to the target (ms)

%% ==================== Mechanism switches (ablations) ====================
p.use_Mg_block     = true;    % false -> voltage-independent NMDA with B = B_fixed
p.B_fixed          = 0.0634;  % Matched so that target-alone peak Ca equals the full model
p.use_resource     = true;    % false -> R held at R0 (unlimited pool)
p.voltage_coupling = true;    % false -> neighbour spines do not inject current into the branch

end
