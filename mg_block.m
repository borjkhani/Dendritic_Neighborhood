function [B, dBdV] = mg_block(V, p)
%% MG_BLOCK - NMDA receptor Mg2+ block (Jahr & Stevens, 1990)
%
%   B(V) = 1 / (1 + [Mg]/K_Mg * exp(-a V))
%
% With p.use_Mg_block = false the block is replaced by the voltage-independent
% constant p.B_fixed (ablation).
%
% Author: Mehdi Borjkhani
% Date: 2026 (revision)

if p.use_Mg_block
    B = 1 ./ (1 + (p.Mg_conc / p.Mg_K) .* exp(-p.Mg_a .* V));
    dBdV = p.Mg_a .* B .* (1 - B);
else
    B = p.B_fixed * ones(size(V));
    dBdV = zeros(size(V));
end

end
