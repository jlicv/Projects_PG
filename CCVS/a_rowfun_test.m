function[tryout] = a_rowfun_test(x,y,varargin)
    if(isempty(varargin))
        z = 0;
    elseif(length(varargin )== 1)
    z = varargin;
    else
    z = varargin{1};
    end
    tryout = x*y+z;
end