function [Z, cmap, ticks, ticklabels] = two_slope_map(D, neg_lim, pos_lim)
%% TWO_SLOPE_MAP - Diverging colour scaling with separate ranges for LTD and LTP
%
% LTD magnitudes are typically much smaller than LTP magnitudes. To keep both
% visible, negative values are scaled to [-1, 0] by |neg_lim| and positive
% values to [0, 1] by pos_lim. The returned tick positions/labels give the
% true Delta-w values for the colourbar.
%
% Author: Mehdi Borjkhani
% Date: 2026 (revision)

Z = D;
Z(D < 0) = max(D(D < 0) ./ abs(neg_lim), -1);
Z(D >= 0) = min(D(D >= 0) ./ pos_lim, 1);

n = 128;
blue = [0.13 0.40 0.67]; red = [0.70 0.09 0.17]; white = [1 1 1];
lower = [linspace(blue(1), white(1), n)', linspace(blue(2), white(2), n)', linspace(blue(3), white(3), n)'];
upper = [linspace(white(1), red(1), n)', linspace(white(2), red(2), n)', linspace(white(3), red(3), n)'];
cmap = [lower; upper];

tv = [neg_lim, neg_lim/2, 0, pos_lim/2, pos_lim];
ticks = [-1, -0.5, 0, 0.5, 1];
ticklabels = arrayfun(@(v) sprintf('%+.2f', v), tv, 'UniformOutput', false);
ticklabels{3} = '0';
end
