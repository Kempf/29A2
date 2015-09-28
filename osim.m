function [ m1, m2, m3, mtp ] = osim( tmax, til )
%OSIM Packaging optimization
%   tmax - simulation time
%   til - tiling in seconds
    awt = NaN(100,100,100);
    str = '';
    fprintf('\nSimulating...\t');
    for r1 = 1:til:100
        for r2 = 1:til:100
            for r3 = 1:til:100
                if(true)
                    rem = repmat('\b',1,length(str));
                    str = [num2str(r1) ':' num2str(r2) ':' num2str(r3)];
                    fprintf([rem str]);
                end
                awt(r1,r2,r3) = asim(tmax, r1, r2, r3);
            end
        end
    end
    
    [mtp,ind] = max(awt(:));
    [m1, m2, m3] = ind2sub(size(awt),ind);
    fprintf('\nMaximum output: %.2f\n\tm1\t%d\n\tm2\t%d\n\tm3\t%d\n',mtp,m1,m2,m3);
end

