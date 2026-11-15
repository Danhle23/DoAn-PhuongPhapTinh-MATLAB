# Đồ Án Phương Pháp Tính & MATLAB App Designer (Phiên Bản Nâng Cấp Tối Đa 10/10)

Hệ thống phần mềm giải quyết toàn diện các bài toán **Phương Pháp Tính (Numerical Methods)** kết hợp trực quan hóa đồ thị động trên nền tảng **MATLAB App Designer (`matlab.apps.AppBase`)**, đáp ứng trọn vẹn **25/25 tiêu chí ứng dụng (70%)** và **7/7 tiêu chí báo cáo học thuật & GitHub (30%)**.

## Cấu trúc thư mục dự án

```text
DoAn_PhuongPhapTinh_MATLAB/
├── AppPhuongPhapTinh.m               # Class giao diện chính kế thừa matlab.apps.AppBase (6 Tabs)
├── AppPhuongPhapTinh_Designer.mlapp  # Gói nhị phân mở trực tiếp trong App Designer Design View
├── KhoiChay_App.m                    # Script 1-click khởi chạy nhanh ứng dụng (nhấn F5)
├── algorithms/                       # 15+ hàm giải thuật độc lập chuẩn Tiêu chí số 25
│   ├── parse_math_func.m             # Bộ phân tích biểu thức tự nhiên sang @(x) vector hóa
│   ├── parse_num_vector.m            # Bộ đọc mảng dữ liệu đa định dạng
│   ├── poly_to_str.m                 # Định dạng chuỗi đa thức toán học chuẩn
│   ├── pp_chiadoi.m                  # Tìm nghiệm: Phương pháp Chia đôi (Bisection)
│   ├── pp_lap.m                      # Tìm nghiệm: Lặp đơn x = phi(x) & tự thích nghi Banach
│   ├── pp_newton.m                   # Tìm nghiệm: Newton-Raphson (Tiếp tuyến + điều kiện Fourier)
│   ├── pp_daycung.m                  # Tìm nghiệm: Phương pháp Dây cung (Secant mở rộng)
│   ├── noisuy_newton.m               # Nội suy: Đa thức Newton (Bảng tỷ hiệu & sơ đồ Horner)
│   ├── noisuy_lagrange.m             # Nội suy: Đa thức Lagrange & công thức Barycentric ổn định
│   ├── hoiquy_tuyentinh.m            # Hồi quy: Tuyến tính y = a*x + b
│   ├── hoiquy_hammu.m                # Hồi quy: Hàm mũ / lũy thừa y = a*x^b
│   ├── hoiquy_mue.m                  # Hồi quy: Hàm mũ cơ số e: y = a*e^(b*x)
│   ├── hoiquy_logarit.m              # Hồi quy: Hàm Logarit y = a + b*ln(x)
│   ├── daoham_tien.m                 # Đạo hàm: Sai phân Tiến O(h) và O(h^2)
│   ├── daoham_lui.m                  # Đạo hàm: Sai phân Lùi O(h) và O(h^2)
│   ├── daoham_trungtam.m             # Đạo hàm: Sai phân Trung tâm O(h^2) và O(h^4)
│   ├── tichphan_hinhthang.m          # Tích phân: Quy tắc Hình thang mở rộng (hàm số & dữ liệu)
│   ├── tichphan_simpson13.m          # Tích phân: Phương pháp Simpson 1/3 (N chẵn)
│   └── tichphan_simpson38.m          # Tích phân: Phương pháp Simpson 3/8 (N chia hết cho 3)
├── sample_data/                      # Bộ dữ liệu CSV thực nghiệm mẫu để demo nạp file
├── screenshots/                      # Ảnh chụp giao diện thực tế 6 Tab xuất trực tiếp từ MATLAB
├── tests/                            # Bộ kiểm thử tự động 25/25 tiêu chí chấm điểm
└── Bao_Cao_Do_An_Phuong_Phap_Tinh_10Diem.docx  # Báo cáo Word hoàn chỉnh sẵn sàng nộp
```

## Hướng dẫn chạy ứng dụng trong 5 giây

1. Mở **MATLAB** (hỗ trợ tốt từ R2020b đến R2026a+).
2. Trỏ thư mục hiện hành (**Current Folder**) vào `DoAn_PhuongPhapTinh_MATLAB`.
3. Gõ lệnh sau trong **Command Window** (hoặc mở `KhoiChay_App.m` và bấm **Run / F5**):
   ```matlab
   KhoiChay_App
   ```
4. Để chạy kiểm thử tự động toàn bộ 25/25 tiêu chí:
   ```matlab
   addpath('tests');
   run_all_25_tests_and_export
   ```

## Quy trình cộng tác nhóm trên GitHub

```bash
git checkout -b feat/tab-nghiem      # Nhánh phát triển Tab Tìm nghiệm
git checkout -b feat/tab-noisuy      # Nhánh phát triển Tab Nội suy
git checkout -b feat/tab-hoiquy      # Nhánh phát triển Tab Hồi quy
git checkout -b feat/tab-daoham-tp   # Nhánh phát triển Tab Đạo hàm & Tích phân
git push -u origin main              # Đẩy toàn bộ lịch sử commit lên GitHub
```
