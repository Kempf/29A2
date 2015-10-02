function [ m1, m2, m3, mtp, awt ] = osim( tmax, til, run )
%OSIM Packaging optimization
%   tmax - simulation time
%   til - til in seconds
%   run - number of runs
    awt = NaN(100,100,100);
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
        for r1 = til:til:100
            for r2 = til:til:100
                for r3 = til:til:100
                    if (r3==til)
                        % Progress output
                        rem = repmat('\b',1,length(str));
                        str = [num2str(n) ':' num2str(r1) ':' num2str(r2) ':' num2str(r3)];
                        fprintf([rem str]);
                    end
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
    
    % Save results
    save('awt');
    
    % Shrink matrix
    shrunk = zeros(100/til);

    for countx = til:til:100
        for county = til:til:100
            for countz = til:til:100
                shrunk(countx/til, county/til, countz/til) = awt(countx, county, countz);
            end
        end
    end

    % Plot results
    xslice = [m1];
    yslice = [m2];
    zslice = [m3];

    x = til:til:100;
    y = til:til:100;
    z = til:til:100;
    
    % Display the slices
    slice(x, y, z, shrunk, xslice, yslice, zslice)    
    ylim([-5 105])
    view(135, 45)
    xlabel('r1');
    ylabel('r2');
    zlabel('r3');
    title(['Average package throughput, r1_{max}= ' num2str(m1)...
        ', r2_{max}= ' num2str(m2) ', r3_{max}= ' num2str(m3)', ' num2str(run) ', runs']);
    
    % Create and label the colorbar
    cb = colorbar;
    cb.Label.String = 'Packages per hour';
end