% Creating Global variables for accessible reference.
global PATHS;
global model_structure_flag;

% Adding paths to workspace for references
PATHS.root      = pwd;

PATHS.functions = [PATHS.root, '/functions/'];
PATHS.init      = [PATHS.root, '/init/'];
PATHS.models    = [PATHS.root, '/models/'];
PATHS.sfunction = [PATHS.root, '/s-function/'];
PATHS.data = [PATHS.root, '/data/'];

% Specification of Revised Model Operation.
model_structure_flag = bi2de([1 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0]);
