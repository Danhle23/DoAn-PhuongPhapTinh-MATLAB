function s = poly_to_str(coeffs, varName, precision)
% POLY_TO_STR Chuyen vector he so da thuc MATLAB [a_n, a_{n-1}, ..., a_0]
% thanh chuoi da thuc dep mat, de doc (vi du: '2.5*x^3 - 1.2*x + 4')

    if nargin < 2 || isempty(varName), varName = 'x'; end
    if nargin < 3 || isempty(precision), precision = 6; end

    n = numel(coeffs) - 1;
    terms = {};
    fmt = sprintf('%%.%dg', precision);

    for idx = 1:numel(coeffs)
        c = coeffs(idx);
        deg = n - (idx - 1);
        if abs(c) < 1e-11
            continue;
        end

        absC = abs(c);
        cStr = sprintf(fmt, absC);

        if deg == 0
            body = cStr;
        elseif deg == 1
            if abs(absC - 1) < 1e-11
                body = varName;
            else
                body = sprintf('%s*%s', cStr, varName);
            end
        else
            if abs(absC - 1) < 1e-11
                body = sprintf('%s^%d', varName, deg);
            else
                body = sprintf('%s*%s^%d', cStr, varName, deg);
            end
        end

        if isempty(terms)
            if c < 0
                terms{end+1} = ['-' body]; %#ok<AGROW>
            else
                terms{end+1} = body; %#ok<AGROW>
            end
        else
            if c < 0
                terms{end+1} = ['- ' body]; %#ok<AGROW>
            else
                terms{end+1} = ['+ ' body]; %#ok<AGROW>
            end
        end
    end

    if isempty(terms)
        s = '0';
    else
        s = strjoin(terms, ' ');
    end
end
