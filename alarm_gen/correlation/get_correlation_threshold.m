function [ thresholds ] = get_correlation_threshold( model, flag)
%GET_CORRELATION_THRESHOLD Summary of this function goes here
%   Detailed explanation goes here
    global PATHS;
    te_set = tennessee_setup(model, ...
                             'sim_start', 0, ...
                             'sim_end', 48, ...
                             'flag', flag);
    out_file_name = [PATHS.threshold, 'corr_threshold_', model, '_', num2str(te_set.model_set.qty_meas), '_', num2str(now), '.csv'];

    if ~exist(out_file_name,'file')
%         out;
        te_set = tennessee_setup(model, ...
                                 'sim_start', 0, ...
                                 'sim_end', 48, ...
                                 'flag', flag);
        norm_out = run_simulation(te_set);
        var_select = [1,2,3,8,9,21];
        n_vars = length(var_select);
        normal_mean = mean(norm_out.simout);
%         idv_corr;
        for idv = 6 %1:13
            te_set = tennessee_setup(model, ...
                                     'sim_start', 0, ...
                                     'sim_end', 96, ...
                                     'dist_id', idv, ...
                                     'dist_start', 24, ...
                                     'dist_end', 96, ...
                                     'flag', flag);
             out = run_simulation(te_set);
             norm_out = norm_simulation(out.simout(:,var_select));
             idv_corr = corr(norm_out);
        end
        r = cell(n_vars);
        
        for i = 1:n_vars - 1
            for j = i+1:n_vars

                [xif, xi] = ksdensity(out.simout(:, var_select(i)), 'Function', 'survivor');
                [yif, yi] = ksdensity(out.simout(:, var_select(j)), 'Function', 'survivor');
                [jf, jxf] = ksdensity(out.simout(:, [var_select(i), var_select(j)]), 'Function', 'survivor');

                xsdf = @(x0) xif(abs(xi - x0) == min(abs(xi - x0)));
                ysdf = @(y0) yif(abs(yi - y0) == min(abs(yi - y0)));
                jsdf = @(x0, y0) jf( abs(jxf(:,1) - x0) == min(abs(jxf(:,1) - x0)) ...
                                   & abs(jxf(:,2) - y0) == min(abs(jxf(:,2) - y0)));
                r{i, j} = (@(x0, y0) ((jsdf(x0, y0) - (xsdf(x0) * ysdf(y0))) ...
                                  / (sqrt(xsdf(x0) - xsdf(x0)^2) ...
                                    * sqrt(ysdf(y0) - ysdf(y0)^2))));

            end
        end
        lb = min(out.simout(:,var_select));
        ub = max(out.simout(:,var_select));
        
        fun = @(x) sum(abs(get_alarm_corr(x, r) - idv_corr(:)));
        nvars = n_vars;
        opt = optimoptions('particleswarm', 'UseParallel', true);
        
        threshold_limits = particleswarm(fun, nvars, lb, ub, opt);
        thresholds = struct();
        for i = 1:length(threshold_limits)
            thresholds(i).proc_var = var_select(i);
            thresholds(i).limit = threshold_limits(i);
            if threshold_limits(i) >= normal_mean(i)
                thresholds(i).type = "HIGH";
            else
                thresholds(i).type = "LOW";
            end
            thresholds(i).dead_band = NaN;
            thresholds(i).delay_time = NaN;
        end
        
        writetable(struct2table(thresholds), out_file_name);
    else
        thresholds = table2struct(readtable(out_file_name, 'TextType', 'string'));
    end

end
