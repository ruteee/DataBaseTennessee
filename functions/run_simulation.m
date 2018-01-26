function [ sim_out ] = run_simulation( te_set )
%RUN_SIMULATION Summary of this function goes here
%   Detailed explanation goes here
    model = te_set.model_set.model;
    in = Simulink.SimulationInput(model);
    
    sfunc_param = sprintf('[],%d,%d', te_set.model_set.seed, ...
                                      te_set.model_set.flag);
    in = load_init(model, in);

    in = in.setModelParameter('StartTime', num2str(te_set.model_set.start), ...
                              'StopTime', num2str(te_set.model_set.end));

    in = in.setBlockParameter([model, '/TE Plant/TE Code'], "Parameters", sfunc_param);
    
    Ts_base = in.Variables(strcmp({in.Variables.Name}, 'Ts_base')).Value;
    ts = (te_set.model_set.start:Ts_base:te_set.model_set.end)';
    dist_input = dist_gen(ts, te_set.dist_set);

    ds = Simulink.SimulationData.Dataset;
    ds = ds.addElement(dist_input, 'MultiLoop_mode1/TE Plant/Disturbances');
    in = in.setExternalInput(ds);
    sim_out = sim(in);
end
