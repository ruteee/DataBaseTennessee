%Disturbances or failures start and end in a specifc instant

% begin setup
run('Mode_1_Init.m')
%run('Mode_3_Init.m')
% end setup

model = 'MultiLoop_mode1';
save_path_base = 'sim_test/sim_config_2/';
mkdir(save_path_base);

%disturbances
sizeRep = 1;
startTime = 2;
endTime = 48;
failures = zeros(1,13);
failures_values= zeros(1, 13);
dist_active = [1 zeros(1,27)];


% for dist_index = 1:size(dist_active,2)
%     dist_path_folder = strcat(save_path_base,'dist', int2str(dist_index),'/');
%     mkdir(dist_path_folder);
% 
%     dist = [0 zeros(1,28); [startTime dist_active]; [endTime zeros(1,28)]];
%     for index=1:sizeRep
%        sim_path = strcat('sim_', int2str(index));
%        sim(model);
%        mkdir(strcat(dist_path_folder,sim_path));
%        csvwrite(strcat(dist_path_folder, sim_path,'/simout_tbase_', mat2str(Ts_base), '.csv'), simout);
%        csvwrite(strcat(dist_path_folder, sim_path,'/tout','.csv'), tout);
%     end
%     dist_active = circshift(dist_active,1);
% end


%failures
dist = zeros(1,29);

sizeFailRep = 10;
startTimeFail = 10;
endTimeFail = 11;
type_fail = [0,25,50,75,100];
failures_active = [1 zeros(1,11)];

for index_fail = 1:28
    failures = [0 zeros(1,12);[startTimeFail failures_active]; [endTimeFail zeros(1,12)]];
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
