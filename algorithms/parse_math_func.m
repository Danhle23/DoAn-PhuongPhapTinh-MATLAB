function [fh, exprClean] = parse_math_func(exprStr)
% PARSE_MATH_FUNC Chuyen chuoi bieu thuc toan hoc sang function handle @(x)
% Ho tro nhap tu nhien: 'x^3 - 2x - 5', 'e^(-x) - x', 'ln(x)', 'sin(x)*cos(x)'
%
% Dau vao:
%   exprStr   - Chuoi bieu thuc (char hoac string), vi du: 'x^3 - 2*x - 5 = 0'
% Dau ra:
%   fh        - Function handle vector hoa @(x) ...
%   exprClean - Chuoi bieu thuc MATLAB da chuan hoa vector hoa

    if isa(exprStr, 'function_handle')
        fh = exprStr;
        exprClean = func2str(exprStr);
        return;
    end

    s = strtrim(char(exprStr));
    if isempty(s)
        error('Bieu thuc ham so khong duoc de trong.');
    end

    % Neu nguoi dung nhap phuong trinh dang "VT = VP", chuyen thanh "(VT) - (VP)"
    eqIdx = strfind(s, '=');
    if numel(eqIdx) == 1 && isempty(strfind(s, '<=')) && isempty(strfind(s, '>=')) && isempty(strfind(s, '==')) && isempty(strfind(s, '~='))
        lhs = strtrim(s(1:eqIdx-1));
        rhs = strtrim(s(eqIdx+1:end));
        if strcmp(rhs, '0')
            s = lhs;
        else
            s = sprintf('(%s) - (%s)', lhs, rhs);
        end
    end

    % Bo tien to @(x) neu nguoi dung nhap san
    s = regexprep(s, '^@\(\s*x\s*\)\s*', '');

    % Chuan hoa ln(x) -> log(x), lg(x) -> log10(x)
    s = regexprep(s, '\<ln\s*\(', 'log(');
    s = regexprep(s, '\<lg\s*\(', 'log10(');

    % Chuan hoa e^(...) -> exp(...) va hang so e doc lap -> exp(1)
    s = regexprep(s, '\<e\s*\.\^\s*', 'exp');
    s = regexprep(s, '\<e\s*\^\s*\(', 'exp(');
    s = regexprep(s, '\<e\s*\^\s*([+-]?[0-9a-zA-Z_\.]+)', 'exp($1)');
    s = regexprep(s, '\<e\>', 'exp(1)');

    % Ho tro phep nhan an: 2x -> 2*x, )x -> )*x, x( -> x*(, 2( -> 2*(
    s = regexprep(s, '(\d)\s*(x\>)', '$1*$2');
    s = regexprep(s, '(\d)\s*\(', '$1*(');
    s = regexprep(s, '\)\s*(x\>|\d|\()', ')*$1');
    s = regexprep(s, '\<x\s*\(', 'x*(');

    % Vector hoa phep toan *, /, ^ thanh .*, ./, .^ (tranh nhan doi neu da co dau cham)
    s = regexprep(s, '(?<!\.)\^', '.^');
    s = regexprep(s, '(?<!\.)\*', '.*');
    s = regexprep(s, '(?<!\.)/', './');

    exprClean = s;
    try
        fh = str2func(['@(x) ' s]);
        % Kiem tra thu tai mot vai diem de bat loi cu phap som
        testVal = fh([1.1, 2.3]); %#ok<NASGU>
    catch ME
        error('Khong the phan tich bieu thuc "%s". Chi tiet: %s', char(exprStr), ME.message);
    end
end
