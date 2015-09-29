function [ m1, m2, m3, mtp ] = osim( tmax, til, run )
%OSIM Packaging optimization
%   tmax - simulation time
%   til - tiling in seconds
%   run - number of runs
    awt = NaN(100,100,100);
    str = '';
    fprintf('\nSimulating...\t');
    % Sanity check
    if (run < 1)
        error('Incorrect number of runs.');
    end
    % Optimization loop
    for n = 1:run
        for r1 = 5:til:100
            for r2 = 5:til:100
                for r3 = 5:til:100
                    % Progress output
                    rem = repmat('\b',1,length(str));
                    str = [num2str(r1) ':' num2str(r2) ':' num2str(r3)];
                    fprintf([rem str]);
                    % Run the sim
                    if (n==1)
                        awt(r1,r2,r3) = asim(tmax, r1, r2, r3);
                    else
                        awt(r1,r2,r3) = awt(r1,r2,r3) + asim(tmax, r1, r2, r3);
                    end
                end
            end
        end
    end
    % Average the results
    awt = awt ./ run;
    % Calculate minimum
    [mtp,ind] = max(awt(:));
    [m1, m2, m3] = ind2sub(size(awt),ind);
    fprintf('\nMaximum output: %.2f\n\tm1\t%d\n\tm2\t%d\n\tm3\t%d\n',mtp,m1,m2,m3);
end

