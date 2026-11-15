function res = noisuy_lagrange(x, y, x0)
% NOISUY_LAGRANGE Tim da thuc noi suy Lagrange P(x) = sum y_i * L_i(x) va tinh P(x0)
% Su dung ca cong thuc co dien L_i(x) de thu he so chinh xac va cong thuc Barycentric
% Lagrange on dinh so hoc de tinh gia tri noi suy cuc nhanh va khong tran so.
%
% Dau vao:
%   x  - Vector moc noi suy [x_1, x_2, ..., x_n]
%   y  - Vector gia tri tuong ung [y_1, y_2, ..., y_n]
%   x0 - (Tuy chon) Gia tri hoac vector can noi suy du doan

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

    poly_coeffs = zeros(1, n);
    L_matrix = zeros(n, n); % Moi hang i la he so da thuc co so L_i(x)
    bary_weights = zeros(1, n);

    for i = 1:n
        % Xay dung tu so prod_{j ~= i} (x - x_j) va mau so prod_{j ~= i} (x_i - x_j)
        other_x = x([1:i-1, i+1:n]);
        num_poly = poly(other_x); % Vector he so da thuc co nghiem la other_x
        denom = prod(x(i) - other_x);
        Li = num_poly / denom;

        L_matrix(i, :) = Li;
        poly_coeffs = poly_coeffs + y(i) * Li;
        bary_weights(i) = 1.0 / denom;
    end

    if nargin < 3
        x0 = [];
    end
    if ~isempty(x0)
        y0 = evalBarycentric(x, y, bary_weights, x0);
    else
        y0 = [];
    end

    % Bang thong ke trong so Barycentric & he so da thuc co so L_i(x)
    headers = cell(1, n + 2);
    headers{1} = 'Moc x_i';
    headers{2} = 'Trong so w_i';
    for deg = (n-1):-1:0
        headers{n - deg + 2} = sprintf('He so x^%d cua L_i', deg);
    end

    runge_warn = '';
    if n >= 9
        runge_warn = sprintf('Luu y: Da thuc Lagrange bac %d co the bi hien tuong Runge o ria khoang noi suy.', n-1);
    end

    res = struct( ...
        'method', 'Noi suy Lagrange', ...
        'x', x, ...
        'y', y, ...
        'degree', n - 1, ...
        'L_basis', L_matrix, ...
        'bary_weights', bary_weights, ...
        'basis_table', [x(:), bary_weights(:), L_matrix], ...
        'headers', {headers}, ...
        'poly_coeffs', poly_coeffs, ...
        'poly_str', poly_to_str(poly_coeffs, 'x', 6), ...
        'eval_fn', @(xq) evalBarycentric(x, y, bary_weights, xq), ...
        'x0', x0, ...
        'y0', y0, ...
        'warning', runge_warn);
end

function yq = evalBarycentric(x_nodes, y_nodes, w, xq)
    yq = zeros(size(xq));
    for idx = 1:numel(xq)
        xv = xq(idx);
        diff_x = xv - x_nodes;
        exactIdx = find(abs(diff_x) < 1e-14, 1, 'first');
        if ~isempty(exactIdx)
            yq(idx) = y_nodes(exactIdx);
        else
            terms = w ./ diff_x;
            yq(idx) = sum(terms .* y_nodes) / sum(terms);
        end
    end
end
