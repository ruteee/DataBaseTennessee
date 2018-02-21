function [ alm_seq ] = apply_threshold( sim_out, thresholds )
%APPLY_THRESHOLD Summary of this function goes here
%   Detailed explanation goes here
    
    alm_seq = zeros(size(sim_out));
    for i = 1:length(thresholds)
        if thresholds(i).type == "LOW"
            alm_seq(:,i) = sim_out(:, thresholds(i).proc_var) < thresholds(i).limit;
        else
            alm_seq(:,i) = thresholds(i).limit < sim_out(:, thresholds(i).proc_var);
        end
    end

end

