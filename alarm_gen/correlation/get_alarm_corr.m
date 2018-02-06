function [ alarm_corr ] = get_alarm_corr( x, r, ij )
%GET_CORRELATIONS Summary of this function goes here
%   Detailed explanation goes here

    alarm_corr = zeros(length(ij), 1);
    
    for pair = 1:length(ij)
        alarm_corr(pair) = r{pair}(x(ij(pair, 1)), x(ij(pair, 2)));
    end
end

