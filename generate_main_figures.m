%% GENERATE_MAIN_FIGURES - Main figures 1-7 of the revised manuscript
%
% Run from the code directory. Figures are written to figures_main/ and the
% numbers quoted in the text are written to results_main.mat and to the log.
%
% Author: Mehdi Borjkhani
% Date: 2026 (revision)

if ~exist('figures_main', 'dir'), mkdir('figures_main'); end
C = figure_defaults();
p0 = params_default();
N  = p0.N_syn;
res = struct();

%% ========================================================================
%% FIGURE 1: Model schematic
%% ========================================================================
fprintf('> Figure 1: model schematic\n');
fig = figure('Position', [100 100 1150 820], 'Color', 'w', 'Visible', 'off');
ax = axes('Position', [0 0 1 1]); hold on; axis off; xlim([0 1]); ylim([0 1]);

% dendritic branch
fill([0.06 0.94 0.94 0.06], [0.44 0.44 0.51 0.51], [0.55 0.35 0.15], 'EdgeColor', [0.3 0.2 0.1], 'LineWidth', 1.5);
text(0.5, 0.475, 'Dendritic branch  (V_d,  R_{in} = 200 M\Omega,  \tau_d = 20 ms)', 'Color', 'w', ...
     'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');

% spines: target, 3 co-active neighbours, 1 inactive neighbour
sx = [0.16 0.34 0.50 0.66 0.84];
lab = {'Target', 'Neighbour', 'Neighbour', 'Neighbour', 'Inactive'};
col = {C.ltp, C.full, C.full, C.full, C.gray};
for i = 1:5
    fill([sx(i)-0.008 sx(i)+0.008 sx(i)+0.008 sx(i)-0.008], [0.51 0.51 0.63 0.63], [0.6 0.6 0.6], 'EdgeColor', 'k');
    rectangle('Position', [sx(i)-0.05, 0.63, 0.10, 0.12], 'Curvature', [1 1], 'FaceColor', col{i}, 'EdgeColor', 'k', 'LineWidth', 1.5);
    text(sx(i), 0.71, sprintf('V_{s,%d}', i), 'HorizontalAlignment', 'center', 'Color', 'w', 'FontWeight', 'bold', 'FontSize', 11);
    text(sx(i), 0.665, sprintf('Ca_%d, w_%d', i, i), 'HorizontalAlignment', 'center', 'Color', 'w', 'FontSize', 10);
    text(sx(i), 0.78, lab{i}, 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'FontSize', 11);
end
text(sx(1)+0.012, 0.57, 'g_{neck}', 'FontSize', 10);
% presynaptic drive arrows
for i = 1:4
    plot([sx(i) sx(i)], [0.84 0.80], 'k-', 'LineWidth', 1.5);
    plot(sx(i), 0.80, 'kv', 'MarkerFaceColor', 'k', 'MarkerSize', 6);
end
text(0.41, 0.855, 'presynaptic burst (AMPA + NMDA)', 'HorizontalAlignment', 'center', 'FontSize', 10);

% shared pool
rectangle('Position', [0.30, 0.17, 0.40, 0.12], 'Curvature', [0.3 0.3], 'FaceColor', [0.98 0.85 0.45], 'EdgeColor', C.pool, 'LineWidth', 2);
text(0.5, 0.245, 'Shared resource pool R', 'HorizontalAlignment', 'center', 'FontSize', 13, 'FontWeight', 'bold');
text(0.5, 0.205, 'R + \Sigma_i w_i  conserved  (slow refill, \tau_R = 60 s)', 'HorizontalAlignment', 'center', 'FontSize', 10);
% LTP / LTD fluxes
plot([0.40 0.40], [0.30 0.42], '-', 'Color', C.ltp, 'LineWidth', 2.5); plot(0.40, 0.42, '^', 'Color', C.ltp, 'MarkerFaceColor', C.ltp, 'MarkerSize', 8);
text(0.385, 0.36, 'LTP: R \rightarrow w_i', 'HorizontalAlignment', 'right', 'Color', C.ltp, 'FontWeight', 'bold', 'FontSize', 11);
plot([0.60 0.60], [0.42 0.30], '-', 'Color', C.ltd, 'LineWidth', 2.5); plot(0.60, 0.30, 'v', 'Color', C.ltd, 'MarkerFaceColor', C.ltd, 'MarkerSize', 8);
text(0.615, 0.36, 'LTD: w_i \rightarrow R', 'HorizontalAlignment', 'left', 'Color', C.ltd, 'FontWeight', 'bold', 'FontSize', 11);

draw_box(0.01, 0.90, 0.37, 0.09, [0.92 0.92 1], [0.3 0.3 0.6], ...
    {'\bfNMDA Mg^{2+} block (spine head)', 'B(V_s) = 1 / (1 + [Mg^{2+}]/3.57 \cdot e^{-0.062 V_s})'}, 11);
