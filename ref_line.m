function h = ref_line(orientation, value, style, color, lw)
%% REF_LINE - Horizontal ('h') or vertical ('v') reference line across current axes
% (portable replacement for xline/yline, works in MATLAB and GNU Octave)
%
% Author: Mehdi Borjkhani
% Date: 2026 (revision)

if nargin < 3, style = '--'; end
if nargin < 4, color = [0.4 0.4 0.4]; end
if nargin < 5, lw = 1.2; end
ax = gca; hold(ax, 'on');
if orientation == 'h'
    xl = xlim(ax); h = plot(ax, xl, [value value], style, 'Color', color, 'LineWidth', lw);
    xlim(ax, xl);
else
    yl = ylim(ax); h = plot(ax, [value value], yl, style, 'Color', color, 'LineWidth', lw);
    ylim(ax, yl);
end
set(h, 'HandleVisibility', 'off');
end
