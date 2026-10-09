%% CONVERGENCE_CHECK - Time-step convergence of the neighbourhood-size sweep (final code)
%
% Runs the standard protocol (s1 = sn = 0.5) for K = 0..20 co-active neighbours with
% dt = 0.1, 0.05, 0.025 and 0.0125 ms and prints Delta w_1 for each time step.
%
% Author: Mehdi Borjkhani
% Date: 2026 (revision)

p0 = params_default();
Ks = 0:20; dts = [0.1 0.05 0.025 0.0125];
D = zeros(numel(dts), numel(Ks));
for j = 1:numel(dts)
    p = p0; p.dt = dts(j); p.stim_strengths = make_S(p0.N_syn, 0.5, Ks, 0.5);
    [~, r] = run_simulation(p); D(j, :) = r.dw(:, 1)';
end
fprintf('> Convergence check (Delta w_1, s1 = sn = 0.5)\n   K      '); fprintf('%8d', Ks); fprintf('\n');
for j = 1:numel(dts), fprintf('   dt=%-6g', dts(j)); fprintf('%+8.3f', D(j, :)); fprintf('\n'); end
for j = 1:numel(dts) - 1
    e = abs(D(j, :) - D(end, :)); [m, im] = max(e);
    fprintf('   dt = %g vs 0.0125: max |diff| = %.4f at K = %d, median = %.5f\n', dts(j), m, Ks(im), median(e));
end
save('results_convergence.mat', 'Ks', 'dts', 'D');
