function vec = parse_num_vector(strInput, fieldName)
% PARSE_NUM_VECTOR Chuyen chuoi so (vi du: '1, 2, 3', '[0 0.5 1]', '0:0.2:1', 'linspace(0,pi,5)')
% thanh vector hang double an toan.

    if nargin < 2, fieldName = 'Du lieu'; end
    if isnumeric(strInput)
        vec = double(strInput(:)');
        return;
    end

    s = strtrim(char(strInput));
    if isempty(s)
        error('%s khong duoc de trong!', fieldName);
    end

    % Thay dau cham phay thanh khoang trang de luon tao vector 1 chieu
    s_norm = strrep(s, ';', ' ');
    vec = str2num(s_norm); %#ok<ST2NM> (cho phep pi, exp(1), 0:0.5:2, linspace...)
    if isempty(vec) || ~isnumeric(vec) || any(~isfinite(vec(:)))
        error('%s "%s" khong hop le! Vi du hop le: 1, 2, 3, 4 hoac 0:0.5:2', fieldName, s);
    end
    vec = double(vec(:)');
end
