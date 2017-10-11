
% Disturbances and failures begin at the start_hour

% begin setup
run('Mode_1_Init.m')
%run('Mode_3_Init.m')
% end setup

model = 'MultiLoop_mode1';
save_path_base = 'sim_test/sim_config_1/';
mkdir(save_path_base);


%disturbances

failures = zeros(1, 13);
    failures_values= zeros(1, 13);

dist_active = [1 zeros(1,27)];
startTimeDist = 10;
sizeRep = 1;


% for dist_index = 1:28
%     dist_path_folder = strcat(save_path_base,'dist', int2str(dist_index),'/');
%     mkdir(dist_path_folder);
%     dist = [zeros(1,29);[startTimeDist dist_active]];
%     for index=1:sizeRep
%        sim_path = strcat('sim_', int2str(index));
%        
%        sim(model);
%        mkdir(strcat(dist_path_folder,sim_path));
%        csvwrite(strcat(dist_path_folder, sim_path,'/simout_tbase_', mat2str(Ts_base), '.csv'), simout);
%        csvwrite(strcat(dist_path_folder, sim_path,'/tout','.csv'), tout);
%     end
%     dist_active = circshift(dist_active,1);
% end



%failures

dist = zeros(1,29);
startTimeFail = 10;
type_fail = [0,25,50,75,100];

failures_active = [1 zeros(1,11)];
sizeFailRep = 10;

for index_fail = 1:12
    failures = [0 zeros(1,12);[startTimeFail failures_active]];
    fail_path_folder = strcat(save_path_base,'failure_', int2str(index_fail),'/');
    mkdir(fail_path_folder);

    for index_type_fail =1:size(type_fail,2)
        fail_val= type_fail(index_type_fail);
        failures_values = [startTimeFail fail_val zeros(1,11)];
        for index_fail_rep=1:sizeFailRep
           sim_path = strcat('/fail_type_', int2str(fail_val),'/sim_', int2str(index_fail_rep));
           mkdir(strcat(fail_path_folder,sim_path));

           sim(model);
           csvwrite(strcat(fail_path_folder,sim_path, '/simout_tbase_', mat2str(Ts_base), '.csv'), simout);
           csvwrite(strcat(fail_path_folder, sim_path,'/tout','.csv'), tout);
        end
    end
   failures_values = circshift(failures_values,1);
   failures_active = circshift(failures_active,1);
end
