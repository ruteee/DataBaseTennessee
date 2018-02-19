function [ thresholds ] = get_sigma_threshold( model, flag )
%GET_MI_SIGMA Summary of this function goes here
%   Detailed explanation goes here
    global PATHS;
    te_set = tennessee_setup(model, ...
                             'sim_start', 0, ...
                             'sim_end', 32, ...
                             'flag', flag);
    out_file_name = [PATHS.threshold, 'sigma_threshold_', model, '_', num2str(te_set.model_set.qty_meas), '.csv'];
    
    if ~exist(out_file_name,'file')
        
        out = run_simulation(te_set);
        
        mi = mean(out.simout);
        sig = std(out.simout);
        low_threshold = mi - 3 * sig;
        high_threshold = mi + 3 * sig;
        
        thresholds = struct();
        for i = 1:length(low_threshold)
            thresholds(i).proc_var = i;
            thresholds(i).limit = low_threshold(i);
            thresholds(i).type = 'LOW';
            thresholds(i).dead_band = NaN;
            thresholds(i).delay_time = NaN;
            
            thresholds(i+1).proc_var = i;
            thresholds(i+1).limit = high_threshold(i);
            thresholds(i+1).type = 'HIGH';
            thresholds(i+1).dead_band = NaN;
            thresholds(i+1).delay_time = NaN;
        end
        
        writetable(struct2table(thresholds), out_file_name);
    else 
        thresholds = table2struct(readtable(out_file_name));
    end
end
