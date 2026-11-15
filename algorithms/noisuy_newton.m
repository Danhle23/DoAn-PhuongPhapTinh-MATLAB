function res = noisuy_newton(x, y, x0)
% NOISUY_NEWTON Tim da thuc noi suy Newton (Ty hieu / Divided Differences) va tinh P(x0)
%
% Dau vao:
%   x  - Vector moc noi suy [x_1, x_2, ..., x_n] (cac moc phai phan biet)
%   y  - Vector gia tri tuong ung [y_1, y_2, ..., y_n]
%   x0 - (Tuy chon) Gia tri hoac vector can noi suy du doan
%
% Dau ra (struct res):
%   res.dd_table    - Bang ty hieu Newton kich thuoc n x n
%   res.newton_coef - He so ty hieu tren duong cheo chinh [f[x0], f[x0,x1], ...]
%   res.poly_coeffs - He so da thuc thu gon chuan MATLAB [a_{n-1}, ..., a_1, a_0]
%   res.poly_str    - Chuoi da thuc thu gon P(x)
%   res.newton_str  - Chuoi dang chinh tac Newton P(x) = c0 + c1(x-x0) + ...
%   res.y0          - Gia tri noi suy tai x0

    x = x(:)';
    y = y(:)';
    n = numel(x);

    if n ~= numel(y)
        error('Vector du lieu x (%d phan tu) va y (%d phan tu) phai co cung do dai!', n, numel(y));
    end
    if n < 2
        error('Can it nhat 2 diem du lieu (x, y) de thuc hien noi suy!');
    end
    if numel(unique(x)) < n
        error('Cac moc noi suy x phai doi mot phan biet (khong duoc trung nhau)!');
    end

    % Xay dung bang ty hieu Newton (Divided Differences Table)
    dd = zeros(n, n);
    dd(:, 1) = y(:);
    for j = 2:n
        for i = 1:(n - j + 1)
            dd(i, j) = (dd(i+1, j-1) - dd(i, j-1)) / (x(i+j-1) - x(i));
        end
    end

    c = dd(1, :); % He so Newton [f[x1], f[x1,x2], ...]

    % Chuyen sang he so da thuc chuan [a_{n-1}, ..., a_0] bang nhan da thuc conv
    poly_coeffs = zeros(1, n);
    basis = 1; % Tich (x - x_1)(x - x_2)...(x - x_{k-1})
    newton_terms = {sprintf('%.6g', c(1))};

    poly_coeffs(end) = c(1);
    for k = 2:n
        basis = conv(basis, [1, -x(k-1)]);
        poly_coeffs(end - numel(basis) + 1 : end) = poly_coeffs(end - numel(basis) + 1 : end) + c(k) * basis;

        if abs(c(k)) >= 1e-11
            factors = '';
            for m = 1:(k-1)
                if abs(x(m)) < 1e-12
                    factors = [factors, '*x']; %#ok<AGROW>
                elseif x(m) > 0
                    factors = [factors, sprintf('*(x - %.4g)', x(m))]; %#ok<AGROW>
                else
                    factors = [factors, sprintf('*(x + %.4g)', abs(x(m)))]; %#ok<AGROW>
                end
            end
            if c(k) >= 0
                newton_terms{end+1} = sprintf('+ %.6g%s', c(k), factors); %#ok<AGROW>
            else
                newton_terms{end+1} = sprintf('- %.6g%s', abs(c(k)), factors); %#ok<AGROW>
            end
        end
    end

    % Tinh gia tri noi suy tai x0 bang luoc do Horner suy rong tren dang Newton (on dinh so hoc cao)
    if nargin < 3
        x0 = [];
    end
    if ~isempty(x0)
        y0 = evalNewtonHorner(x, c, x0);
    else
        y0 = [];
    end

    runge_warn = '';
    if n >= 9
        runge_warn = sprintf('Luu y: Bac da thuc cao (bac %d) tren moc cach deu co the gay dao dong Runge o bien.', n-1);
    end

    headers = cell(1, n + 1);
    headers{1} = 'x_i';
    headers{2} = 'y_i = f[x_i]';
    for j = 2:n
        headers{j+1} = sprintf('Ty hieu cap %d', j-1);
    end

    res = struct( ...
        'method', 'Noi suy Newton (Ty hieu)', ...
        'x', x, ...
        'y', y, ...
        'degree', n - 1, ...
        'dd_table', [x(:), dd], ...
        'headers', {headers}, ...
        'newton_coef', c, ...
        'poly_coeffs', poly_coeffs, ...
        'poly_str', poly_to_str(poly_coeffs, 'x', 6), ...
        'newton_str', strjoin(newton_terms, ' '), ...
        'eval_fn', @(xq) evalNewtonHorner(x, c, xq), ...
        'x0', x0, ...
        'y0', y0, ...
        'warning', runge_warn);
end

function yq = evalNewtonHorner(x_nodes, c, xq)
    n = numel(c);
    yq = c(n) * ones(size(xq));
    for k = (n-1):-1:1
        yq = yq .* (xq - x_nodes(k)) + c(k);
    end
end
