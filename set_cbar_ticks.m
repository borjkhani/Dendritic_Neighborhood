function set_cbar_ticks(cb, ticks, labels)
%% SET_CBAR_TICKS - Portable colourbar tick setting (MATLAB / GNU Octave)
if exist('OCTAVE_VERSION', 'builtin')
    set(cb, 'YTick', ticks, 'YTickLabel', labels);
else
    set(cb, 'Ticks', ticks, 'TickLabels', labels);
end
end
