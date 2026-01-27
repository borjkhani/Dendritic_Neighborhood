%% GENERATE_ALL_FIGURES_POLISHED - Publication-quality figures
%
% Optimized for: Journal of Computational Neuroscience
%
% Changes from previous version:
%   - Larger fonts (14pt axes, 16pt titles, 12pt legends)
%   - Thicker lines (2.5pt data, 1.5pt reference)
%   - Larger figure sizes for clarity
%   - Simplified legends (details in captions)
%   - Consistent color scheme throughout
%   - High-resolution output (300 dpi)
%
% Author: Mehdi Borjkhani
% Date: 2025

clear; close all; clc;

fprintf('================================================================\n');
fprintf('  NEIGHBORHOOD PLASTICITY MODEL - POLISHED FIGURES\n');
fprintf('  For: Journal of Computational Neuroscience\n');
fprintf('================================================================\n\n');

% Create output directories
if ~exist('figures_main', 'dir'), mkdir('figures_main'); end
if ~exist('figures_supp', 'dir'), mkdir('figures_supp'); end

%% ========================================================================
%% GLOBAL FIGURE SETTINGS (Journal-quality)
%% ========================================================================
set(0, 'DefaultAxesFontSize', 14);
set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultAxesFontWeight', 'normal');
set(0, 'DefaultAxesLabelFontSizeMultiplier', 1.1);
set(0, 'DefaultAxesTitleFontSizeMultiplier', 1.2);
set(0, 'DefaultAxesTitleFontWeight', 'bold');
set(0, 'DefaultLineLineWidth', 2.5);
set(0, 'DefaultAxesLineWidth', 1.5);
set(0, 'DefaultAxesBox', 'off');
set(0, 'DefaultAxesTickDir', 'out');
set(0, 'DefaultFigureColor', 'w');

% Consistent color scheme
colors.target_alone = [0.2 0.4 0.8];      % Blue
colors.target_paired = [0.85 0.2 0.2];    % Red
colors.neighbor = [0.2 0.7 0.3];          % Green
colors.resource = [0.8 0.4 0.0];          % Orange
colors.calcium = [0.6 0.2 0.8];           % Purple
colors.full = [0.2 0.4 0.8];              % Blue (full model)
colors.no_mg = [0.85 0.2 0.2];            % Red (no Mg)
colors.no_r = [0.2 0.7 0.3];              % Green (no R)
colors.neither = [0.7 0.2 0.7];           % Magenta (neither)
colors.gray = [0.5 0.5 0.5];              % Gray for reference

% High-res export settings
export_dpi = 300;

% Load default parameters
p_base = params_default();
p_base.T_total = 400;
p_base.stim_times = [100, 150, 200];

%% ========================================================================
%%                          MAIN FIGURES
%% ========================================================================
fprintf('================================================================\n');
fprintf('                      MAIN FIGURES (1-7)\n');
fprintf('================================================================\n\n');

%% ------------------------------------------------------------------------
%% MAIN FIGURE 1: Model Schematic
%% ------------------------------------------------------------------------
fprintf('> Figure 1: Model Schematic\n');

fig1 = figure('Position', [100 100 1100 800], 'Color', 'w');

axes('Position', [0.05 0.05 0.9 0.9]);
hold on;

% Draw dendritic branch (thicker, more prominent)
fill([0.08 0.92 0.92 0.08], [0.46 0.46 0.54 0.54], [0.55 0.35 0.15], 'EdgeColor', [0.3 0.2 0.1], 'LineWidth', 2);
text(0.5, 0.38, 'Dendritic Branch (shared V_d)', 'HorizontalAlignment', 'center', ...
    'FontSize', 15, 'FontWeight', 'bold');

% Draw synapses (larger, clearer)
syn_x = [0.25, 0.5, 0.75];
syn_labels = {'Target', 'Neighbor 1', 'Neighbor 2'};
syn_colors = {colors.target_paired, colors.target_alone, colors.target_alone};

for i = 1:3
    % Spine neck
    fill([syn_x(i)-0.015 syn_x(i)+0.015 syn_x(i)+0.015 syn_x(i)-0.015], ...
         [0.54 0.54 0.70 0.70], [0.6 0.6 0.6], 'EdgeColor', 'k', 'LineWidth', 1.5);
    % Spine head (larger)
    rectangle('Position', [syn_x(i)-0.055, 0.70, 0.11, 0.14], ...
        'Curvature', [1 1], 'FaceColor', syn_colors{i}, 'EdgeColor', 'k', 'LineWidth', 2.5);
    % Label above
    text(syn_x(i), 0.89, syn_labels{i}, 'HorizontalAlignment', 'center', ...
        'FontSize', 14, 'FontWeight', 'bold');
    % Ca label inside
    text(syn_x(i), 0.77, sprintf('Ca_%d', i), 'HorizontalAlignment', 'center', ...
        'FontSize', 13, 'Color', 'w', 'FontWeight', 'bold');
end

% Shared resource box (larger)
rectangle('Position', [0.28, 0.15, 0.44, 0.14], 'Curvature', [0.3 0.3], ...
    'FaceColor', [0.95 0.88 0.4], 'EdgeColor', [0.6 0.5 0.1], 'LineWidth', 2.5);
text(0.5, 0.22, 'Shared Resource R', 'HorizontalAlignment', 'center', ...
    'FontSize', 14, 'FontWeight', 'bold');

% Arrows from resource to branch
for i = 1:3
    annotation('arrow', [syn_x(i), syn_x(i)], [0.27, 0.40], ...
        'LineWidth', 2, 'Color', [0.6 0.5 0.1], 'HeadWidth', 10, 'HeadLength', 8);
end

