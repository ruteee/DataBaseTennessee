function [ tags ] = get_tag( var )
%GET_TAG Summary of this function goes here
%   Detailed explanation goes here

    tags = compose("XMV-%02d", var);

end

