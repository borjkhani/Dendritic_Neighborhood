%% GENERATE_SUPP_FIGURES - Supplementary figures S1-S7 of the revised manuscript
%
% Author: Mehdi Borjkhani
% Date: 2026 (revision)

if ~exist('figures_supp', 'dir'), mkdir('figures_supp'); end
C = figure_defaults();
p0 = params_default();
N  = p0.N_syn;
sres = struct();
pos4 = @(r, c) [0.08 + (c-1)*0.48, 0.58 - (r-1)*0.47, 0.38, 0.32];

%% ========================================================================
%% S1: Electrical calibration and supralinear integration
%% ========================================================================
fprintf('> Figure S1: electrical calibration\n');
p = p0; p.stim_times = 100; p.T_total = 300; p.stim_strengths = make_S(N, 0.5, 0, 0.5);
[t, r] = run_simulation(p, @stim_protocol, struct('record', true));
epsp_s = r.Vs_peak(1, 1) - p0.E_L; epsp_d = r.Vd_peak(1) - p0.E_L;
fprintf('   single input: spine-head EPSP = %.1f mV, branch EPSP = %.2f mV, ratio = %.1f\n', epsp_s, epsp_d, epsp_s / epsp_d);
sres.S1.epsp_spine = epsp_s; sres.S1.epsp_branch = epsp_d;
% number of synchronous inputs
n_in = 1:N;
p1 = p0; p1.stim_times = 100; p1.T_total = 300; p1.stim_strengths = make_S(N, 0.5, n_in - 1, 0.5);
[~, r1] = run_simulation(p1);
p3 = p0; p3.stim_strengths = make_S(N, 0.5, n_in - 1, 0.5);
[~, r3] = run_simulation(p3);
pn = p1; pn.use_Mg_block = false; pn.B_fixed = 0.0; [~, rn] = run_simulation(pn);   % AMPA only
p3n = p3; p3n.use_Mg_block = false; p3n.B_fixed = 0.0; [~, r3n] = run_simulation(p3n);
fprintf('   branch depolarization, single pulse: n=5: %.1f, n=10: %.1f, n=21: %.1f mV (AMPA-only n=21: %.1f mV)\n', ...
    r1.Vd_peak(5) + 70, r1.Vd_peak(10) + 70, r1.Vd_peak(21) + 70, rn.Vd_peak(21) + 70);
fprintf('   branch depolarization, 20-Hz burst: n=1: %.2f, n=5: %.1f, n=10: %.1f, n=13: %.1f, n=21: %.1f mV\n', ...
    r3.Vd_peak(1) + 70, r3.Vd_peak(5) + 70, r3.Vd_peak(10) + 70, r3.Vd_peak(13) + 70, r3.Vd_peak(21) + 70);
fprintf('   burst, AMPA only: n=10: %.1f, n=21: %.1f mV; NMDA boost at n=10: %.0f%%, n=21: %.0f%%\n', r3n.Vd_peak(10) + 70, r3n.Vd_peak(21) + 70, ...
    100 * ((r3.Vd_peak(10) + 70) / (r3n.Vd_peak(10) + 70) - 1), 100 * ((r3.Vd_peak(21) + 70) / (r3n.Vd_peak(21) + 70) - 1));
sres.S1.n = n_in; sres.S1.Vd_single = r1.Vd_peak' + 70; sres.S1.Vd_burst = r3.Vd_peak' + 70; sres.S1.Vd_ampa = rn.Vd_peak' + 70;
% input resistance dependence
gL = [2.5 3.33 5 7.5 10 20]; Rin = 1000 ./ gL;
es = zeros(size(gL)); ed = es;
for j = 1:numel(gL)
    q = p; q.g_L = gL(j); q.C_d = 20 * gL(j);
    [~, rq] = run_simulation(q); es(j) = rq.Vs_peak(1, 1) + 70; ed(j) = rq.Vd_peak(1) + 70;