draw_box(0.42, 0.90, 0.57, 0.09, [1 0.92 0.92], [0.6 0.3 0.3], ...
    {'\bfPlasticity rule', 'dw_i/dt = \eta_P[Ca_i-\theta_P]_+ (R/R_0)(1-w_i/w_{max}) - \eta_D[Ca_i-\theta_D]_+ w_i'}, 11);
draw_box(0.03, 0.01, 0.94, 0.13, [0.9 0.98 0.9], [0.2 0.5 0.2], ...
    {'\bfMechanism:\rm co-active neighbours depolarize the branch \rightarrow Mg^{2+} block in the target spine is relieved', ...
     'Ca_1 in (\theta_D, \theta_P): LTD, resource returned to R;   Ca_1 > \theta_P: LTP, resource drawn from R', ...
     'potentiating synapses compete for R, depressing synapses replenish it (branch-level normalization)'}, 11);
save_figure(fig, 'figures_main/fig1_schematic', C.dpi);

%% ========================================================================
%% FIGURE 2: The neighbourhood selects the sign of plasticity
%% ========================================================================
fprintf('> Figure 2: neighbourhood selects plasticity outcome\n');
K2 = [0 6 12];
p = p0; p.stim_strengths = make_S(N, 0.5, K2, 0.5);
[t, r2] = run_simulation(p, @stim_protocol, struct('record', true));
res.fig2.K = K2; res.fig2.dw = r2.dw(:, 1)'; res.fig2.Ca_peak = r2.Ca_peak(:, 1)';
res.fig2.Vd_peak = r2.Vd_peak'; res.fig2.Vs_peak = r2.Vs_peak(:, 1)'; res.fig2.R_final = r2.R_final';
for c = 1:3
    fprintf('   K = %2d: dw = %+.3f, peak Ca = %.3f, peak Vd = %.1f mV, peak Vs = %.1f mV, R_final = %.2f\n', ...
        K2(c), r2.dw(c, 1), r2.Ca_peak(c, 1), r2.Vd_peak(c), r2.Vs_peak(c, 1), r2.R_final(c));
end
cc = {C.alone, C.ltd, C.ltp};
names = {'Target alone', '+ 6 neighbours', '+ 12 neighbours'};
fig = figure('Position', [100 100 1350 760], 'Color', 'w', 'Visible', 'off');
pos = @(r, c) [0.07 + (c-1)*0.325, 0.57 - (r-1)*0.48, 0.25, 0.33];
ax = axes('Position', pos(1,1)); hold on;
for c = 1:3, plot(t, r2.Vs(:, c), 'Color', cc{c}); end
ylabel('V_{s,1} (mV)'); xlabel('Time (ms)'); xlim([0 400]); ylim([-72 -20]);
legend(names, 'Location', 'northeast', 'FontSize', 9); legend boxoff; panel_label(ax, 'A', 'Target spine head');
ax = axes('Position', pos(1,2)); hold on;
for c = 1:3, plot(t, r2.Vd(:, c), 'Color', cc{c}); end
ylabel('V_d (mV)'); xlabel('Time (ms)'); xlim([0 400]); ylim([-72 -20]); panel_label(ax, 'B', 'Dendritic branch');
ax = axes('Position', pos(1,3)); hold on;
for c = 1:3, plot(t, r2.Ca(:, c), 'Color', cc{c}); end
ref_line('h', p0.theta_LTP, '--', C.ltp); ref_line('h', p0.theta_LTD, ':', C.ltd);
text(395, p0.theta_LTP + 0.04, '\theta_P', 'HorizontalAlignment', 'right', 'Color', C.ltp);
text(395, p0.theta_LTD + 0.04, '\theta_D', 'HorizontalAlignment', 'right', 'Color', C.ltd);
ylabel('[Ca^{2+}]_1 (norm.)'); xlabel('Time (ms)'); xlim([0 400]); panel_label(ax, 'C', 'Target calcium');
ax = axes('Position', pos(2,1)); hold on;
for c = 1:3, plot(t, r2.w(:, c), 'Color', cc{c}); end
ylabel('w_1'); xlabel('Time (ms)'); xlim([0 400]); panel_label(ax, 'D', 'Target weight');
ax = axes('Position', pos(2,2)); hold on;
for c = 1:3, plot(t, r2.R(:, c), 'Color', cc{c}); end
ylabel('Pool R'); xlabel('Time (ms)'); xlim([0 400]); panel_label(ax, 'E', 'Shared pool');
ax = axes('Position', pos(2,3)); hold on;
for c = 1:3, bar(c, r2.dw(c, 1), 0.6, 'FaceColor', cc{c}, 'EdgeColor', 'k'); end
ref_line('h', 0, '-', 'k', 1);
ylim([-0.12 0.26]);
for c = 1:3
    if r2.dw(c, 1) >= 0, yy = r2.dw(c, 1) + 0.008; va = 'bottom'; else, yy = r2.dw(c, 1) - 0.008; va = 'top'; end
    text(c, yy, sprintf('%+.3f', r2.dw(c, 1)), 'HorizontalAlignment', 'center', 'VerticalAlignment', va, 'FontWeight', 'bold');
