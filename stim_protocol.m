function I_stim = stim_protocol(t, p)
%% STIM_PROTOCOL - Presynaptic drive for all synapses at time t
%
% Returns a K x N matrix (K parallel conditions, N synapses). Synapse 1 is the
% target; synapses 2..N are neighbours and may be delayed by p.neighbor_delay.
%
% Fields used:
%   p.stim_strengths : 1xN or KxN drive amplitudes (0 = inactive synapse)
%   p.stim_times     : pulse onset times (ms)
%   p.stim_duration  : pulse duration (ms)
%   p.neighbor_delay : delay of neighbours relative to the target (ms)
%
% Author: Mehdi Borjkhani
% Date: 2026 (revision)

S = p.stim_strengths;
N = size(S, 2);

on_target = any(t >= p.stim_times & t < p.stim_times + p.stim_duration);
d = 0;
if isfield(p, 'neighbor_delay'), d = p.neighbor_delay; end
on_nb = any(t >= p.stim_times + d & t < p.stim_times + d + p.stim_duration);

gate = [double(on_target), double(on_nb) * ones(1, N - 1)];
I_stim = S .* gate;   % implicit expansion (K x N)

end
