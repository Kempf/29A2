function [ m1, m2, m3, mtp ] = osim( tmax, til )
%OSIM Packaging optimization
%   tmax - simulation time
%   til - tiling in seconds
    awt = NaN(100,100,100);
    for r1 = 5:til:100
        for r2 = 5:til:100
            for r3 = 5:til:100
                str = ['\n','r1: ', num2str(r1),', r2: ', num2str(r2), ', r3: ', num2str(r3)];
                fprintf(str);
                awt(r1,r2,r3) = asim(tmax, r1, r2, r3);
            end
        end
    end
    
    [mtp,ind] = max(awt(:));
    [m1, m2, m3] = ind2sub(size(awt),ind);
end

