function [ low_threshold, high_threshold, new_threshold, vars] = get_correlation_threshold( model, flag )
%GET_CORRELATION_THRESHOLD Summary of this function goes here
%   Detailed explanation goes here

    if ~exist('corr_threshold.mat','file')
        
        corr_threshold = .6;
        
        te_set = tennessee_setup(model, ...
                                 'sim_start', 0, ...
                                 'sim_end', 10, ...
                                 'dist_id', 1, ...
                                 'dist_start', 0, ...
                                 'dist_end', 10, ...
                                 'flag', flag);
        out = run_simulation(te_set);
        
        process = norm_simulation(out.simout);
        process_corr = triu(corr(process), 1);
        
        sf_proc = containers.Map('KeyType', 'int32', 'ValueType', 'any');
        [xs, ys] = find(process_corr >=  corr_threshold);
        r = cell(1, length(xs));
        vars = union(xs, ys);
        ij = zeros(length(vars), 2);
        for i = 1:length(xs)
            if ~sf_proc.isKey(xs(i))
                [f, xf] = ksdensity(process(:,xs(i)));
                sf_proc(xs(i)) = [xf, f];
            end
            
            if ~sf_proc.isKey(ys(i))
                [f, yf] = ksdensity(process(:,ys(i)));
                sf_proc(ys(i)) = [yf, f];
            end
            f = sf_proc(xs(i));
            xif = f(:, 2);
            xi = f(:, 1);
            f = sf_proc(ys(i));
            yif = f(:, 2);
            yi = f(:, 1); 
            [jf, jxf] = ksdensity(process(:,[xs(i), ys(i)]), 'Function', 'survivor');
            r{i} = (@(x0, y0) (jf( abs(jxf(:,1) - x0) == min(abs(jxf(:,1) - x0)) ...
                                   & abs(jxf(:,2) - y0) == min(abs(jxf(:,2) - y0))) ...
                                - (xif(abs(xi - x0) == min(abs(xi - x0))) ...
                                    * yif(abs(yi - y0) == min(abs(yi - y0))))) ...
                              / (sqrt(xif(abs(xi - x0) == min(abs(xi - x0))) ...
                                        - xif(abs(xi - x0) == min(abs(xi - x0)))^2) ...
                                    * sqrt(yif(abs(yi - y0) == min(abs(yi - y0))) ...
                                        - yif(abs(yi - y0) == min(abs(yi - y0))))));
            ij(i, :) = [find(vars == xs(i)), find(vars == ys(i))];
        end
        
        fun = @(x) sum(abs(get_alarm_corr(x, r, ij) - process_corr(process_corr >= corr_threshold)));
        nvars = length(vars);
        lb = min(process(:, vars));
        ub = max(process(:, vars));
        opt = optimoptions('particleswarm', 'UseParallel', true);
        
        new_threshold = particleswarm(fun, nvars, lb, ub, opt);
        
        new_threshold = unnorm_threshold(new_threshold, out.simout(:, vars));
        
        low_threshold = [-1 -1];
        high_threshold = [1 1];
%         save('corr_threshold.mat', 'low_threshold', 'high_threshold', 'new_threshold');
    else 
        load('corr_threshold');
    end

end

