addpath(genpath(pwd));

% TODO checar se o .mex já foi gerado
mex -outdir s-function s-function/temexd_mod.c;

root_dir = pwd;
models_dir    = [root_dir, '/models/'];
scripts_dir   = [root_dir, '/scripts/'];
sfunction_dir = [root_dir, '/s-function/'];
init_dir      = [root_dir, '/init/'];
database_dir  = [root_dir, '/database/'];