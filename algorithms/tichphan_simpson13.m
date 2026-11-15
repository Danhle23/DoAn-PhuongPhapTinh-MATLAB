function res = tichphan_simpson13(mode, arg1, arg2, arg3, arg4)
% TICHPHAN_SIMPSON13 Tinh tich phan xac dinh bang phuong phap Simpson 1/3 mo rong
% Dieu kien: So khoang chia N phai la SO CHAN (N >= 2, mod(N, 2) == 0).
% Ho tro ca che do 'func' (f, a, b, N) va 'data' (x, y cach deu voi N = length(x)-1 chan).

    if strcmpi(mode, 'data')
        [x, sortIdx] = sort(arg1(:)');
        y = arg2(:)';
        y = y(sortIdx);
        n = numel(x);
        N = n - 1;
        if n ~= numel(y) || N < 2
            error('Simpson 1/3 tren du lieu can it nhat 3 diem (N >= 2 khoang chia)!');
        end
        if mod(N, 2) ~= 0
            error('Simpson 1/3 yeu cau so khoang chia N = length(x)-1 = %d phai la SO CHAN!', N);
        end
        dx = diff(x);
        h = dx(1);
        if max(abs(dx - h)) > 1e-6 * max(1, abs(h))
            error('Simpson 1/3 tren du lieu roi rac yeu cau cac moc x phai CACH DEU nhau!');
        end

        w = ones(1, n);
        w(2:2:end-1) = 4;
        w(3:2:end-2) = 2;
        I = (h / 3) * sum(w .* y);

        res = struct( ...
            'method', 'Simpson 1/3 (Du lieu x, y)', ...
            'mode', 'data', ...
            'I', I, ...
            'I_exact', NaN, ...
            'abs_err', NaN, ...
            'N', N, ...
            'h', h, ...
            'x_nodes', x, ...
            'y_nodes', y, ...
            'weights', w * (h / 3), ...
            'formula', 'I = (h/3) * [y_0 + 4*(y_1+y_3+...) + 2*(y_2+y_4+...) + y_N]');
    else
        [f, ~] = parse_math_func(arg1);
        a = arg2;
        b = arg3;
        N = round(arg4);
        if N < 2 || mod(N, 2) ~= 0
            error('Phuong phap Simpson 1/3 yeu cau so khoang chia N (%d) phai la SO NGUYEN DUONG CHAN (vi du: 2, 4, 6, 10, 20)!', N);
        end

        h = (b - a) / N;
        x_nodes = linspace(a, b, N + 1);
        y_nodes = f(x_nodes);

        w = ones(1, N + 1);
        w(2:2:end-1) = 4; % Chi so MATLAB 2,4,... tuong ung y_1, y_3,... (chi so le toan hoc)
        w(3:2:end-2) = 2; % Chi so MATLAB 3,5,... tuong ung y_2, y_4,... (chi so chan toan hoc)

        I = (h / 3) * sum(w .* y_nodes);
        I_exact = integral(f, a, b, 'RelTol', 1e-12, 'AbsTol', 1e-14);

        res = struct( ...
            'method', 'Simpson 1/3 (Ham so)', ...
            'mode', 'func', ...
            'I', I, ...
            'I_exact', I_exact, ...
            'abs_err', abs(I - I_exact), ...
            'N', N, ...
            'h', h, ...
            'x_nodes', x_nodes, ...
            'y_nodes', y_nodes, ...
            'weights', w * (h / 3), ...
            'formula', 'I = (h/3) * [y_0 + 4*sum(y_le) + 2*sum(y_chan) + y_N]');
    end
end
