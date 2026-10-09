function S = make_S(N, s_target, K, s_neighbor)
%% MAKE_S - Build stimulation-strength rows: target + K co-active neighbours
%
%   S = make_S(N, s_target, K, s_neighbor)
% s_target, K and s_neighbor may be vectors of equal length (or scalars, which
% are expanded); each element defines one condition (row of S). Synapse 1 is the
% target, synapses 2..K+1 are the co-active neighbours, the rest are inactive.
%
% Author: Mehdi Borjkhani
% Date: 2026 (revision)

if nargin < 4, s_neighbor = s_target; end
n = max([numel(s_target), numel(K), numel(s_neighbor)]);
s_target   = s_target(:)   .* ones(n, 1);
K          = K(:)          .* ones(n, 1);
s_neighbor = s_neighbor(:) .* ones(n, 1);

S = zeros(n, N);
for c = 1:n
    S(c, 1) = s_target(c);
    S(c, 2:K(c) + 1) = s_neighbor(c);
end
end
