function C = figure_defaults()
%% FIGURE_DEFAULTS - Global graphics defaults and the colour scheme used in all figures
%
% Author: Mehdi Borjkhani
% Date: 2026 (revision)

set(0, 'DefaultAxesFontSize', 12);
set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');
set(0, 'DefaultLineLineWidth', 2.0);
set(0, 'DefaultAxesLineWidth', 1.2);
set(0, 'DefaultAxesBox', 'off');
set(0, 'DefaultAxesTickDir', 'out');
set(0, 'DefaultFigureColor', 'w');

C.alone   = [0.35 0.35 0.35];   % target alone (grey)
C.ltd     = [0.13 0.40 0.67];   % LTD condition (blue)
C.ltp     = [0.75 0.15 0.15];   % LTP condition (red)
C.pool    = [0.85 0.50 0.05];   % resource pool (orange)
C.calcium = [0.50 0.20 0.70];   % calcium (purple)
C.volt    = [0.10 0.50 0.30];   % voltage (green)
C.full    = [0.20 0.40 0.80];   % full model
C.no_mg   = [0.85 0.20 0.20];   % no Mg block
C.no_r    = [0.20 0.65 0.30];   % no pool
C.neither = [0.65 0.20 0.65];   % neither
C.gray    = [0.55 0.55 0.55];
C.seq     = [0.10 0.10 0.10; 0.20 0.40 0.80; 0.85 0.45 0.10; 0.75 0.15 0.15; 0.40 0.65 0.30];
C.dpi     = 300;
end
