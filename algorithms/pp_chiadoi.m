function res = pp_chiadoi(f_input, a, b, tol, maxIter)
% PP_CHIADOI Tim nghiem phuong trinh f(x) = 0 bang phuong phap Chia doi (Bisection)
%
% Dau vao:
%   f_input - Chuoi ham so hoac function handle @(x)
%   a, b    - Khoang phan ly nghiem [a, b] (a < b)
%   tol     - Sai so cho phep (mac dinh: 1e-6)
%   maxIter - So lan lap toi da (mac dinh: 1000)
%
% Dau ra (struct res):
%   res.root      - Nghiem xap xi
%   res.f_root    - Gia tri f(root)
%   res.iter      - So lan lap thuc te
%   res.err       - Sai so uoc luong cuoi cung |b - a|/2
%   res.history   - Ma tran lich su [k, a_k, b_k, c_k, f(c_k), sai_so]
%   res.converged - Trang thai hoi tu (logical)
%   res.message   - Thong bao ket qua chi tiet

    if nargin < 4 || isempty(tol), tol = 1e-6; end
    if nargin < 5 || isempty(maxIter), maxIter = 1000; end

    [f, ~] = parse_math_func(f_input);

    if a >= b
        error('Khoang phan ly [a, b] khong hop le: can a < b.');
    end
    if tol <= 0
        error('Sai so cho phep phai lon hon 0.');
    end

    fa = f(a);
    fb = f(b);

    if any(~isfinite([fa, fb]))
        error('Ham so khong xac dinh (NaN/Inf) tai hai dau mut a hoac b.');
    end

    % Kiem tra nghiem dung ngay tai bien
    if abs(fa) == 0
        res = buildResult(a, fa, 0, 0, [0, a, b, a, fa, 0], true, ...
            'Dau mut a la nghiem chinh xac cua phuong trinh.');
        return;
    elseif abs(fb) == 0
        res = buildResult(b, fb, 0, 0, [0, a, b, b, fb, 0], true, ...
            'Dau mut b la nghiem chinh xac cua phuong trinh.');
        return;
    end

    % Neu fa * fb > 0, thu quet luoi min tren [a, b] tim khoang doi dau con
    if fa * fb > 0
        xs = linspace(a, b, 200);
        ys = f(xs);
        idx = find(ys(1:end-1) .* ys(2:end) <= 0 & isfinite(ys(1:end-1)) & isfinite(ys(2:end)), 1, 'first');
        if ~isempty(idx)
            a = xs(idx);
            b = xs(idx+1);
            fa = f(a);
            fb = f(b);
        else
            error(['Dieu kien phan ly f(a)*f(b) < 0 khong thoa man tren [%.4g, %.4g] ' ...
                   '(f(a)=%.4g, f(b)=%.4g). Vui long chon khoang khac!'], a, b, fa, fb);
        end
    end

    history = zeros(maxIter, 6);
    ak = a;
    bk = b;
    converged = false;

    for k = 1:maxIter
        ck = 0.5 * (ak + bk);
        fck = f(ck);
        err = 0.5 * abs(bk - ak);
        history(k, :) = [k, ak, bk, ck, fck, err];

        if abs(fck) < eps || err <= tol
            converged = true;
            history = history(1:k, :);
            break;
        end

        if fa * fck < 0
            bk = ck;
            fb = fck; %#ok<NASGU>
        else
            ak = ck;
            fa = fck;
        end
    end

    if ~converged
        k = maxIter;
    end

    msg = sprintf('Hoi tu sau %d lan lap (sai so = %.3e <= %.3e).', k, err, tol);
    if ~converged
        msg = sprintf('Dat gioi han %d lan lap (sai so hien tai = %.3e).', k, err);
    end
    res = buildResult(ck, fck, k, err, history, converged, msg);
end

function res = buildResult(root, f_root, iter, err, history, converged, msg)
    res = struct( ...
        'method', 'Chia doi (Bisection)', ...
        'root', root, ...
        'f_root', f_root, ...
        'iter', iter, ...
        'err', err, ...
        'history', history, ...
        'headers', {{'Lan lap k', 'a_k', 'b_k', 'c_k', 'f(c_k)', 'Sai so |b-a|/2'}}, ...
        'converged', converged, ...
        'message', msg);
end