end
fig = figure('Position', [100 100 1150 820], 'Color', 'w', 'Visible', 'off');
ax = axes('Position', pos4(1,1)); hold on;
plot(t, r.Vs(:, 1), 'Color', C.ltp); plot(t, r.Vd(:, 1), 'Color', C.volt);
xlim([90 200]); xlabel('Time (ms)'); ylabel('V (mV)');
legend({sprintf('spine head (%.1f mV)', epsp_s), sprintf('branch (%.2f mV)', epsp_d)}, 'Location', 'northeast', 'FontSize', 9); legend boxoff;
panel_label(ax, 'A', 'Single-input EPSP');
ax = axes('Position', pos4(1,2)); hold on;
plot(n_in, r3.Vd_peak + 70, 'o-', 'Color', C.ltp, 'MarkerFaceColor', C.ltp, 'MarkerSize', 4);
plot(n_in, r3n.Vd_peak + 70, '^-', 'Color', C.gray, 'MarkerFaceColor', C.gray, 'MarkerSize', 4);
plot(n_in, n_in * (r3.Vd_peak(1) + 70), 'k:', 'LineWidth', 1.2);
plot(n_in, r1.Vd_peak + 70, 's-', 'Color', C.full, 'MarkerFaceColor', C.full, 'MarkerSize', 4);
xlabel('Synchronously active inputs'); ylabel('Peak branch depolarization (mV)'); xlim([0 22]);
legend({'20-Hz burst', '20-Hz burst, AMPA only', 'linear sum (burst)', 'single pulse'}, 'Location', 'northwest', 'FontSize', 9); legend boxoff;
panel_label(ax, 'B', 'Integration of synchronous inputs');
ax = axes('Position', pos4(2,1)); hold on;
V = -90:0.5:10;
plot(V, 1 ./ (1 + (1/3.57) * exp(-0.062 * V)), 'Color', C.full);
plot(V, 1 ./ (1 + exp(-(V + 25) / 10)), '--', 'Color', C.gray);
xlabel('V (mV)'); ylabel('B(V)'); legend({'Jahr & Stevens (1990), revised', 'sigmoid, original submission'}, 'Location', 'northwest', 'FontSize', 9); legend boxoff;
panel_label(ax, 'C', 'Mg^{2+} block');
ax = axes('Position', pos4(2,2)); hold on;
plot(Rin, es, 'o-', 'Color', C.ltp, 'MarkerFaceColor', C.ltp); plot(Rin, ed, 's-', 'Color', C.volt, 'MarkerFaceColor', C.volt);
set(gca, 'XScale', 'log', 'XTick', [50 100 200 400], 'XTickLabel', {'50', '100', '200', '400'});
xlabel('Branch input resistance (M\Omega)'); ylabel('Single-input EPSP (mV)');
legend({'spine head', 'branch'}, 'Location', 'northwest', 'FontSize', 9); legend boxoff;
panel_label(ax, 'D', 'Dependence on branch impedance');
save_figure(fig, 'figures_supp/figS1_electrical_calibration', C.dpi);

%% ========================================================================
%% S2: Weight stabilization and conservation
%% ========================================================================
fprintf('> Figure S2: weight stabilization\n');
p = p0; p.T_total = 1000; p.stim_strengths = make_S(N, 0.5, [6 12], 0.5);
[t, r] = run_simulation(p, @stim_protocol, struct('record', true));
dwdt = [diff(r.w); zeros(1, 2)] / p.dt;
fprintf('   K = 12: dw(400 ms) = %+.4f, dw(1000 ms) = %+.4f; |sum w + R change| = %.2e\n', ...
    r.w(round(400 / p.dt) + 1, 2) - 0.5, r.w(end, 2) - 0.5, max(abs(r.total_final - r.total0)));
