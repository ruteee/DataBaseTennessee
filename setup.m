addpath(genpath(pwd));

% constants

% Gerar .mex para execução de simulação
% 3: File is a MEX-file
if exist([sfunction_dir, 'temexd_mod'], 'file') ~= 3
    mex -outdir s-function s-function/temexd_mod.c;
end