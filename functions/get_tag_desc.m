function [ tags ] = get_tag_desc( var )
%GET_TAG_DESC Summary of this function goes here
%   Detailed explanation goes here

    tags = compose("XMV-%02d", var);
    
end

