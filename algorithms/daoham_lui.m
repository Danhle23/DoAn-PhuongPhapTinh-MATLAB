function res = daoham_lui(mode, arg1, arg2, x0, orderStr)
% DAOHAM_LUI Tinh dao ham cap 1 bang xap xi sai phan LUI (Backward Difference)
% Ho tro ca O(h) (2 diem) va O(h^2) (3 diem) cho ham so va du lieu (x, y)

    if nargin < 5 || isempty(orderStr), orderStr = 'O(h)'; end
    isOh2 = ~isempty(strfind(char(orderStr), '2'));

    if strcmpi(mode, 'func')
        [f, ~] = parse_math_func(arg1);
        h = arg2;
        if h <= 0, error('Buoc luoi h phai lon hon 0!'); end

        if ~isOh2
            df_val = (f(x0) - f(x0 - h)) / h;
            formula = 'f''(x0) = [f(x0) - f(x0 - h)] / h  [Sai so O(h)]';
            pts_x = [x0 - h, x0];
        else
            df_val = (3*f(x0) - 4*f(x0 - h) + f(x0 - 2*h)) / (2*h);
            formula = 'f''(x0) = [3f(x0) - 4f(x0 - h) + f(x0 - 2h)] / (2h)  [Sai so O(h^2)]';
            pts_x = [x0 - 2*h, x0 - h, x0];
        end
        pts_y = f(pts_x);

        href = 1e-5;
        df_ref = (-f(x0 + 2*href) + 8*f(x0 + href) - 8*f(x0 - href) + f(x0 - 2*href)) / (12*href);

        res = struct( ...
            'method', ['Xap xi Lui - ' orderStr], ...
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
        if n ~= numel(y) || n < 2
            error('Vector x va y phai co cung do dai va it nhat 2 diem!');
        end

        diffs = diff(x);
        h = diffs(1);
        isUniform = max(abs(diffs - h)) <= 1e-7 * max(1, abs(h));
        idx = find(abs(x - x0) <= 1e-9 * max(1, abs(x0)), 1, 'first');

        if isUniform && ~isempty(idx)
            if ~isOh2
                if idx - 1 < 1
                    error('Khong the tinh xap xi LUI O(h) tai moc dau tien x(1) = %.6g (can i-1 >= 1)!', x0);
                end
                df_val = (y(idx) - y(idx-1)) / h;
                formula = sprintf('f''(%.4g) = [y_%d - y_%d] / h  (h = %.4g, O(h))', x0, idx, idx-1, h);
                pts_x = x(idx-1:idx);
                pts_y = y(idx-1:idx);
            else
                if idx - 2 < 1
                    error('Khong the tinh xap xi LUI O(h^2) tai moc x(%d) = %.6g (can it nhat 2 moc phia sau: i-2 >= 1)!', idx, x0);
                end
                df_val = (3*y(idx) - 4*y(idx-1) + y(idx-2)) / (2*h);
                formula = sprintf('f''(%.4g) = [3*y_%d - 4*y_%d + y_%d] / (2h)  (h = %.4g, O(h^2))', x0, idx, idx-1, idx-2, h);
                pts_x = x(idx-2:idx);
                pts_y = y(idx-2:idx);
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
            'method', ['Xap xi Lui (Du lieu) - ' orderStr], ...
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
