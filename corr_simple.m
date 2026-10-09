function r = corr_simple(x, y)
%% CORR_SIMPLE - Pearson correlation without toolbox dependencies
x = x(:) - mean(x(:)); y = y(:) - mean(y(:));
r = sum(x .* y) / sqrt(sum(x .^ 2) * sum(y .^ 2));
end