% Equation boxes (larger, clearer fonts)
annotation('textbox', [0.02, 0.88, 0.42, 0.11], 'String', ...
    {'{\bfNMDA Mg-block:}'; 'B(V) = 1 / (1 + [Mg] \cdot exp(-(V-V_{half})/k))'}, ...
    'FontSize', 13, 'BackgroundColor', [0.9 0.9 1], 'EdgeColor', [0.3 0.3 0.6], ...
    'LineWidth', 2, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

annotation('textbox', [0.56, 0.88, 0.42, 0.11], 'String', ...
    {'{\bfPlasticity Rule:}'; 'dw/dt = \eta \cdot (Ca - \theta) \cdot R   if Ca > \theta'}, ...
    'FontSize', 13, 'BackgroundColor', [1 0.9 0.9], 'EdgeColor', [0.6 0.3 0.3], ...
    'LineWidth', 2, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

annotation('textbox', [0.12, 0.01, 0.76, 0.10], 'String', ...
    {'{\bfKey Mechanism:} Neighbors depolarize branch \rightarrow relieve Mg-block \rightarrow'; ...
     'enhance Ca influx at target \rightarrow enable LTP'}, ...
    'FontSize', 13, 'BackgroundColor', [0.88 0.98 0.88], 'EdgeColor', [0.2 0.5 0.2], ...
    'LineWidth', 2, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

axis off;
xlim([0 1]); ylim([0 1]);

print(fig1, 'figures_main/fig1_schematic', '-dpng', ['-r' num2str(export_dpi)]);
saveas(fig1, 'figures_main/fig1_schematic.fig');
close(fig1);
fprintf('   Saved: figures_main/fig1_schematic.png\n\n');

%% ------------------------------------------------------------------------
%% MAIN FIGURE 2: Core Facilitation (4-panel)
%% ------------------------------------------------------------------------
fprintf('> Figure 2: Core Facilitation Effect\n');

% Run simulations
p1 = p_base;
p1.stim_strengths = [0.5; 0];
p1.active_synapses = [true; false];
[t1, ~, rec1] = run_simulation(p1, @stim_protocol, false);

p2 = p_base;
p2.stim_strengths = [0.5; 0.5];
[t2, ~, rec2] = run_simulation(p2, @stim_protocol, false);

fprintf('   Target Only:       Peak Ca = %.3f, dw = %.4f\n', rec1.Ca_peak(1), rec1.dw_final(1));
fprintf('   Target + Neighbor: Peak Ca = %.3f, dw = %.4f\n', rec2.Ca_peak(1), rec2.dw_final(1));

fig2 = figure('Position', [100 100 1400 1000], 'Color', 'w');

% A: Dendritic Voltage
subplot(2,2,1);
hold on;
fill([100 200 200 100], [-80 -80 5 5], [0.92 0.92 0.92], 'EdgeColor', 'none', 'HandleVisibility', 'off');
h1a = plot(t1, rec1.V_d, '-', 'LineWidth', 3, 'Color', colors.target_alone);
h2a = plot(t2, rec2.V_d, '-', 'LineWidth', 3, 'Color', colors.target_paired);
xlabel('Time (ms)');
ylabel('V_d (mV)');
title('A. Dendritic Voltage');
legend([h1a, h2a], {'Target Only', 'Target + Neighbor'}, 'Location', 'northeast', 'FontSize', 12, 'Box', 'off');
xlim([0 400]); ylim([-75 0]);
set(gca, 'XTick', 0:100:400, 'YTick', -75:25:0);
grid on; box off;

% B: Target Calcium
subplot(2,2,2);
hold on;
fill([100 200 200 100], [-0.1 -0.1 2.1 2.1], [0.92 0.92 0.92], 'EdgeColor', 'none', 'HandleVisibility', 'off');
h1b = plot(t1, rec1.Ca(:,1), '-', 'LineWidth', 3, 'Color', colors.target_alone);
h2b = plot(t2, rec2.Ca(:,1), '-', 'LineWidth', 3, 'Color', colors.target_paired);
yline(p_base.theta_LTP, '--', 'LineWidth', 2, 'Color', 'k', 'HandleVisibility', 'off');
yline(p_base.theta_LTD, ':', 'LineWidth', 1.5, 'Color', colors.gray, 'HandleVisibility', 'off');
text(320, p_base.theta_LTP+0.08, '\theta_{LTP}', 'FontSize', 13, 'FontWeight', 'bold');
text(320, p_base.theta_LTD-0.08, '\theta_{LTD}', 'FontSize', 12, 'Color', colors.gray);
xlabel('Time (ms)');
ylabel('[Ca^{2+}] (normalized)');
title('B. Target Calcium');
legend([h1b, h2b], {'Target Only', 'Target + Neighbor'}, 'Location', 'northeast', 'FontSize', 12, 'Box', 'off');
xlim([0 400]); ylim([0 1.8]);
grid on; box off;

% C: Target Weight
subplot(2,2,3);
hold on;
fill([100 200 200 100], [0.35 0.35 1.05 1.05], [0.92 0.92 0.92], 'EdgeColor', 'none', 'HandleVisibility', 'off');
h1c = plot(t1, rec1.w(:,1), '-', 'LineWidth', 3, 'Color', colors.target_alone);
h2c = plot(t2, rec2.w(:,1), '-', 'LineWidth', 3, 'Color', colors.target_paired);
xlabel('Time (ms)');
ylabel('w_{target}');
title('C. Target Synaptic Weight');
legend([h1c, h2c], {'Target Only', 'Target + Neighbor'}, 'Location', 'southeast', 'FontSize', 12, 'Box', 'off');
xlim([0 400]); ylim([0.45 1.0]);
grid on; box off;

% D: Summary Bar
subplot(2,2,4);
bar_data = [rec1.dw_final(1), rec2.dw_final(1)];
b = bar(bar_data, 0.6);
b.FaceColor = 'flat';
b.CData = [colors.target_alone; colors.target_paired];
b.EdgeColor = 'k';
b.LineWidth = 1.5;
set(gca, 'XTickLabel', {'Target Only', 'Target + Neighbor'}, 'FontSize', 13);
ylabel('\Deltaw_{target}');
title('D. Final Weight Change');
yline(0, 'k--', 'LineWidth', 1.5);
ylim([-0.05 max(bar_data)*1.4]);
grid on; box off;

% Add facilitation annotation
text(1.5, max(bar_data)*1.2, sprintf('Facilitation: +%.3f', rec2.dw_final(1)-rec1.dw_final(1)), ...
    'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

sgtitle('Figure 2: Neighbor Co-activity Enables Target LTP', 'FontSize', 18, 'FontWeight', 'bold');

print(fig2, 'figures_main/fig2_core_facilitation', '-dpng', ['-r' num2str(export_dpi)]);
saveas(fig2, 'figures_main/fig2_core_facilitation.fig');
close(fig2);
fprintf('   Saved: figures_main/fig2_core_facilitation.png\n\n');

%% ------------------------------------------------------------------------
%% MAIN FIGURE 3: Phase Diagram
%% ------------------------------------------------------------------------
fprintf('> Figure 3: Phase Diagram\n');

neighbor_range = linspace(0, 1.0, 25);
target_range = linspace(0.3, 0.8, 25);
dw_phase = zeros(length(target_range), length(neighbor_range));

fprintf('   Computing phase diagram (%d simulations)...\n', length(target_range)*length(neighbor_range));
for i = 1:length(target_range)
    for j = 1:length(neighbor_range)
        p_temp = p_base;
        p_temp.stim_strengths = [target_range(i); neighbor_range(j)];
        [~, ~, rec_temp] = run_simulation(p_temp, @stim_protocol, false);
        dw_phase(i, j) = rec_temp.dw_final(1);
    end
end

% Create diverging colormap (blue-white-red)
n_colors = 256;
cmap_neg = [linspace(0.2, 1, n_colors/2)', linspace(0.3, 1, n_colors/2)', linspace(0.8, 1, n_colors/2)'];
cmap_pos = [linspace(1, 0.8, n_colors/2)', linspace(1, 0.2, n_colors/2)', linspace(1, 0.2, n_colors/2)'];
cmap_diverging = [cmap_neg; cmap_pos];

fig3 = figure('Position', [100 100 1000 850], 'Color', 'w');

imagesc(neighbor_range, target_range, dw_phase);
set(gca, 'YDir', 'normal');
colormap(cmap_diverging);
max_abs = max(abs(dw_phase(:)));
caxis([-max_abs, max_abs]);

cb = colorbar;
ylabel(cb, 'Target \Deltaw', 'FontSize', 14, 'FontWeight', 'bold');
set(cb, 'LineWidth', 1.5, 'FontSize', 12);

xlabel('Neighbor Stimulation Strength', 'FontSize', 15);
ylabel('Target Stimulation Strength', 'FontSize', 15);
title('Figure 3: Phase Diagram of Neighborhood Plasticity', 'FontSize', 18, 'FontWeight', 'bold');

% Add contour at dw = 0
hold on;
[C, h] = contour(neighbor_range, target_range, dw_phase, [0 0], 'k-', 'LineWidth', 3.5);

% Label regions
text(0.08, 0.76, 'LTP', 'FontSize', 18, 'FontWeight', 'bold', 'Color', 'w');
text(0.72, 0.36, 'No Change', 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'k');
text(0.06, 0.36, 'LTD', 'FontSize', 14, 'FontWeight', 'bold', 'Color', [0.2 0.2 0.6]);

% Target-alone threshold
yline(0.52, 'w--', 'LineWidth', 2.5);
text(0.82, 0.545, 'Target alone', 'FontSize', 11, 'Color', 'w', 'FontWeight', 'bold');
text(0.82, 0.495, 'threshold', 'FontSize', 11, 'Color', 'w', 'FontWeight', 'bold');

set(gca, 'FontSize', 13, 'LineWidth', 1.5);

print(fig3, 'figures_main/fig3_phase_diagram', '-dpng', ['-r' num2str(export_dpi)]);
saveas(fig3, 'figures_main/fig3_phase_diagram.fig');
close(fig3);
fprintf('   Saved: figures_main/fig3_phase_diagram.png\n\n');

%% ------------------------------------------------------------------------
%% MAIN FIGURE 4: Facilitation-Competition Curve
%% ------------------------------------------------------------------------
fprintf('> Figure 4: Facilitation-Competition Curve\n');

neighbor_strengths = linspace(0, 2.0, 40);
dw_comp = zeros(length(neighbor_strengths), 1);
R_min = zeros(length(neighbor_strengths), 1);
Ca_peak_comp = zeros(length(neighbor_strengths), 1);

for i = 1:length(neighbor_strengths)
    p_temp = p_base;
    p_temp.stim_strengths = [0.5; neighbor_strengths(i)];
    [~, ~, rec_temp] = run_simulation(p_temp, @stim_protocol, false);
    dw_comp(i) = rec_temp.dw_final(1);
    R_min(i) = rec_temp.R_min;
    Ca_peak_comp(i) = rec_temp.Ca_peak(1);
end

[max_dw, max_idx] = max(dw_comp);
fprintf('   Optimal neighbor strength: %.2f (dw = %.4f)\n', neighbor_strengths(max_idx), max_dw);

fig4 = figure('Position', [100 100 1500 500], 'Color', 'w');

% A: Main curve
subplot(1,3,1);
hold on;
% Shading for facilitation vs competition
fill([0 neighbor_strengths(max_idx) neighbor_strengths(max_idx) 0], ...
     [-0.1 -0.1 max_dw*1.3 max_dw*1.3], [0.9 1 0.9], 'EdgeColor', 'none');
fill([neighbor_strengths(max_idx) 2 2 neighbor_strengths(max_idx)], ...
     [-0.1 -0.1 max_dw*1.3 max_dw*1.3], [1 0.9 0.9], 'EdgeColor', 'none');
plot(neighbor_strengths, dw_comp, '-', 'LineWidth', 3.5, 'Color', colors.target_alone);
plot(neighbor_strengths(max_idx), max_dw, 'o', 'MarkerSize', 14, 'LineWidth', 3, ...
    'Color', colors.target_paired, 'MarkerFaceColor', colors.target_paired);
yline(0, 'k--', 'LineWidth', 2);
text(0.18, max_dw*0.85, 'Facilitation', 'FontSize', 14, 'Color', [0 0.5 0], 'FontWeight', 'bold');
text(1.35, max_dw*0.85, 'Competition', 'FontSize', 14, 'Color', [0.6 0 0], 'FontWeight', 'bold');
text(neighbor_strengths(max_idx)+0.12, max_dw+0.01, sprintf('Optimal: %.2f', neighbor_strengths(max_idx)), ...
    'FontSize', 12, 'FontWeight', 'bold');
xlabel('Neighbor Strength');
ylabel('Target \Deltaw');
title('A. Non-monotonic Plasticity');
xlim([0 2]); ylim([-0.06 max_dw*1.3]);
grid on; box off;

% B: Resource depletion
subplot(1,3,2);
yyaxis left;
plot(neighbor_strengths, dw_comp, '-', 'LineWidth', 3, 'Color', colors.target_alone);
ylabel('Target \Deltaw', 'Color', colors.target_alone);
set(gca, 'YColor', colors.target_alone);
ylim([-0.15 0.35]);
yyaxis right;
plot(neighbor_strengths, R_min, '-', 'LineWidth', 3, 'Color', colors.resource);
ylabel('Minimum Resource R', 'Color', colors.resource);
set(gca, 'YColor', colors.resource);
ylim([0 1.05]);
xlabel('Neighbor Strength');
title('B. Resource Competition');
legend({'Target \Deltaw', 'Min Resource'}, 'Location', 'east', 'FontSize', 11, 'Box', 'off');
xlim([0 2]);
grid on; box off;

% C: Calcium vs plasticity
subplot(1,3,3);
yyaxis left;
plot(neighbor_strengths, dw_comp, '-', 'LineWidth', 3, 'Color', colors.target_alone);
ylabel('Target \Deltaw', 'Color', colors.target_alone);
set(gca, 'YColor', colors.target_alone);
ylim([-0.15 0.35]);
yyaxis right;
plot(neighbor_strengths, Ca_peak_comp, '-', 'LineWidth', 3, 'Color', colors.calcium);
hold on;
yline(p_base.theta_LTP, 'k--', 'LineWidth', 2);
text(1.75, p_base.theta_LTP+0.08, '\theta_{LTP}', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Peak [Ca^{2+}]_{target}', 'Color', colors.calcium);
set(gca, 'YColor', colors.calcium);
xlabel('Neighbor Strength');
title('C. Calcium Dynamics');
legend({'Target \Deltaw', 'Peak Ca'}, 'Location', 'southeast', 'FontSize', 11, 'Box', 'off');
xlim([0 2]);
grid on; box off;

sgtitle('Figure 4: Non-monotonic Facilitation \rightarrow Competition', 'FontSize', 18, 'FontWeight', 'bold');

print(fig4, 'figures_main/fig4_competition_curve', '-dpng', ['-r' num2str(export_dpi)]);
saveas(fig4, 'figures_main/fig4_competition_curve.fig');
close(fig4);
fprintf('   Saved: figures_main/fig4_competition_curve.png\n\n');

%% ------------------------------------------------------------------------
%% MAIN FIGURE 5: 2x2 Mechanistic Dissection
%% ------------------------------------------------------------------------
fprintf('> Figure 5: 2x2 Mechanistic Dissection\n');

neighbor_scan = linspace(0, 1.5, 30);
conditions = {'Full Model', 'No Mg-block', 'No Resource', 'Neither'};
colors_mech = {colors.full, colors.no_mg, colors.no_r, colors.neither};
dw_mech = zeros(length(neighbor_scan), 4);

for i = 1:length(neighbor_scan)
    for c = 1:4
        p_temp = p_base;
        p_temp.stim_strengths = [0.5; neighbor_scan(i)];
        
        switch c
            case 1  % Full model
                p_temp.use_Mg_block = true;
                p_temp.use_resource = true;
            case 2  % No Mg-block
                p_temp.use_Mg_block = false;
                p_temp.use_resource = true;
            case 3  % No Resource
                p_temp.use_Mg_block = true;
                p_temp.use_resource = false;
            case 4  % Neither
                p_temp.use_Mg_block = false;
                p_temp.use_resource = false;
        end
        
        [~, ~, rec_temp] = run_simulation(p_temp, @stim_protocol, false);
        dw_mech(i, c) = rec_temp.dw_final(1);
    end
end

fig5 = figure('Position', [100 100 1400 550], 'Color', 'w');

% A: All curves
subplot(1,2,1);
hold on;
for c = 1:4
    plot(neighbor_scan, dw_mech(:,c), '-', 'LineWidth', 3, 'Color', colors_mech{c});
end
yline(0, 'k--', 'LineWidth', 2);
xlabel('Neighbor Strength');
ylabel('Target \Deltaw');
title('A. Mechanistic Dissection');
legend(conditions, 'Location', 'northeast', 'FontSize', 12, 'Box', 'off');
xlim([0 1.5]); ylim([-0.1 1.6]);
grid on; box off;

% B: Bar comparison at neighbor = 0.5
subplot(1,2,2);
idx_05 = find(neighbor_scan >= 0.5, 1);
bar_vals = dw_mech(idx_05, :);
b = bar(bar_vals, 0.65);
b.FaceColor = 'flat';
b.CData = [colors.full; colors.no_mg; colors.no_r; colors.neither];
b.EdgeColor = 'k';
b.LineWidth = 1.5;
set(gca, 'XTickLabel', conditions, 'XTickLabelRotation', 20, 'FontSize', 12);
ylabel('Target \Deltaw (neighbor = 0.5)');
title('B. Comparison at Fixed Neighbor');
yline(0, 'k--', 'LineWidth', 2);
ylim([-0.1 1.7]);
grid on; box off;

% Print interpretation to command window
fprintf('   INTERPRETATION: Full model = non-monotonic (facilitation + competition).\n');
fprintf('                   No Mg-block = only competition. No Resource = only facilitation.\n');
fprintf('                   Both mechanisms required for full behavior.\n');

sgtitle('Figure 5: 2x2 Mechanistic Dissection -- {Mg-block} x {Resource}', 'FontSize', 18, 'FontWeight', 'bold');

print(fig5, 'figures_main/fig5_mechanistic_grid', '-dpng', ['-r' num2str(export_dpi)]);
saveas(fig5, 'figures_main/fig5_mechanistic_grid.fig');
close(fig5);
fprintf('   Saved: figures_main/fig5_mechanistic_grid.png\n\n');

%% ------------------------------------------------------------------------
%% MAIN FIGURE 6: N > 2 Synapses
%% ------------------------------------------------------------------------
fprintf('> Figure 6: N > 2 Synapses Analysis\n');

N_synapses = 10;
n_active_range = 0:9;
n_trials = 5;

dw_vs_n = zeros(length(n_active_range), n_trials);
Ca_vs_n = zeros(length(n_active_range), n_trials);

fprintf('   Computing N=%d synapse simulations...\n', N_synapses);

rng(42); % For reproducibility
for k = 1:length(n_active_range)
    n_active = n_active_range(k);
    for trial = 1:n_trials
        p_N = params_default();
        p_N.N_syn = N_synapses;
        p_N.T_total = 400;
        p_N.stim_times = [100, 150, 200];
        
        strengths = zeros(N_synapses, 1);
        active = false(N_synapses, 1);
        
        strengths(1) = 0.5;
        active(1) = true;
        
        if n_active > 0
            neighbor_idx = 2:N_synapses;
            active_neighbors = neighbor_idx(randperm(N_synapses-1, n_active));
            for idx = active_neighbors
                active(idx) = true;
                strengths(idx) = 0.3 + 0.2*rand();
            end
        end
        
        p_N.stim_strengths = strengths;
        p_N.active_synapses = active;
        
        [~, ~, rec_N] = run_simulation(p_N, @stim_protocol, false);
        dw_vs_n(k, trial) = rec_N.dw_final(1);
        Ca_vs_n(k, trial) = rec_N.Ca_peak(1);
    end
end

dw_mean = mean(dw_vs_n, 2);
dw_std = std(dw_vs_n, 0, 2);
Ca_mean = mean(Ca_vs_n, 2);
Ca_std = std(Ca_vs_n, 0, 2);

% Total strength scan
total_range = linspace(0, 3, 30);
dw_vs_total = zeros(size(total_range));

for i = 1:length(total_range)
    p_N = params_default();
    p_N.N_syn = 5;
    p_N.T_total = 400;
    p_N.stim_times = [100, 150, 200];
    
    neighbor_strength = total_range(i) / 4;
    p_N.stim_strengths = [0.5; neighbor_strength*ones(4,1)];
    p_N.active_synapses = true(5, 1);
    
    [~, ~, rec_N] = run_simulation(p_N, @stim_protocol, false);
    dw_vs_total(i) = rec_N.dw_final(1);
end

fig6 = figure('Position', [100 100 1500 500], 'Color', 'w');

subplot(1,3,1);
errorbar(n_active_range, dw_mean, dw_std, '-o', 'LineWidth', 2.5, 'MarkerSize', 10, ...
    'Color', colors.target_alone, 'MarkerFaceColor', colors.target_alone, 'CapSize', 12);
hold on;
yline(0, 'k--', 'LineWidth', 2);
xlabel('Number of Active Neighbors');
ylabel('Target \Deltaw');
title('A. Plasticity vs #Neighbors');
xlim([-0.5 9.5]);
set(gca, 'XTick', 0:2:9);
grid on; box off;

subplot(1,3,2);
errorbar(n_active_range, Ca_mean, Ca_std, '-s', 'LineWidth', 2.5, 'MarkerSize', 10, ...
    'Color', colors.target_paired, 'MarkerFaceColor', colors.target_paired, 'CapSize', 12);
hold on;
yline(p_base.theta_LTP, 'k--', 'LineWidth', 2);
text(7.5, p_base.theta_LTP+0.08, '\theta_{LTP}', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Number of Active Neighbors');
ylabel('Peak [Ca^{2+}]_{target}');
title('B. Calcium vs #Neighbors');
xlim([-0.5 9.5]);
set(gca, 'XTick', 0:2:9);
grid on; box off;

subplot(1,3,3);
plot(total_range, dw_vs_total, '-o', 'LineWidth', 2.5, 'MarkerSize', 8, ...
    'Color', colors.target_alone, 'MarkerFaceColor', colors.target_alone);
hold on;
yline(0, 'k--', 'LineWidth', 2);
xlabel('Total Neighbor Strength (N=5)');
ylabel('Target \Deltaw');
title('C. Plasticity vs Total Drive');
grid on; box off;

sgtitle(sprintf('Figure 6: Extended Neighborhood Analysis (N = %d Synapses)', N_synapses), ...
    'FontSize', 18, 'FontWeight', 'bold');

print(fig6, 'figures_main/fig6_N_synapses', '-dpng', ['-r' num2str(export_dpi)]);
saveas(fig6, 'figures_main/fig6_N_synapses.fig');
close(fig6);
fprintf('   Saved: figures_main/fig6_N_synapses.png\n\n');

%% ------------------------------------------------------------------------
%% MAIN FIGURE 7: Graphical Summary
%% ------------------------------------------------------------------------
fprintf('> Figure 7: Graphical Summary\n');

fig7 = figure('Position', [50 50 1500 800], 'Color', 'w');

% A: Mechanism schematic (simplified)
subplot(2,3,1);
hold on;
% Simple schematic
rectangle('Position', [0.1, 0.38, 0.8, 0.14], 'FaceColor', [0.6 0.4 0.25], 'EdgeColor', 'k', 'LineWidth', 2);
rectangle('Position', [0.22, 0.52, 0.14, 0.32], 'Curvature', [0.5 0.5], 'FaceColor', colors.target_paired, 'EdgeColor', 'k', 'LineWidth', 2);
rectangle('Position', [0.52, 0.52, 0.14, 0.32], 'Curvature', [0.5 0.5], 'FaceColor', colors.target_alone, 'EdgeColor', 'k', 'LineWidth', 2);
text(0.29, 0.92, 'Target', 'FontSize', 12, 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
text(0.59, 0.92, 'Neighbor', 'FontSize', 12, 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
text(0.5, 0.18, 'Shared V_d + R', 'FontSize', 12, 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
axis([0 1 0 1]); axis off;
title('A. Model Architecture', 'FontSize', 14, 'FontWeight', 'bold');

% B: Calcium effect
subplot(2,3,2);
hold on;
h7b1 = plot(t1, rec1.Ca(:,1), '-', 'LineWidth', 2.5, 'Color', colors.target_alone);
h7b2 = plot(t2, rec2.Ca(:,1), '-', 'LineWidth', 2.5, 'Color', colors.target_paired);
yline(p_base.theta_LTP, 'k--', 'LineWidth', 2, 'HandleVisibility', 'off');
xlabel('Time (ms)'); ylabel('[Ca^{2+}]');
title('B. Calcium Facilitation', 'FontSize', 14, 'FontWeight', 'bold');
legend([h7b1, h7b2], {'Alone', 'Paired'}, 'Location', 'northeast', 'FontSize', 10, 'Box', 'off');
xlim([0 400]); grid on; box off;

% C: Phase diagram (simplified)
subplot(2,3,3);
imagesc(neighbor_range, target_range, dw_phase);
set(gca, 'YDir', 'normal');
colormap(gca, cmap_diverging);
caxis([-max_abs, max_abs]);
hold on;
contour(neighbor_range, target_range, dw_phase, [0 0], 'k-', 'LineWidth', 2.5);
xlabel('Neighbor'); ylabel('Target');
title('C. Phase Diagram', 'FontSize', 14, 'FontWeight', 'bold');
cb = colorbar; ylabel(cb, '\Deltaw');
box off;

% D: Competition curve
subplot(2,3,4);
plot(neighbor_strengths, dw_comp, '-', 'LineWidth', 2.5, 'Color', colors.target_alone);
hold on;
plot(neighbor_strengths(max_idx), max_dw, 'o', 'MarkerSize', 12, 'LineWidth', 2.5, ...
    'Color', colors.target_paired, 'MarkerFaceColor', colors.target_paired);
yline(0, 'k--', 'LineWidth', 1.5);
xlabel('Neighbor Strength'); ylabel('\Deltaw');
title('D. Facilitation \rightarrow Competition', 'FontSize', 14, 'FontWeight', 'bold');
xlim([0 2]); grid on; box off;

% E: N synapses
subplot(2,3,5);
errorbar(n_active_range, dw_mean, dw_std, '-o', 'LineWidth', 2.5, 'MarkerSize', 8, ...
    'Color', colors.target_alone, 'MarkerFaceColor', colors.target_alone, 'CapSize', 10);
hold on;
yline(0, 'k--', 'LineWidth', 1.5);
xlabel('#Active Neighbors'); ylabel('\Deltaw');
title('E. N>2 Synapses', 'FontSize', 14, 'FontWeight', 'bold');
xlim([-0.5 9.5]); grid on; box off;

% F: Mechanistic grid
subplot(2,3,6);
hold on;
for c = 1:4
    plot(neighbor_scan, dw_mech(:,c), '-', 'LineWidth', 2.5, 'Color', colors_mech{c});
end
yline(0, 'k--', 'LineWidth', 1.5);
xlabel('Neighbor Strength'); ylabel('\Deltaw');
title('F. Mechanistic Grid', 'FontSize', 14, 'FontWeight', 'bold');
legend({'Full', 'No Mg', 'No R', 'Neither'}, 'Location', 'northeast', 'FontSize', 9, 'Box', 'off');
xlim([0 1.5]); grid on; box off;

sgtitle('Figure 7: Neighborhood Plasticity -- Summary', 'FontSize', 18, 'FontWeight', 'bold');

print(fig7, 'figures_main/fig7_summary', '-dpng', ['-r' num2str(export_dpi)]);
saveas(fig7, 'figures_main/fig7_summary.fig');
close(fig7);
fprintf('   Saved: figures_main/fig7_summary.png\n\n');

%% ========================================================================
%%                      SUPPLEMENTARY FIGURES
%% ========================================================================
fprintf('================================================================\n');
fprintf('                 SUPPLEMENTARY FIGURES (S1-S8)\n');
fprintf('================================================================\n\n');

%% ------------------------------------------------------------------------
%% SUPP FIGURE S1: Conductance Dependence (Boundary Conditions)
%% ------------------------------------------------------------------------
fprintf('> Figure S1: Conductance Dependence\n');

% Define neighbor strength scan range
neighbor_scan_s = linspace(0, 1.5, 25);

cond_scales = [1.0, 0.7, 0.5, 0.3];
cond_labels = {'100%', '70%', '50%', '30%'};

dw_volt = zeros(length(neighbor_scan_s), length(cond_scales));
Vd_peak = zeros(length(cond_scales), 2);
facil_volt = zeros(length(cond_scales), 1);

for ci = 1:length(cond_scales)
    p = p_base;
    p.g_AMPA = 0.5 * cond_scales(ci);
    p.g_NMDA = 0.5 * cond_scales(ci);
    
    p_alone = p; p_alone.stim_strengths = [0.5; 0]; p_alone.active_synapses = [true; false];
    [~, ~, rec_a] = run_simulation(p_alone, @stim_protocol, false);
    Vd_peak(ci, 1) = max(rec_a.V_d);
    
    p_pair = p; p_pair.stim_strengths = [0.5; 0.5];
    [~, ~, rec_p] = run_simulation(p_pair, @stim_protocol, false);
    Vd_peak(ci, 2) = max(rec_p.V_d);
    
    facil_volt(ci) = rec_p.dw_final(1) - rec_a.dw_final(1);
    
    for ni = 1:length(neighbor_scan_s)
        p_temp = p;
        p_temp.stim_strengths = [0.5; neighbor_scan_s(ni)];
        [~, ~, rec] = run_simulation(p_temp, @stim_protocol, false);
        dw_volt(ni, ci) = rec.dw_final(1);
    end
    
    fprintf('   %s: V_peak=%.1f/%.1f mV, Facilitation=%.3f\n', ...
        cond_labels{ci}, Vd_peak(ci,1), Vd_peak(ci,2), facil_volt(ci));
end

figS2 = figure('Position', [100 100 1500 500], 'Color', 'w');

subplot(1,3,1);
colors_cond = [colors.target_alone; colors.neighbor; colors.resource; colors.calcium];
hold on;
for ci = 1:length(cond_scales)
    plot(neighbor_scan_s, dw_volt(:,ci), '-', 'LineWidth', 2.5, 'Color', colors_cond(ci,:));
end
yline(0, 'k--', 'LineWidth', 2);
xlabel('Neighbor Strength');
ylabel('Target \Deltaw');
title('A. Effect at Different Conductances');
legend(cond_labels, 'Location', 'northeast', 'FontSize', 11, 'Box', 'off');
xlim([0 1.5]); grid on; box off;

subplot(1,3,2);
b = bar([Vd_peak(:,1), Vd_peak(:,2)], 0.7);
b(1).FaceColor = colors.target_alone;
b(2).FaceColor = colors.target_paired;
b(1).EdgeColor = 'k'; b(2).EdgeColor = 'k';
b(1).LineWidth = 1.5; b(2).LineWidth = 1.5;
set(gca, 'XTickLabel', cond_labels, 'FontSize', 12);
ylabel('Peak V_d (mV)');
title('B. Peak Dendritic Voltage');
legend({'Alone', 'Paired'}, 'Location', 'northeast', 'FontSize', 11, 'Box', 'off');
yline(-30, 'k--', 'LineWidth', 2);
text(4.4, -27, 'Mg-block threshold', 'FontSize', 10);
grid on; box off;

subplot(1,3,3);
b2 = bar(facil_volt, 0.6);
b2.FaceColor = 'flat';
for ci = 1:length(cond_scales)
    if facil_volt(ci) > 0.05
        b2.CData(ci,:) = colors.neighbor;
    else
        b2.CData(ci,:) = colors.target_paired;
    end
end
b2.EdgeColor = 'k';
b2.LineWidth = 1.5;
set(gca, 'XTickLabel', cond_labels, 'FontSize', 12);
ylabel('Facilitation');
title('C. Requires Sufficient Drive');
yline(0, 'k--', 'LineWidth', 2);
grid on; box off;

% Print prediction to command window
fprintf('   PREDICTION: Facilitation requires V_d > -30 mV for Mg-block relief.\n');
fprintf('               This defines the operating regime of the mechanism.\n');

sgtitle('Figure S1: Conductance Dependence (Operating Regime)', 'FontSize', 18, 'FontWeight', 'bold');

print(figS2, 'figures_supp/figS1_conductance_dependence', '-dpng', ['-r' num2str(export_dpi)]);
saveas(figS2, 'figures_supp/figS1_conductance_dependence.fig');
close(figS2);
fprintf('   Saved: figures_supp/figS1_conductance_dependence.png\n\n');

%% ------------------------------------------------------------------------
%% SUPP FIGURE S2: Weight Stabilization
%% ------------------------------------------------------------------------
fprintf('> Figure S2: Weight Stabilization\n');

p = p_base;
p.T_total = 600;
p.stim_strengths = [0.5; 0.5];
[t, ~, rec] = run_simulation(p, @stim_protocol, false);

dw_dt = [0; diff(rec.w(:,1))] / p.dt;

figS3 = figure('Position', [100 100 1400 500], 'Color', 'w');

subplot(1,3,1);
h_s3_ca = plot(t, rec.Ca(:,1), '-', 'LineWidth', 3, 'Color', colors.target_alone);
hold on;
h_s3_ltp = yline(p.theta_LTP, '--', 'LineWidth', 2, 'Color', colors.target_paired);
h_s3_ltd = yline(p.theta_LTD, ':', 'LineWidth', 2, 'Color', colors.gray);
fill([100 200 200 100], [0 0 2 2], 'k', 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off');
xlabel('Time (ms)');
ylabel('[Ca^{2+}]');
title('A. Calcium Dynamics');
legend([h_s3_ca, h_s3_ltp, h_s3_ltd], {'Ca', '\theta_{LTP}', '\theta_{LTD}'}, 'Location', 'northeast', 'FontSize', 11, 'Box', 'off');
xlim([0 600]); ylim([0 1.0]);
grid on; box off;

subplot(1,3,2);
plot(t, rec.w(:,1), '-', 'LineWidth', 3, 'Color', colors.target_alone);
hold on;
fill([100 200 200 100], [0.4 0.4 1 1], 'k', 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off');
xlabel('Time (ms)');
ylabel('w_{target}');
title('B. Weight Dynamics');
xlim([0 600]); ylim([0.45 0.8]);
grid on; box off;

subplot(1,3,3);
plot(t, dw_dt*1000, '-', 'LineWidth', 3, 'Color', colors.target_paired);
hold on;
yline(0, 'k--', 'LineWidth', 2, 'HandleVisibility', 'off');
fill([100 200 200 100], [-5 -5 12 12], 'k', 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off');
xlabel('Time (ms)');
ylabel('dw/dt (\times10^{-3} ms^{-1})');
title('C. Rate of Weight Change');
xlim([0 600]); ylim([-2 12]);
grid on; box off;

% Print interpretation to command window
fprintf('   After stimulation ends, Ca returns to %.2f < theta_LTD = %.2f\n', rec.Ca(end,1), p.theta_LTD);
fprintf('   Therefore dw/dt = 0 and weights stabilize.\n');

sgtitle('Figure S2: Weight Stabilization Mechanism', 'FontSize', 18, 'FontWeight', 'bold');

print(figS3, 'figures_supp/figS2_weight_stabilization', '-dpng', ['-r' num2str(export_dpi)]);
saveas(figS3, 'figures_supp/figS2_weight_stabilization.fig');
close(figS3);
fprintf('   Saved: figures_supp/figS2_weight_stabilization.png\n\n');

%% ------------------------------------------------------------------------
%% SUPP FIGURE S3: Timing Window
%% ------------------------------------------------------------------------
fprintf('> Figure S3: Timing Window\n');

delay_range = linspace(-50, 50, 35);
dw_timing = zeros(length(delay_range), 1);
Ca_timing = zeros(length(delay_range), 1);

for i = 1:length(delay_range)
    p_temp = p_base;
    p_temp.stim_strengths = [0.5; 0.5];
    p_temp.neighbor_delay = delay_range(i);
    [~, ~, rec_temp] = run_simulation(p_temp, @stim_protocol, false);
    dw_timing(i) = rec_temp.dw_final(1);
    Ca_timing(i) = rec_temp.Ca_peak(1);
end

figS4 = figure('Position', [100 100 1200 500], 'Color', 'w');

subplot(1,2,1);
hold on;
fill([-50 0 0 -50], [min(dw_timing)-0.05 min(dw_timing)-0.05 max(dw_timing)+0.08 max(dw_timing)+0.08], ...
    [0.9 0.9 1], 'EdgeColor', 'none');
fill([0 50 50 0], [min(dw_timing)-0.05 min(dw_timing)-0.05 max(dw_timing)+0.08 max(dw_timing)+0.08], ...
    [1 0.9 0.9], 'EdgeColor', 'none');
plot(delay_range, dw_timing, '-o', 'LineWidth', 2.5, 'MarkerSize', 8, ...
    'Color', colors.target_alone, 'MarkerFaceColor', colors.target_alone);
yline(0, 'k--', 'LineWidth', 2);
xline(0, ':', 'Color', colors.gray, 'LineWidth', 2);
[~, opt_idx] = max(dw_timing);
plot(delay_range(opt_idx), dw_timing(opt_idx), 'o', 'MarkerSize', 14, 'LineWidth', 3, ...
    'Color', colors.target_paired, 'MarkerFaceColor', colors.target_paired);
text(-38, max(dw_timing)*0.92, 'Neighbor first', 'FontSize', 12, 'FontWeight', 'bold');
text(12, max(dw_timing)*0.92, 'Target first', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Neighbor Delay (ms)');
ylabel('Target \Deltaw');
title('A. Plasticity vs Timing');
xlim([-55 55]);
grid on; box off;

subplot(1,2,2);
plot(delay_range, Ca_timing, '-s', 'LineWidth', 2.5, 'MarkerSize', 8, ...
    'Color', colors.target_paired, 'MarkerFaceColor', colors.target_paired);
hold on;
yline(p_base.theta_LTP, 'k--', 'LineWidth', 2);
xline(0, ':', 'Color', colors.gray, 'LineWidth', 2);
text(38, p_base.theta_LTP+0.03, '\theta_{LTP}', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Neighbor Delay (ms)');
ylabel('Peak [Ca^{2+}]_{target}');
title('B. Peak Calcium vs Timing');
xlim([-55 55]);
grid on; box off;

sgtitle('Figure S3: Timing Window for Neighbor Facilitation', 'FontSize', 18, 'FontWeight', 'bold');

print(figS4, 'figures_supp/figS3_timing_window', '-dpng', ['-r' num2str(export_dpi)]);
saveas(figS4, 'figures_supp/figS3_timing_window.fig');
close(figS4);
fprintf('   Saved: figures_supp/figS3_timing_window.png\n\n');

%% ------------------------------------------------------------------------
%% SUPP FIGURE S4: History Dependence (Resource State)
%% ------------------------------------------------------------------------
fprintf('> Figure S4: History Dependence (Resource State)\n');

% APPROACH: Show how initial resource state affects plasticity outcomes
% This isolates the resource effect without confounding weight changes

% Panel A: Scan initial resource levels
R_init_values = linspace(0.1, 1.0, 15);
dw_by_R_init = zeros(length(R_init_values), 1);

for ri = 1:length(R_init_values)
    p_temp = p_base;
    p_temp.R_init = R_init_values(ri);
    [~, ~, rec_temp] = run_simulation(p_temp, @stim_protocol, false);
    dw_by_R_init(ri) = rec_temp.dw_final(1);
end

fprintf('   R_init scan: R=1.0 -> dw=%.3f, R=0.5 -> dw=%.3f, R=0.1 -> dw=%.3f\n', ...
    dw_by_R_init(end), dw_by_R_init(round(length(R_init_values)/2)), dw_by_R_init(1));

% Panel B: Show 3-epoch time course with diminishing increments
p_3ep = p_base;
p_3ep.T_total = 1000;
p_3ep.stim_times = [100, 150, 200, 400, 450, 500, 700, 750, 800];  % 3 epochs, 200ms gaps
[t_3ep, ~, rec_3ep] = run_simulation(p_3ep, @stim_protocol, false);

% Find epoch boundaries
idx_e1_end = find(t_3ep >= 300, 1);
idx_e2_end = find(t_3ep >= 600, 1);

dw_e1 = rec_3ep.w(idx_e1_end, 1) - rec_3ep.w(1, 1);
dw_e2 = rec_3ep.w(idx_e2_end, 1) - rec_3ep.w(idx_e1_end, 1);
dw_e3 = rec_3ep.w(end, 1) - rec_3ep.w(idx_e2_end, 1);

fprintf('   3-epoch (tau_R=0.5s): E1=%.3f, E2=%.3f, E3=%.3f\n', dw_e1, dw_e2, dw_e3);

% Panel C: Compare tau_R values with 3 epochs
tau_R_test = [200, 500, 2000];  % fast, default, slow
dw_by_tau_epoch = zeros(3, length(tau_R_test));

for ti = 1:length(tau_R_test)
    p_tau = p_base;
    p_tau.T_total = 1000;
    p_tau.tau_R = tau_R_test(ti);
    p_tau.stim_times = [100, 150, 200, 400, 450, 500, 700, 750, 800];
    [t_tau, ~, rec_tau] = run_simulation(p_tau, @stim_protocol, false);
    
    idx1 = find(t_tau >= 300, 1);
    idx2 = find(t_tau >= 600, 1);
    
    dw_by_tau_epoch(1, ti) = rec_tau.w(idx1, 1) - rec_tau.w(1, 1);
    dw_by_tau_epoch(2, ti) = rec_tau.w(idx2, 1) - rec_tau.w(idx1, 1);
    dw_by_tau_epoch(3, ti) = rec_tau.w(end, 1) - rec_tau.w(idx2, 1);
end

fprintf('   tau_R comparison: fast E3=%.3f, default E3=%.3f, slow E3=%.3f\n', ...
    dw_by_tau_epoch(3,1), dw_by_tau_epoch(3,2), dw_by_tau_epoch(3,3));

figS5 = figure('Position', [100 100 1600 500], 'Color', 'w');

% Panel A: Plasticity depends on initial resource
subplot(1,3,1);
plot(R_init_values, dw_by_R_init, '-o', 'LineWidth', 3, 'MarkerSize', 10, ...
    'Color', colors.target_alone, 'MarkerFaceColor', colors.target_alone);
hold on;
yline(0, 'k--', 'LineWidth', 1.5, 'HandleVisibility', 'off');
xline(p_base.R_threshold, '--', 'LineWidth', 2, 'Color', colors.target_paired, 'HandleVisibility', 'off');

xlabel('Initial Resource R(t_0)');
ylabel('Target \Deltaw');
title('A. Same Protocol, Different Outcomes');

% Add annotations
text(0.95, max(dw_by_R_init)*0.85, 'Fresh branch', 'FontSize', 11, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'right', 'Color', [0.2 0.5 0.2]);
text(0.15, max(dw_by_R_init)*0.25, 'Depleted', 'FontSize', 11, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'left', 'Color', [0.6 0.3 0.2]);

xlim([0 1.05]);
grid on; box off;

% Panel B: Time course with 3 epochs
subplot(1,3,2);
hold on;

% Shading for epochs (gradient from green to red)
fill([100 200 200 100], [-0.1 -0.1 1.5 1.5], [0.85 0.95 0.85], 'EdgeColor', 'none', 'HandleVisibility', 'off');
fill([400 500 500 400], [-0.1 -0.1 1.5 1.5], [0.92 0.92 0.85], 'EdgeColor', 'none', 'HandleVisibility', 'off');
fill([700 800 800 700], [-0.1 -0.1 1.5 1.5], [0.95 0.85 0.85], 'EdgeColor', 'none', 'HandleVisibility', 'off');

yyaxis left;
h_w = plot(t_3ep, rec_3ep.w(:,1), '-', 'LineWidth', 3, 'Color', colors.target_alone);
ylabel('Target Weight w', 'Color', colors.target_alone);
set(gca, 'YColor', colors.target_alone);
ylim([0.45 1.0]);

yyaxis right;
h_R = plot(t_3ep, rec_3ep.R, '-', 'LineWidth', 2.5, 'Color', colors.resource);
ylabel('Resource R', 'Color', colors.resource);
set(gca, 'YColor', colors.resource);
ylim([0 1.1]);

xlabel('Time (ms)');
title('B. Three Identical Epochs (\tau_R = 0.5 s)');
legend([h_w, h_R], {'Weight', 'Resource'}, 'Location', 'east', 'FontSize', 11, 'Box', 'off');

% Add epoch labels with dw values
text(150, 1.02, sprintf('E1\n+%.2f', dw_e1), 'FontSize', 10, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center', 'Color', [0.2 0.5 0.2]);
text(450, 1.02, sprintf('E2\n+%.2f', dw_e2), 'FontSize', 10, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center', 'Color', [0.5 0.4 0.2]);
text(750, 1.02, sprintf('E3\n+%.2f', dw_e3), 'FontSize', 10, 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center', 'Color', [0.5 0.2 0.2]);

xlim([0 950]);
grid on; box off;

% Panel C: Compare tau_R values
subplot(1,3,3);
epoch_labels = {'Epoch 1', 'Epoch 2', 'Epoch 3'};
x_pos = 1:3;
bar_width = 0.25;

hold on;
colors_bars = [0.3 0.7 0.3; 0.7 0.5 0.2; 0.7 0.3 0.3];  % Green, orange, red for epochs
tau_labels = {'\tau_R=0.2s', '\tau_R=0.5s', '\tau_R=2s'};

for ti = 1:length(tau_R_test)
    x_offset = (ti - 2) * bar_width;
    b_ti = bar(x_pos + x_offset, dw_by_tau_epoch(:, ti), bar_width);
    b_ti.FaceColor = colors_bars(ti, :);
    b_ti.EdgeColor = 'k';
    b_ti.LineWidth = 1.5;
end

set(gca, 'XTick', x_pos, 'XTickLabel', epoch_labels, 'FontSize', 12);
ylabel('Target \Deltaw per epoch');
title('C. Faster Recovery = More Total Plasticity');
legend(tau_labels, 'Location', 'northeast', 'FontSize', 10, 'Box', 'off');
yline(0, 'k--', 'LineWidth', 1.5, 'HandleVisibility', 'off');
ylim([0 max(dw_by_tau_epoch(:))*1.25]);
grid on; box off;

% Add total plasticity comparison
totals = sum(dw_by_tau_epoch, 1);
for ti = 1:length(tau_R_test)
    text(ti, max(dw_by_tau_epoch(:))*1.15, sprintf('\\Sigma=%.2f', totals(ti)), ...
        'FontSize', 10, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
end

% Print key result to command window
fprintf('   KEY RESULT: Same stimulation produces different plasticity depending on resource state.\n');
fprintf('               Prior activity depletes resources, causing diminishing returns.\n');
fprintf('               Faster recovery (tau_R) enables more total plasticity across epochs.\n');

sgtitle('Figure S4: History Dependence -- Resource State Determines Plasticity', 'FontSize', 18, 'FontWeight', 'bold');

print(figS5, 'figures_supp/figS4_initial_conditions', '-dpng', ['-r' num2str(export_dpi)]);
saveas(figS5, 'figures_supp/figS4_initial_conditions.fig');
close(figS5);
fprintf('   Saved: figures_supp/figS4_initial_conditions.png\n\n');

%% ------------------------------------------------------------------------
%% SUPP FIGURE S5: Parameter Robustness (including τ_R)
%% ------------------------------------------------------------------------
fprintf('> Figure S5: Parameter Robustness\n');

% 5 parameters including tau_R
param_names = {'\theta_{LTP}', '\tau_{Ca}', '\kappa', 'g_{NMDA}', '\tau_R'};
param_fields = {'theta_LTP', 'tau_Ca', 'kappa', 'g_NMDA', 'tau_R'};
param_ranges = {
    linspace(0.5, 0.8, 12);
    linspace(15, 60, 12);
    linspace(0.01, 0.05, 12);
    linspace(0.3, 0.8, 12);
    [300, 500, 1000, 2000, 5000, 10000, 20000, 30000];  % tau_R in ms
};
param_defaults = [0.65, 30, 0.02, 0.5, 500];
param_units = {'', ' (ms)', '', '', ' (ms)'};

figS5 = figure('Position', [100 100 1600 700], 'Color', 'w');

for pp = 1:5
    facilitation = zeros(length(param_ranges{pp}), 1);
    dw_paired = zeros(length(param_ranges{pp}), 1);
    dw_alone = zeros(length(param_ranges{pp}), 1);
    
    for i = 1:length(param_ranges{pp})
        p_rob = p_base;
        p_rob.(param_fields{pp}) = param_ranges{pp}(i);
        
        p_a = p_rob; p_a.stim_strengths = [0.5; 0]; p_a.active_synapses = [true; false];
        [~, ~, rec_a] = run_simulation(p_a, @stim_protocol, false);
        dw_alone(i) = rec_a.dw_final(1);
        
        p_p = p_rob; p_p.stim_strengths = [0.5; 0.5];
        [~, ~, rec_p] = run_simulation(p_p, @stim_protocol, false);
        dw_paired(i) = rec_p.dw_final(1);
        
        facilitation(i) = dw_paired(i) - dw_alone(i);
    end
    
    % Top row: dw curves
    subplot(2,5,pp);
    hold on;
    
    % For tau_R, use log scale on x-axis
    if pp == 5
        semilogx(param_ranges{pp}/1000, dw_alone, '--', 'LineWidth', 2.5, 'Color', colors.target_alone);
        semilogx(param_ranges{pp}/1000, dw_paired, '-', 'LineWidth', 3, 'Color', colors.target_paired);
        xline(param_defaults(pp)/1000, 'k--', 'LineWidth', 2);
        xlabel([param_names{pp} ' (s)']);
        xlim([0.2 40]);
    else
        plot(param_ranges{pp}, dw_alone, '--', 'LineWidth', 2.5, 'Color', colors.target_alone);
        plot(param_ranges{pp}, dw_paired, '-', 'LineWidth', 3, 'Color', colors.target_paired);
        xline(param_defaults(pp), 'k--', 'LineWidth', 2);
        xlabel([param_names{pp} param_units{pp}]);
    end
    
    yline(0, 'k:', 'LineWidth', 1.5);
    ylabel('\Deltaw');
    title(sprintf('%s', param_names{pp}));
    if pp == 1
        legend({'Alone', 'Paired'}, 'Location', 'best', 'FontSize', 9, 'Box', 'off');
    end
    grid on; box off;
    
    % Bottom row: facilitation bars
    subplot(2,5,pp+5);
    
    if pp == 5
        % For tau_R, use bar chart with labels
        b = bar(1:length(param_ranges{pp}), facilitation, 0.7);
        tau_labels = {'0.3', '0.5', '1', '2', '5', '10', '20', '30'};
        set(gca, 'XTick', 1:length(tau_labels), 'XTickLabel', tau_labels, 'FontSize', 9);
        xlabel([param_names{pp} ' (s)']);
    else
        b = bar(param_ranges{pp}, facilitation, 0.8);
        xline(param_defaults(pp), '--', 'LineWidth', 2, 'Color', colors.target_paired);
        xlabel([param_names{pp} param_units{pp}]);
    end
    
    b.FaceColor = colors.target_alone;
    b.EdgeColor = 'none';
    hold on;
    yline(0, 'k--', 'LineWidth', 2);
    ylabel('Facilitation');
    
    % Status label
    frac_pos = sum(facilitation > 0.02) / length(facilitation);
    if frac_pos > 0.7
        status = 'ROBUST';
        col = colors.neighbor;
    elseif frac_pos > 0.3
        status = 'PARTIAL';
        col = colors.resource;
    else
        status = 'SENSITIVE';
        col = colors.target_paired;
    end
    
    if max(facilitation) > 0
        text_y = max(facilitation)*0.85;
    else
        text_y = 0.1;
    end
    
    if pp == 5
        text(length(param_ranges{pp})/2, text_y, status, ...
            'FontSize', 10, 'Color', col, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    else
        text(mean(param_ranges{pp}), text_y, status, ...
            'FontSize', 10, 'Color', col, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    end
    grid on; box off;
    
    % Print summary
    fprintf('   %s: Facilitation range [%.3f, %.3f] - %s\n', ...
        param_names{pp}, min(facilitation), max(facilitation), status);
end

sgtitle('Figure S5: Parameter Robustness Analysis', 'FontSize', 18, 'FontWeight', 'bold');

print(figS5, 'figures_supp/figS5_parameter_robustness', '-dpng', ['-r' num2str(export_dpi)]);
saveas(figS5, 'figures_supp/figS5_parameter_robustness.fig');
close(figS5);
fprintf('   Saved: figures_supp/figS5_parameter_robustness.png\n\n');

%% ------------------------------------------------------------------------
%% SUPP FIGURE S6: Protocol Dependence
%% ------------------------------------------------------------------------
fprintf('> Figure S6: Protocol Dependence\n');

protocols = {
    struct('name', '50 Hz (3p)', 'times', [100, 120, 140]);
    struct('name', '20 Hz (3p)', 'times', [100, 150, 200]);
    struct('name', '100 Hz (5p)', 'times', [100, 110, 120, 130, 140]);
    struct('name', 'Theta burst', 'times', [100, 110, 120, 200, 210, 220]);
    struct('name', 'Single', 'times', [100]);
    struct('name', 'Long train', 'times', 100:20:280)
};

dw_prot_alone = zeros(length(protocols), 1);
dw_prot_paired = zeros(length(protocols), 1);

for i = 1:length(protocols)
    p_prot = p_base;
    p_prot.stim_times = protocols{i}.times;
    
    p_a = p_prot; p_a.stim_strengths = [0.5; 0]; p_a.active_synapses = [true; false];
    [~, ~, rec_a] = run_simulation(p_a, @stim_protocol, false);
    dw_prot_alone(i) = rec_a.dw_final(1);
    
    p_p = p_prot; p_p.stim_strengths = [0.5; 0.5];
    [~, ~, rec_p] = run_simulation(p_p, @stim_protocol, false);
    dw_prot_paired(i) = rec_p.dw_final(1);
    
    fprintf('   %s: Alone=%.3f, Paired=%.3f\n', protocols{i}.name, dw_prot_alone(i), dw_prot_paired(i));
end

figS7 = figure('Position', [100 100 1300 550], 'Color', 'w');

subplot(1,2,1);
bar_data = [dw_prot_alone, dw_prot_paired];
b = bar(bar_data, 0.8);
b(1).FaceColor = colors.target_alone;
b(2).FaceColor = colors.target_paired;
b(1).EdgeColor = 'k'; b(2).EdgeColor = 'k';
b(1).LineWidth = 1.5; b(2).LineWidth = 1.5;
set(gca, 'XTickLabel', cellfun(@(x) x.name, protocols, 'UniformOutput', false), ...
    'XTickLabelRotation', 30, 'FontSize', 11);
ylabel('Target \Deltaw');
title('A. Protocol Comparison');
legend({'Target Alone', 'Target + Neighbor'}, 'Location', 'northwest', 'FontSize', 11, 'Box', 'off');
yline(0, 'k--', 'LineWidth', 2);
grid on; box off;

subplot(1,2,2);
facil_prot = dw_prot_paired - dw_prot_alone;
b2 = bar(facil_prot, 0.6);
b2.FaceColor = 'flat';
for i = 1:length(facil_prot)
    if facil_prot(i) > 0.02
        b2.CData(i,:) = colors.neighbor;  % Green = facilitation
    elseif facil_prot(i) < -0.02
        b2.CData(i,:) = colors.target_paired;  % Red = competition
    else
        b2.CData(i,:) = colors.gray;  % Gray = no effect
    end
end
b2.EdgeColor = 'k';
b2.LineWidth = 1.5;
set(gca, 'XTickLabel', cellfun(@(x) x.name, protocols, 'UniformOutput', false), ...
    'XTickLabelRotation', 30, 'FontSize', 11);
ylabel('Facilitation (\Deltaw_{paired} - \Deltaw_{alone})');
title('B. Facilitation vs Competition');
yline(0, 'k--', 'LineWidth', 2);
grid on; box off;

sgtitle('Figure S6: Protocol Dependence', 'FontSize', 18, 'FontWeight', 'bold');

% Print prediction to command window
fprintf('   PREDICTION: Weak protocols (20Hz, single) -> facilitation (target subthreshold alone)\n');
fprintf('               Strong protocols (100Hz, theta, long) -> competition (target suprathreshold alone)\n');

print(figS7, 'figures_supp/figS6_protocol_dependence', '-dpng', ['-r' num2str(export_dpi)]);
saveas(figS7, 'figures_supp/figS6_protocol_dependence.fig');
close(figS7);
fprintf('   Saved: figures_supp/figS6_protocol_dependence.png\n\n');

%% ------------------------------------------------------------------------
%% SUPP FIGURE S7: Detailed Facilitation (8 panels)
%% ------------------------------------------------------------------------
fprintf('> Figure S7: Detailed Facilitation (8 panels)\n');

figS7 = figure('Position', [50 50 1600 900], 'Color', 'w');

subplot(2,4,1);
hold on;
fill([100 200 200 100], [-80 -80 5 5], [0.92 0.92 0.92], 'EdgeColor', 'none', 'HandleVisibility', 'off');
h1_s8a = plot(t1, rec1.V_d, '-', 'LineWidth', 2.5, 'Color', colors.target_alone);
h2_s8a = plot(t2, rec2.V_d, '-', 'LineWidth', 2.5, 'Color', colors.target_paired);
xlabel('Time (ms)'); ylabel('V_d (mV)');
title('A. Dendritic Voltage');
legend([h1_s8a, h2_s8a], {'Alone', 'Paired'}, 'Location', 'northeast', 'FontSize', 10, 'Box', 'off');
xlim([0 400]); ylim([-75 0]);
grid on; box off;

subplot(2,4,2);
hold on;
fill([100 200 200 100], [-0.1 -0.1 2.1 2.1], [0.92 0.92 0.92], 'EdgeColor', 'none', 'HandleVisibility', 'off');
plot(t1, rec1.Ca(:,1), '-', 'LineWidth', 2.5, 'Color', colors.target_alone);
plot(t2, rec2.Ca(:,1), '-', 'LineWidth', 2.5, 'Color', colors.target_paired);
yline(p_base.theta_LTP, 'k--', 'LineWidth', 2, 'HandleVisibility', 'off');
yline(p_base.theta_LTD, 'k:', 'LineWidth', 1.5, 'HandleVisibility', 'off');
xlabel('Time (ms)'); ylabel('[Ca^{2+}]');
title('B. Target Calcium');
xlim([0 400]); ylim([0 1.8]);
grid on; box off;

subplot(2,4,3);
hold on;
fill([100 200 200 100], [0.35 0.35 1.05 1.05], [0.92 0.92 0.92], 'EdgeColor', 'none', 'HandleVisibility', 'off');
plot(t1, rec1.w(:,1), '-', 'LineWidth', 2.5, 'Color', colors.target_alone);
plot(t2, rec2.w(:,1), '-', 'LineWidth', 2.5, 'Color', colors.target_paired);
xlabel('Time (ms)'); ylabel('w_{target}');
title('C. Target Weight');
xlim([0 400]); ylim([0.45 1.0]);
grid on; box off;

subplot(2,4,4);
hold on;
fill([100 200 200 100], [-0.05 -0.05 1.1 1.1], [0.92 0.92 0.92], 'EdgeColor', 'none', 'HandleVisibility', 'off');
plot(t1, rec1.R, '-', 'LineWidth', 2.5, 'Color', colors.target_alone);
plot(t2, rec2.R, '-', 'LineWidth', 2.5, 'Color', colors.target_paired);
yline(p_base.R_threshold, 'k--', 'LineWidth', 2, 'HandleVisibility', 'off');
xlabel('Time (ms)'); ylabel('Resource R');
title('D. Shared Resource');
xlim([0 400]); ylim([0 1.1]);
grid on; box off;

subplot(2,4,5);
bar_data_e = [rec1.dw_final(1), rec2.dw_final(1)];
b_e = bar(bar_data_e, 0.6);
b_e.FaceColor = 'flat';
b_e.CData = [colors.target_alone; colors.target_paired];
b_e.EdgeColor = 'k';
b_e.LineWidth = 1.5;
set(gca, 'XTickLabel', {'Alone', 'Paired'}, 'FontSize', 12);
ylabel('\Deltaw_{target}');
title('E. Final Weight Change');
yline(0, 'k--', 'LineWidth', 1.5);
grid on; box off;

subplot(2,4,6);
hold on;
fill([100 200 200 100], [-0.05 -0.05 1.05 1.05], [0.92 0.92 0.92], 'EdgeColor', 'none', 'HandleVisibility', 'off');
plot(t1, rec1.B_Mg, '-', 'LineWidth', 2.5, 'Color', colors.target_alone);
plot(t2, rec2.B_Mg, '-', 'LineWidth', 2.5, 'Color', colors.target_paired);
xlabel('Time (ms)'); ylabel('B(V)');
title('F. Mg-block Relief');
xlim([0 400]); ylim([0 1]);
grid on; box off;

subplot(2,4,7);
hold on;
fill([100 200 200 100], [-0.05 -0.05 0.45 0.45], [0.92 0.92 0.92], 'EdgeColor', 'none', 'HandleVisibility', 'off');
plot(t1, rec1.s_NMDA(:,1), '-', 'LineWidth', 2.5, 'Color', colors.target_alone);
plot(t2, rec2.s_NMDA(:,1), '-', 'LineWidth', 2.5, 'Color', colors.target_paired);
xlabel('Time (ms)'); ylabel('s_{NMDA}');
title('G. NMDA Activation');
xlim([0 400]); ylim([0 0.4]);
grid on; box off;

subplot(2,4,8);
bar_data_h = [rec1.Ca_peak(1), rec2.Ca_peak(1)];
b_h = bar(bar_data_h, 0.6);
b_h.FaceColor = 'flat';
b_h.CData = [colors.target_alone; colors.target_paired];
b_h.EdgeColor = 'k';
b_h.LineWidth = 1.5;
hold on;
yline(p_base.theta_LTP, 'k--', 'LineWidth', 2);
set(gca, 'XTickLabel', {'Alone', 'Paired'}, 'FontSize', 12);
ylabel('Peak [Ca^{2+}]');
title('H. Peak Calcium');
grid on; box off;

sgtitle('Figure S7: Detailed Facilitation Dynamics', 'FontSize', 18, 'FontWeight', 'bold');

print(figS7, 'figures_supp/figS7_detailed_facilitation', '-dpng', ['-r' num2str(export_dpi)]);
saveas(figS7, 'figures_supp/figS7_detailed_facilitation.fig');
close(figS7);
fprintf('   Saved: figures_supp/figS7_detailed_facilitation.png\n\n');

%% ========================================================================
%%                          SUMMARY
%% ========================================================================
fprintf('\n');
fprintf('================================================================\n');
fprintf('              POLISHED FIGURE GENERATION COMPLETE\n');
fprintf('================================================================\n\n');

fprintf('MAIN FIGURES (figures_main/):\n');
fprintf('----------------------------------------------------------------\n');
main_files = dir('figures_main/*.png');
for i = 1:length(main_files)
    fprintf('  %d. %s\n', i, main_files(i).name);
end

fprintf('\nSUPPLEMENTARY FIGURES (figures_supp/):\n');
fprintf('----------------------------------------------------------------\n');
supp_files = dir('figures_supp/*.png');
for i = 1:length(supp_files)
    fprintf('  S%d. %s\n', i, supp_files(i).name);
end

fprintf('\nKEY RESULTS:\n');
fprintf('----------------------------------------------------------------\n');
fprintf('  Target alone:       Peak Ca = %.3f, dw = %.4f\n', rec1.Ca_peak(1), rec1.dw_final(1));
fprintf('  Target + Neighbor:  Peak Ca = %.3f, dw = %.4f\n', rec2.Ca_peak(1), rec2.dw_final(1));
fprintf('  Facilitation:       %.4f\n', rec2.dw_final(1) - rec1.dw_final(1));
fprintf('  Optimal neighbor:   %.2f\n', neighbor_strengths(max_idx));
fprintf('\n');
fprintf('Export settings: %d dpi, Arial font, publication-quality\n', export_dpi);
fprintf('Ready for Journal of Computational Neuroscience submission!\n');
