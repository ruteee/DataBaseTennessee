function [ setup ] = tennessee_setup( model, varargin )
%TENNESSEE_SETUP Summary of this function goes here
%   Detailed explanation goes here

    p = inputParser;
    addRequired(p, 'model');
    addParameter(p, 'sim_start', 0);
    addParameter(p, 'sim_end', 58);
    addParameter(p, 'seed', 1);
    addParameter(p, 'flag', 129);
    addParameter(p, 'dist_id', -1);
    addParameter(p, 'dist_start', -1);
    addParameter(p, 'dist_end', -1);
    
    parse(p, model, varargin{:});
    
    setup.model_set.model = p.Results.model;
    setup.model_set.start = p.Results.sim_start;
    setup.model_set.end = p.Results.sim_end;
    setup.model_set.seed = p.Results.seed;
    setup.model_set.flag = p.Results.flag;
    setup.dist_set.id = p.Results.dist_id;
    setup.dist_set.start = p.Results.dist_start;
    setup.dist_set.end = p.Results.dist_end;
    
end

