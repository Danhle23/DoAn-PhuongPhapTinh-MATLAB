function res = pp_daycung(f_input, a, b, tol, maxIter)
% PP_DAYCUNG Tim nghiem phuong trinh f(x) = 0 bang phuong phap Day cung (Secant)
% (Chuc nang nang cao bo sung de so sanh toc do hoi tu voi Chia doi, Lap, Newton)

    if nargin < 4 || isempty(tol), tol = 1e-6; end
    if nargin < 5 || isempty(maxIter), maxIter = 500; end

    [f, ~] = parse_math_func(f_input);
    x_prev = a;
    xk = b;
    f_prev = f(x_prev);
    history = zeros(maxIter, 6);
    converged = false;

    for k = 1:maxIter
        fxk = f(xk);
        denom = fxk - f_prev;
        if abs(denom) < 1e-14
            error('Mau so f(x_k) - f(x_{k-1}) ~ 0 tai buoc k = %d.', k);
        end
        x_next = xk - fxk * (xk - x_prev) / denom;
        err = abs(x_next - xk);
        history(k, :) = [k, x_prev, xk, fxk, x_next, err];

        if err <= tol || abs(f(x_next)) < eps
            converged = true;
            xk = x_next;
            history = history(1:k, :);
            break;
        end
        x_prev = xk;
        f_prev = fxk;
        xk = x_next;
    end

    if ~converged
        k = maxIter;
    end

    res = struct( ...
        'method', 'Day cung (Secant)', ...
        'root', xk, ...
        'f_root', f(xk), ...
        'iter', k, ...
        'err', err, ...
        'history', history, ...
        'headers', {{'Lan lap k', 'x_{k-1}', 'x_k', 'f(x_k)', 'x_{k+1}', 'Sai so |dx|'}}, ...
        'converged', converged, ...
        'message', sprintf('Phuong phap Day cung hoan tat sau %d lan lap (sai so = %.3e).', k, err));
end
