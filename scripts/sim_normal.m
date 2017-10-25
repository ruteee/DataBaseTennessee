%Simulation with no failures or disturbances
% begin setup
run([init_dir,'Mode_1_Init.m']);
% end setup

models = ["MultiLoop_mode1"];

dist = zeros(1,29);
failures = zeros(1, 13);
failures_values= zeros(1, 13);

if isempty(sims)
    sim_id = 1;
else
    sim_id = sims.SIM_ID(end) + 1;
end
    
sizeRep = 1;

for indexModel=1:size(models,2)
    for index=1:sizeRep
        te_seed = index;
        sim(models_dir + models(indexModel));
        csvwrite([data_dir, '/simout_', mat2str(sim_id), '.csv'], [tout simout]);
        
        % Save Current Simulation
        sims = [sims; {sim_id, Ts_base, Ts_save, te_seed, 72}];
        sim_id = sim_id + 1;
    end
end

save_db