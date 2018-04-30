global PATHS;
global model_structure_flag;

PATHS.root      = pwd;
PATHS.alarm_gen = [PATHS.root, '/alarm_gen/'];
PATHS.threshold = [PATHS.root, '/threshold data/'];
PATHS.functions = [PATHS.root, '/functions/'];
PATHS.init      = [PATHS.root, '/init/'];
PATHS.models    = [PATHS.root, '/models/'];
PATHS.scripts   = [PATHS.root, '/scripts/'];
PATHS.sfunction = [PATHS.root, '/s-function/'];
PATHS.proc_data = [PATHS.root, '/process_data/'];

model_structure_flag = bi2de([1 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0]);
