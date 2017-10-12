addpath(genpath(pwd));

% TODO checar se o .mex já foi gerado
mex -outdir s-function s-function/temexd_mod.c;