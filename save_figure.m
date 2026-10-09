function save_figure(fig, filename, dpi)
%% SAVE_FIGURE - Export a figure as PNG (and .fig when running in MATLAB)
%
% Author: Mehdi Borjkhani
% Date: 2026 (revision)

if nargin < 3, dpi = 300; end
print(fig, filename, '-dpng', ['-r' num2str(dpi)]);
if ~exist('OCTAVE_VERSION', 'builtin')
    savefig(fig, [filename '.fig']);
end
close(fig);
fprintf('   Saved: %s.png\n', filename);
end
