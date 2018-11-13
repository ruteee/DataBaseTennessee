addpath(genpath(pwd));

constants

% Generate .mex for Simulink.
% Value '3' specifies a file is a MEX-file
if exist([PATHS.sfunction, 'temexd_mod'], 'file') ~= 3
    mex -outdir s-function s-function/temexd_mod.c;
end