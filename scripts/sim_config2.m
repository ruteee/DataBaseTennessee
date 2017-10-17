%Disturbances or failures start and end in a specifc instant

% begin setup
run([init_dir,'Mode_1_Init.m']);
% end setup

models=["MultiLoop_mode1"];

%disturbances
sizeRep = 10;
startTimeDist = 2;
endTimeDist = 48;
failures = zeros(1,13);
failures_values= zeros(1, 13);
failures_values_active = zeros(1,12);
dist_active = [1 zeros(1,27)];

% Simulation ID
if isempty(sims)
    sim_id = 1;
else
    sim_id = sims(end, 1) + 1;
end

for indexModel=1:size(models,2)
    disp("Init simulation")
    for dist_index = 1:size(dist_active,2)
        disp(strcat('Dist: ', int2str(dist_index)));
        dist = [0 zeros(1,28); [startTimeDist dist_active]; [endTimeDist zeros(1,28)]];
        for index=1:sizeRep
            te_seed = index;
            sim(models_dir + models(indexModel));
            csvwrite([data_dir, '/simout_', mat2str(sim_id), '.csv'], [tout' simout]);
            
            % Save Current Simulation
            sims = [sims; sim_id, Ts_base, Ts_save te_seed, 72];
            sim_dists = [sim_dists; sim_id, dist_index, startTimeDist, endTimeDist];
            save([database_dir, 'reg_db.mat'], "sims", "dists", "fails", "sim_dists", "sim_fails");
            sim_id = sim_id + 1;
        end
        dist_active = circshift(dist_active,1);
    end
    disp("end simulation");
end

%failures
dist = zeros(1,29);

sizeFailRep = 10;
startTimeFail = 10;
endTimeFail = 11;
type_fail = [0,25,50,75,100];
failures_active = [1 zeros(1,11)];

indexModels=0;

for indexModels=1:size(models,2)
    disp("Init simulation");
    for index_fail = 1:size(failures_active, 2)
        failures = [0 zeros(1,12);[startTimeFail failures_active]; [endTimeFail zeros(1,12)]];
        disp(strcat('Fail: ', int2str(index_fail)));
        for index_type_fail =1:size(type_fail,2)
            fail_val = type_fail(index_type_fail);
            failures_values_active(index_fail) = fail_val;
            failures_values = [startTimeFail failures_values_active];
            disp(strcat('Fail Type: ', int2str(fail_val)));
            for index_fail_rep=1:sizeFailRep
                te_seed = index_fail_rep;
                disp(strcat('sim_', int2str(index_fail_rep)));
                sim(models_dir + models(indexModel));
                csvwrite([data_dir, '/simout_', mat2str(sim_id), '.csv'], [tout' simout]);
                
                % Save Current Simulation
                sims = [sims; sim_id, Ts_base, Ts_save, te_seed, 72];
                sim_fails = [sim_fails; sim_id, index_fail, fail_val, startTimeFail, endTimeFail];
                save([database_dir, 'reg_db.mat'], "sims", "dists", "fails", "sim_dists", "sim_fails");
                sim_id = sim_id + 1;
            end
        end
        failures_values_active(index_fail) = 0;
        failures_active = circshift(failures_active,1);
    end
    disp("end simulation");
end