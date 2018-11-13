function process_data_gen( te_set, varargin )
%ALARM_GEN Summary of this function goes here
%   Detailed explanation goes here
%   time_ref: YYYY-MM-DD | YYYY-MM-DD HH:mm:ss
    global PATHS;
    
    p = inputParser;
    addRequired(p, 'te_set');
    addParameter(p, 'time_ref', 'now');
    addParameter(p, 'name', 'proc_data.csv');

    parse(p, te_set, varargin{:});
    
    te_set = p.Results.te_set;
    time_ref = p.Results.time_ref;
    name = p.Results.name;
    
    process = run_simulation(te_set);
    time_out = posixtime(datetime(time_ref) + hours(process.tout));
    
    simout_header = ['TOUT', compose('XMEAS%02d',1:te_set.model_set.qty_meas)];
    proc_table = array2table([time_out process.simout], 'VariableNames', simout_header);
    
    if exist(PATHS.data, 'dir') ~= 7
        mkdir(PATHS.data)
    end
    
    writetable(proc_table, [PATHS.data, name]);
end
