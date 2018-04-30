function [ alarm_corr ] = get_alarm_corr( x, r )
%GET_CORRELATIONS Summary of this function goes here
%   Detailed explanation goes here

    alarm_corr = zeros(length(x));
    
    for i = 1:length(x) - 1
        for j = i + 1:length(x)
            alarm_corr(i, j) = r{i, j}(x(i), x(j));
        end
    end
    
    alarm_corr = alarm_corr(:);
end

