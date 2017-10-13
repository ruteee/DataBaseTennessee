%Disturbances or failures start and end in a specifc instant

% begin setup
run([init_dir,'Mode_1_Init.m']);


%run('Mode_3_Init.m')
% end setup

models=["MultiLoop_mode1"];
save_path_base = [database_dir, '/data/simulations/sim_config_2/'];
mkdir(save_path_base);

%disturbances
sizeRep = 1;
startTime = 2;
endTime = 48;
failures = zeros(1,13);
failures_values= zeros(1, 13);
dist_active = [1 zeros(1,27)];

% Simulation ID
if isempty(sims)
    sim_id = 1;
else
    sim_id = sims(end, 1);
end

for indexModel=1:size(models,2)
    disp("Init simulation")
    for dist_index = 1:size(dist_active,2)
        dist_path_folder = strcat(save_path_base,'dist', int2str(dist_index),'/');
        mkdir(dist_path_folder);
        disp(strcat('Dist: ', int2str(dist_index)));
        dist = [0 zeros(1,28); [startTime dist_active]; [endTime zeros(1,28)]];
        for index=1:sizeRep
            te_seed = index;
            sim_path = strcat('sim_', int2str(index));
            disp(sim_path);
            sim(models_dir + models(indexModel));
            mkdir(strcat(dist_path_folder,sim_path));
            csvwrite(strcat(dist_path_folder, sim_path,'/simout_tbase_', mat2str(Ts_base), '.csv'), simout);
            csvwrite(strcat(dist_path_folder, sim_path,'/tout','.csv'), tout);
            
            % Save Current Simulation
            sims = [sims; sim_id, Ts_base, te_seed, 72];
            sim_dists = [sim_dists; sim_id, dist_index, startTime, endTime];
            save([database_dir, 'reg_db.mat'], "sims", "dists", "fails", "sim_dists", "sim_fails");
            sim_id = sim_id + 1;
        end
        dist_active = circshift(dist_active,1);
    end
    disp("end simulation");
end

%failures
dist = zeros(1,29);

sizeFailRep = 1;
startTimeFail = 10;
endTimeFail = 11;
type_fail = [0,25,50,75,100];
failures_active = [1 zeros(1,11)];

indexModels=0;

for indexModels=1:size(models,2)
    disp("Init simulation");
    for index_fail = 1:size(failures_active, 2)
        failures = [0 zeros(1,12);[startTimeFail failures_active]; [endTimeFail zeros(1,12)]];
        fail_path_folder = strcat(save_path_base,'failure_', int2str(index_fail),'/');
        mkdir(fail_path_folder);
        disp(strcat('Fail: ', int2str(index_fail)));
        for index_type_fail =1:size(type_fail,2)
            fail_val= type_fail(index_type_fail);
            failures_values = [startTimeFail fail_val zeros(1,11)];
            disp(strcat('Fail Type: ', int2str(fail_val)));
            for index_fail_rep=1:sizeFailRep
                te_seed = index_fail_rep;
                sim_path = strcat('/fail_type_', int2str(fail_val),'/sim_', int2str(index_fail_rep));
                mkdir(strcat(fail_path_folder,sim_path));
                disp(strcat('sim_', int2str(index_fail_rep)));
                sim(models_dir + models(indexModel));
                csvwrite(strcat(fail_path_folder,sim_path, '/simout_tbase_', mat2str(Ts_base), '.csv'), simout);
                csvwrite(strcat(fail_path_folder, sim_path,'/tout','.csv'), tout);
                
                % Save Current Simulation
                sims = [sims; sim_id, Ts_base, te_seed, 72];
                sim_fails = [sim_fails; sim_id, index_fail, fail_val, startTimeFail, endTimeFail];
                save([database_dir, 'reg_db.mat'], "sims", "dists", "fails", "sim_dists", "sim_fails");
                sim_id = sim_id + 1;
            end
        end
        failures_values = circshift(failures_values,1);
        failures_active = circshift(failures_active,1);
    end
    disp("end simulation");
end