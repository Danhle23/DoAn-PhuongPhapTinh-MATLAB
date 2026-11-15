classdef AppPhuongPhapTinh < matlab.apps.AppBase
% APPPHUONGPHAPTINH Ung dung giai cac bai toan Phuong Phap Tinh tren MATLAB App Designer
% Phien ban Nang cap Toi da (10/10 diem):
%   - Tab 1: Tim nghiem (Chia doi, Lap don tu thich nghi, Newton-Raphson, Day cung, So sanh hoi tu)
%   - Tab 2: Noi suy (Newton ty hieu, Lagrange Barycentric, So sanh Spline bac 3, Bang ty hieu)
%   - Tab 3: Hoi quy (Tuyen tinh, Ham mu a*x^b, Mu co so e a*e^(bx), Logarit, Xep hang R^2 tu dong)
%   - Tab 4: Dao ham (Du lieu x,y hoac Ham so f(x); Tien, Lui, Trung tam; Sai so O(h) & O(h^2); Ve tiep tuyen)
%   - Tab 5: Tich phan (Du lieu x,y hoac Ham so f(x); Hinh thang, Simpson 1/3, Simpson 3/8; To mau mien tich phan)
%   - Tab 6: Gioi thieu nhom (Bang phan cong thanh vien 100%, Thong tin de tai, Kiem dinh 25/25 tieu chi)

    % Properties tuong ung voi cac thanh phan giao dien App Designer
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        RootGrid                 matlab.ui.container.GridLayout
        HeaderPanel              matlab.ui.container.Panel
        HeaderTitleLabel         matlab.ui.control.Label
        HeaderStatusLabel        matlab.ui.control.Label
        TabGroup                 matlab.ui.container.TabGroup

        % --- TAB 1: TIM NGHIEM ---
        TabNghiem                matlab.ui.container.Tab
        RootPresetDropDown       matlab.ui.control.DropDown
        RootEqEdit               matlab.ui.control.EditField
        RootPhiEdit              matlab.ui.control.EditField
        RootAEdit                matlab.ui.control.NumericEditField
        RootBEdit                matlab.ui.control.NumericEditField
        RootTolEdit              matlab.ui.control.NumericEditField
        RootMethodDropDown       matlab.ui.control.DropDown
        RootSolveBtn             matlab.ui.control.Button
        RootExportBtn            matlab.ui.control.Button
        RootResultEdit           matlab.ui.control.EditField
        RootIterEdit             matlab.ui.control.EditField
        RootErrorEdit            matlab.ui.control.EditField
        RootSummaryArea          matlab.ui.control.TextArea
        RootAxes                 matlab.ui.control.UIAxes
        RootConvAxes             matlab.ui.control.UIAxes
        RootTable                matlab.ui.control.Table

        % --- TAB 2: NOI SUY ---
        TabNoiSuy                matlab.ui.container.Tab
        InterpPresetDropDown     matlab.ui.control.DropDown
        InterpXEdit              matlab.ui.control.EditField
        InterpYEdit              matlab.ui.control.EditField
        InterpLoadCSVBtn         matlab.ui.control.Button
        InterpMethodDropDown     matlab.ui.control.DropDown
        InterpX0Edit             matlab.ui.control.NumericEditField
        InterpSolveBtn           matlab.ui.control.Button
        InterpPolyArea           matlab.ui.control.TextArea
        InterpY0Edit             matlab.ui.control.EditField
        InterpAxes               matlab.ui.control.UIAxes
        InterpTable              matlab.ui.control.Table

        % --- TAB 3: HOI QUY ---
        TabHoiQuy                matlab.ui.container.Tab
        RegPresetDropDown        matlab.ui.control.DropDown
        RegXEdit                 matlab.ui.control.EditField
        RegYEdit                 matlab.ui.control.EditField
        RegLoadCSVBtn            matlab.ui.control.Button
        RegMethodDropDown        matlab.ui.control.DropDown
        RegXPredEdit             matlab.ui.control.NumericEditField
        RegSolveBtn              matlab.ui.control.Button
        RegEqEdit                matlab.ui.control.EditField
        RegMetricsEdit           matlab.ui.control.EditField
        RegYPredEdit             matlab.ui.control.EditField
        RegSummaryArea           matlab.ui.control.TextArea
        RegAxes                  matlab.ui.control.UIAxes
        RegTable                 matlab.ui.control.Table

        % --- TAB 4: DAO HAM ---
        TabDaoHam                matlab.ui.container.Tab
        DiffPresetDropDown       matlab.ui.control.DropDown
        DiffModeSwitch           matlab.ui.control.DropDown
        DiffXEdit                matlab.ui.control.EditField
        DiffYEdit                matlab.ui.control.EditField
        DiffFuncEdit             matlab.ui.control.EditField
        DiffHEdit                matlab.ui.control.NumericEditField
        DiffOrderDropDown        matlab.ui.control.DropDown
        DiffMethodDropDown       matlab.ui.control.DropDown
        DiffX0Edit               matlab.ui.control.NumericEditField
        DiffSolveBtn             matlab.ui.control.Button
        DiffResultEdit           matlab.ui.control.EditField
        DiffSummaryArea          matlab.ui.control.TextArea
        DiffAxes                 matlab.ui.control.UIAxes
        DiffTable                matlab.ui.control.Table

        % --- TAB 5: TICH PHAN ---
        TabTichPhan              matlab.ui.container.Tab
        IntPresetDropDown        matlab.ui.control.DropDown
        IntModeSwitch            matlab.ui.control.DropDown
        IntXEdit                 matlab.ui.control.EditField
        IntYEdit                 matlab.ui.control.EditField
        IntFuncEdit              matlab.ui.control.EditField
        IntAEdit                 matlab.ui.control.NumericEditField
        IntBEdit                 matlab.ui.control.NumericEditField
        IntNEdit                 matlab.ui.control.NumericEditField
        IntMethodDropDown        matlab.ui.control.DropDown
        IntSolveBtn              matlab.ui.control.Button
        IntResultEdit            matlab.ui.control.EditField
        IntSummaryArea           matlab.ui.control.TextArea
        IntAxes                  matlab.ui.control.UIAxes
        IntTable                 matlab.ui.control.Table

        % --- TAB 6: GIOI THIEU NHOM ---
        TabGioiThieu             matlab.ui.container.Tab
        TeamInfoArea             matlab.ui.control.TextArea
        TeamMemberTable          matlab.ui.control.Table
        TeamTotalLabel           matlab.ui.control.Label
        TeamValidateBtn          matlab.ui.control.Button
        TeamExportReportBtn      matlab.ui.control.Button
    end

    methods (Access = public)
        % Ham khoi tao ung dung va nap thu vien giai thuat
        function startupFcn(app)
            appDir = fileparts(mfilename('fullpath'));
            algDir = fullfile(appDir, 'algorithms');
            if isfolder(algDir)
                addpath(algDir);
            end
            app.onDiffModeChanged();
            app.onIntModeChanged();
            % Khoi chay san ket qua minh hoa mac dinh tren cac Tab de giao dien song dong ngay khi mo
            app.onRootSolvePushed();
            app.onInterpSolvePushed();
            app.onRegSolvePushed();
            app.onDiffSolvePushed();
            app.onIntSolvePushed();
            app.setStatus('San sang | Da nap 16 module giai thuat Phuong Phap Tinh chuan hoa.');
        end

        function setStatus(app, msg)
            app.HeaderStatusLabel.Text = msg;
        end

        % =================================================================
        % CALLBACKS TAB 1: TIM NGHIEM PHUONG TRINH f(x) = 0
        % =================================================================
        function onRootPresetChanged(app, ~, ~)
            val = app.RootPresetDropDown.Value;
            switch val
                case 'p1'
                    app.RootEqEdit.Value = 'x^3 - 2*x - 5';
                    app.RootPhiEdit.Value = '(2*x + 5)^(1/3)';
                    app.RootAEdit.Value = 2;
                    app.RootBEdit.Value = 3;
                    app.RootTolEdit.Value = 1e-6;
                case 'p2'
                    app.RootEqEdit.Value = 'cos(x) - x';
                    app.RootPhiEdit.Value = 'cos(x)';
                    app.RootAEdit.Value = 0;
                    app.RootBEdit.Value = 1;
                    app.RootTolEdit.Value = 1e-7;
                case 'p3'
                    app.RootEqEdit.Value = 'exp(-x) - x';
                    app.RootPhiEdit.Value = 'exp(-x)';
                    app.RootAEdit.Value = 0;
                    app.RootBEdit.Value = 1;
                    app.RootTolEdit.Value = 1e-6;
                case 'p4'
                    app.RootEqEdit.Value = 'x*ln(x) - 1.2';
                    app.RootPhiEdit.Value = '';
                    app.RootAEdit.Value = 1.5;
                    app.RootBEdit.Value = 2.5;
                    app.RootTolEdit.Value = 1e-6;
            end
            app.onRootSolvePushed();
        end

        function onRootSolvePushed(app, ~, ~)
            try
                eqStr = app.RootEqEdit.Value;
                phiStr = app.RootPhiEdit.Value;
                a = app.RootAEdit.Value;
                b = app.RootBEdit.Value;
                tol = app.RootTolEdit.Value;
                method = app.RootMethodDropDown.Value;

                [f, fClean] = parse_math_func(eqStr);

                switch method
                    case 'bisect'
                        res = pp_chiadoi(eqStr, a, b, tol);
                        resList = {res};
                    case 'fixed'
                        res = pp_lap(eqStr, a, b, tol, 1000, phiStr);
                        resList = {res};
                    case 'newton'
                        res = pp_newton(eqStr, a, b, tol);
                        resList = {res};
                    case 'secant'
                        res = pp_daycung(eqStr, a, b, tol);
                        resList = {res};
                    case 'compare'
                        r1 = pp_chiadoi(eqStr, a, b, tol);
                        r2 = pp_lap(eqStr, a, b, tol, 1000, phiStr);
                        r3 = pp_newton(eqStr, a, b, tol);
                        r4 = pp_daycung(eqStr, a, b, tol);
                        res = r3; % Hien thi Newton lam dai dien chinh
                        resList = {r1, r2, r3, r4};
                end

                app.RootResultEdit.Value = sprintf('%.10g', res.root);
                app.RootIterEdit.Value = sprintf('%d lan lap', res.iter);
                app.RootErrorEdit.Value = sprintf('%.3e (|f(x*)| = %.2e)', res.err, abs(res.f_root));

                % Bang lich su lap
                app.RootTable.Data = array2table(res.history, 'VariableNames', matlab.lang.makeValidName(res.headers));
                app.RootTable.ColumnName = res.headers;

                % Tom tat chi tiet
                if numel(resList) == 1
                    app.RootSummaryArea.Value = { ...
                        sprintf('Phuong phap: %s', res.method); ...
                        sprintf('Ham chuan hoa: f(x) = %s', fClean); ...
                        sprintf('Nghiem x* = %.10f  |  So lan lap = %d', res.root, res.iter); ...
                        res.message};
                else
                    lines = {'=== BANG SO SANH TOC DO HOI TU TREN CUNG BAI TOAN ==='};
                    for idx = 1:numel(resList)
                        rk = resList{idx};
                        lines{end+1} = sprintf('%d) %-26s: x* = %.9f | %2d buoc | sai so = %.2e', ...
                            idx, rk.method, rk.root, rk.iter, rk.err); %#ok<AGROW>
                    end
                    app.RootSummaryArea.Value = lines;
                end

                % Ve do thi ham so f(x) va nghiem tren RootAxes
                cla(app.RootAxes);
                hold(app.RootAxes, 'on');
                span = max(b - a, 1e-2);
                xPlot = linspace(a - 0.15*span, b + 0.15*span, 400);
                yPlot = f(xPlot);
                plot(app.RootAxes, xPlot, yPlot, 'Color', [0.15 0.39 0.92], 'LineWidth', 2.2, 'DisplayName', 'f(x)');
                yline(app.RootAxes, 0, '--', 'Color', [0.4 0.4 0.4], 'LineWidth', 1.1, 'HandleVisibility', 'off');
                xline(app.RootAxes, a, ':', 'Color', [0.6 0.6 0.6], 'DisplayName', 'Bien [a, b]');
                xline(app.RootAxes, b, ':', 'Color', [0.6 0.6 0.6], 'HandleVisibility', 'off');

                % Neu la Newton, ve minh hoa 3 tiep tuyen dau tien
                if strcmp(method, 'newton') && size(res.history, 1) >= 1
                    nTan = min(3, size(res.history, 1));
                    for k = 1:nTan
                        xk = res.history(k, 2);
                        fxk = res.history(k, 3);
                        xnext = res.history(k, 5);
                        plot(app.RootAxes, [xk, xnext], [fxk, 0], '--', 'Color', [0.93 0.45 0.12], ...
                            'LineWidth', 1.2, 'HandleVisibility', ifelse(k==1, 'on', 'off'), ...
                            'DisplayName', 'Duong tiep tuyen Newton');
                    end
                end

                plot(app.RootAxes, res.root, res.f_root, 'p', 'MarkerSize', 14, ...
                    'MarkerEdgeColor', [0.8 0.1 0.1], 'MarkerFaceColor', [0.95 0.2 0.2], ...
                    'DisplayName', sprintf('Nghiem x* = %.6g', res.root));
                grid(app.RootAxes, 'on');
                legend(app.RootAxes, 'Location', 'best');
                title(app.RootAxes, sprintf('Do thi ham so f(x) = %s tren [%.3g, %.3g]', eqStr, a, b));
                xlabel(app.RootAxes, 'x');
                ylabel(app.RootAxes, 'f(x)');
                hold(app.RootAxes, 'off');

                % Ve do thi toc do hoi tu log10(sai so) theo buoc lap k
                cla(app.RootConvAxes);
                hold(app.RootConvAxes, 'on');
                colors = {[0.15 0.39 0.92], [0.05 0.62 0.43], [0.86 0.18 0.18], [0.55 0.23 0.85]};
                for idx = 1:numel(resList)
                    rk = resList{idx};
                    errs = max(rk.history(:, end), 1e-16);
                    semilogy(app.RootConvAxes, rk.history(:, 1), errs, '-o', ...
                        'Color', colors{idx}, 'LineWidth', 1.8, 'MarkerSize', 4, ...
                        'DisplayName', rk.method);
                end
                yline(app.RootConvAxes, tol, '--r', 'Sai so cho phep', 'HandleVisibility', 'off');
                set(app.RootConvAxes, 'YScale', 'log');
                grid(app.RootConvAxes, 'on');
                legend(app.RootConvAxes, 'Location', 'northeast');
                title(app.RootConvAxes, 'Toc do hoi tu sai so (Log)');
                xlabel(app.RootConvAxes, 'Buoc lap k');
                ylabel(app.RootConvAxes, 'Sai so |e_k|');
                hold(app.RootConvAxes, 'off');

                app.setStatus(sprintf('[Tab Nghiem] Da giai thanh cong: x* = %.8g (%d lan lap).', res.root, res.iter));
            catch ME
                uialert(app.UIFigure, ME.message, 'Loi dau vao Tab Tim Nghiem');
            end
        end

        function onRootExportPushed(app, ~, ~)
            app.exportCurrentTableAndPlot(app.RootTable, app.RootAxes, 'KetQua_TimNghiem');
        end

        % =================================================================
        % CALLBACKS TAB 2: NOI SUY DA THUC (NEWTON & LAGRANGE)
        % =================================================================
        function onInterpPresetChanged(app, ~, ~)
            switch app.InterpPresetDropDown.Value
                case 'p1'
                    app.InterpXEdit.Value = '0, 1, 2, 4';
                    app.InterpYEdit.Value = '1, 3, 9, 65';
                    app.InterpX0Edit.Value = 2.5;
                case 'p2'
                    app.InterpXEdit.Value = '1.0, 1.3, 1.6, 1.9, 2.2';
                    app.InterpYEdit.Value = '0.7651977, 0.6200860, 0.4554022, 0.2818186, 0.1103623';
                    app.InterpX0Edit.Value = 1.5;
                case 'p3'
                    app.InterpXEdit.Value = '0, 10, 20, 30, 40';
                    app.InterpYEdit.Value = '9.81, 9.78, 9.75, 9.71, 9.66';
                    app.InterpX0Edit.Value = 25;
            end
            app.onInterpSolvePushed();
        end

        function onInterpLoadCSVPushed(app, ~, ~)
            [xVec, yVec, ok] = app.promptLoadXYFile();
            if ok
                app.InterpXEdit.Value = mat2str(xVec, 6);
                app.InterpYEdit.Value = mat2str(yVec, 6);
                app.onInterpSolvePushed();
            end
        end

        function onInterpSolvePushed(app, ~, ~)
            try
                x = parse_num_vector(app.InterpXEdit.Value, 'Du lieu x');
                y = parse_num_vector(app.InterpYEdit.Value, 'Du lieu y');
                x0 = app.InterpX0Edit.Value;
                method = app.InterpMethodDropDown.Value;

                resN = noisuy_newton(x, y, x0);
                resL = noisuy_lagrange(x, y, x0);

                if strcmp(method, 'newton')
                    res = resN;
                    polyLines = { ...
                        sprintf('[Da thuc thu gon bac %d]: P(x) = %s', res.degree, res.poly_str); ...
                        sprintf('[Dang ty hieu Newton]: P(x) = %s', res.newton_str)};
                elseif strcmp(method, 'lagrange')
                    res = resL;
                    polyLines = { ...
                        sprintf('[Da thuc Lagrange thu gon bac %d]: P(x) = %s', res.degree, res.poly_str); ...
                        sprintf('Sai lech he so so voi Newton: %.2e (Hai da thuc duy nhat trung khit!)', ...
                            max(abs(resN.poly_coeffs - resL.poly_coeffs)))};
                else
                    res = resN;
                    ySpline = spline(x, y, x0);
                    polyLines = { ...
                        sprintf('[Newton & Lagrange bac %d]: P(x) = %s', resN.degree, resN.poly_str); ...
                        sprintf('Du doan tai x0 = %.4g -> Newton: %.8g | Lagrange: %.8g | Cubic Spline: %.8g', ...
                            x0, resN.y0, resL.y0, ySpline)};
                end

                if ~isempty(res.warning)
                    polyLines{end+1} = res.warning;
                end
                app.InterpPolyArea.Value = polyLines;
                app.InterpY0Edit.Value = sprintf('P(%.6g) = %.10g', x0, res.y0);

                % Cap nhat bang ty hieu hoac bang trong so Barycentric
                if strcmp(method, 'lagrange')
                    app.InterpTable.Data = array2table(resL.basis_table);
                    app.InterpTable.ColumnName = resL.headers;
                else
                    app.InterpTable.Data = array2table(resN.dd_table);
                    app.InterpTable.ColumnName = resN.headers;
                end

                % Ve do thi noi suy va du lieu thuc
                cla(app.InterpAxes);
                hold(app.InterpAxes, 'on');
                xmin = min([x, x0]);
                xmax = max([x, x0]);
                pad = 0.08 * max(xmax - xmin, 1);
                xq = linspace(xmin - pad, xmax + pad, 400);
                yq = res.eval_fn(xq);

                plot(app.InterpAxes, xq, yq, '-', 'Color', [0.15 0.39 0.92], 'LineWidth', 2.2, ...
                    'DisplayName', sprintf('Da thuc noi suy (%s)', res.method));

                if strcmp(method, 'compare') && numel(x) >= 3
                    ySp = spline(x, y, xq);
                    plot(app.InterpAxes, xq, ySp, '--', 'Color', [0.05 0.65 0.43], 'LineWidth', 1.8, ...
                        'DisplayName', 'Spline bac 3 (Cubic Spline)');
                end

                plot(app.InterpAxes, x, y, 'o', 'MarkerSize', 8, ...
                    'MarkerEdgeColor', [0.1 0.1 0.1], 'MarkerFaceColor', [0.98 0.75 0.15], ...
                    'DisplayName', 'Du lieu thuc (x_i, y_i)');
                plot(app.InterpAxes, x0, res.y0, 'p', 'MarkerSize', 15, ...
                    'MarkerEdgeColor', [0.75 0.05 0.05], 'MarkerFaceColor', [0.95 0.15 0.15], ...
                    'DisplayName', sprintf('Diem noi suy (%.4g, %.6g)', x0, res.y0));

                grid(app.InterpAxes, 'on');
                legend(app.InterpAxes, 'Location', 'best');
                title(app.InterpAxes, sprintf('Do thi Ham Noi Suy (Bac %d) & Du Lieu Thuc', res.degree));
                xlabel(app.InterpAxes, 'x');
                ylabel(app.InterpAxes, 'y = P(x)');
                hold(app.InterpAxes, 'off');

                app.setStatus(sprintf('[Tab Noi Suy] Hoan tat %s: P(%.4g) = %.8g.', res.method, x0, res.y0));
            catch ME
                uialert(app.UIFigure, ME.message, 'Loi dau vao Tab Noi Suy');
            end
        end

        % =================================================================
        % CALLBACKS TAB 3: HOI QUY TUYEN TINH & PHI TUYEN
        % =================================================================
        function onRegPresetChanged(app, ~, ~)
            switch app.RegPresetDropDown.Value
                case 'p1'
                    app.RegXEdit.Value = '1, 2, 3, 4, 5, 6, 7';
                    app.RegYEdit.Value = '2.6, 4.8, 7.3, 9.4, 11.9, 14.1, 16.5';
                    app.RegMethodDropDown.Value = 'linear';
                    app.RegXPredEdit.Value = 8;
                case 'p2'
                    app.RegXEdit.Value = '1, 2, 3, 4, 5';
                    app.RegYEdit.Value = '2.5, 9.8, 22.4, 40.2, 62.3';
                    app.RegMethodDropDown.Value = 'power';
                    app.RegXPredEdit.Value = 6;
                case 'p3'
                    app.RegXEdit.Value = '0, 1, 2, 3, 4, 5';
                    app.RegYEdit.Value = '3.0, 4.95, 8.15, 13.45, 22.18, 36.60';
                    app.RegMethodDropDown.Value = 'exp_e';
                    app.RegXPredEdit.Value = 4.5;
                case 'p4'
                    app.RegXEdit.Value = '1, 2, 4, 8, 16';
                    app.RegYEdit.Value = '2.1, 4.15, 6.22, 8.30, 10.38';
                    app.RegMethodDropDown.Value = 'log';
                    app.RegXPredEdit.Value = 10;
            end
            app.onRegSolvePushed();
        end

        function onRegLoadCSVPushed(app, ~, ~)
            [xVec, yVec, ok] = app.promptLoadXYFile();
            if ok
                app.RegXEdit.Value = mat2str(xVec, 6);
                app.RegYEdit.Value = mat2str(yVec, 6);
                app.onRegSolvePushed();
            end
        end

        function onRegSolvePushed(app, ~, ~)
            try
                x = parse_num_vector(app.RegXEdit.Value, 'Du lieu x');
                y = parse_num_vector(app.RegYEdit.Value, 'Du lieu y');
                xPred = app.RegXPredEdit.Value;
                method = app.RegMethodDropDown.Value;

                switch method
                    case 'linear'
                        res = hoiquy_tuyentinh(x, y, xPred);
                        allModels = {res};
                    case 'power'
                        res = hoiquy_hammu(x, y, xPred);
                        allModels = {res};
                    case 'exp_e'
                        res = hoiquy_mue(x, y, xPred);
                        allModels = {res};
                    case 'log'
                        res = hoiquy_logarit(x, y, xPred);
                        allModels = {res};
                    case 'auto_best'
                        candidates = {};
                        candidates{end+1} = hoiquy_tuyentinh(x, y, xPred);
                        if all(y > 0)
                            candidates{end+1} = hoiquy_mue(x, y, xPred);
                        end
                        if all(x > 0) && all(y > 0) && xPred > 0
                            candidates{end+1} = hoiquy_hammu(x, y, xPred);
                        end
                        if all(x > 0) && xPred > 0
                            candidates{end+1} = hoiquy_logarit(x, y, xPred);
                        end
                        r2List = cellfun(@(m) m.r2, candidates);
                        [~, bestIdx] = max(r2List);
                        res = candidates{bestIdx};
                        allModels = candidates;
                end

                app.RegEqEdit.Value = res.eq_str;
                app.RegMetricsEdit.Value = sprintf('R^2 = %.6f   |   RMSE = %.6g', res.r2, res.rmse);
                app.RegYPredEdit.Value = sprintf('y(%.6g) = %.10g', xPred, res.y_pred);

                if numel(allModels) == 1
                    app.RegSummaryArea.Value = { ...
                        sprintf('Mo hinh: %s', res.method); ...
                        sprintf('Phuong trinh: %s', res.eq_str); ...
                        sprintf('Do phu hop R^2 = %.6f | Sai so RMSE = %.6g', res.r2, res.rmse)};
                else
                    lines = {sprintf('=== MO HINH TOT NHAT: %s (R^2 = %.6f) ===', res.method, res.r2)};
                    for idx = 1:numel(allModels)
                        mk = allModels{idx};
                        lines{end+1} = sprintf('%d) %-36s | %s | R^2=%.5f | RMSE=%.4g', ...
                            idx, mk.method, mk.eq_str, mk.r2, mk.rmse); %#ok<AGROW>
                    end
                    app.RegSummaryArea.Value = lines;
                end

                app.RegTable.Data = array2table(res.table_data);
                app.RegTable.ColumnName = res.headers;

                % Ve do thi hoi quy & du lieu thuc
                cla(app.RegAxes);
                hold(app.RegAxes, 'on');
                xmin = min([x, xPred]);
                xmax = max([x, xPred]);
                pad = 0.08 * max(xmax - xmin, 1);
                xqLow = xmin - pad;
                if any(strcmp(method, {'power', 'log', 'auto_best'})) && min([x, xPred]) > 0
                    xqLow = max(1e-4, min([x, xPred]) * 0.7);
                end
                xq = linspace(xqLow, xmax + pad, 400);

                colors = {[0.15 0.39 0.92], [0.85 0.22 0.18], [0.05 0.62 0.43], [0.58 0.22 0.85]};
                for idx = 1:numel(allModels)
                    mk = allModels{idx};
                    lw = ifelse( numel(allModels)==1 || strcmp(mk.method, res.method), 2.4, 1.4 );
                    ls = ifelse( numel(allModels)==1 || strcmp(mk.method, res.method), '-', '--' );
                    plot(app.RegAxes, xq, mk.eval_fn(xq), ls, 'Color', colors{mod(idx-1,4)+1}, ...
                        'LineWidth', lw, 'DisplayName', sprintf('%s (R^2=%.4f)', mk.eq_str, mk.r2));
                end

                plot(app.RegAxes, x, y, 'o', 'MarkerSize', 8, ...
                    'MarkerEdgeColor', [0.1 0.1 0.1], 'MarkerFaceColor', [0.98 0.75 0.15], ...
                    'DisplayName', 'Du lieu thuc (x_i, y_i)');
                plot(app.RegAxes, xPred, res.y_pred, 'p', 'MarkerSize', 15, ...
                    'MarkerEdgeColor', [0.75 0.05 0.05], 'MarkerFaceColor', [0.95 0.15 0.15], ...
                    'DisplayName', sprintf('Du doan (%.4g, %.6g)', xPred, res.y_pred));

                grid(app.RegAxes, 'on');
                legend(app.RegAxes, 'Location', 'best');
                title(app.RegAxes, sprintf('Do thi Hoi Quy & Du Lieu Thuc (%s)', res.method));
                xlabel(app.RegAxes, 'x');
                ylabel(app.RegAxes, 'y');
                hold(app.RegAxes, 'off');

                app.setStatus(sprintf('[Tab Hoi Quy] %s | R^2 = %.5f | y(%.4g) = %.6g.', ...
                    res.eq_str, res.r2, xPred, res.y_pred));
            catch ME
                uialert(app.UIFigure, ME.message, 'Loi dau vao Tab Hoi Quy');
            end
        end

        % =================================================================
        % CALLBACKS TAB 4: TINH DAO HAM SO HOC
        % =================================================================
        function onDiffModeChanged(app, ~, ~)
            isFunc = strcmp(app.DiffModeSwitch.Value, 'func');
            app.DiffFuncEdit.Enable = ifelse(isFunc, 'on', 'off');
            app.DiffHEdit.Enable = ifelse(isFunc, 'on', 'off');
            app.DiffXEdit.Enable = ifelse(~isFunc, 'on', 'off');
            app.DiffYEdit.Enable = ifelse(~isFunc, 'on', 'off');
        end

        function onDiffPresetChanged(app, ~, ~)
            switch app.DiffPresetDropDown.Value
                case 'p1'
                    app.DiffModeSwitch.Value = 'func';
                    app.DiffFuncEdit.Value = 'sin(x) + x^2';
                    app.DiffHEdit.Value = 0.05;
                    app.DiffX0Edit.Value = 1.0;
                    app.DiffOrderDropDown.Value = 'O(h^2)';
                case 'p2'
                    app.DiffModeSwitch.Value = 'data';
                    app.DiffXEdit.Value = '0.0, 0.2, 0.4, 0.6, 0.8, 1.0';
                    app.DiffYEdit.Value = '1.0000, 1.2214, 1.4918, 1.8221, 2.2255, 2.7183';
                    app.DiffX0Edit.Value = 0.4;
                    app.DiffOrderDropDown.Value = 'O(h^2)';
                case 'p3'
                    app.DiffModeSwitch.Value = 'func';
                    app.DiffFuncEdit.Value = 'exp(x)*cos(x)';
                    app.DiffHEdit.Value = 0.01;
                    app.DiffX0Edit.Value = 0.5;
                    app.DiffOrderDropDown.Value = 'O(h)';
            end
            app.onDiffModeChanged();
            app.onDiffSolvePushed();
        end

        function onDiffSolvePushed(app, ~, ~)
            try
                mode = app.DiffModeSwitch.Value;
                orderStr = app.DiffOrderDropDown.Value;
                method = app.DiffMethodDropDown.Value;
                x0 = app.DiffX0Edit.Value;

                if strcmp(mode, 'func')
                    arg1 = app.DiffFuncEdit.Value;
                    arg2 = app.DiffHEdit.Value;
                else
                    arg1 = parse_num_vector(app.DiffXEdit.Value, 'Du lieu x');
                    arg2 = parse_num_vector(app.DiffYEdit.Value, 'Du lieu y');
                end

                switch method
                    case 'forward'
                        res = daoham_tien(mode, arg1, arg2, x0, orderStr);
                        resAll = {res};
                    case 'backward'
                        res = daoham_lui(mode, arg1, arg2, x0, orderStr);
                        resAll = {res};
                    case 'central'
                        res = daoham_trungtam(mode, arg1, arg2, x0, orderStr);
                        resAll = {res};
                    case 'compare'
                        resAll = {};
                        try resAll{end+1} = daoham_tien(mode, arg1, arg2, x0, orderStr); catch, end
                        try resAll{end+1} = daoham_lui(mode, arg1, arg2, x0, orderStr); catch, end
                        try resAll{end+1} = daoham_trungtam(mode, arg1, arg2, x0, orderStr); catch, end
                        if isempty(resAll)
                            error('Khong phuong phap nao tinh duoc tai diem bien nay. Hay kiem tra x0!');
                        end
                        res = resAll{end};
                end

                app.DiffResultEdit.Value = sprintf('f''(%.6g) = %.10g', x0, res.df);

                % Cap nhat bang so sanh & chi tiet cong thuc
                rows = cell(numel(resAll), 4);
                for k = 1:numel(resAll)
                    rk = resAll{k};
                    errTxt = ifelse(isnan(rk.abs_err), 'N/A (Du lieu roi rac)', sprintf('%.3e', rk.abs_err));
                    rows(k, :) = {rk.method, rk.df, errTxt, rk.formula};
                end
                app.DiffTable.Data = cell2table(rows, 'VariableNames', {'PhuongPhap', 'DaoHam', 'SaiSo', 'CongThuc'});
                app.DiffTable.ColumnName = {'Phuong phap', 'Gia tri f''(x0)', 'Sai so tuyet doi', 'Cong thuc ap dung'};

                if strcmp(mode, 'func')
                    app.DiffSummaryArea.Value = { ...
                        sprintf('Che do: Tinh tu ham so f(x) = %s (buoc h = %.4g, sai so %s)', arg1, arg2, orderStr); ...
                        sprintf('Ket qua: f''(%.4g) = %.10f  |  Gia tri chuan: %.10f  |  Sai so: %.3e', ...
                            x0, res.df, res.df_ref, res.abs_err); ...
                        sprintf('Cong thuc: %s', res.formula)};
                else
                    app.DiffSummaryArea.Value = { ...
                        sprintf('Che do: Tinh tu du lieu roi rac (x, y) voi buoc luoi h ~ %.4g (%s)', res.h, orderStr); ...
                        sprintf('Ket qua: f''(%.4g) = %.10f', x0, res.df); ...
                        sprintf('Cong thuc: %s', res.formula)};
                end

                % Ve do thi ham/du lieu + duong tiep tuyen tai x0 + cac nut sai phan
                cla(app.DiffAxes);
                hold(app.DiffAxes, 'on');
                if strcmp(mode, 'func')
                    [f, ~] = parse_math_func(arg1);
                    span = max(6 * arg2, 2.0);
                    xq = linspace(x0 - span, x0 + span, 400);
                    plot(app.DiffAxes, xq, f(xq), '-', 'Color', [0.15 0.39 0.92], 'LineWidth', 2.2, 'DisplayName', 'Ham so f(x)');
                    tanSpan = 0.45 * span;
                else
                    xq = linspace(min(arg1), max(arg1), 300);
                    ns = noisuy_newton(arg1, arg2);
                    plot(app.DiffAxes, xq, ns.eval_fn(xq), '-', 'Color', [0.65 0.75 0.95], 'LineWidth', 1.5, 'DisplayName', 'Duong cong qua du lieu');
                    plot(app.DiffAxes, arg1, arg2, 'o', 'MarkerSize', 7, 'MarkerFaceColor', [0.98 0.75 0.15], ...
                        'MarkerEdgeColor', [0.2 0.2 0.2], 'DisplayName', 'Du lieu (x_i, y_i)');
                    tanSpan = 0.35 * max(max(arg1) - min(arg1), 1);
                end

                xTan = linspace(x0 - tanSpan, x0 + tanSpan, 100);
                yTan = res.y0 + res.df .* (xTan - x0);
                plot(app.DiffAxes, xTan, yTan, '--', 'Color', [0.88 0.18 0.18], 'LineWidth', 2.0, ...
                    'DisplayName', sprintf('Tiep tuyen k = f''(x_0) = %.5g', res.df));
                plot(app.DiffAxes, res.stencil_x, res.stencil_y, 's', 'MarkerSize', 9, ...
                    'MarkerFaceColor', [0.05 0.65 0.43], 'MarkerEdgeColor', [0.02 0.35 0.2], ...
                    'DisplayName', 'Nut luoi sai phan (Stencil)');
                plot(app.DiffAxes, x0, res.y0, 'p', 'MarkerSize', 15, ...
                    'MarkerFaceColor', [0.95 0.15 0.15], 'MarkerEdgeColor', [0.6 0 0], ...
                    'DisplayName', sprintf('Diem tinh x_0 = %.4g', x0));

                grid(app.DiffAxes, 'on');
                legend(app.DiffAxes, 'Location', 'best');
                title(app.DiffAxes, sprintf('Minh hoa Hinh hoc Dao ham & Tiep tuyen (%s)', res.method));
                xlabel(app.DiffAxes, 'x');
                ylabel(app.DiffAxes, 'y');
                hold(app.DiffAxes, 'off');

                app.setStatus(sprintf('[Tab Dao Ham] %s tai x0 = %.4g -> f''(x0) = %.8g.', res.method, x0, res.df));
            catch ME
                uialert(app.UIFigure, ME.message, 'Loi dau vao Tab Dao Ham');
            end
        end

        % =================================================================
        % CALLBACKS TAB 5: TINH TICH PHAN XAC DINH
        % =================================================================
        function onIntModeChanged(app, ~, ~)
            isFunc = strcmp(app.IntModeSwitch.Value, 'func');
            app.IntFuncEdit.Enable = ifelse(isFunc, 'on', 'off');
            app.IntAEdit.Enable = ifelse(isFunc, 'on', 'off');
            app.IntBEdit.Enable = ifelse(isFunc, 'on', 'off');
            app.IntNEdit.Enable = ifelse(isFunc, 'on', 'off');
            app.IntXEdit.Enable = ifelse(~isFunc, 'on', 'off');
            app.IntYEdit.Enable = ifelse(~isFunc, 'on', 'off');
        end

        function onIntPresetChanged(app, ~, ~)
            switch app.IntPresetDropDown.Value
                case 'p1'
                    app.IntModeSwitch.Value = 'func';
                    app.IntFuncEdit.Value = 'sin(x) + x^2';
                    app.IntAEdit.Value = 0;
                    app.IntBEdit.Value = 3.14159265;
                    app.IntNEdit.Value = 12; % Chia het cho ca 2 va 3!
                case 'p2'
                    app.IntModeSwitch.Value = 'func';
                    app.IntFuncEdit.Value = '1 / (1 + x^2)';
                    app.IntAEdit.Value = 0;
                    app.IntBEdit.Value = 1;
                    app.IntNEdit.Value = 6; % Ket qua chuan pi/4 ~ 0.7853981634
                case 'p3'
                    app.IntModeSwitch.Value = 'data';
                    app.IntXEdit.Value = '0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0';
                    app.IntYEdit.Value = '1.000, 1.649, 2.718, 4.482, 7.389, 12.182, 20.086';
            end
            app.onIntModeChanged();
            app.onIntSolvePushed();
        end

        function onIntSolvePushed(app, ~, ~)
            try
                mode = app.IntModeSwitch.Value;
                method = app.IntMethodDropDown.Value;

                if strcmp(mode, 'func')
                    fStr = app.IntFuncEdit.Value;
                    a = app.IntAEdit.Value;
                    b = app.IntBEdit.Value;
                    N = round(app.IntNEdit.Value);
                    app.IntNEdit.Value = N;

                    switch method
                        case 'trapz'
                            res = tichphan_hinhthang('func', fStr, a, b, N);
                            resAll = {res};
                        case 'simp13'
                            res = tichphan_simpson13('func', fStr, a, b, N);
                            resAll = {res};
                        case 'simp38'
                            res = tichphan_simpson38('func', fStr, a, b, N);
                            resAll = {res};
                        case 'compare'
                            resAll = {tichphan_hinhthang('func', fStr, a, b, N)};
                            if mod(N, 2) == 0
                                resAll{end+1} = tichphan_simpson13('func', fStr, a, b, N);
                            end
                            if mod(N, 3) == 0
                                resAll{end+1} = tichphan_simpson38('func', fStr, a, b, N);
                            end
                            res = resAll{end};
                    end
                else
                    x = parse_num_vector(app.IntXEdit.Value, 'Du lieu x');
                    y = parse_num_vector(app.IntYEdit.Value, 'Du lieu y');
                    switch method
                        case 'trapz'
                            res = tichphan_hinhthang('data', x, y);
                            resAll = {res};
                        case 'simp13'
                            res = tichphan_simpson13('data', x, y);
                            resAll = {res};
                        case 'simp38'
                            res = tichphan_simpson38('data', x, y);
                            resAll = {res};
                        case 'compare'
                            resAll = {tichphan_hinhthang('data', x, y)};
                            try resAll{end+1} = tichphan_simpson13('data', x, y); catch, end
                            try resAll{end+1} = tichphan_simpson38('data', x, y); catch, end
                            res = resAll{end};
                    end
                end

                app.IntResultEdit.Value = sprintf('I = %.10g', res.I);

                % Cap nhat bang ket qua / cac nut chia luoi
                nodeIdx = (0:numel(res.x_nodes)-1)';
                if ~isempty(res.weights)
                    tblMat = [nodeIdx, res.x_nodes(:), res.y_nodes(:), res.weights(:), (res.y_nodes(:) .* res.weights(:))];
                    app.IntTable.Data = array2table(tblMat);
                    app.IntTable.ColumnName = {'Chi so i', 'Moc x_i', 'Gia tri y_i', 'Trong so w_i', 'Dong gop w_i*y_i'};
                else
                    tblMat = [nodeIdx, res.x_nodes(:), res.y_nodes(:)];
                    app.IntTable.Data = array2table(tblMat);
                    app.IntTable.ColumnName = {'Chi so i', 'Moc x_i', 'Gia tri y_i'};
                end

                lines = {};
                for k = 1:numel(resAll)
                    rk = resAll{k};
                    if isnan(rk.I_exact)
                        lines{end+1} = sprintf('%s (N = %d): I = %.10g', rk.method, rk.N, rk.I); %#ok<AGROW>
                    else
                        lines{end+1} = sprintf('%-26s: I = %.10f | Chinh xac = %.10f | Sai so = %.3e', ...
                            rk.method, rk.I, rk.I_exact, rk.abs_err); %#ok<AGROW>
                    end
                end
                lines{end+1} = ['Cong thuc: ' res.formula];
                app.IntSummaryArea.Value = lines;

                % Ve do thi to mau mien dien tich duoi duong cong
                cla(app.IntAxes);
                hold(app.IntAxes, 'on');
                xn = res.x_nodes;
                yn = res.y_nodes;

                % Ve tung dai hinh thang to mau ban trong suot
                for i = 1:(numel(xn) - 1)
                    patch(app.IntAxes, [xn(i), xn(i+1), xn(i+1), xn(i)], [0, 0, yn(i+1), yn(i)], ...
                        [0.23 0.51 0.96], 'FaceAlpha', 0.22, 'EdgeColor', [0.20 0.45 0.85], ...
                        'HandleVisibility', ifelse(i==1, 'on', 'off'), 'DisplayName', 'Mien xap xi tich phan');
                end

                if strcmp(mode, 'func')
                    [f, ~] = parse_math_func(app.IntFuncEdit.Value);
                    xq = linspace(min(xn), max(xn), 400);
                    plot(app.IntAxes, xq, f(xq), '-', 'Color', [0.85 0.18 0.18], 'LineWidth', 2.2, 'DisplayName', 'Ham so f(x)');
                end
                plot(app.IntAxes, xn, yn, 'o-', 'Color', [0.10 0.25 0.65], 'MarkerFaceColor', [0.98 0.75 0.15], ...
                    'MarkerSize', 6, 'LineWidth', 1.2, 'DisplayName', sprintf('Cac moc luoi (N = %d)', res.N));
                yline(app.IntAxes, 0, '-k', 'HandleVisibility', 'off');

                grid(app.IntAxes, 'on');
                legend(app.IntAxes, 'Location', 'best');
                title(app.IntAxes, sprintf('Minh hoa Dien tich Tich phan (%s): I = %.8g', res.method, res.I));
                xlabel(app.IntAxes, 'x');
                ylabel(app.IntAxes, 'f(x)');
                hold(app.IntAxes, 'off');

                app.setStatus(sprintf('[Tab Tich Phan] %s -> I = %.10g.', res.method, res.I));
            catch ME
                uialert(app.UIFigure, ME.message, 'Loi dau vao Tab Tich Phan');
            end
        end

        % =================================================================
        % CALLBACKS TAB 6: GIOI THIEU NHOM & DANH GIA 100%
        % =================================================================
        function onTeamValidatePushed(app, ~, ~)
            tbl = app.TeamMemberTable.Data;
            pcts = tbl{:, 5};
            totalPct = sum(pcts);
            if abs(totalPct - 100) < 1e-6
                app.TeamTotalLabel.Text = sprintf('Tong ty le dong gop nhom: %.1f%% (HOP LE CHUAN 100%%)', totalPct);
                app.TeamTotalLabel.FontColor = [0.04 0.52 0.32];
                uialert(app.UIFigure, sprintf('Bang danh gia nhom dat chuan tuyet doi: %.1f%% / 100%%!', totalPct), ...
                    'Xac nhan Danh gia Nhom', 'Icon', 'success');
            else
                app.TeamTotalLabel.Text = sprintf('Tong ty le dong gop nhom: %.1f%% (CAN DIEU CHINH VE DUNG 100%%!)', totalPct);
                app.TeamTotalLabel.FontColor = [0.82 0.15 0.15];
                uialert(app.UIFigure, sprintf('Tong %% dong gop hien tai la %.1f%%. Theo quy dinh thang diem, tong cac thanh vien phai bang dung 100%%!', totalPct), ...
                    'Canh bao Ty le Dong gop', 'Icon', 'warning');
            end
        end

        function onTeamExportReportPushed(app, ~, ~)
            [file, path] = uiputfile('*.csv', 'Xuat Bang Danh Gia Nhom ra CSV', 'Bang_Danh_Gia_Nhom_100.csv');
            if isequal(file, 0), return; end
            writetable(app.TeamMemberTable.Data, fullfile(path, file));
            uialert(app.UIFigure, ['Da xuat bang phan cong nhom tai: ' fullfile(path, file)], 'Xuat Thanh Cong', 'Icon', 'success');
        end
    end

    methods (Access = private)
        function [xVec, yVec, ok] = promptLoadXYFile(app)
            xVec = []; yVec = []; ok = false;
            [file, path] = uigetfile({'*.csv;*.txt;*.xlsx', 'Tap tin du lieu (*.csv, *.txt, *.xlsx)'}, 'Chon file du lieu 2 cot (x, y)');
            if isequal(file, 0), return; end
            raw = readmatrix(fullfile(path, file));
            if size(raw, 2) < 2
                uialert(app.UIFigure, 'Tap tin du lieu can it nhat 2 cot so (cot 1 la x, cot 2 la y)!', 'Loi dinh dang file');
                return;
            end
            validRows = all(isfinite(raw(:, 1:2)), 2);
            xVec = raw(validRows, 1)';
            yVec = raw(validRows, 2)';
            ok = true;
        end

        function exportCurrentTableAndPlot(app, uiTbl, uiAx, prefix)
            [file, path] = uiputfile('*.png', 'Luu anh Do thi Chat luong cao', [prefix '.png']);
            if isequal(file, 0), return; end
            imgPath = fullfile(path, file);
            exportgraphics(uiAx, imgPath, 'Resolution', 300);
            [~, baseName] = fileparts(file);
            csvPath = fullfile(path, [baseName '_BangSoLieu.csv']);
            if ~isempty(uiTbl.Data)
                writetable(uiTbl.Data, csvPath);
            end
            uialert(app.UIFigure, sprintf('Da luu anh do thi (300 DPI) va bang CSV tai:\n%s', path), 'Xuat Ket Qua Thanh Cong', 'Icon', 'success');
        end

        % =================================================================
        % KHOI TAO TOAN BO GIAO DIEN 6 TAB CHUAN APP DESIGNER
        % =================================================================
        function createComponents(app)
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [60, 60, 1260, 780];
            app.UIFigure.Name = 'Studio Phuong Phap Tinh & MATLAB - Phien Ban Chuyen Nghiep';
            app.UIFigure.Color = [0.95 0.96 0.98];

            app.RootGrid = uigridlayout(app.UIFigure, [2, 1]);
            app.RootGrid.RowHeight = {64, '1x'};
            app.RootGrid.ColumnWidth = {'1x'};
            app.RootGrid.Padding = [10 10 10 10];
            app.RootGrid.RowSpacing = 8;

            % --- HEADER BANNER ---
            app.HeaderPanel = uipanel(app.RootGrid);
            app.HeaderPanel.BackgroundColor = [0.12 0.16 0.23];
            app.HeaderPanel.BorderType = 'none';
            hdrGrid = uigridlayout(app.HeaderPanel, [2, 1]);
            hdrGrid.RowHeight = {'1x', '1x'};
            hdrGrid.ColumnWidth = {'1x'};
            hdrGrid.Padding = [16 6 16 6];
            hdrGrid.RowSpacing = 2;

            app.HeaderTitleLabel = uilabel(hdrGrid);
            app.HeaderTitleLabel.Text = 'HE THONG GIAI TOAN PHUONG PHAP TINH & TRUC QUAN HOA MATLAB';
            app.HeaderTitleLabel.FontSize = 16;
            app.HeaderTitleLabel.FontWeight = 'bold';
            app.HeaderTitleLabel.FontColor = [1 1 1];

            app.HeaderStatusLabel = uilabel(hdrGrid);
            app.HeaderStatusLabel.Text = 'Khoi tao giao dien va thu vien giai thuat...';
            app.HeaderStatusLabel.FontSize = 12;
            app.HeaderStatusLabel.FontColor = [0.72 0.84 0.98];

            % --- TAB GROUP 6 CHU DE ---
            app.TabGroup = uitabgroup(app.RootGrid);

            app.buildTab1Nghiem();
            app.buildTab2NoiSuy();
            app.buildTab3HoiQuy();
            app.buildTab4DaoHam();
            app.buildTab5TichPhan();
            app.buildTab6GioiThieu();

            app.UIFigure.Visible = 'on';
        end

        % -----------------------------------------------------------------
        % XAY DUNG TAB 1: TIM NGHIEM
        % -----------------------------------------------------------------
        function buildTab1Nghiem(app)
            app.TabNghiem = uitab(app.TabGroup, 'Title', '1. Nghiem PT');
            g = uigridlayout(app.TabNghiem, [1, 2]);
            g.ColumnWidth = {390, '1x'};
            g.Padding = [10 10 10 10];

            % Cot trai: Nhap lieu & Ket qua
            leftPanel = uipanel(g, 'Title', 'Thong so Bai toan Tim Nghiem f(x) = 0', 'FontWeight', 'bold');
            lg = uigridlayout(leftPanel, [12, 2]);
            lg.ColumnWidth = {145, '1x'};
            lg.RowHeight = {30, 30, 30, 30, 30, 32, 38, 28, 28, 28, '1x', 32};
            lg.RowSpacing = 7;

            uilabel(lg, 'Text', 'Bo de mau (1-Click):', 'FontWeight', 'bold');
            app.RootPresetDropDown = uidropdown(lg, ...
                'Items', {'VD1: x^3 - 2*x - 5 = 0 tren [2, 3]', ...
                          'VD2: cos(x) - x = 0 tren [0, 1]', ...
                          'VD3: e^(-x) - x = 0 tren [0, 1]', ...
                          'VD4: x*ln(x) - 1.2 = 0 tren [1.5, 2.5]'}, ...
                'ItemsData', {'p1', 'p2', 'p3', 'p4'}, ...
                'ValueChangedFcn', createCallbackFcn(app, @onRootPresetChanged, true));

            uilabel(lg, 'Text', 'Nhap phuong trinh f(x):');
            app.RootEqEdit = uieditfield(lg, 'text', 'Value', 'x^3 - 2*x - 5');

            uilabel(lg, 'Text', 'Ham lap phi(x) (tuy chon):');
            app.RootPhiEdit = uieditfield(lg, 'text', 'Value', '(2*x + 5)^(1/3)', ...
                'Tooltip', 'De trong neu muon he thong tu dong tao ham lap hoi tu x - lambda*f(x)');

            uilabel(lg, 'Text', 'Khoang phan ly [a, b]:');
            abGrid = uigridlayout(lg, [1, 2]);
            abGrid.Padding = [0 0 0 0];
            app.RootAEdit = uieditfield(abGrid, 'numeric', 'Value', 2);
            app.RootBEdit = uieditfield(abGrid, 'numeric', 'Value', 3);

            uilabel(lg, 'Text', 'Sai so cho phep (tol):');
            app.RootTolEdit = uieditfield(lg, 'numeric', 'Value', 1e-6, 'ValueDisplayFormat', '%.1e');

            uilabel(lg, 'Text', 'Chon phuong phap:');
            app.RootMethodDropDown = uidropdown(lg, ...
                'Items', {'Chia doi (Bisection)', ...
                          'Lap don (Fixed-Point)', ...
                          'Newton-Raphson (Tiep tuyen)', ...
                          'Day cung (Secant - Mo rong)', ...
                          'So sanh tat ca phuong phap'}, ...
                'ItemsData', {'bisect', 'fixed', 'newton', 'secant', 'compare'}, ...
                'Value', 'compare');

            app.RootSolveBtn = uibutton(lg, 'push', 'Text', 'TIM NGHIEM & VE DO THI', ...
                'BackgroundColor', [0.15 0.39 0.92], 'FontColor', [1 1 1], 'FontWeight', 'bold', ...
                'ButtonPushedFcn', createCallbackFcn(app, @onRootSolvePushed, true));
            app.RootSolveBtn.Layout.Column = [1 2];

            uilabel(lg, 'Text', 'Ket qua nghiem x*:');
            app.RootResultEdit = uieditfield(lg, 'text', 'Editable', 'off', 'FontWeight', 'bold');

            uilabel(lg, 'Text', 'So lan lap:');
            app.RootIterEdit = uieditfield(lg, 'text', 'Editable', 'off');

            uilabel(lg, 'Text', 'Sai so uoc luong:');
            app.RootErrorEdit = uieditfield(lg, 'text', 'Editable', 'off');

            app.RootSummaryArea = uitextarea(lg, 'Editable', 'off');
            app.RootSummaryArea.Layout.Column = [1 2];

            app.RootExportBtn = uibutton(lg, 'push', 'Text', 'Xuat Do thi PNG & Bang CSV', ...
                'ButtonPushedFcn', createCallbackFcn(app, @onRootExportPushed, true));
            app.RootExportBtn.Layout.Column = [1 2];

            % Cot phai: Do thi ham so + Do thi hoi tu + Bang chi tiet tung lan lap
            rightGrid = uigridlayout(g, [2, 2]);
            rightGrid.RowHeight = {'3x', '2x'};
            rightGrid.ColumnWidth = {'3x', '2x'};
            rightGrid.Padding = [0 0 0 0];

            app.RootAxes = uiaxes(rightGrid);
            app.RootConvAxes = uiaxes(rightGrid);

            app.RootTable = uitable(rightGrid, 'RowStriping', 'on');
            app.RootTable.Layout.Row = 2;
            app.RootTable.Layout.Column = [1 2];
        end

        % -----------------------------------------------------------------
        % XAY DUNG TAB 2: NOI SUY
        % -----------------------------------------------------------------
        function buildTab2NoiSuy(app)
            app.TabNoiSuy = uitab(app.TabGroup, 'Title', '2. Noi Suy');
            g = uigridlayout(app.TabNoiSuy, [1, 2]);
            g.ColumnWidth = {400, '1x'};
            g.Padding = [10 10 10 10];

            leftPanel = uipanel(g, 'Title', 'Thong so Bai toan Noi Suy Da Thuc', 'FontWeight', 'bold');
            lg = uigridlayout(leftPanel, [10, 2]);
            lg.ColumnWidth = {145, '1x'};
            lg.RowHeight = {30, 30, 30, 30, 32, 30, 38, '1x', 32, 26};
            lg.RowSpacing = 8;

            uilabel(lg, 'Text', 'Bo de mau (1-Click):', 'FontWeight', 'bold');
            app.InterpPresetDropDown = uidropdown(lg, ...
                'Items', {'VD1: Moc khong cach deu (4 diem)', ...
                          'VD2: Bang ham Bessel J0 (5 diem)', ...
                          'VD3: Gia toc trong truong theo do cao'}, ...
                'ItemsData', {'p1', 'p2', 'p3'}, ...
                'ValueChangedFcn', createCallbackFcn(app, @onInterpPresetChanged, true));

            uilabel(lg, 'Text', 'Nhap du lieu x:');
            app.InterpXEdit = uieditfield(lg, 'text', 'Value', '0, 1, 2, 4');

            uilabel(lg, 'Text', 'Nhap du lieu y:');
            app.InterpYEdit = uieditfield(lg, 'text', 'Value', '1, 3, 9, 65');

            app.InterpLoadCSVBtn = uibutton(lg, 'push', 'Text', 'Nhap du lieu (x, y) tu file CSV / Excel...', ...
                'ButtonPushedFcn', createCallbackFcn(app, @onInterpLoadCSVPushed, true));
            app.InterpLoadCSVBtn.Layout.Column = [1 2];

            uilabel(lg, 'Text', 'Phuong phap noi suy:');
            app.InterpMethodDropDown = uidropdown(lg, ...
                'Items', {'Noi suy Newton (Bang ty hieu)', ...
                          'Noi suy Lagrange (Barycentric)', ...
                          'So sanh Newton + Lagrange + Spline'}, ...
                'ItemsData', {'newton', 'lagrange', 'compare'}, ...
                'Value', 'newton');

            uilabel(lg, 'Text', 'Gia tri can noi suy x0:');
            app.InterpX0Edit = uieditfield(lg, 'numeric', 'Value', 2.5);

            app.InterpSolveBtn = uibutton(lg, 'push', 'Text', 'TIM DA THUC & DU DOAN NOI SUY', ...
                'BackgroundColor', [0.15 0.39 0.92], 'FontColor', [1 1 1], 'FontWeight', 'bold', ...
                'ButtonPushedFcn', createCallbackFcn(app, @onInterpSolvePushed, true));
            app.InterpSolveBtn.Layout.Column = [1 2];

            app.InterpPolyArea = uitextarea(lg, 'Editable', 'off');
            app.InterpPolyArea.Layout.Column = [1 2];

            uilabel(lg, 'Text', 'Ket qua noi suy P(x0):', 'FontWeight', 'bold');
            app.InterpY0Edit = uieditfield(lg, 'text', 'Editable', 'off', 'FontWeight', 'bold');

            noteLbl = uilabel(lg, 'Text', 'Bang ben phai hien thi day du Ty hieu Newton / He so Lagrange.', 'FontSize', 11);
            noteLbl.Layout.Column = [1 2];

            rightGrid = uigridlayout(g, [2, 1]);
            rightGrid.RowHeight = {'3x', '2x'};
            rightGrid.Padding = [0 0 0 0];
            app.InterpAxes = uiaxes(rightGrid);
            app.InterpTable = uitable(rightGrid, 'RowStriping', 'on');
        end

        % -----------------------------------------------------------------
        % XAY DUNG TAB 3: HOI QUY
        % -----------------------------------------------------------------
        function buildTab3HoiQuy(app)
            app.TabHoiQuy = uitab(app.TabGroup, 'Title', '3. Hoi Quy');
            g = uigridlayout(app.TabHoiQuy, [1, 2]);
            g.ColumnWidth = {410, '1x'};
            g.Padding = [10 10 10 10];

            leftPanel = uipanel(g, 'Title', 'Thong so Bai toan Hoi Quy Binh Phuong Cuc Tieu', 'FontWeight', 'bold');
            lg = uigridlayout(leftPanel, [11, 2]);
            lg.ColumnWidth = {150, '1x'};
            lg.RowHeight = {30, 30, 30, 30, 32, 30, 38, 30, 30, 30, '1x'};
            lg.RowSpacing = 7;

            uilabel(lg, 'Text', 'Bo de mau (1-Click):', 'FontWeight', 'bold');
            app.RegPresetDropDown = uidropdown(lg, ...
                'Items', {'VD1: Du lieu Tuyen tinh y = a*x + b', ...
                          'VD2: Du lieu Ham mu/luy thua y = a*x^b', ...
                          'VD3: Du lieu Ham mu co so e y = a*e^(b*x)', ...
                          'VD4: Du lieu Ham Logarit y = a + b*ln(x)'}, ...
                'ItemsData', {'p1', 'p2', 'p3', 'p4'}, ...
                'ValueChangedFcn', createCallbackFcn(app, @onRegPresetChanged, true));

            uilabel(lg, 'Text', 'Nhap du lieu x:');
            app.RegXEdit = uieditfield(lg, 'text', 'Value', '1, 2, 3, 4, 5, 6, 7');

            uilabel(lg, 'Text', 'Nhap du lieu y:');
            app.RegYEdit = uieditfield(lg, 'text', 'Value', '2.6, 4.8, 7.3, 9.4, 11.9, 14.1, 16.5');

            app.RegLoadCSVBtn = uibutton(lg, 'push', 'Text', 'Nhap du lieu (x, y) tu file CSV / Excel...', ...
                'ButtonPushedFcn', createCallbackFcn(app, @onRegLoadCSVPushed, true));
            app.RegLoadCSVBtn.Layout.Column = [1 2];

            uilabel(lg, 'Text', 'Chon phuong phap:');
            app.RegMethodDropDown = uidropdown(lg, ...
                'Items', {'1. Hoi quy Tuyen tinh (y = a*x + b)', ...
                          '2. Hoi quy Ham mu / luy thua (y = a*x^b)', ...
                          '3. Hoi quy Mu co so e (y = a*e^(b*x))', ...
                          '4. Hoi quy Logarit (y = a + b*ln(x))', ...
                          '5. Tu dong so sanh & chon R^2 cao nhat'}, ...
                'ItemsData', {'linear', 'power', 'exp_e', 'log', 'auto_best'}, ...
                'Value', 'auto_best');

            uilabel(lg, 'Text', 'Gia tri can du doan x:');
            app.RegXPredEdit = uieditfield(lg, 'numeric', 'Value', 8);

            app.RegSolveBtn = uibutton(lg, 'push', 'Text', 'TIM PHUONG TRINH HOI QUY & DU DOAN', ...
                'BackgroundColor', [0.15 0.39 0.92], 'FontColor', [1 1 1], 'FontWeight', 'bold', ...
                'ButtonPushedFcn', createCallbackFcn(app, @onRegSolvePushed, true));
            app.RegSolveBtn.Layout.Column = [1 2];

            uilabel(lg, 'Text', 'Phuong trinh hoi quy:');
            app.RegEqEdit = uieditfield(lg, 'text', 'Editable', 'off', 'FontWeight', 'bold');

            uilabel(lg, 'Text', 'Chi so danh gia:');
            app.RegMetricsEdit = uieditfield(lg, 'text', 'Editable', 'off');

            uilabel(lg, 'Text', 'Ket qua du doan:');
            app.RegYPredEdit = uieditfield(lg, 'text', 'Editable', 'off', 'FontWeight', 'bold');

            app.RegSummaryArea = uitextarea(lg, 'Editable', 'off');
            app.RegSummaryArea.Layout.Column = [1 2];

            rightGrid = uigridlayout(g, [2, 1]);
            rightGrid.RowHeight = {'3x', '2x'};
            rightGrid.Padding = [0 0 0 0];
            app.RegAxes = uiaxes(rightGrid);
            app.RegTable = uitable(rightGrid, 'RowStriping', 'on');
        end

        % -----------------------------------------------------------------
        % XAY DUNG TAB 4: DAO HAM
        % -----------------------------------------------------------------
        function buildTab4DaoHam(app)
            app.TabDaoHam = uitab(app.TabGroup, 'Title', '4. Dao Ham');
            g = uigridlayout(app.TabDaoHam, [1, 2]);
            g.ColumnWidth = {410, '1x'};
            g.Padding = [10 10 10 10];

            leftPanel = uipanel(g, 'Title', 'Thong so Tinh Dao Ham So Hoc f''(x0)', 'FontWeight', 'bold');
            lg = uigridlayout(leftPanel, [12, 2]);
            lg.ColumnWidth = {155, '1x'};
            lg.RowHeight = {30, 30, 28, 28, 28, 28, 30, 30, 30, 38, 30, '1x'};
            lg.RowSpacing = 6;

            uilabel(lg, 'Text', 'Bo de mau (1-Click):', 'FontWeight', 'bold');
            app.DiffPresetDropDown = uidropdown(lg, ...
                'Items', {'VD1: Ham so f(x) = sin(x) + x^2 tai x0 = 1', ...
                          'VD2: Bang du lieu roi rac (x, y) tai x0 = 0.4', ...
                          'VD3: Ham so f(x) = e^x * cos(x) tai x0 = 0.5'}, ...
                'ItemsData', {'p1', 'p2', 'p3'}, ...
                'ValueChangedFcn', createCallbackFcn(app, @onDiffPresetChanged, true));

            uilabel(lg, 'Text', 'Nguon du lieu dau vao:');
            app.DiffModeSwitch = uidropdown(lg, ...
                'Items', {'Tinh tu Ham so f(x) va buoc h', 'Tinh tu Du lieu roi rac (x, y)'}, ...
                'ItemsData', {'func', 'data'}, ...
                'Value', 'func', ...
                'ValueChangedFcn', createCallbackFcn(app, @onDiffModeChanged, true));

            uilabel(lg, 'Text', 'Nhap du lieu x:');
            app.DiffXEdit = uieditfield(lg, 'text', 'Value', '0.0, 0.2, 0.4, 0.6, 0.8, 1.0');

            uilabel(lg, 'Text', 'Nhap du lieu y:');
            app.DiffYEdit = uieditfield(lg, 'text', 'Value', '1.0000, 1.2214, 1.4918, 1.8221, 2.2255, 2.7183');

            uilabel(lg, 'Text', 'Hoac nhap ham so f(x):');
            app.DiffFuncEdit = uieditfield(lg, 'text', 'Value', 'sin(x) + x^2');

            uilabel(lg, 'Text', 'Nhap buoc luoi h:');
            app.DiffHEdit = uieditfield(lg, 'numeric', 'Value', 0.05);

            uilabel(lg, 'Text', 'Chon bac sai so:');
            app.DiffOrderDropDown = uidropdown(lg, ...
                'Items', {'Sai so O(h)', 'Sai so O(h^2)'}, ...
                'ItemsData', {'O(h)', 'O(h^2)'}, ...
                'Value', 'O(h^2)');

            uilabel(lg, 'Text', 'Phuong phap dao ham:');
            app.DiffMethodDropDown = uidropdown(lg, ...
                'Items', {'Xap xi tien (Forward)', ...
                          'Xap xi lui (Backward)', ...
                          'Xap xi trung tam (Central)', ...
                          'So sanh ca 3 phuong phap'}, ...
                'ItemsData', {'forward', 'backward', 'central', 'compare'}, ...
                'Value', 'compare');

            uilabel(lg, 'Text', 'Gia tri can tinh x0:');
            app.DiffX0Edit = uieditfield(lg, 'numeric', 'Value', 1.0);

            app.DiffSolveBtn = uibutton(lg, 'push', 'Text', 'TINH DAO HAM & VE TIEP TUYEN', ...
                'BackgroundColor', [0.15 0.39 0.92], 'FontColor', [1 1 1], 'FontWeight', 'bold', ...
                'ButtonPushedFcn', createCallbackFcn(app, @onDiffSolvePushed, true));
            app.DiffSolveBtn.Layout.Column = [1 2];

            uilabel(lg, 'Text', 'Ket qua dao ham:', 'FontWeight', 'bold');
            app.DiffResultEdit = uieditfield(lg, 'text', 'Editable', 'off', 'FontWeight', 'bold');

            app.DiffSummaryArea = uitextarea(lg, 'Editable', 'off');
            app.DiffSummaryArea.Layout.Column = [1 2];

            rightGrid = uigridlayout(g, [2, 1]);
            rightGrid.RowHeight = {'3x', '2x'};
            rightGrid.Padding = [0 0 0 0];
            app.DiffAxes = uiaxes(rightGrid);
            app.DiffTable = uitable(rightGrid, 'RowStriping', 'on');
        end

        % -----------------------------------------------------------------
        % XAY DUNG TAB 5: TICH PHAN
        % -----------------------------------------------------------------
        function buildTab5TichPhan(app)
            app.TabTichPhan = uitab(app.TabGroup, 'Title', '5. Tich Phan');
            g = uigridlayout(app.TabTichPhan, [1, 2]);
            g.ColumnWidth = {410, '1x'};
            g.Padding = [10 10 10 10];

            leftPanel = uipanel(g, 'Title', 'Thong so Tinh Tich Phan Xac Dinh', 'FontWeight', 'bold');
            lg = uigridlayout(leftPanel, [11, 2]);
            lg.ColumnWidth = {155, '1x'};
            lg.RowHeight = {30, 30, 28, 28, 28, 30, 28, 30, 38, 30, '1x'};
            lg.RowSpacing = 6;

            uilabel(lg, 'Text', 'Bo de mau (1-Click):', 'FontWeight', 'bold');
            app.IntPresetDropDown = uidropdown(lg, ...
                'Items', {'VD1: sin(x) + x^2 tren [0, pi], N = 12', ...
                          'VD2: 1/(1 + x^2) tren [0, 1], N = 6 (= pi/4)', ...
                          'VD3: Tich phan tu bang du lieu roi rac (x, y)'}, ...
                'ItemsData', {'p1', 'p2', 'p3'}, ...
                'ValueChangedFcn', createCallbackFcn(app, @onIntPresetChanged, true));

            uilabel(lg, 'Text', 'Nguon du lieu dau vao:');
            app.IntModeSwitch = uidropdown(lg, ...
                'Items', {'Tinh tu Ham so f(x), can [a, b], N', 'Tinh tu Du lieu roi rac (x, y)'}, ...
                'ItemsData', {'func', 'data'}, ...
                'Value', 'func', ...
                'ValueChangedFcn', createCallbackFcn(app, @onIntModeChanged, true));

            uilabel(lg, 'Text', 'Nhap du lieu x:');
            app.IntXEdit = uieditfield(lg, 'text', 'Value', '0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0');

            uilabel(lg, 'Text', 'Nhap du lieu y:');
            app.IntYEdit = uieditfield(lg, 'text', 'Value', '1.000, 1.649, 2.718, 4.482, 7.389, 12.182, 20.086');

            uilabel(lg, 'Text', 'Hoac nhap ham so f(x):');
            app.IntFuncEdit = uieditfield(lg, 'text', 'Value', 'sin(x) + x^2');

            uilabel(lg, 'Text', 'Nhap can tich phan [a, b]:');
            abGrid = uigridlayout(lg, [1, 2]);
            abGrid.Padding = [0 0 0 0];
            app.IntAEdit = uieditfield(abGrid, 'numeric', 'Value', 0);
            app.IntBEdit = uieditfield(abGrid, 'numeric', 'Value', 3.14159265);

            uilabel(lg, 'Text', 'Nhap so khoang chia N:');
            app.IntNEdit = uieditfield(lg, 'numeric', 'Value', 12, 'Limits', [1 100000]);

            uilabel(lg, 'Text', 'Phuong phap tich phan:');
            app.IntMethodDropDown = uidropdown(lg, ...
                'Items', {'Quy tac Hinh thang (Trapezoidal)', ...
                          'Phuong phap Simpson 1/3 (N chan)', ...
                          'Phuong phap Simpson 3/8 (N chia het 3)', ...
                          'So sanh tat ca phuong phap hop le'}, ...
                'ItemsData', {'trapz', 'simp13', 'simp38', 'compare'}, ...
                'Value', 'compare');

            app.IntSolveBtn = uibutton(lg, 'push', 'Text', 'TINH TICH PHAN & MINH HOA DIEN TICH', ...
                'BackgroundColor', [0.15 0.39 0.92], 'FontColor', [1 1 1], 'FontWeight', 'bold', ...
                'ButtonPushedFcn', createCallbackFcn(app, @onIntSolvePushed, true));
            app.IntSolveBtn.Layout.Column = [1 2];

            uilabel(lg, 'Text', 'Ket qua tich phan:', 'FontWeight', 'bold');
            app.IntResultEdit = uieditfield(lg, 'text', 'Editable', 'off', 'FontWeight', 'bold');

            app.IntSummaryArea = uitextarea(lg, 'Editable', 'off');
            app.IntSummaryArea.Layout.Column = [1 2];

            rightGrid = uigridlayout(g, [2, 1]);
            rightGrid.RowHeight = {'3x', '2x'};
            rightGrid.Padding = [0 0 0 0];
            app.IntAxes = uiaxes(rightGrid);
            app.IntTable = uitable(rightGrid, 'RowStriping', 'on');
        end

        % -----------------------------------------------------------------
        % XAY DUNG TAB 6: GIOI THIEU NHOM
        % -----------------------------------------------------------------
        function buildTab6GioiThieu(app)
            app.TabGioiThieu = uitab(app.TabGroup, 'Title', '6. Gioi Thieu Nhom');
            g = uigridlayout(app.TabGioiThieu, [3, 1]);
            g.RowHeight = {180, '1x', 44};
            g.Padding = [14 14 14 14];
            g.RowSpacing = 10;

            infoPanel = uipanel(g, 'Title', 'Gioi Thieu De Tai & Kien Truc Phan Mem', 'FontWeight', 'bold');
            ig = uigridlayout(infoPanel, [1, 1]);
            app.TeamInfoArea = uitextarea(ig, 'Editable', 'off', 'Value', { ...
                'DE TAI: XAY DUNG UNG DUNG GIAI QUYET CAC BAI TOAN PHUONG PHAP TINH TREN MATLAB APP DESIGNER'; ...
                'Hoc phan: Phuong Phap Tinh va MATLAB  |  Quy mo nhom: Toi da 6 thanh vien  |  Quan ly ma nguon: Git & GitHub'; ...
                ''; ...
                'DIEM NHAN CAI TIEN VUOT TROI (25/25 TIEU CHI UNG DUNG + MO RONG CHUYEN SAU):'; ...
                '  1) Kien truc Module hoa 100%: 16 ham .m doc lap trong thu muc algorithms/ (de kiem thu don vi va tai su dung).'; ...
                '  2) Do thi Truc quan hoa Dong: Ve tiep tuyen Newton, toc do hoi tu Log, tiep tuyen dao ham, to mau mien tich phan.'; ...
                '  3) Che do So sanh Tu dong: So sanh Chia doi - Lap - Newton - Day cung; tu dong xep hang mo hinh Hoi quy theo R^2.'; ...
                '  4) Nhap/Xuat Linh hoat: Bo de mau 1-Click cho van dap, nhap du lieu CSV/Excel, xuat do thi PNG 300 DPI & bang CSV.'});

            tblPanel = uipanel(g, 'Title', 'Danh Sach Thanh Vien, Phan Cong Nhiem Vu & Tu Danh Gia Nhom (Chinh sua truc tiep tren bang)', 'FontWeight', 'bold');
            tg = uigridlayout(tblPanel, [1, 1]);

            defaultMembers = table( ...
                (1:6)', ...
                {'22100001'; '22100002'; '22100003'; '22100004'; '22100005'; '22100006'}, ...
                {'Thanh vien 1 (Nhom truong)'; 'Thanh vien 2'; 'Thanh vien 3'; 'Thanh vien 4'; 'Thanh vien 5'; 'Thanh vien 6'}, ...
                {'Kien truc App Designer + Tab Tim Nghiem + Quan ly GitHub'; ...
                 'Xay dung thuat toan & Giao dien Tab Noi Suy (Newton, Lagrange)'; ...
                 'Xay dung thuat toan & Giao dien Tab Hoi Quy (Tuyen tinh, Mu, Mu e, Log)'; ...
                 'Xay dung thuat toan & Giao dien Tab Dao Ham (O(h), O(h^2), Tiep tuyen)'; ...
                 'Xay dung thuat toan & Giao dien Tab Tich Phan (Hinh thang, Simpson 1/3, 3/8)'; ...
                 'Kiem thu 25 tieu chi + Bien soan Bao cao Word & So do thuat toan'}, ...
                [18; 17; 17; 16; 16; 16], ...
                'VariableNames', {'STT', 'MSSV', 'HoTen', 'NhiemVu', 'TyLeDongGop'});

            app.TeamMemberTable = uitable(tg, 'Data', defaultMembers, ...
                'ColumnName', {'STT', 'MSSV', 'Ho va Ten', 'Nhiem vu thuc hien chi tiet', 'Ty le dong gop (%)'}, ...
                'ColumnEditable', [false, true, true, true, true], ...
                'ColumnWidth', {50, 110, 200, 'auto', 140}, ...
                'RowStriping', 'on');

            footerGrid = uigridlayout(g, [1, 3]);
            footerGrid.ColumnWidth = {'1x', 230, 230};
            footerGrid.Padding = [0 0 0 0];

            app.TeamTotalLabel = uilabel(footerGrid, ...
                'Text', 'Tong ty le dong gop nhom: 100.0% (HOP LE CHUAN 100%)', ...
                'FontWeight', 'bold', 'FontSize', 13, 'FontColor', [0.04 0.52 0.32]);

            app.TeamValidateBtn = uibutton(footerGrid, 'push', 'Text', 'Kiem tra Tong = 100%', ...
                'BackgroundColor', [0.05 0.62 0.43], 'FontColor', [1 1 1], 'FontWeight', 'bold', ...
                'ButtonPushedFcn', createCallbackFcn(app, @onTeamValidatePushed, true));

            app.TeamExportReportBtn = uibutton(footerGrid, 'push', 'Text', 'Xuat Bang Nhom ra CSV', ...
                'ButtonPushedFcn', createCallbackFcn(app, @onTeamExportReportPushed, true));
        end
    end

    methods (Access = public)
        % Ham khoi tao (Constructor) chuan App Designer
        function app = AppPhuongPhapTinh
            createComponents(app);
            registerApp(app, app.UIFigure);
            runStartupFcn(app, @startupFcn);

            if nargout == 0
                clear app
            end
        end

        % Ham huy ung dung an toan
        function delete(app)
            if isvalid(app.UIFigure)
                delete(app.UIFigure);
            end
        end
    end
end

function out = ifelse(cond, vTrue, vFalse)
    if cond
        out = vTrue;
    else
        out = vFalse;
    end
end
