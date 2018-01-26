function [ alarm_table ] = sigma3( te_set )
%SIGMA3 Summary of this function goes here
%   Detailed explanation goes here

    [low_threshold, high_threshold] = get_sigma_threshold(te_set.model_set.model, ...
                                                          te_set.model_set.flag);
                    
    process = run_simulation(te_set);
    
    [low, high] = apply_threshold(process, low_threshold, high_threshold);
    
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
end
