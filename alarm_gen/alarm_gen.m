function [ data ] = alarm_gen( out_mode, save_process, te_set, threshold_method, process_data )
%ALARM_GEN Summary of this function goes here
%   Detailed explanation goes here

    if ~exist("threshold", "var")
        switch threshold_method
            case "3SIG"
                thresholds = get_sigma_threshold(te_set.model_set.model, ...
                                                              te_set.model_set.flag);
            case "CORR"
                thresholds = get_correlation_threshold(te_set.model_set.model, ...
                                                                     te_set.model_set.flag);
            case "FAP-MAP"
                thresholds = get_fap_map_threshold(te_set.model_set.model, ...
                                                                        te_set.model_set.flag);
        end
    end
    
    if exist("process_data", "var")
        process = process_data;
    else
        process = run_simulation(te_set);
    end
    
    alm_seq = apply_threshold(process.simout, thresholds);
    
    switch out_mode
        case "LOG"
            alm_state = [alm_seq(1,:), ;diff(alm_seq)];

            [alm_time, i_alm_var, alm_state] = find(alm_state);

            alm_time = process.tout(alm_time);
            alm_var = [thresholds(i_alm_var).proc_var]';
            
            alarm_table = table;
            alarm_table.TIME = alm_time;
            alarm_table.TAG = get_tag(alm_var);
            alarm_table.TAG_DESC = get_tag_desc(alm_var);
            alarm_table.ALARM = [thresholds(i_alm_var).type]';
            alarm_table.ALARM_DESC = [thresholds(i_alm_var).type]';
            alarm_table.STATE = get_state(alm_state);
            alarm_table = sortrows(alarm_table, 'TIME');
            alarm_table.TIME = string(datetime('now', 'Format', 'd-MM-y HH:mm:ss.ms') ...
                               + hours(alarm_table.TIME));
            data.log = alarm_table;
        case "ALM_SEQ"
            data.alm_seq = alm_seq;
    end
    
    if save_process
        simout_header = ['tout', compose('xmeas%02d',1:te_set.model_set.qty_meas)];
        data.process = array2table([process.tout process.simout], 'VariableNames', simout_header);
    end
    
end
