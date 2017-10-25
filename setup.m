addpath(genpath(pwd));

root_dir      = pwd;
database_dir  = [root_dir, '/database/'];
init_dir      = [root_dir, '/init/'];
models_dir    = [root_dir, '/models/'];
scripts_dir   = [root_dir, '/scripts/'];
sfunction_dir = [root_dir, '/s-function/'];
data_dir      = [database_dir, 'data/'];

% Gerar .mex para execução de simulação
if exist([sfunction_dir, 'temexd_mod'], 'file') ~= 3
    mex -outdir s-function s-function/temexd_mod.c;
end

% Load db registry
% TODO load from CSV files
if exist([database_dir, 'sims.csv'], 'file')
    sims = readtable([database_dir, 'sims.csv']);
else
    sims = cell2table(cell(0, 5), 'VariableNames', {'SIM_ID', 'TS_BASE', 'TS_SAVE', 'TE_SEED', 'DURATION'});
end

if exist([database_dir, 'dists.csv'], 'file')
    dists = readtable([database_dir, 'dists.csv']);
else
    define_dists
end

if exist([database_dir, 'fails.csv'], 'file')
    fails = readtable([database_dir, 'fails.csv']);
else
    define_fails
end

if exist([database_dir, 'sim_dists.csv'], 'file')
    sim_dists = readtable([database_dir, 'sim_dists.csv']);
else
    sim_dists = cell2table(cell(0, 4), 'VariableNames', {'SIM_ID', 'DIST_ID', 'START_TIME', 'END_TIME'});
end

if exist([database_dir, 'sim_fails.csv'], 'file')
    sim_fails = readtable([database_dir, 'sim_fails.csv']);
else
    sim_fails = cell2table(cell(0, 5), 'VariableNames', {'SIM_ID', 'FAIL_ID', 'VAL', 'START_TIME', 'END_TIME'});
end

% writetable(sims,      [database_dir, 'sims.csv']);
writetable(dists,     [database_dir, 'dists.csv']);
writetable(fails,     [database_dir, 'fails.csv']);
% writetable(sim_dists, [database_dir, 'sim_dists.csv']);
% writetable(sim_fails, [database_dir, 'sim_fails.csv']);