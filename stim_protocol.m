function I_stim = stim_protocol(t, p)
%% STIM_PROTOCOL - Flexible stimulation protocol for N synapses
%
% Supports:
%   - N >= 2 synapses
%   - Per-synapse timing and strength
%   - Neighbor delay for timing experiments
%
% Protocol specification via p fields:
%   p.stim_times        : base stimulation times (ms)
%   p.stim_strengths    : N×1 vector of strengths (or scalar for uniform)
%   p.stim_duration     : pulse duration (ms)
%   p.neighbor_delay    : delay for synapses 2:N relative to synapse 1 (ms)
%   p.active_synapses   : logical N×1 vector (which synapses are active)
%
% Author: Mehdi Borjkhani
% Date: 2025

N = p.N_syn;
I_stim = zeros(N, 1);

%% ==================== Get Stimulation Strengths ====================
if isfield(p, 'stim_strengths') && length(p.stim_strengths) == N
    strengths = p.stim_strengths(:);
elseif isfield(p, 'stim_strength')
    strengths = p.stim_strength * ones(N, 1);
else
    strengths = 0.5 * ones(N, 1);
end

%% ==================== Get Active Synapses ====================
if isfield(p, 'active_synapses') && length(p.active_synapses) == N
    active = p.active_synapses(:);
else
    active = true(N, 1);  % All active by default
end

%% ==================== Get Neighbor Delay ====================
if isfield(p, 'neighbor_delay')
    delay = p.neighbor_delay;
else
    delay = 0;
end

%% ==================== Apply Stimulation ====================
for i = 1:N
    if ~active(i)
        continue;
    end
    
    % Delay for non-target synapses (synapse 1 = target)
    if i == 1
        syn_delay = 0;
    else
        syn_delay = delay;
    end
    
    % Check if current time falls within any stimulation pulse
    for j = 1:length(p.stim_times)
        t_stim = p.stim_times(j) + syn_delay;
        if t >= t_stim && t < t_stim + p.stim_duration
            I_stim(i) = strengths(i);
            break;
        end
    end
end

end
