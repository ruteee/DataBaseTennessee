%Simulation with no failures or disturbances
% begin setup
run('Mode_1_Init.m')
%run('Mode_3_Init.m')
% end setup

model='MultiLoop_mode1';

dist = zeros(1,29);
failures = zeros(1, 13);
failures_values= zeros(1, 13);

numRep = 10;
save_path_base = 'sim_test/sim_norm/';
mkdir(save_path_base);
for index=1:numRep
    sim_path = strcat('sim_', int2str(index));
    sim(model);
    mkdir(strcat(save_path_base,sim_path));
    csvwrite(strcat(save_path_base, sim_path,'/simout_tbase_', mat2str(Ts_base), '.csv'), simout);
    csvwrite(strcat(save_path_base, sim_path,'/tout','.csv'), tout);
end