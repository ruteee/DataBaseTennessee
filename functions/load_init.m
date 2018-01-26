function [ in ] = load_init( model, in)
%LOAD_INIT Summary of this function goes here
%   Detailed explanation goes here

    switch model
        case 'MultiLoop_mode1'
            init_scrpit = 'Mode_1_Init';
        case 'MultiLoop_mode3'
            init_scrpit = 'Mode_3_Init';
        case 'MultiLoop_Skode_mode1'
            init_scrpit = 'Skoge_Mode1_Init';
    end
    
    run(init_scrpit);
    init_vars = who;
    for i = 1:length(init_vars)
        if ~strcmp(init_vars{i}, 'in')
            in = in.setVariable(init_vars{i}, eval(init_vars{i}), 'Workspace', model);
        end
    end

end

