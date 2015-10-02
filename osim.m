function [ m1, m2, m3, mtp, awt ] = osim( tmax, til, run )
%OSIM Packaging optimization
%   tmax - simulation time
%   til - til in seconds
%   run - number of runs
    awt = NaN(100,100,100,100);
    str = '';
    fprintf('\nSimulating...\t');
    % Sanity check
    if (run < 1)
        error('Incorrect number of runs.');
    end
    if (til<=0 || round(til)~=til )
        error('Incorrect til.');
    end
    % Optimization loop
    for n = 1:run
        for g = 1:100
            for r1 = til:til:100
                for r2 = til:til:100
                    for r3 = til:til:100
                        if (r3==til)
                            % Progress output
                            rem = repmat('\b',1,length(str));
                            str = [num2str(n) ':' num2str(g) ':' num2str(r1) ':' num2str(r2) ':' num2str(r3)];
                            fprintf([rem str]);
                        end
                        % Run the sim
                        if (n==1)
                            awt(r1,r2,r3,g) = asim(tmax, r1, r2, r3,g*30);
                        else
                            awt(r1,r2,r3,g) = awt(r1,r2,r3,g) + asim(tmax, r1, r2, r3,g*30);
                        end
                    end
                end
            end
        end
    end
    % Average the results
    awt = awt ./ run;
    % Calculate minimum
    [mtp,ind] = max(awt(:));
    [m1, m2, m3, mg] = ind2sub(size(awt),ind);
    fprintf('\nMaximum output: %.2f\n\tm1\t%d\n\tm2\t%d\n\tm3\t%d\n\tg\t%d\n\n',mtp,m1,m2,m3,mg);
    
    % Save results
    save('awt',awt);
end