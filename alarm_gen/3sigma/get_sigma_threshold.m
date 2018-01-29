function [ low_threshold, high_threshold ] = get_sigma_threshold( model, flag )
%GET_MI_SIGMA Summary of this function goes here
%   Detailed explanation goes here
    if ~exist('sigma_threshold.mat','file')
        te_set = tennessee_setup(model, ...
                                 'sim_start', 0, ...
                                 'sim_end', 32, ...
                                 'flag', flag);
        out = run_simulation(te_set);
        
        mi = mean(out.simout);
        sig = std(out.simout);
        low_threshold = mi - 3 * sig;
        high_threshold = mi + 3 * sig;
        save('sigma_threshold.mat', 'low_threshold', 'high_threshold');
    else 
        load('sigma_threshold');
    end
end