end
set(gca, 'XTick', 1:3, 'XTickLabel', {'alone', '+6', '+12'}); xlim([0.4 3.6]);
ylabel('\Deltaw_1'); panel_label(ax, 'F', 'Outcome');
save_figure(fig, 'figures_main/fig2_neighbourhood_selects_sign', C.dpi);

%% ========================================================================
%% FIGURE 3: Phase diagram (target strength x number of co-active neighbours)
%% ========================================================================
fprintf('> Figure 3: phase diagram\n');
st = 0.2:0.025:1.0; Ks = 0:20;
[KK, SS] = meshgrid(Ks, st);
p = p0; p.stim_strengths = make_S(N, SS(:), KK(:), 0.5);
[~, r3] = run_simulation(p);
D3 = reshape(r3.dw(:, 1), numel(st), numel(Ks));
res.fig3.st = st; res.fig3.K = Ks; res.fig3.dw = D3;
fprintf('   min dw = %.3f, max dw = %.3f; LTD cells (<-0.01): %d, LTP cells (>0.01): %d, of %d\n', ...
    min(D3(:)), max(D3(:)), sum(D3(:) < -0.01), sum(D3(:) > 0.01), numel(D3));
alone = D3(:, 1);
fprintf('   target alone: max dw = %.3f (never LTP for strengths <= 1.0)\n', max(alone));
neg_lim = -0.1; pos_lim = 1.0;
[Z, cmap, tk, tkl] = two_slope_map(D3, neg_lim, pos_lim);
fig = figure('Position', [100 100 1300 560], 'Color', 'w', 'Visible', 'off');
ax = axes('Position', [0.07 0.13 0.38 0.75]);
imagesc(Ks, st, Z); set(gca, 'YDir', 'normal'); colormap(ax, cmap); caxis([-1 1]); hold on;
contour(Ks, st, D3, [0.01 0.01], 'k-', 'LineWidth', 1.8);
contour(Ks, st, D3, [-0.01 -0.01], 'k--', 'LineWidth', 1.5);
cb = colorbar; set_cbar_ticks(cb, tk, tkl); ylabel(cb, '\Deltaw_1 (target)');
xlabel('Number of co-active neighbours K'); ylabel('Target stimulation strength');
panel_label(ax, 'A', 'Target \Deltaw');
ax2 = axes('Position', [0.57 0.13 0.38 0.75]);
cat3 = zeros(size(D3)); cat3(D3 < -0.01) = -1; cat3(D3 > 0.01) = 1;
imagesc(Ks, st, cat3); set(gca, 'YDir', 'normal'); colormap(ax2, [0.55 0.72 0.90; 1 1 1; 0.93 0.55 0.55]); caxis([-1.5 1.5]);
hold on; contour(Ks, st, D3, [0.01 0.01], 'k-', 'LineWidth', 1.5); contour(Ks, st, D3, [-0.01 -0.01], 'k--', 'LineWidth', 1.2);
text(1.5, 0.30, 'No change', 'FontWeight', 'bold', 'FontSize', 12);
text(7.0, 0.42, 'LTD', 'FontWeight', 'bold', 'FontSize', 13, 'Color', C.ltd);
text(1.8, 0.85, 'LTD', 'FontWeight', 'bold', 'FontSize', 13, 'Color', C.ltd);
text(13, 0.75, 'LTP', 'FontWeight', 'bold', 'FontSize', 14, 'Color', C.ltp);
xlabel('Number of co-active neighbours K'); ylabel('Target stimulation strength');
panel_label(ax2, 'B', 'Plasticity regimes (|\Deltaw| > 0.01)');
save_figure(fig, 'figures_main/fig3_phase_diagram', C.dpi);

