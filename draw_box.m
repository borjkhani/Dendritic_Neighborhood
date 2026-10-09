function draw_box(x, y, w, h, face, edge, lines, fs)
%% DRAW_BOX - Rounded text box in data coordinates (portable MATLAB / Octave)
if nargin < 8, fs = 11; end
rectangle('Position', [x, y, w, h], 'Curvature', [0.08 0.25], 'FaceColor', face, 'EdgeColor', edge, 'LineWidth', 1.5);
n = numel(lines);
for k = 1:n
    yy = y + h - (k - 0.5) * h / n;
    text(x + w/2, yy, lines{k}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', fs);
end
end
