function [ data ] = alarm_gen( out_mode, save_process, te_set, threshold_method, threshold )
%ALARM_GEN Summary of this function goes here
%   Detailed explanation goes here

    if ~exist("threshold", "var")
        switch threshold_method
            case "3SIG"
                [low_threshold, high_threshold] = get_sigma_threshold(te_set.model_set.model, ...
                                                              te_set.model_set.flag);
            case "CORR"
                [low_threshold, high_threshold] = get_corr_threshold(te_set.model_set.model, ...
                                                                     te_set.model_set.flag);
            case "FAP-MAP"
                [low_threshold, high_threshold] = get_fap_map_threshold(te_set.model_set.model, ...
                                                                        te_set.model_set.flag);
        end
    else
        low_threshold = threshold(1, :);
        high_threshold = threshold(2, :);
    end
    
    process = run_simulation(te_set);
    
    [low_seq, high_seq] = apply_threshold(process.simout, low_threshold, high_threshold);
    
    switch out_mode
        case "LOG"
            low.state = [low_seq(1,:), ;diff(low_seq)];
            high.state = [high_seq(1,:), ;diff(high_seq)];

            [low.time, low.var] = find(low.state);
            [high.time, high.var] = find(high.state);

            low.state = low.state(low.time + (low.var-1) * size(low.state, 1));
            high.state = high.state(high.time + (high.var - 1) * size(high.state, 1));

            low.time = process.tout(low.time);
            high.time = process.tout(high.time);
            
            alarm_table = table;
            alarm_table.TIME = [low.time; high.time];
            alarm_table.TAG = get_tag([low.var; high.var]);
            alarm_table.TAG_DESC = get_tag_desc([low.var; high.var]);
            alarm_table.ALARM = get_alarm(low.var, high.var);
            alarm_table.ALARM_DESC = get_alarm_desc(low.var, high.var);
            alarm_table.STATE = get_state([low.state; high.state]);
            alarm_table = sortrows(alarm_table, 'TIME');
            alarm_table.TIME = string(datetime('now', 'Format', 'd-MM-y HH:mm:ss.ms') ...
                               + hours(alarm_table.TIME));
            data.log = alarm_table;
        case "ALM_SEQ"
            alarm_seq_header = ['tout', compose('xmeas%02d_low',1:te_set.model_set.qty_meas), compose('xmeas%02d_high',1:te_set.model_set.qty_meas)];
            data.alm_seq = array2table([process.tout low_seq high_seq], 'VariableNames', alarm_seq_header);
    end
    
    if save_process
        simout_header = ['tout', compose('xmeas%02d',1:te_set.model_set.qty_meas)];
        data.process = array2table([process.tout process.simout], 'VariableNames', simout_header);
    end
    
end
