function lines = giai_thich_tung_buoc(domain, res)
% GIAI_THICH_TUNG_BUOC Sinh loi giai tay tung buoc bang tieng Viet de hieu
% giup sinh vien nam ro ban chat toan hoc va tu tin tra loi van dap do an.

    lines = {};
    switch lower(domain)
        case 'root'
            lines{end+1} = sprintf('▶ PHƯƠNG PHÁP: %s', res.method);
            lines{end+1} = sprintf('• Ý tưởng cốt lõi: Thu hẹp dần sai số qua từng bước lặp cho tới khi |sai số| <= cho phép.');
            H = res.history;
            nShow = min(3, size(H, 1));
            for k = 1:nShow
                if ~isempty(strfind(char(res.method), 'Chia'))
                    lines{end+1} = sprintf('  - Bước %d: Chia đôi [%.5g, %.5g] -> trung điểm c = %.6g, f(c) = %.3e, sai số = %.3e', ...
                        H(k,1), H(k,2), H(k,3), H(k,4), H(k,5), H(k,6)); %#ok<AGROW>
                elseif ~isempty(strfind(char(res.method), 'Newton'))
                    lines{end+1} = sprintf('  - Bước %d: Từ x = %.6g, kẻ tiếp tuyến x_mới = x - f(x)/f''(x) = %.6g - (%.3g)/(%.3g) = %.7g', ...
                        H(k,1), H(k,2), H(k,2), H(k,3), H(k,4), H(k,5)); %#ok<AGROW>
                else
                    lines{end+1} = sprintf('  - Bước %d: Thay x_cũ = %.6g -> x_mới = %.7g (sai số = %.3e)', ...
                        H(k,1), H(k,2), H(k,3), H(k,end)); %#ok<AGROW>
                end
            end
            if size(H, 1) > 3
                lines{end+1} = sprintf('  ... (tiếp tục lặp đến bước %d trong bảng bên phải)', size(H, 1));
            end
            lines{end+1} = sprintf('✔ KẾT LUẬN: Nghiệm gần đúng x* = %.10f (thử lại f(x*) = %.2e ≈ 0).', res.root, res.f_root);

        case 'interp'
            lines{end+1} = sprintf('▶ PHƯƠNG PHÁP: %s (Đa thức bậc %d đi qua đúng %d điểm đo)', ...
                res.method, res.degree, numel(res.x));
            lines{end+1} = sprintf('• Đa thức thu gọn duy nhất: P(x) = %s', res.poly_str);
            if isfield(res, 'newton_str')
                lines{end+1} = sprintf('• Dạng tỷ hiệu Newton: P(x) = %s', res.newton_str);
            end
            if ~isempty(res.x0)
                lines{end+1} = sprintf('• Thay x0 = %.6g vào P(x) -> Giá trị nội suy dự đoán P(%.6g) = %.10g.', ...
                    res.x0, res.x0, res.y0);
            end

        case 'reg'
            lines{end+1} = sprintf('▶ MÔ HÌNH HỒI QUY: %s', res.method);
            lines{end+1} = '• Khác với Nội suy (ép đường cong đi qua mọi điểm nhiễu), Hồi quy tìm đường xu hướng mượt nhất sao cho tổng bình phương sai lệch là nhỏ nhất.';
            lines{end+1} = sprintf('• Phương trình tìm được: %s (hệ số a = %.6g, b = %.6g)', res.eq_str, res.a, res.b);
            lines{end+1} = sprintf('• Độ chính xác R^2 = %.5f (giải thích %.2f%% sự biến thiên của dữ liệu đo) | RMSE = %.5g', ...
                res.r2, res.r2 * 100, res.rmse);
            if ~isempty(res.x_pred)
                lines{end+1} = sprintf('✔ DỰ ĐOÁN: Tại x = %.6g -> y_dự_đoán = %.10g.', res.x_pred, res.y_pred);
            end

        case 'diff'
            lines{end+1} = sprintf('▶ PHƯƠNG PHÁP ĐẠO HÀM: %s', res.method);
            lines{end+1} = '• Ý nghĩa vật lý: Đạo hàm f''(x0) chính là tốc độ biến thiên tức thời (hệ số góc đường tiếp tuyến màu đỏ trên đồ thị).';
            lines{end+1} = sprintf('• Công thức sai phân áp dụng: %s', res.formula);
            if ~isnan(res.df_ref)
                lines{end+1} = sprintf('✔ KẾT QUẢ: f''(%.4g) = %.10f | Đạo hàm chuẩn = %.10f | Sai số cắt cụt = %.3e.', ...
                    res.x0, res.df, res.df_ref, res.abs_err);
            else
                lines{end+1} = sprintf('✔ KẾT QUẢ TỪ BẢNG ĐO: f''(%.4g) = %.10f (bước lưới h ≈ %.4g).', res.x0, res.df, res.h);
            end

        case 'int'
            lines{end+1} = sprintf('▶ PHƯƠNG PHÁP TÍCH PHÂN: %s (Chia miền thành N = %d khoảng, bước h = %.5g)', ...
                res.method, res.N, res.h);
            lines{end+1} = '• Ý nghĩa hình học: Tích phân chính là tổng diện tích có hướng của các dải màu xanh dưới đường cong f(x).';
            lines{end+1} = sprintf('• Công thức: %s', res.formula);
            if ~isnan(res.I_exact)
                lines{end+1} = sprintf('✔ KẾT QUẢ: I_xấp_xỉ = %.10f | I_chính_xác = %.10f | Sai số = %.3e.', ...
                    res.I, res.I_exact, res.abs_err);
            else
                lines{end+1} = sprintf('✔ KẾT QUẢ TỪ DỮ LIỆU ĐO: Diện tích / Tích phân I = %.10f.', res.I);
            end
    end
end