fig = figure('Position', [100 100 1150 820], 'Color', 'w', 'Visible', 'off');
cc = {C.ltd, C.ltp};
ax = axes('Position', pos4(1,1)); hold on;
for c = 1:2, plot(t, r.Ca(:, c), 'Color', cc{c}); end
ref_line('h', p0.theta_LTP, '--', C.ltp); ref_line('h', p0.theta_LTD, ':', C.ltd);
xlabel('Time (ms)'); ylabel('[Ca^{2+}]_1'); legend({'K = 6', 'K = 12'}, 'FontSize', 9); legend boxoff; panel_label(ax, 'A', 'Calcium');
ax = axes('Position', pos4(1,2)); hold on;
for c = 1:2, plot(t, r.w(:, c), 'Color', cc{c}); end
xlabel('Time (ms)'); ylabel('w_1'); panel_label(ax, 'B', 'Target weight');
ax = axes('Position', pos4(2,1)); hold on;
for c = 1:2, plot(t, dwdt(:, c), 'Color', cc{c}); end
ref_line('h', 0, '-', 'k', 1); xlabel('Time (ms)'); ylabel('dw_1/dt (ms^{-1})'); panel_label(ax, 'C', 'Rate of change');
ax = axes('Position', pos4(2,2)); hold on;
for c = 1:2, plot(t, r.R(:, c), 'Color', cc{c}); end
xlabel('Time (ms)'); ylabel('Pool R'); panel_label(ax, 'D', 'Pool');
save_figure(fig, 'figures_supp/figS2_weight_stabilization', C.dpi);

%% ========================================================================
%% S3: Timing window
%% ========================================================================
fprintf('> Figure S3: timing window\n');
delays = -100:10:100; KS3 = [9 12];
D = zeros(numel(KS3), numel(delays)); Cp = D;
for j = 1:numel(delays)
    p = p0; p.neighbor_delay = delays(j); p.T_total = 500; p.stim_strengths = make_S(N, 0.5, KS3, 0.5);
    [~, r] = run_simulation(p); D(:, j) = r.dw(:, 1); Cp(:, j) = r.Ca_peak(:, 1);
end
for k = 1:numel(KS3)
    [m, im] = max(D(k, :));
    fprintf('   K = %d: dw(0) = %+.3f, max %+.3f at %+d ms, min %+.3f at %+d ms\n', KS3(k), D(k, delays == 0), m, delays(im), min(D(k, :)), delays(D(k, :) == min(D(k, :))));
end
sres.S3 = struct('delays', delays, 'K', KS3, 'dw', D, 'Ca', Cp);
fig = figure('Position', [100 100 1150 430], 'Color', 'w', 'Visible', 'off');
ax = axes('Position', [0.08 0.17 0.38 0.68]); hold on;
for k = 1:numel(KS3), plot(delays, D(k, :), 'o-', 'Color', C.seq(k+1, :), 'MarkerFaceColor', C.seq(k+1, :), 'MarkerSize', 4); end
ref_line('h', 0, '-', 'k', 1); ref_line('v', 0, ':', C.gray);
legend(arrayfun(@(k) sprintf('K = %d', k), KS3, 'UniformOutput', false), 'Location', 'northwest', 'FontSize', 9); legend boxoff;
xlabel('Neighbour delay (ms)'); ylabel('\Deltaw_1'); panel_label(ax, 'A', 'Target plasticity');
ax = axes('Position', [0.57 0.17 0.38 0.68]); hold on;
for k = 1:numel(KS3), plot(delays, Cp(k, :), 'o-', 'Color', C.seq(k+1, :), 'MarkerFaceColor', C.seq(k+1, :), 'MarkerSize', 4); end
ref_line('h', p0.theta_LTP, '--', C.ltp); ref_line('h', p0.theta_LTD, ':', C.ltd);
xlabel('Neighbour delay (ms)'); ylabel('Peak [Ca^{2+}]_1'); panel_label(ax, 'B', 'Target calcium');
save_figure(fig, 'figures_supp/figS3_timing_window', C.dpi);

