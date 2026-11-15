function res = hoiquy_mue(x, y, x_pred)
% HOIQUY_MUE Hoi quy ham mu co so e dang y = a * e^(b*x)
% Tuyen tinh hoa bang logarit tu nhien: ln(y) = ln(a) + b*x
% (Yeu cau y > 0)

    x = x(:);
    y = y(:);
    n = numel(x);
    if n ~= numel(y) || n < 2
        error('Du lieu x va y phai co cung so phan tu va n >= 2!');
    end
    if any(y <= 0)
        error('Hoi quy mu co so e (y = a*e^(b*x)) yeu cau moi gia tri y > 0!');
    end

    Y = log(y);
    lin = hoiquy_tuyentinh(x, Y);

    b = lin.a;
    a = exp(lin.b);

    f_hat = @(xq) a .* exp(b .* xq);
    y_hat = f_hat(x);

    ss_res = sum((y - y_hat).^2);
    ss_tot = sum((y - mean(y)).^2);
    r2 = 1 - ss_res / max(ss_tot, eps);
    rmse = sqrt(mean((y - y_hat).^2));

    eq_str = sprintf('y = %.6g * e^(%.6g * x)', a, b);

    if nargin < 3
        x_pred = [];
    end
    y_pred = [];
    if ~isempty(x_pred)
        y_pred = f_hat(x_pred);
    end

    res = struct( ...
        'method', 'Hoi quy Mu co so e (y = a*e^(b*x))', ...
        'a', a, ...
        'b', b, ...
        'eq_str', eq_str, ...
        'r2', r2, ...
        'r2_log', lin.r2, ...
        'rmse', rmse, ...
        'eval_fn', f_hat, ...
        'y_fit', y_hat, ...
        'residuals', y - y_hat, ...
        'table_data', [x, y, y_hat, abs(y - y_hat)], ...
        'headers', {{'x_i', 'y_i (Thuc)', 'y_hat (a*e^(bx))', 'Sai lech |e_i|'}}, ...
        'x_pred', x_pred, ...
        'y_pred', y_pred);
end
