function res = hoiquy_tuyentinh(x, y, x_pred)
% HOIQUY_TUYENTINH Hoi quy binh phuong cuc tieu tuyen tinh y = a*x + b
%
% Dau vao:
%   x, y   - Vector du lieu thuc nghiem cung do dai (n >= 2)
%   x_pred - (Tuy chon) Gia tri x can du doan y
%
% Dau ra (struct res):
%   res.a, res.b - He so goc a va he so chan b (y = a*x + b)
%   res.eq_str   - Phuong trinh hoi quy dang chuoi
%   res.r2       - He so xac dinh R^2
%   res.rmse     - Sai so trung binh binh phuong can (RMSE)
%   res.y_pred   - Gia tri du doan tai x_pred

    x = x(:);
    y = y(:);
    n = numel(x);
    if n ~= numel(y) || n < 2
        error('Du lieu x va y phai co cung so phan tu va n >= 2!');
    end

    sx = sum(x);
    sy = sum(y);
    sxx = sum(x.^2);
    sxy = sum(x .* y);

    denom = n * sxx - sx^2;
    if abs(denom) < 1e-14
        error('Tat ca gia tri x deu bang nhau, khong the lap duong hoi quy tuyen tinh!');
    end

    a = (n * sxy - sx * sy) / denom;
    b = (sy - a * sx) / n;

    f_hat = @(xq) a .* xq + b;
    y_hat = f_hat(x);
    [r2, rmse] = calc_metrics(y, y_hat);

    if b >= 0
        eq_str = sprintf('y = %.6g * x + %.6g', a, b);
    else
        eq_str = sprintf('y = %.6g * x - %.6g', a, abs(b));
    end

    if nargin < 3
        x_pred = [];
    end
    y_pred = [];
    if ~isempty(x_pred)
        y_pred = f_hat(x_pred);
    end

    res = struct( ...
        'method', 'Hoi quy Tuyen tinh (y = a*x + b)', ...
        'a', a, ...
        'b', b, ...
        'eq_str', eq_str, ...
        'r2', r2, ...
        'rmse', rmse, ...
        'eval_fn', f_hat, ...
        'y_fit', y_hat, ...
        'residuals', y - y_hat, ...
        'table_data', [x, y, y_hat, abs(y - y_hat)], ...
        'headers', {{'x_i', 'y_i (Thuc)', 'y_hat (Hoi quy)', 'Sai lech |e_i|'}}, ...
        'x_pred', x_pred, ...
        'y_pred', y_pred);
end

function [r2, rmse] = calc_metrics(y_true, y_pred)
    ss_res = sum((y_true - y_pred).^2);
    ss_tot = sum((y_true - mean(y_true)).^2);
    if ss_tot < 1e-15
        r2 = 1.0;
    else
        r2 = max(0, 1 - ss_res / ss_tot);
    end
    rmse = sqrt(mean((y_true - y_pred).^2));
end
