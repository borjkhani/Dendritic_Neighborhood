function cm = parula_like(n)
%% PARULA_LIKE - Blue -> green -> yellow sequential colours (portable)
anchors = [0.21 0.17 0.53; 0.07 0.45 0.80; 0.10 0.65 0.65; 0.55 0.75 0.30; 0.98 0.80 0.15];
x = linspace(0, 1, size(anchors, 1)); xi = linspace(0, 1, n);
cm = [interp1(x, anchors(:,1), xi)', interp1(x, anchors(:,2), xi)', interp1(x, anchors(:,3), xi)'];
end
