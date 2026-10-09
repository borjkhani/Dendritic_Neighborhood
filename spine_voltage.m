function Vs = spine_voltage(Vd, Vs, gA, gN, p)
%% SPINE_VOLTAGE - Quasi-steady-state spine-head voltages (Newton's method)
%
% The spine-head membrane time constant (~10 us) is much shorter than all other
% time scales, so each spine head is treated as being in instantaneous current
% balance:
%
%   g_neck (V_d - V_s) + g_A (E_AMPA - V_s) + g_N B(V_s) (E_NMDA - V_s) = 0
%
% Inputs
%   Vd : K x 1 branch voltage (mV)
%   Vs : K x N initial guess (previous time step) (mV)
%   gA, gN : K x N instantaneous AMPA / NMDA conductances (nS)
%
% Author: Mehdi Borjkhani
% Date: 2026 (revision)

for it = 1:p.newton_iter
    [B, dB] = mg_block(Vs, p);
    f  = p.g_neck .* (Vd - Vs) + gA .* (p.E_AMPA - Vs) + gN .* B .* (p.E_NMDA - Vs);
    fp = -p.g_neck - gA + gN .* (dB .* (p.E_NMDA - Vs) - B);
    Vs = Vs - f ./ fp;
end

end
