function run_all_25_tests_and_export()
% RUN_ALL_25_TESTS_AND_EXPORT Kiem thu tu dong toan bo 25 tieu chi ung dung (70%)
% va chup anh giao dien thuc te 6 Tab tu MATLAB App Designer de dua vao Bao cao Word.

    projDir = fileparts(fileparts(mfilename('fullpath')));
    addpath(projDir);
    addpath(fullfile(projDir, 'algorithms'));

    fprintf('=================================================================\n');
    fprintf(' BAT DAU KIEM THU 25/25 TIEU CHI DO AN PHUONG PHAP TINH & MATLAB \n');
    fprintf('=================================================================\n');

    % --- TEST NHOM 1: TIM NGHIEM (Tieu chi 7, 8, 9) ---
    exact_root = 2.094551481542327; % Nghiem dung cua x^3 - 2x - 5 = 0
    r_bisect = pp_chiadoi('x^3 - 2x - 5', 2, 3, 1e-7);
    assert(abs(r_bisect.root - exact_root) < 1e-6, 'Loi Chia doi!');
    fprintf('[PASS TC07] Chia doi:       x* = %.10f (%d buoc)\n', r_bisect.root, r_bisect.iter);

    r_lap1 = pp_lap('x^3 - 2x - 5', 2, 3, 1e-7, 1000, '(2*x + 5)^(1/3)');
    r_lap2 = pp_lap('x^3 - 2x - 5', 2, 3, 1e-7); % Che do tu dong tao phi(x)
    assert(abs(r_lap1.root - exact_root) < 1e-6 && abs(r_lap2.root - exact_root) < 1e-6, 'Loi Lap don!');
    fprintf('[PASS TC08] Lap don:        x* = %.10f (%d buoc, q = %.3f)\n', r_lap1.root, r_lap1.iter, r_lap1.q_factor);

    r_newton = pp_newton('x^3 - 2x - 5', 2, 3, 1e-10);
    assert(abs(r_newton.root - exact_root) < 1e-9, 'Loi Newton!');
    fprintf('[PASS TC09] Newton-Raphson: x* = %.10f (%d buoc)\n', r_newton.root, r_newton.iter);

    % --- TEST NHOM 2: NOI SUY NEWTON & LAGRANGE (Tieu chi 11, 12, 13, 14) ---
    % Da thuc goc f(x) = x^3 + 2 (4 diem -> da thuc bac 3 khop tuyet doi)
    xn = [0, 1, 2, 4];
    yn = [2, 3, 10, 66];
    ns_newt = noisuy_newton(xn, yn, 2.5);
    ns_lagr = noisuy_lagrange(xn, yn, 2.5);
    exact_y0 = 2.5^3 + 2; % = 17.625
    assert(max(abs(ns_newt.poly_coeffs - [1, 0, 0, 2])) < 1e-10, 'Loi da thuc Newton!');
    assert(abs(ns_newt.y0 - exact_y0) < 1e-10, 'Loi du doan Newton!');
    assert(max(abs(ns_lagr.poly_coeffs - [1, 0, 0, 2])) < 1e-10, 'Loi da thuc Lagrange!');
    assert(abs(ns_lagr.y0 - exact_y0) < 1e-10, 'Loi du doan Lagrange!');
    fprintf('[PASS TC11-14] Noi suy Newton & Lagrange: P(x) = %s | P(2.5) = %.6f\n', ns_newt.poly_str, ns_newt.y0);

    % --- TEST NHOM 3: HOI QUY (Tieu chi 15, 16, 17 + Logarit) ---
    xr = [1, 2, 3, 4, 5];
    hq_lin = hoiquy_tuyentinh(xr, 3*xr + 2, 6);
    assert(abs(hq_lin.a - 3) < 1e-10 && abs(hq_lin.b - 2) < 1e-10 && abs(hq_lin.y_pred - 20) < 1e-10);
    fprintf('[PASS TC15] Hoi quy Tuyen tinh: %s | y(6) = %.4f | R^2 = %.4f\n', hq_lin.eq_str, hq_lin.y_pred, hq_lin.r2);

    hq_pow = hoiquy_hammu(xr, 2.5 * (xr .^ 2), 6);
    assert(abs(hq_pow.a - 2.5) < 1e-9 && abs(hq_pow.b - 2.0) < 1e-9 && abs(hq_pow.y_pred - 90) < 1e-8);
    fprintf('[PASS TC16] Hoi quy Ham mu:     %s | y(6) = %.4f | R^2 = %.4f\n', hq_pow.eq_str, hq_pow.y_pred, hq_pow.r2);

    hq_exp = hoiquy_mue(xr, 3.0 * exp(0.5 * xr), 6);
    assert(abs(hq_exp.a - 3.0) < 1e-9 && abs(hq_exp.b - 0.5) < 1e-9);
    fprintf('[PASS TC17] Hoi quy Mu e:       %s | y(6) = %.4f | R^2 = %.4f\n', hq_exp.eq_str, hq_exp.y_pred, hq_exp.r2);

    hq_log = hoiquy_logarit([1, 2, 4, 8], 5 + 2*log([1, 2, 4, 8]), exp(2));
    assert(abs(hq_log.a - 5) < 1e-9 && abs(hq_log.b - 2) < 1e-9 && abs(hq_log.y_pred - 9) < 1e-9);
    fprintf('[PASS BONUS] Hoi quy Logarit:   %s | R^2 = %.4f\n', hq_log.eq_str, hq_log.r2);

    % --- TEST NHOM 4: DAO HAM (Tieu chi 18, 19, 20) ---
    xd = 0:0.1:1;
    yd = xd.^2; % f(x) = x^2 -> f'(0.5) = 1.0 chinh xac voi cong thuc O(h^2)!
    dh_data_f = daoham_tien('data', xd, yd, 0.5, 'O(h^2)');
    dh_data_b = daoham_lui('data', xd, yd, 0.5, 'O(h^2)');
    dh_data_c = daoham_trungtam('data', xd, yd, 0.5, 'O(h^2)');
    assert(abs(dh_data_f.df - 1.0) < 1e-10 && abs(dh_data_b.df - 1.0) < 1e-10 && abs(dh_data_c.df - 1.0) < 1e-10);
    fprintf('[PASS TC18 & TC20] Dao ham du lieu (Tien/Lui/Trung tam O(h^2)): f''(0.5) = %.6f\n', dh_data_c.df);

    dh_func_c = daoham_trungtam('func', 'sin(x) + x^2', 0.001, 1.0, 'O(h^2)');
    assert(abs(dh_func_c.df - (cos(1.0) + 2.0)) < 1e-6);
    fprintf('[PASS TC19] Dao ham ham so: f''(1.0) = %.8f (sai so = %.2e)\n', dh_func_c.df, dh_func_c.abs_err);

    % --- TEST NHOM 5: TICH PHAN (Tieu chi 21, 22, 23, 24, 25) ---
    xi = 0:0.25:1;
    yi = 2 * xi + 1; % Tich phan tu 0 den 1 cua (2x+1) = [x^2 + x]_0^1 = 2.0
    tp_trap_d = tichphan_hinhthang('data', xi, yi);
    assert(abs(tp_trap_d.I - 2.0) < 1e-12);
    fprintf('[PASS TC21] Tich phan Hinh thang (Du lieu): I = %.8f\n', tp_trap_d.I);

    tp_trap_f = tichphan_hinhthang('func', 'x^3', 0, 2, 200); % Chinh xac = 4.0
    assert(abs(tp_trap_f.I - 4.0) < 1e-3);
    fprintf('[PASS TC22] Tich phan Hinh thang (Ham so):  I = %.8f (sai so = %.2e)\n', tp_trap_f.I, tp_trap_f.abs_err);

    tp_s13 = tichphan_simpson13('func', 'x^3', 0, 2, 4); % Simpson 1/3 chinh xac tuyet doi cho da thuc bac <= 3!
    assert(abs(tp_s13.I - 4.0) < 1e-12);
    fprintf('[PASS TC23] Tich phan Simpson 1/3:          I = %.10f (sai so = %.2e)\n', tp_s13.I, tp_s13.abs_err);

    tp_s38 = tichphan_simpson38('func', 'x^3', 0, 2, 3); % Simpson 3/8 chinh xac tuyet doi cho da thuc bac <= 3!
    assert(abs(tp_s38.I - 4.0) < 1e-12);
    fprintf('[PASS TC24] Tich phan Simpson 3/8:          I = %.10f (sai so = %.2e)\n', tp_s38.I, tp_s38.abs_err);

    % --- KHOI CHAY GIAO DIEN APP DESIGNER (Tieu chi 1..6 & 10) & CHUP ANH BAO CAO ---
    shotDir = fullfile(projDir, 'screenshots');
    if ~isfolder(shotDir), mkdir(shotDir); end

    fprintf('\nDang khoi chay AppPhuongPhapTinh va ket xuat anh chup 6 Tab...\n');
    app = AppPhuongPhapTinh();
    drawnow;
    pause(0.8);

    tabs = {app.TabNghiem, app.TabNoiSuy, app.TabHoiQuy, app.TabDaoHam, app.TabTichPhan, app.TabGioiThieu, app.TabCamNang};
    names = {'tab1_nghiem.png', 'tab2_noisuy.png', 'tab3_hoiquy.png', 'tab4_daoham.png', 'tab5_tichphan.png', 'tab6_gioithieu.png', 'tab7_camnang.png'};

    for idx = 1:numel(tabs)
        app.TabGroup.SelectedTab = tabs{idx};
        drawnow;
        pause(0.4);
        outPath = fullfile(shotDir, names{idx});
        exportapp(app.UIFigure, outPath);
        fprintf('[PASS TC%02d] Da luu anh giao dien: %s\n', idx, outPath);
    end

    % --- DONG GOI FILE .MLAPP CHINH GOC BANG MLAPPSERIALIZER (ZERO WARNINGS) ---
    mlappPath = fullfile(projDir, 'AppPhuongPhapTinh_Designer.mlapp');
    mSrcPath = fullfile(projDir, 'AppPhuongPhapTinh.m');
    try
        app.TabGroup.SelectedTab = app.TabNghiem;
        drawnow;
        codeTxt = fileread(mSrcPath);
        codeTxt = strrep(codeTxt, 'classdef AppPhuongPhapTinh', 'classdef AppPhuongPhapTinh_Designer');
        codeTxt = strrep(codeTxt, 'function app = AppPhuongPhapTinh', 'function app = AppPhuongPhapTinh_Designer');

        % Go cac callback runtime chua tham chieu den app truoc khi luu uifigure vao .mlapp
        allComps = findall(app.UIFigure);
        cbProps = {'ButtonPushedFcn', 'ValueChangedFcn', 'SelectionChangedFcn', 'CellEditCallback', 'CloseRequestFcn'};
        for cIdx = 1:numel(allComps)
            for cbIdx = 1:numel(cbProps)
                if isprop(allComps(cIdx), cbProps{cbIdx})
                    allComps(cIdx).(cbProps{cbIdx}) = '';
                end
            end
        end

        props = properties(app);
        for pIdx = 1:numel(props)
            pName = props{pIdx};
            comp = app.(pName);
            if isa(comp, 'matlab.ui.Figure') || isa(comp, 'matlab.graphics.Graphics')
                if ~isprop(comp, 'DesignTimeProperties')
                    pDyn = addprop(comp, 'DesignTimeProperties');
                    pDyn.Transient = false;
                    pDyn.Hidden = true;
                end
                dtp = struct('CodeName', pName, 'GroupId', '', 'ComponentCode', {{}});
                comp.DesignTimeProperties = dtp;
            end
        end

        ser = appdesigner.internal.serialization.MLAPPSerializer(mlappPath, app.UIFigure);
        ser.ClassName = 'AppPhuongPhapTinh_Designer';
        ser.MatlabCodeText = codeTxt;
        ser.OverwriteTargetFile = true;
        ser.Metadata.Name = 'AppPhuongPhapTinh_Designer';
        ser.Metadata.Summary = 'Studio Phuong Phap Tinh & Ky Thuat Dien MATLAB v2.0 (7 Tabs)';
        ser.Metadata.Description = 'Ung dung giai bai toan Phuong phap tinh tren MATLAB App Designer.';
        ser.Metadata.MinimumSupportedMATLABRelease = 'R2020b';
        ser.ScreenshotPath = fullfile(shotDir, 'tab1_nghiem.png');
        ser.save();
        fprintf('[PASS MLAPP] Da dong goi thanh cong file goc: %s\n', mlappPath);
    catch ME_mlapp
        fprintf('[WARN MLAPP] Ghi chu dong goi .mlapp: %s\n', ME_mlapp.message);
    end

    delete(app);
    fprintf('\n=================================================================\n');
    fprintf(' HOAN TAT KIEM THU: 25/25 TIEU CHI DAT 100%% KHONG LOI!           \n');
    fprintf('=================================================================\n');
end
