function res = daoham_trungtam(mode, arg1, arg2, x0, orderStr)
% DAOHAM_TRUNGTAM Tinh dao ham cap 1 bang xap xi sai phan TRUNG TAM (Central Difference)
% Sai phan trung tam co ban dat do chinh xac O(h^2): [f(x0+h) - f(x0-h)] / (2h)
% Neu chon bac cao O(h^4) (Richardson 4 diem): [-f(x0+2h) + 8f(x0+h) - 8f(x0-h) + f(x0-2h)] / (12h)

    if nargin < 5 || isempty(orderStr), orderStr = 'O(h^2)'; end
    isOh4 = ~isempty(strfind(char(orderStr), '4'));

    if strcmpi(mode, 'func')
        [f, ~] = parse_math_func(arg1);
        h = arg2;
        if h <= 0, error('Buoc luoi h phai lon hon 0!'); end

        if ~isOh4
            df_val = (f(x0 + h) - f(x0 - h)) / (2*h);
            formula = 'f''(x0) = [f(x0 + h) - f(x0 - h)] / (2h)  [Sai so O(h^2)]';
            pts_x = [x0 - h, x0, x0 + h];
        else
            df_val = (-f(x0 + 2*h) + 8*f(x0 + h) - 8*f(x0 - h) + f(x0 - 2*h)) / (12*h);
            formula = 'f''(x0) = [-f(x0+2h) + 8f(x0+h) - 8f(x0-h) + f(x0-2h)] / (12h)  [Sai so O(h^4)]';
            pts_x = [x0 - 2*h, x0 - h, x0, x0 + h, x0 + 2*h];
        end
        pts_y = f(pts_x);

        href = 1e-5;
        df_ref = (-f(x0 + 2*href) + 8*f(x0 + href) - 8*f(x0 - href) + f(x0 - 2*href)) / (12*href);

        res = struct( ...
            'method', ['Xap xi Trung tam - ' ifelse_str(isOh4, 'O(h^4)', 'O(h^2)')], ...
            'mode', 'func', ...
            'x0', x0, ...
            'y0', f(x0), ...
            'h', h, ...
            'df', df_val, ...
            'df_ref', df_ref, ...
            'abs_err', abs(df_val - df_ref), ...
            'formula', formula, ...
            'stencil_x', pts_x, ...
            'stencil_y', pts_y);
    else
        [x, sortIdx] = sort(arg1(:)');
        y = arg2(:)';
        y = y(sortIdx);
        n = numel(x);
        if n ~= numel(y) || n < 3
            error('Sai phan trung tam tren du lieu roi rac can it nhat 3 diem (x, y)!');
        end

        diffs = diff(x);
        h = diffs(1);
        isUniform = max(abs(diffs - h)) <= 1e-7 * max(1, abs(h));
        idx = find(abs(x - x0) <= 1e-9 * max(1, abs(x0)), 1, 'first');

        if isUniform && ~isempty(idx)
            if idx == 1 || idx == n
                error('Khong the tinh xap xi TRUNG TAM tai bien x(%d) = %.6g (can ca hai moc lan can i-1 va i+1)!', idx, x0);
            end
            if isOh4 && idx - 2 >= 1 && idx + 2 <= n
                df_val = (-y(idx+2) + 8*y(idx+1) - 8*y(idx-1) + y(idx-2)) / (12*h);
                formula = sprintf('f''(%.4g) = [-y_%d + 8*y_%d - 8*y_%d + y_%d] / (12h)  (O(h^4))', x0, idx+2, idx+1, idx-1, idx-2);
                pts_x = x(idx-2:idx+2);
                pts_y = y(idx-2:idx+2);
            else
                df_val = (y(idx+1) - y(idx-1)) / (2*h);
                formula = sprintf('f''(%.4g) = [y_%d - y_%d] / (2h)  (h = %.4g, O(h^2))', x0, idx+1, idx-1, h);
                pts_x = x(idx-1:idx+1);
                pts_y = y(idx-1:idx+1);
            end
            y0_val = y(idx);
        else
            ns = noisuy_newton(x, y, x0);
            dp = polyder(ns.poly_coeffs);
            df_val = polyval(dp, x0);
            y0_val = ns.y0;
            formula = 'Luoi khong cach deu / x0 ngoai nut -> Tinh bang dao ham da thuc noi suy P''(x0)';
            pts_x = x;
            pts_y = y;
        end

        res = struct( ...
            'method', 'Xap xi Trung tam (Du lieu) - O(h^2)', ...
            'mode', 'data', ...
            'x0', x0, ...
            'y0', y0_val, ...
            'h', h, ...
            'df', df_val, ...
            'df_ref', NaN, ...
            'abs_err', NaN, ...
            'formula', formula, ...
            'stencil_x', pts_x, ...
            'stencil_y', pts_y);
    end
end

function out = ifelse_str(cond, sTrue, sFalse)
    if cond, out = sTrue; else, out = sFalse; end
end
