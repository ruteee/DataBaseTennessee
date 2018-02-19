function [ thresholds ] = get_correlation_threshold( model, flag, corr_threshold )
%GET_CORRELATION_THRESHOLD Summary of this function goes here
%   Detailed explanation goes here
    global PATHS;
    te_set = tennessee_setup(model, ...
                             'sim_start', 0, ...
                             'sim_end', 48, ...
                             'flag', flag);
    out_file_name = [PATHS.threshold, 'corr_threshold_', model, '_', num2str(te_set.model_set.qty_meas), '.csv'];
    
    if ~exist('corr_threshold', 'var')
        corr_threshold = .6;
    end

    if ~exist(out_file_name,'file')
        out = cell(1, 13);
        te_set = tennessee_setup(model, ...
                                     'sim_start', 0, ...
                                     'sim_end', 48, ...
                                     'flag', flag);
        norm_out = run_simulation(te_set);
        normal_mean = mean(norm_out.simout);
        idv_corr = zeros(te_set.model_set.qty_meas, te_set.model_set.qty_meas, 13);
        for idv = [1:13, 21:28]
            disp(idv);
            te_set = tennessee_setup(model, ...
                                     'sim_start', 0, ...
                                     'sim_end', 48, ...
                                     'dist_id', idv, ...
                                     'dist_start', 0, ...
                                     'dist_end', 48, ...
                                     'flag', flag);
             out{idv} = run_simulation(te_set);
             norm_out = norm_simulation(out{idv}.simout);
             idv_corr(:, :, idv) = corr(norm_out);
        end
        max_idv = find(abs(idv_corr) == max(abs(idv_corr), [], 3));
        [i, iu] = unique(mod(max_idv, te_set.model_set.qty_meas ^ 2));
        i(i == 0) = te_set.model_set.qty_meas ^ 2;
        max_idv = max_idv(iu);
        max_corr(i) = idv_corr(max_idv);
        max_corr = reshape(max_corr, te_set.model_set.qty_meas, te_set.model_set.qty_meas);
        max_idv = ((max_idv - i)/te_set.model_set.qty_meas^2) + 1;
        max_idv = reshape(max_idv, te_set.model_set.qty_meas, te_set.model_set.qty_meas);
        max_corr = triu(max_corr, 1);
        
        [xs, ys] = find(abs(max_corr) >=  corr_threshold);
        r = cell(1, length(xs));
        vars = union(xs, ys);
        ij = zeros(length(xs), 2);
        
        lb = min(out{1}.simout(:, vars));
        ub = max(out{1}.simout(:, vars));
        
        for i = 1:length(xs)
            idv_loc = max_idv(xs(i), ys(i));
            
            [xif, xi] = ksdensity(out{idv_loc}.simout(:, xs(i)), 'Function', 'survivor');
            [yif, yi] = ksdensity(out{idv_loc}.simout(:, ys(i)), 'Function', 'survivor');
            [jf, jxf] = ksdensity(out{idv_loc}.simout(:, [xs(i), ys(i)]), 'Function', 'survivor');
            
            xsdf = @(x0) xif(abs(xi - x0) == min(abs(xi - x0)));
            ysdf = @(y0) yif(abs(yi - y0) == min(abs(yi - y0)));
            jsdf = @(x0, y0) jf( abs(jxf(:,1) - x0) == min(abs(jxf(:,1) - x0)) ...
                               & abs(jxf(:,2) - y0) == min(abs(jxf(:,2) - y0)));
            r{i} = (@(x0, y0) ((jsdf(x0, y0) - (xsdf(x0) * ysdf(y0))) ...
                              / (sqrt(xsdf(x0) - xsdf(x0)^2) ...
                                * sqrt(ysdf(y0) - ysdf(y0)^2))));
            ij(i, :) = [find(vars == xs(i)), find(vars == ys(i))];
            lb(ij(i,1)) = min(lb(ij(i,1)), min(out{idv_loc}.simout(:, xs(i))));
            lb(ij(i,2)) = min(lb(ij(i,2)), min(out{idv_loc}.simout(:, ys(i))));
            
            ub(ij(i,1)) = max(ub(ij(i,1)), max(out{idv_loc}.simout(:, xs(i))));
            ub(ij(i,2)) = max(ub(ij(i,2)), max(out{idv_loc}.simout(:, ys(i))));
        end
        
        fun = @(x) sum(abs(get_alarm_corr(x, r, ij) - max_corr(abs(max_corr) >=  corr_threshold)));
        nvars = length(vars);
        opt = optimoptions('particleswarm', 'UseParallel', true);
        
        threshold_limits = particleswarm(fun, nvars, lb, ub, opt);
        thresholds = struct();
        for i = 1:length(threshold_limits)
            thresholds(i).proc_var = vars(i);
            thresholds(i).limit = threshold_limits(i);
            if threshold_limits(i) > normal_mean(vars(i))
                thresholds(i).type = 'HIGH';
            else
                thresholds(i).type = 'LOW';
            end
            thresholds(i).dead_band = NaN;
            thresholds(i).delay_time = NaN; 
        end
        
        writetable(struct2table(thresholds), out_file_name);
    else 
        thresholds = table2struct(readtable(out_file_name));
    end

end
