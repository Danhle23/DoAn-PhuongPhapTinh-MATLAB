% CI_OCTAVE_VERIFY Bo kiem thu tu dong tren GitHub Actions (tuong thich ca MATLAB & GNU Octave)
projDir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(projDir, 'algorithms'));

fprintf('=== CHAY KIEM THU TU DONG CI CHO 16 MODULE PHUONG PHAP TINH ===\n');

% 1. Tim nghiem
r1 = pp_chiadoi('x^3 - 2*x - 5', 2, 3, 1e-7);
assert(abs(r1.root - 2.0945514815) < 1e-5);

r2 = pp_lap('x^3 - 2*x - 5', 2, 3, 1e-7, 1000, '(2*x + 5)^(1/3)');
assert(abs(r2.root - 2.0945514815) < 1e-5);

r3 = pp_newton('x^3 - 2*x - 5', 2, 3, 1e-9);
assert(abs(r3.root - 2.0945514815) < 1e-8);

r4 = pp_daycung('x^3 - 2*x - 5', 2, 3, 1e-8);
assert(abs(r4.root - 2.0945514815) < 1e-7);

% 2. Noi suy
nsN = noisuy_newton([0, 1, 2, 4], [2, 3, 10, 66], 2.5);
nsL = noisuy_lagrange([0, 1, 2, 4], [2, 3, 10, 66], 2.5);
assert(abs(nsN.y0 - 17.625) < 1e-9 && abs(nsL.y0 - 17.625) < 1e-9);

% 3. Hoi quy
xr = [1, 2, 3, 4, 5];
hq1 = hoiquy_tuyentinh(xr, 3*xr + 2, 6);
hq2 = hoiquy_hammu(xr, 2.5*(xr.^2), 6);
hq3 = hoiquy_mue(xr, 3*exp(0.5*xr), 6);
hq4 = hoiquy_logarit([1, 2, 4, 8], 5 + 2*log([1, 2, 4, 8]), exp(2));
assert(abs(hq1.y_pred - 20) < 1e-9 && abs(hq2.y_pred - 90) < 1e-8);
assert(abs(hq3.a - 3) < 1e-8 && abs(hq4.y_pred - 9) < 1e-8);

% 4. Dao ham
xd = 0:0.1:1;
yd = xd.^2;
dhF = daoham_tien('data', xd, yd, 0.5, 'O(h^2)');
dhB = daoham_lui('data', xd, yd, 0.5, 'O(h^2)');
dhC = daoham_trungtam('func', 'sin(x) + x^2', 0.001, 1.0, 'O(h^2)');
assert(abs(dhF.df - 1.0) < 1e-9 && abs(dhB.df - 1.0) < 1e-9);
assert(abs(dhC.df - (cos(1.0) + 2.0)) < 1e-6);

% 5. Tich phan
tp1 = tichphan_hinhthang('data', [0, 0.5, 1.0], [1, 2, 3]);
assert(abs(tp1.I - 2.0) < 1e-10);

fprintf('[CI SUCCESS] Toan bo giai thuat Phuong Phap Tinh vuot qua 100%% bai test!\n');
