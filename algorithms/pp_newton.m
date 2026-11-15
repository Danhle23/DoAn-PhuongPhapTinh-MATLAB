function res = pp_newton(f_input, a, b, tol, maxIter, x0_override)
% PP_NEWTON Tim nghiem phuong trinh f(x) = 0 bang phuong phap Newton-Raphson (Tiep tuyen)
% Tu dong chon diem xuat phat Fourier f(x0)*f''(x0) > 0 tren [a, b] neu khong chi dinh x0.
%
% Dau vao:
%   f_input     - Chuoi ham f(x) hoac function handle
%   a, b        - Khoang phan ly nghiem [a, b]
%   tol         - Sai so cho phep (mac dinh: 1e-6)
%   maxIter     - So lan lap toi da (mac dinh: 500)
%   x0_override - (Tuy chon) Diem bat dau x0 cu the
%
% Dau ra: struct res chua root, f_root, iter, err, history, x0

    if nargin < 4 || isempty(tol), tol = 1e-6; end
    if nargin < 5 || isempty(maxIter), maxIter = 500; end
    if nargin < 6, x0_override = []; end

    [f, ~] = parse_math_func(f_input);
    if a >= b
        error('Khoang phan ly [a, b] can thoa a < b.');
    end

    % Dao ham bac 1 xap xi trung tam O(h^4) rat chinh xac va dao ham bac 2 O(h^2)
    h1 = 1e-5;
    df = @(x) (-f(x + 2*h1) + 8*f(x + h1) - 8*f(x - h1) + f(x - 2*h1)) ./ (12 * h1);
    h2 = 1e-4;
    d2f = @(x) (f(x + h2) - 2*f(x) + f(x - h2)) ./ (h2^2);

    % Chon x0 theo dieu kien Fourier f(x0)*f''(x0) > 0
    if ~isempty(x0_override) && isfinite(x0_override)
        x0 = x0_override;
    else
        if f(a) * d2f(a) > 0
            x0 = a;
        elseif f(b) * d2f(b) > 0
            x0 = b;
        else
            x0 = 0.5 * (a + b);
        end
    end

    history = zeros(maxIter, 6);
    xk = x0;
    converged = false;

    for k = 1:maxIter
        fxk = f(xk);
        dfxk = df(xk);

        if ~isfinite(fxk) || ~isfinite(dfxk)
            error('Ham so hoac dao ham khong xac dinh tai x = %.6g (buoc %d).', xk, k);
        end

        if abs(dfxk) < 1e-14
            error('Dao ham f''(x_k) ~ 0 tai x = %.6g (buoc %d). Tiep tuyen song song truc hoanh!', xk, k);
        end

        x_next = xk - fxk / dfxk;
        err = abs(x_next - xk);
        history(k, :) = [k, xk, fxk, dfxk, x_next, err];

        if err <= tol || abs(f(x_next)) < eps
            converged = true;
            xk = x_next;
            history = history(1:k, :);
            break;
        end

        xk = x_next;
    end

    if ~converged
        k = maxIter;
    end

    msg = sprintf('Hoi tu bac 2 sau %d lan lap tu x0 = %.6g (sai so = %.3e).', k, x0, err);
    if ~converged
        msg = sprintf('Chua hoi tu sau %d lan lap (sai so = %.3e).', k, err);
    end

    res = struct( ...
        'method', 'Newton-Raphson (Tiep tuyen)', ...
        'root', xk, ...
        'f_root', f(xk), ...
        'x0', x0, ...
        'iter', k, ...
        'err', err, ...
        'history', history, ...
        'headers', {{'Lan lap k', 'x_k', 'f(x_k)', 'f''(x_k)', 'x_{k+1}', 'Sai so |dx|'}}, ...
        'converged', converged, ...
        'message', msg);
end
