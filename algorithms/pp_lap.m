function res = pp_lap(f_input, a, b, tol, maxIter, phi_input)
% PP_LAP Tim nghiem phuong trinh f(x) = 0 bang phuong phap Lap don x = phi(x)
% Ho tro 2 che do:
%   1) Nguoi dung nhap truc tiep ham lap phi(x) (qua tham so phi_input)
%   2) Tu dong xay dung ham lap hoi tu phi(x) = x - lambda * f(x) tren [a, b]
%      sao cho he so co q = max|phi'(x)| < 1 (phuong phap lap co giãn tu thich nghi)
%
% Dau vao:
%   f_input   - Chuoi ham f(x) hoac function handle
%   a, b      - Khoang phan ly [a, b] (x0 mac dinh la trung diem (a+b)/2)
%   tol       - Sai so cho phep (mac dinh: 1e-6)
%   maxIter   - So lan lap toi da (mac dinh: 1000)
%   phi_input - (Tuy chon) Chuoi ham lap phi(x), de trong '' de tu dong tao
%
% Dau ra: struct res chua root, f_root, iter, err, history, q_factor, phi_expr

    if nargin < 4 || isempty(tol), tol = 1e-6; end
    if nargin < 5 || isempty(maxIter), maxIter = 1000; end
    if nargin < 6, phi_input = ''; end

    [f, f_str] = parse_math_func(f_input);
    if a >= b
        error('Khoang phan ly [a, b] can thoa a < b.');
    end

    x0 = 0.5 * (a + b);
    h_diff = 1e-6;
    df_num = @(x) (f(x + h_diff) - f(x - h_diff)) ./ (2 * h_diff);

    % Xay dung hoac phan tich ham lap phi(x)
    if ~isempty(strtrim(char(phi_input)))
        [phi, phi_str] = parse_math_func(phi_input);
    else
        % Tu dong tim tham so thu gian lambda toi uu tren [a, b]
        xs = linspace(a, b, 100);
        dfdxs = df_num(xs);
        dfdxs = dfdxs(isfinite(dfdxs));
        if isempty(dfdxs)
            error('Khong the uoc luong dao ham tren khoang [a, b].');
        end
        % Chon dau va do lon lambda sao cho |1 - lambda * f'(x)| nho nhat
        m_min = min(dfdxs);
        M_max = max(dfdxs);
        if m_min * M_max > 0
            % f'(x) giu nguyen dau tren [a, b] -> cong thuc thu gian toi uu 2/(m + M)
            lambda = 2.0 / (m_min + M_max);
        else
            % Neu f'(x) doi dau, lay dao ham tai diem giua hoac quet cuc tieu
            df0 = df_num(x0);
            if abs(df0) < 1e-8
                df0 = sign(M_max + eps) * max(abs([m_min, M_max]));
            end
            lambda = 1.0 / df0;
        end
        phi = @(x) x - lambda .* f(x);
        phi_str = sprintf('x - (%.6g)*(%s)', lambda, f_str);
    end

    % Uoc luong he so co q = max |phi'(x)| tren [a, b]
    dphi_num = @(x) (phi(x + h_diff) - phi(x - h_diff)) ./ (2 * h_diff);
    xs_check = linspace(a, b, 50);
    q_vals = abs(dphi_num(xs_check));
    q_factor = max(q_vals(isfinite(q_vals)));
    if isempty(q_factor) || ~isfinite(q_factor)
        q_factor = 0;
    end

    history = zeros(maxIter, 5);
    xk = x0;
    converged = false;

    for k = 1:maxIter
        x_next = phi(xk);
        if ~isfinite(x_next) || abs(x_next) > 1e12
            history = history(1:max(1, k-1), :);
            error(['Day lap phan ky tai buoc k = %d (x = %.4g). ' ...
                   'Hay thu thu hep khoang [a, b] hoac nhap ham phi(x) thoa |phi''(x)| < 1.'], k, x_next);
        end

        step_diff = abs(x_next - xk);
        % Sai so hau nghiem Banach neu q < 0.99, nguoc lai dung |x_{k+1} - x_k|
        if q_factor > 0 && q_factor < 0.95
            err = (q_factor / (1 - q_factor)) * step_diff;
        else
            err = step_diff;
        end

        fx_next = f(x_next);
        history(k, :) = [k, xk, x_next, fx_next, err];

        if step_diff <= tol && abs(fx_next) <= max(tol * 10, 1e-12)
            converged = true;
            xk = x_next;
            history = history(1:k, :);
            break;
        elseif err <= tol && abs(fx_next) <= 1e-4
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

    msg = sprintf('Hoi tu sau %d lan lap voi phi(x) = %s (he so co q ~ %.3f).', k, phi_str, q_factor);
    if ~converged
        msg = sprintf('Chua dat sai so sau %d lan lap (sai so = %.3e, q ~ %.3f).', k, err, q_factor);
    end

    res = struct( ...
        'method', 'Lap don (Fixed-Point)', ...
        'root', xk, ...
        'f_root', f(xk), ...
        'iter', k, ...
        'err', err, ...
        'q_factor', q_factor, ...
        'phi_expr', phi_str, ...
        'phi_handle', phi, ...
        'history', history, ...
        'headers', {{'Lan lap k', 'x_k', 'x_{k+1} = phi(x_k)', 'f(x_{k+1})', 'Sai so'}}, ...
        'converged', converged, ...
        'message', msg);
end
