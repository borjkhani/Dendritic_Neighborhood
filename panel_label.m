function panel_label(ax, letter, ttl)
%% PANEL_LABEL - Bold panel letter + short title above an axes
%
% Author: Mehdi Borjkhani
% Date: 2026 (revision)
if nargin < 3, ttl = ''; end
title(ax, sprintf('%s   %s', letter, ttl), 'FontWeight', 'bold', 'FontSize', 13, ...
      'HorizontalAlignment', 'left', 'Units', 'normalized', 'Position', [-0.12 1.03 0]);
end
