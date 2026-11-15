%% KHOICHAY_APP Script khoi dong nhanh Ung dung Phuong Phap Tinh & MATLAB
% Chi can nhan Run (F5) tren file nay hoac go `AppPhuongPhapTinh` trong Command Window!

clc;
rootDir = fileparts(mfilename('fullpath'));
addpath(rootDir);
addpath(fullfile(rootDir, 'algorithms'));

fprintf('Dang khoi dong Studio Phuong Phap Tinh & MATLAB...\n');
app = AppPhuongPhapTinh();
