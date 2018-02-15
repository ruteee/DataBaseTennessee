function [ low_threshold, high_threshold ] = get_fap_map_threshold( model, flag )
%GET_FAP_MAP_THRESHOLD Summary of this function goes here
%   Detailed explanation goes here

    if ~exist('fap_map_threshold.mat','file')
        te_set = tennessee_setup(model, ...
                                 'sim_start', 0, ...
                                 'sim_end', 1000, ...
                                 'flag', flag);
        out = run_simulation(te_set);
        
        
        low_threshold = -inf;
        high_threshold = +inf;
        save('fap_map_threshold.mat', 'low_threshold', 'high_threshold');
    else 
        load('fap_map_threshold');
    end
end

