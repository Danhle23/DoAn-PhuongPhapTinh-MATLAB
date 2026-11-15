function res = hoiquy_logarit(x, y, x_pred)
% HOIQUY_LOGARIT Hoi quy ham Logarit dang y = a + b * ln(x)
% (Bo sung day du theo giao dien mau trang 2: Tuyen tinh, Ham mu, Mu e, Logarit)

    x = x(:);
    y = y(:);
    n = numel(x);
    if n ~= numel(y) || n < 2
        error('Du lieu x va y phai co cung so phan tu va n >= 2!');
    end
    if any(x <= 0)
        error('Hoi quy Logarit y = a + b*ln(x) yeu cau moi gia tri x > 0!');
    end

    X = log(x);
    lin = hoiquy_tuyentinh(X, y);

    b = lin.a;
    a = lin.b;

    f_hat = @(xq) a + b .* log(xq);
    y_hat = f_hat(x);

    if b >= 0
        eq_str = sprintf('y = %.6g + %.6g * ln(x)', a, b);
    else
        eq_str = sprintf('y = %.6g - %.6g * ln(x)', a, abs(b));
    end

    if nargin < 3
        x_pred = [];
    end
    y_pred = [];
    if ~isempty(x_pred)
        if any(x_pred <= 0)
            error('Gia tri x can du doan phai > 0 doi voi mo hinh Logarit.');
        end
        y_pred = f_hat(x_pred);
    end

    res = struct( ...
        'method', 'Hoi quy Logarit (y = a + b*ln(x))', ...
        'a', a, ...
        'b', b, ...
        'eq_str', eq_str, ...
        'r2', lin.r2, ...
        'rmse', lin.rmse, ...
        'eval_fn', f_hat, ...
        'y_fit', y_hat, ...
        'residuals', y - y_hat, ...
        'table_data', [x, y, y_hat, abs(y - y_hat)], ...
        'headers', {{'x_i', 'y_i (Thuc)', 'y_hat (Logarit)', 'Sai lech |e_i|'}}, ...
        'x_pred', x_pred, ...
        'y_pred', y_pred);
end