%% ========================================================================
%% FIGURE 4: LTD -> facilitation -> competition as a function of the neighbourhood
%% ========================================================================
fprintf('> Figure 4: non-monotonic neighbourhood dependence\n');
Ks = 0:20;
p = p0; p.stim_strengths = make_S(N, 0.5, Ks, 0.5);
[~, r4] = run_simulation(p);
dwT = r4.dw(:, 1)';
dwN = zeros(size(Ks)); for c = 1:numel(Ks), if Ks(c) > 0, dwN(c) = mean(r4.dw(c, 2:Ks(c)+1)); else, dwN(c) = NaN; end, end
dSum = (sum(r4.w_final, 2) - N * p0.w_init)';
[mx, imx] = max(dwT);
iLTP = find(dwT > 0.01, 1); iLTD = find(dwT < -0.01);
res.fig4 = struct('K', Ks, 'dw_target', dwT, 'dw_neigh', dwN, 'R_final', r4.R_final', 'dSumW', dSum, ...
    'Ca_peak', r4.Ca_peak(:, 1)', 'Vd_peak', r4.Vd_peak', 'Vs_peak', r4.Vs_peak(:, 1)');
fprintf('   LTD for K = %d..%d (min %.3f at K = %d); LTP from K = %d; max dw = %.3f at K = %d; dw(K=20) = %.3f\n', ...
    Ks(iLTD(1)), Ks(iLTD(end)), min(dwT), Ks(dwT == min(dwT)), Ks(iLTP), mx, Ks(imx), dwT(end));
fprintf('   R_final at K = 0/%d/20: %.2f / %.2f / %.2f; max |total change| = %.4f\n', Ks(imx), ...
    r4.R_final(1), r4.R_final(imx), r4.R_final(end), max(abs(r4.total_final - r4.total0)));
% neighbour-strength sweep
sn = 0:0.05:1.5; Kset = [6 10 14];
[SN, KS] = meshgrid(sn, Kset);
p = p0; p.stim_strengths = make_S(N, 0.5, reshape(KS', [], 1), reshape(SN', [], 1));
[~, r4b] = run_simulation(p);
D4b = reshape(r4b.dw(:, 1), numel(sn), numel(Kset))';
res.fig4.sn = sn; res.fig4.Kset = Kset; res.fig4.dw_sn = D4b;
for j = 1:numel(Kset)
    [m, im] = max(D4b(j, :));
    fprintf('   K = %d: min dw = %+.3f, max dw = %+.3f at s_n = %.2f, dw(s_n = 1.5) = %+.3f\n', Kset(j), min(D4b(j,:)), m, sn(im), D4b(j, end));
end

stE = [0.4 0.5 0.6 0.7];
[KE, SE] = meshgrid(Ks, stE);
p = p0; p.stim_strengths = make_S(N, reshape(SE', [], 1), reshape(KE', [], 1), 0.5);
[~, r4e] = run_simulation(p);
D4e = reshape(r4e.dw(:, 1), numel(Ks), numel(stE))';
res.fig4.stE = stE; res.fig4.dw_stE = D4e;
for j = 1:numel(stE)
    [m, im] = max(D4e(j, :)); iL = find(D4e(j, :) > 0.01, 1);
    fprintf('   s_target = %.1f: min dw = %+.3f, LTP from K = %d, max dw = %+.3f at K = %d, dw(K=20) = %+.3f\n', stE(j), min(D4e(j,:)), Ks(iL), m, Ks(im), D4e(j, end));
end
fig = figure('Position', [100 100 1350 760], 'Color', 'w', 'Visible', 'off');
ax = axes('Position', pos(1,1)); hold on;
yl = [-0.1 0.3];
fill([Ks(iLTD(1))-0.5 Ks(iLTD(end))+0.5 Ks(iLTD(end))+0.5 Ks(iLTD(1))-0.5], [yl(1) yl(1) yl(2) yl(2)], [0.85 0.9 1], 'EdgeColor', 'none');
fill([Ks(iLTP)-0.5 Ks(imx)+0.5 Ks(imx)+0.5 Ks(iLTP)-0.5], [yl(1) yl(1) yl(2) yl(2)], [0.88 1 0.88], 'EdgeColor', 'none');
fill([Ks(imx)+0.5 20.5 20.5 Ks(imx)+0.5], [yl(1) yl(1) yl(2) yl(2)], [1 0.9 0.9], 'EdgeColor', 'none');
plot(Ks, dwT, 'o-', 'Color', C.full, 'MarkerFaceColor', C.full, 'MarkerSize', 5);
ref_line('h', 0, '-', 'k', 1);
text(Ks(iLTD(1))+0.2, 0.27, 'LTD', 'Color', C.ltd, 'FontWeight', 'bold');
text(Ks(iLTP)-0.2, 0.27, 'facil.', 'Color', [0.1 0.5 0.1], 'FontWeight', 'bold');
text(15, 0.27, 'competition', 'Color', C.ltp, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
xlim([-0.5 20.5]); ylim(yl); xlabel('Co-active neighbours K'); ylabel('\Deltaw_1'); panel_label(ax, 'A', 'Target plasticity');
ax = axes('Position', pos(1,2)); hold on;
plot(Ks, r4.Ca_peak(:, 1), 'o-', 'Color', C.calcium, 'MarkerFaceColor', C.calcium, 'MarkerSize', 5);
ref_line('h', p0.theta_LTP, '--', C.ltp); ref_line('h', p0.theta_LTD, ':', C.ltd);
xlim([-0.5 20.5]); xlabel('Co-active neighbours K'); ylabel('Peak [Ca^{2+}]_1'); panel_label(ax, 'B', 'Target calcium');
ax = axes('Position', pos(1,3)); hold on;
plot(Ks, r4.Vs_peak(:, 1), 'o-', 'Color', C.ltp, 'MarkerFaceColor', C.ltp, 'MarkerSize', 5);
plot(Ks, r4.Vd_peak, 's-', 'Color', C.volt, 'MarkerFaceColor', C.volt, 'MarkerSize', 5);
legend({'target spine V_{s,1}', 'branch V_d'}, 'Location', 'northwest', 'FontSize', 9); legend boxoff;
xlim([-0.5 20.5]); xlabel('Co-active neighbours K'); ylabel('Peak voltage (mV)'); panel_label(ax, 'C', 'Depolarization');
ax = axes('Position', pos(2,1)); hold on;
plot(Ks, r4.R_final, 'o-', 'Color', C.pool, 'MarkerFaceColor', C.pool, 'MarkerSize', 5);
plot(Ks, dSum, 's-', 'Color', [0.3 0.3 0.3], 'MarkerFaceColor', [0.3 0.3 0.3], 'MarkerSize', 5);
ref_line('h', p0.R0, ':', C.pool); ref_line('h', 0, '-', 'k', 1);
legend({'pool R (end)', '\Sigma_i \Deltaw_i (branch)'}, 'Location', 'west', 'FontSize', 9); legend boxoff;
xlim([-0.5 20.5]); xlabel('Co-active neighbours K'); ylabel('Weight units'); panel_label(ax, 'D', 'Conservation');
ax = axes('Position', pos(2,2)); hold on;
for j = 1:numel(stE), plot(Ks, D4e(j, :), 'o-', 'Color', C.seq(j, :), 'MarkerFaceColor', C.seq(j, :), 'MarkerSize', 4); end
ref_line('h', 0, '-', 'k', 1); xlim([-0.5 20.5]);
legend(arrayfun(@(s) sprintf('s_1 = %.1f', s), stE, 'UniformOutput', false), 'Location', 'northeast', 'FontSize', 9); legend boxoff;
xlabel('Co-active neighbours K'); ylabel('\Deltaw_1'); panel_label(ax, 'E', 'Target strength');
ax = axes('Position', pos(2,3)); hold on;
for j = 1:numel(Kset), plot(sn, D4b(j, :), '-', 'Color', C.seq(j+1, :)); end
ref_line('h', 0, '-', 'k', 1);
legend(arrayfun(@(k) sprintf('K = %d', k), Kset, 'UniformOutput', false), 'Location', 'northeast', 'FontSize', 9); legend boxoff;
xlim([0 1.5]); xlabel('Neighbour strength s_n'); ylabel('\Deltaw_1'); panel_label(ax, 'F', 'Neighbour strength');
save_figure(fig, 'figures_main/fig4_ltd_facilitation_competition', C.dpi);

%% ========================================================================
%% FIGURE 5: 2 x 2 mechanistic dissection {Mg block} x {shared pool}
%% ========================================================================
fprintf('> Figure 5: 2x2 mechanistic dissection\n');
% match B_fixed so that the target-alone peak calcium is identical to the full model
pa = p0; pa.stim_strengths = make_S(N, 0.5, 0, 0.5); pa.T_total = 300;
[~, ra] = run_simulation(pa); ca_ref = ra.Ca_peak(1, 1);
lo = 0; hi = 1;
for it = 1:30
    m = (lo + hi) / 2; pb = pa; pb.use_Mg_block = false; pb.B_fixed = m;
    [~, rb] = run_simulation(pb);
    if rb.Ca_peak(1, 1) < ca_ref, lo = m; else, hi = m; end
end
B_fixed = (lo + hi) / 2;
fprintf('   matched B_fixed = %.4f (target-alone peak Ca = %.3f)\n', B_fixed, ca_ref);
conds = {'Full model', 'Fixed Mg^{2+} block', 'No pool', 'Neither'};
mg = [true false true false]; rs = [true true false false];
cc5 = {C.full, C.no_mg, C.no_r, C.neither};
Ks = 0:20;
D5 = zeros(4, numel(Ks)); Ca5 = D5; S5 = D5;
for c = 1:4
    p = p0; p.use_Mg_block = mg(c); p.use_resource = rs(c); p.B_fixed = B_fixed;
    p.stim_strengths = make_S(N, 0.5, Ks, 0.5);
    [~, r5] = run_simulation(p);
    D5(c, :) = r5.dw(:, 1)'; Ca5(c, :) = r5.Ca_peak(:, 1)'; S5(c, :) = (sum(r5.w_final, 2) - N * p0.w_init)';
    fprintf('   %-18s dw(K=0) = %+.3f, dw(K=12) = %+.3f, dw(K=20) = %+.3f, max = %+.3f, branch sum dw(K=20) = %+.2f\n', ...
        strrep(strrep(conds{c}, '^{2+}', ''), '\', ''), D5(c, 1), D5(c, Ks == 12), D5(c, end), max(D5(c, :)), S5(c, end));
end
res.fig5 = struct('K', Ks, 'dw', D5, 'Ca', Ca5, 'dSumW', S5, 'B_fixed', B_fixed);
fig = figure('Position', [100 100 1350 760], 'Color', 'w', 'Visible', 'off');
ax = axes('Position', pos(1,1)); hold on;
for c = 1:4, plot(Ks, D5(c, :), 'o-', 'Color', cc5{c}, 'MarkerFaceColor', cc5{c}, 'MarkerSize', 4); end
ref_line('h', 0, '-', 'k', 1); xlim([-0.5 20.5]);
legend(conds, 'Location', 'northwest', 'FontSize', 9); legend boxoff;
xlabel('Co-active neighbours K'); ylabel('\Deltaw_1'); panel_label(ax, 'A', 'Target plasticity');
ax = axes('Position', pos(1,2)); hold on;
for c = [1 3 2 4], plot(Ks, Ca5(c, :), 'o-', 'Color', cc5{c}, 'MarkerFaceColor', cc5{c}, 'MarkerSize', 4); end
ref_line('h', p0.theta_LTP, '--', C.ltp); ref_line('h', p0.theta_LTD, ':', C.ltd); xlim([-0.5 20.5]);
xlabel('Co-active neighbours K'); ylabel('Peak [Ca^{2+}]_1'); panel_label(ax, 'B', 'Target calcium');
ax = axes('Position', pos(1,3)); hold on;
for c = 1:4, plot(Ks, S5(c, :), 'o-', 'Color', cc5{c}, 'MarkerFaceColor', cc5{c}, 'MarkerSize', 4); end
ref_line('h', p0.R0, ':', C.pool); ref_line('h', 0, '-', 'k', 1); xlim([-0.5 20.5]);
text(0.5, p0.R0 + 1.6, 'resting pool R_0', 'Color', C.pool, 'FontSize', 9);
xlabel('Co-active neighbours K'); ylabel('\Sigma_i \Deltaw_i (branch)'); panel_label(ax, 'C', 'Total branch weight');
ax = axes('Position', [0.07 0.09 0.40 0.33]); hold on;
k12 = find(Ks == 12); k6 = find(Ks == 6);
bw = [D5(:, k6), D5(:, k12)];
hb = bar(bw, 0.8); set(hb(1), 'FaceColor', C.ltd); set(hb(2), 'FaceColor', C.ltp);
ref_line('h', 0, '-', 'k', 1);
set(gca, 'XTick', 1:4, 'XTickLabel', {'Full', 'Fixed Mg', 'No pool', 'Neither'});
legend({'K = 6', 'K = 12'}, 'Location', 'northeast', 'FontSize', 9); legend boxoff;
ylabel('\Deltaw_1'); panel_label(ax, 'D', 'Comparison at K = 6 and K = 12');
annotation('textbox', [0.54, 0.09, 0.42, 0.33], 'String', { ...
    '\bfInterpretation\rm'; ''; ...
    '\bullet With a voltage-independent Mg^{2+} block, neighbours'; '   cannot change target calcium: no LTD, no LTP'; ...
    '\bullet Without the shared pool, LTP grows monotonically'; '   with K; total branch weight far exceeds R_0'; ...
    '\bullet The LTD \rightarrow LTP \rightarrow competition sequence'; '   requires both mechanisms'}, ...
    'FontSize', 11, 'EdgeColor', [0.6 0.6 0.6], 'BackgroundColor', [0.98 0.98 0.98], 'VerticalAlignment', 'middle');
save_figure(fig, 'figures_main/fig5_mechanistic_dissection', C.dpi);

%% ========================================================================
%% FIGURE 6: Branch-level competition and normalization (LTP and LTD together)
%% ========================================================================
fprintf('> Figure 6: competition and normalization across a branch\n');
n_act = 14; n_ep = 10; gap = 2000;   % inter-epoch interval (ms)
s_in = [linspace(0.1, 0.9, n_act), zeros(1, N - n_act)];
s_in(1:n_act) = s_in([1 8 2 9 3 10 4 11 5 12 6 13 7 14]);   % interleave positions
labels6 = {'Full model', 'No pool'};
W6 = cell(1, 2); R6 = cell(1, 2);
for c = 1:2
    p = p0; p.use_resource = (c == 1); p.stim_strengths = s_in;
    w = p0.w_init * ones(1, N); wE = w; R = p0.R0;
    W6{c} = zeros(n_ep + 1, N); W6{c}(1, :) = w; R6{c} = zeros(n_ep + 1, 1); R6{c}(1) = R;
    for e = 1:n_ep
        p.w_init = w; p.wE_init = wE; p.R_init = R;
        [~, r6] = run_simulation(p);
        w = r6.w_final; wE = r6.wE_final; R = r6.R_final;
        if p.use_resource, R = p.R0 + (R - p.R0) * exp(-gap / p.tau_R); end
        wE = w + (wE - w) * exp(-gap / p.tau_E);
        W6{c}(e + 1, :) = w; R6{c}(e + 1) = R;
    end
    dW = W6{c}(end, :) - p0.w_init; act = s_in > 0;
    fprintf('   %-10s sum(w): %.2f -> %.2f | LTP %d, LTD %d of %d active | inactive max|dw| = %.3g | corr(s, dw) = %.2f\n', ...
        labels6{c}, sum(W6{c}(1, :)), sum(W6{c}(end, :)), sum(dW(act) > 0.01), sum(dW(act) < -0.01), n_act, ...
        max(abs(dW(~act))), corr_simple(s_in(act), dW(act)));
end
res.fig6 = struct('s_in', s_in, 'W_full', W6{1}, 'W_nopool', W6{2}, 'R_full', R6{1}, 'R_nopool', R6{2});
fig = figure('Position', [100 100 1350 760], 'Color', 'w', 'Visible', 'off');
ax = axes('Position', pos(1,1)); hold on;
plot(0:n_ep, sum(W6{1}, 2), 'o-', 'Color', C.full, 'MarkerFaceColor', C.full);
plot(0:n_ep, sum(W6{2}, 2), 's-', 'Color', C.no_r, 'MarkerFaceColor', C.no_r);
ref_line('h', N * p0.w_init + p0.R0, ':', C.pool);
text(0.3, N * p0.w_init + p0.R0 + 1, '\Sigma w_0 + R_0', 'Color', C.pool, 'FontSize', 9);
legend(labels6, 'Location', 'southeast', 'FontSize', 9); legend boxoff;
xlabel('Induction epoch'); ylabel('\Sigma_i w_i'); panel_label(ax, 'A', 'Total branch weight');
ax = axes('Position', pos(1,2)); hold on;
plot(0:n_ep, R6{1}, 'o-', 'Color', C.pool, 'MarkerFaceColor', C.pool);
xlabel('Induction epoch'); ylabel('Pool R'); panel_label(ax, 'B', 'Pool content (full model)');
ax = axes('Position', pos(1,3)); hold on;
act = s_in > 0;
plot(s_in(act), W6{2}(end, act) - p0.w_init, 's', 'Color', C.no_r, 'MarkerFaceColor', C.no_r, 'MarkerSize', 7);
plot(s_in(act), W6{1}(end, act) - p0.w_init, 'o', 'Color', C.full, 'MarkerFaceColor', C.full, 'MarkerSize', 7);
plot(zeros(1, sum(~act)), W6{1}(end, ~act) - p0.w_init, 'o', 'Color', C.gray, 'MarkerSize', 7);
ref_line('h', 0, '-', 'k', 1);
legend({'No pool', 'Full model', 'inactive'}, 'Location', 'northwest', 'FontSize', 9); legend boxoff;
xlabel('Input strength s_i'); ylabel('\Deltaw_i after 10 epochs'); panel_label(ax, 'C', 'Selectivity');
ax = axes('Position', [0.07 0.09 0.40 0.33]); hold on;
[~, ord] = sort(s_in(act)); idx = find(act); idx = idx(ord);
cm = parula_like(numel(idx));
for j = 1:numel(idx), plot(0:n_ep, W6{1}(:, idx(j)), '-', 'Color', cm(j, :), 'LineWidth', 1.6); end
xlabel('Induction epoch'); ylabel('w_i (full model)'); panel_label(ax, 'D', 'Weight trajectories (colour = s_i)');
ax = axes('Position', [0.56 0.09 0.40 0.33]); hold on;
for j = 1:numel(idx), plot(0:n_ep, W6{2}(:, idx(j)), '-', 'Color', cm(j, :), 'LineWidth', 1.6); end
xlabel('Induction epoch'); ylabel('w_i (no pool)'); panel_label(ax, 'E', 'Without the shared pool');
save_figure(fig, 'figures_main/fig6_competition_normalization', C.dpi);

%% ========================================================================
%% FIGURE 7: Neighbourhood shifts the frequency threshold, weight fixed point and history
%% ========================================================================
fprintf('> Figure 7: frequency dependence, weight dependence and history\n');
freqs = [1 2 5 10 20 50 100]; K7 = [0 4 10 16]; npulse = 20;
D7a = zeros(numel(K7), numel(freqs));
for f = 1:numel(freqs)
    isi = 1000 / freqs(f);
    p = p0; p.stim_times = 100 + isi * (0:npulse-1); p.T_total = p.stim_times(end) + 300;
    p.stim_strengths = make_S(N, 0.5, K7, 0.5);
    [~, r7] = run_simulation(p);
    D7a(:, f) = r7.dw(:, 1);
end
for j = 1:numel(K7)
    fprintf('   freq response K = %2d: %s\n', K7(j), sprintf('%+.3f ', D7a(j, :)));
end
% initial-weight dependence (BTSP-like bidirectionality)
w0s = 0.1:0.1:1.9; K7b = [0 6 12];
[W0, KB] = meshgrid(w0s, K7b);
p = p0; p.stim_strengths = make_S(N, 0.5, reshape(KB', [], 1), 0.5);
Winit = p0.w_init * ones(numel(W0), N); Winit(:, 1) = reshape(W0', [], 1); p.w_init = Winit;
[~, r7b] = run_simulation(p);
D7b = reshape(r7b.dw(:, 1), numel(w0s), numel(K7b))';
for j = 1:numel(K7b)
    fprintf('   w0 dependence K = %2d: %s\n', K7b(j), sprintf('%+.2f ', D7b(j, :)));
end
% history: initial pool content
Rin = 0:0.25:4; K7c = [10 12 16];
[RR, KC] = meshgrid(Rin, K7c);
p = p0; p.stim_strengths = make_S(N, 0.5, reshape(KC', [], 1), 0.5); p.R_init = reshape(RR', [], 1);
[~, r7c] = run_simulation(p);
D7c = reshape(r7c.dw(:, 1), numel(Rin), numel(K7c))';
for j = 1:numel(K7c)
    fprintf('   R_init dependence K = %2d: dw(R=4) = %+.3f, dw(R=0) = %+.3f\n', K7c(j), D7c(j, end), D7c(j, 1));
end
res.fig7 = struct('freqs', freqs, 'K_freq', K7, 'dw_freq', D7a, 'w0', w0s, 'K_w0', K7b, 'dw_w0', D7b, ...
                  'R_init', Rin, 'K_R', K7c, 'dw_R', D7c);
fig = figure('Position', [100 100 1350 430], 'Color', 'w', 'Visible', 'off');
ax = axes('Position', [0.06 0.17 0.26 0.70]); hold on;
for j = 1:numel(K7), semilogx(freqs, D7a(j, :), 'o-', 'Color', C.seq(j, :), 'MarkerFaceColor', C.seq(j, :), 'MarkerSize', 5); end
set(gca, 'XScale', 'log', 'XTick', freqs, 'XTickLabel', arrayfun(@num2str, freqs, 'UniformOutput', false)); xlim([0.8 125]); ref_line('h', 0, '-', 'k', 1);
legend(arrayfun(@(k) sprintf('K = %d', k), K7, 'UniformOutput', false), 'Location', 'northwest', 'FontSize', 9); legend boxoff;
xlabel('Stimulation frequency (Hz, 20 pulses)'); ylabel('\Deltaw_1'); panel_label(ax, 'A', 'Frequency response');
ax = axes('Position', [0.39 0.17 0.26 0.70]); hold on;
for j = 1:numel(K7b), plot(w0s, D7b(j, :), 'o-', 'Color', C.seq(j, :), 'MarkerFaceColor', C.seq(j, :), 'MarkerSize', 5); end
ref_line('h', 0, '-', 'k', 1);
legend(arrayfun(@(k) sprintf('K = %d', k), K7b, 'UniformOutput', false), 'Location', 'southwest', 'FontSize', 9); legend boxoff;
xlabel('Initial target weight w_1(0)'); ylabel('\Deltaw_1'); panel_label(ax, 'B', 'Weight dependence');
ax = axes('Position', [0.72 0.17 0.26 0.70]); hold on;
for j = 1:numel(K7c), plot(Rin, D7c(j, :), 'o-', 'Color', C.seq(j+1, :), 'MarkerFaceColor', C.seq(j+1, :), 'MarkerSize', 5); end
ref_line('h', 0, '-', 'k', 1);
legend(arrayfun(@(k) sprintf('K = %d', k), K7c, 'UniformOutput', false), 'Location', 'northwest', 'FontSize', 9); legend boxoff;
xlabel('Initial pool content R(0)'); ylabel('\Deltaw_1'); panel_label(ax, 'C', 'Branch history');
save_figure(fig, 'figures_main/fig7_frequency_weight_history', C.dpi);

save('results_main.mat', 'res');
fprintf('Main figures done.\n\n');
