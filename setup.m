addpath(genpath(pwd));

root_dir      = pwd;
database_dir  = [root_dir, '/database/'];
init_dir      = [root_dir, '/init/'];
models_dir    = [root_dir, '/models/'];
scripts_dir   = [root_dir, '/scripts/'];
sfunction_dir = [root_dir, '/s-function/'];

% Gerar .mex para execução de simulação
if exist([sfunction_dir, 'temexd_mod'], 'file') ~= 3
    mex -outdir s-function s-function/temexd_mod.c;
end

% Load db registry
% TODO load from CSV files
if exist('reg_db.mat', 'file')
    load('reg_db.mat');
end

if ~ exist('sims', 'var')
    sims = [];
end

if ~ exist('dists', 'var')
    define_dists
end

if ~ exist('fails', 'var')
    define_fails
end

if ~ exist('sim_dists', 'var')
    sim_dists = [];
end

if ~ exist('sim_fails', 'var')
    sim_fails = [];
end

save([database_dir, 'reg_db.mat'], sims, dists, fails, sim_dists, sim_fails);