%% ========================================================================
%% S4: History dependence across repeated epochs
%% ========================================================================
fprintf('> Figure S4: history dependence\n');
ep = [100 2100 4100]; tauRs = [1000 10000 60000];
tmp = [ep; ep + 50; ep + 100]; p = p0; p.stim_times = sort(tmp(:)'); p.T_total = 4600;
p.stim_strengths = make_S(N, 0.5, 12, 0.5);
Wt = cell(1, 3); Rt = Wt; dEp = zeros(3, 3);
for j = 1:3
    q = p; q.tau_R = tauRs(j);
    [t, r] = run_simulation(q, @stim_protocol, struct('record', true));
    Wt{j} = r.w; Rt{j} = r.R;
    ix = @(tt) round(tt / p.dt) + 1; wb = [r.w(ix(90)), r.w(ix(2090)), r.w(ix(4090)), r.w(end)];
    dEp(j, :) = diff(wb);
    fprintf('   tau_R = %5.0f ms: dw per epoch = %s\n', tauRs(j), sprintf('%+.3f ', dEp(j, :)));
end
sres.S4 = struct('tau_R', tauRs, 'dw_epoch', dEp);
% Control: separate pool depletion from the weight changes left by epoch 1 (tau_R = 60 s, 2-s gap)
q = p0; q.stim_strengths = make_S(N, 0.5, 12, 0.5);
[~, e1] = run_simulation(q);
Rg = q.R0 + (e1.R_final - q.R0) * exp(-2000 / q.tau_R);
c2 = zeros(1, 3);
qa = q; qa.w_init = e1.w_final; qa.wE_init = e1.wE_final; qa.R_init = Rg;   [~, ra] = run_simulation(qa); c2(1) = ra.dw(1, 1);
qb = q; qb.w_init = e1.w_final; qb.wE_init = e1.wE_final; qb.R_init = q.R0; [~, rb] = run_simulation(qb); c2(2) = rb.dw(1, 1);
qc = q; qc.R_init = Rg;                                                    [~, rc] = run_simulation(qc); c2(3) = rc.dw(1, 1);
fprintf('   control (epoch 2, tau_R = 60 s): epoch 1 %+.3f | depleted pool + evolved weights %+.3f | pool restored %+.3f | weights reset %+.3f\n', e1.dw(1, 1), c2);
sres.S4.control = [e1.dw(1, 1), c2];
fig = figure('Position', [100 100 1150 820], 'Color', 'w', 'Visible', 'off');
ax = axes('Position', pos4(1,1)); hold on;
for j = 1:3, plot(t / 1000, Wt{j}, 'Color', C.seq(j+1, :)); end
legend(arrayfun(@(x) sprintf('\\tau_R = %g s', x / 1000), tauRs, 'UniformOutput', false), 'Location', 'southeast', 'FontSize', 9); legend boxoff;
xlabel('Time (s)'); ylabel('w_1'); panel_label(ax, 'A', 'Target weight');
ax = axes('Position', pos4(1,2)); hold on;
for j = 1:3, plot(t / 1000, Rt{j}, 'Color', C.seq(j+1, :)); end
xlabel('Time (s)'); ylabel('Pool R'); panel_label(ax, 'B', 'Pool');
ax = axes('Position', pos4(2,1)); hold on;
hb = bar(dEp', 0.8); for j = 1:3, set(hb(j), 'FaceColor', C.seq(j+1, :)); end
ref_line('h', 0, '-', 'k', 1); set(gca, 'XTick', 1:3, 'XTickLabel', {'Epoch 1', 'Epoch 2', 'Epoch 3'});
ylabel('\Deltaw_1 per epoch'); panel_label(ax, 'C', 'Diminishing returns');
ax = axes('Position', pos4(2,2)); hold on;
cv = [e1.dw(1, 1), c2]; cc4 = {C.gray, C.ltp, C.full, C.pool};
for j = 1:4, fill(j + [-0.3 0.3 0.3 -0.3], [0 0 cv(j) cv(j)], cc4{j}, 'EdgeColor', 'k'); end
xlim([0.4 4.6]); ref_line('h', 0, '-', 'k', 1);
set(gca, 'XTick', 1:4, 'XTickLabel', {'Epoch 1', 'Epoch 2', 'pool restored', 'w reset'});
xlabel('Epoch 2 conditions: depleted / restored pool / reset weights');
ylabel('\Deltaw_1'); panel_label(ax, 'D', 'Pool vs. weight history (\tau_R = 60 s)');
save_figure(fig, 'figures_supp/figS4_history_dependence', C.dpi);

%% ========================================================================
%% S5: Parameter robustness
%% ========================================================================
fprintf('> Figure S5: parameter robustness\n');
Ks = 0:20;
pars = {'theta_LTP', [0.5 0.6 0.7], '\theta_P'; 'theta_LTD', [0.30 0.35 0.40], '\theta_D'; ...
        'tau_Ca', [20 30 45], '\tau_{Ca} (ms)'; 'R0', [2 4 8], 'R_0'; ...
        'g_NMDA', [5 6 7], 'g_{NMDA} (nS)'; 'g_neck', [1 2 4], 'g_{neck} (nS)'; ...
        'eta_LTD', [0.005 0.01 0.02], '\eta_D'; 'tau_R', [1000 60000 600000], '\tau_R (ms)'};
fig = figure('Position', [100 100 1450 720], 'Color', 'w', 'Visible', 'off');
letters = 'ABCDEFGH';
sres.S5 = struct();
for k = 1:size(pars, 1)
    vals = pars{k, 2};
    row = floor((k-1) / 4); col = mod(k-1, 4);
    ax = axes('Position', [0.06 + col*0.245, 0.58 - row*0.47, 0.19, 0.32]); hold on;
    for j = 1:numel(vals)
        p = p0; p.(pars{k, 1}) = vals(j); p.stim_strengths = make_S(N, 0.5, Ks, 0.5);
        [~, r] = run_simulation(p); d = r.dw(:, 1)';
        plot(Ks, d, '-', 'Color', C.seq(j+1, :));
        iL = find(d > 0.01, 1); [m, im] = max(d);
        fprintf('   %-10s = %-8g min %+.3f | LTP from K = %2d | max %+.3f at K = %2d | dw(K=20) = %+.3f\n', ...
            pars{k, 1}, vals(j), min(d), Ks(iL), m, Ks(im), d(end));
        sres.S5.(pars{k, 1})(j, :) = d;
    end
    ref_line('h', 0, '-', 'k', 1); xlim([0 20]);
    legend(arrayfun(@(v) sprintf('%g', v), vals, 'UniformOutput', false), 'Location', 'northwest', 'FontSize', 8); legend boxoff;
    xlabel('K'); ylabel('\Deltaw_1'); panel_label(ax, letters(k), pars{k, 3});
end
save_figure(fig, 'figures_supp/figS5_parameter_robustness', C.dpi);

%% ========================================================================
%% S6: Protocol dependence
%% ========================================================================
fprintf('> Figure S6: protocol dependence\n');
prots = {'Single pulse', 100, 400; ...
         '20 Hz x3', [100 150 200], 400; ...
         '5 Hz x20', 100 + 200 * (0:19), 4300; ...
         '20 Hz x20', 100 + 50 * (0:19), 1400; ...
         'TBS 4x4', sort(reshape((100 + 200 * (0:3))' + 10 * (0:3), 1, [])), 1200; ...
         '100 Hz x20', 100 + 10 * (0:19), 600};
K6 = [0 4 10];
D6 = zeros(size(prots, 1), numel(K6));
for j = 1:size(prots, 1)
    p = p0; p.stim_times = prots{j, 2}; p.T_total = prots{j, 3}; p.stim_strengths = make_S(N, 0.5, K6, 0.5);
    [~, r] = run_simulation(p); D6(j, :) = r.dw(:, 1)';
    fprintf('   %-12s alone %+.3f | +4 %+.3f | +10 %+.3f\n', prots{j, 1}, D6(j, :));
end
sres.S6 = struct('protocols', {prots(:, 1)}, 'K', K6, 'dw', D6);
fig = figure('Position', [100 100 1150 480], 'Color', 'w', 'Visible', 'off');
ax = axes('Position', [0.08 0.20 0.88 0.68]); hold on;
hb = bar(D6, 0.8); cols = {C.alone, C.ltd, C.ltp}; for j = 1:3, set(hb(j), 'FaceColor', cols{j}); end
ref_line('h', 0, '-', 'k', 1);
set(gca, 'XTick', 1:size(prots, 1), 'XTickLabel', prots(:, 1));
legend({'target alone', '+4 neighbours', '+10 neighbours'}, 'Location', 'northwest', 'FontSize', 10); legend boxoff;
ylabel('\Deltaw_1'); title('Plasticity outcome by induction protocol', 'FontWeight', 'bold');
save_figure(fig, 'figures_supp/figS6_protocol_dependence', C.dpi);

%% ========================================================================
%% S7: Operating regime - branch impedance, AMPA blockade, hyperpolarization
%% ========================================================================
fprintf('> Figure S7: operating regime\n');
Ks = 0:20;
fig = figure('Position', [100 100 1450 430], 'Color', 'w', 'Visible', 'off');
sets = {'g_L', [2.5 5 10 20], 'R_{in}', @(v) sprintf('%d M\\Omega', round(1000 / v)); ...
        'g_AMPA', [2 1.5 1], 'AMPA', @(v) sprintf('%d%% g_{AMPA}', round(100 * v / 2)); ...
        'E_L', [-70 -75 -80], 'E_L', @(v) sprintf('E_L = %d mV', v)};
ttl = {'Branch input resistance', 'Partial AMPA-receptor block', 'Dendritic hyperpolarization'};
sres.S7 = struct();
for k = 1:3
    ax = axes('Position', [0.05 + (k-1)*0.33, 0.17, 0.27, 0.68]); hold on;
    vals = sets{k, 2}; lg = cell(1, numel(vals));
    for j = 1:numel(vals)
        p = p0; p.(sets{k, 1}) = vals(j);
        if strcmp(sets{k, 1}, 'g_L'), p.C_d = 20 * vals(j); end
        p.stim_strengths = make_S(N, 0.5, Ks, 0.5);
        [~, r] = run_simulation(p); d = r.dw(:, 1)';
        plot(Ks, d, 'o-', 'Color', C.seq(j, :), 'MarkerFaceColor', C.seq(j, :), 'MarkerSize', 4);
        lg{j} = sets{k, 4}(vals(j));
        iL = find(d > 0.01, 1); if isempty(iL), kL = NaN; else, kL = Ks(iL); end
        fprintf('   %-7s = %-6g LTP from K = %g | max dw = %+.3f | min dw = %+.3f\n', sets{k, 1}, vals(j), kL, max(d), min(d));
        sres.S7.(sets{k, 1})(j, :) = d;
    end
    ref_line('h', 0, '-', 'k', 1); xlim([-0.5 20.5]);
    legend(lg, 'Location', 'northwest', 'FontSize', 9); legend boxoff;
    xlabel('Co-active neighbours K'); ylabel('\Deltaw_1'); panel_label(ax, char('A' + k - 1), ttl{k});
end
save_figure(fig, 'figures_supp/figS7_operating_regime', C.dpi);

save('results_supp.mat', 'sres');
fprintf('Supplementary figures done.\n');
