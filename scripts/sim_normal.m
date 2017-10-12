%Simulation with no failures or disturbances
% begin setup
run([init_dir,'Mode_1_Init.m']);

%run('Mode_3_Init.m')
% end setup

models=["MultiLoop_mode1"];
save_path_base = [database_dir, '/data/simulations/sim_norm/'];
mkdir(save_path_base);

dist = zeros(1,29);
failures = zeros(1, 13);
failures_values= zeros(1, 13);
sizeRep = 1;

for indexModel=1:size(models,2)
    for index=1:sizeRep
        sim_path = strcat('sim_', int2str(index));
        disp(sim_path);
        sim(models_dir + models(indexModel));
        mkdir(strcat(save_path_base,sim_path));
        csvwrite(strcat(save_path_base, sim_path,'/simout_tbase_', mat2str(Ts_base), '.csv'), simout);
        csvwrite(strcat(save_path_base, sim_path,'/tout','.csv'), tout);
    end
end