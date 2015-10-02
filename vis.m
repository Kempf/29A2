function [] = vis (str, til, xslice, yslice, zslice)
%VIS graphs saved data
%   str - saved variable name

    % Load results
    awt = load(str);

    [mtp,ind] = max(awt(:));
    [m1, m2, m3, g] = ind2sub(size(awt),ind);
    
    % Shrink matrix
    shrunk = zeros(100/til);

    for countx = til:til:100
        for county = til:til:100
            for countz = til:til:100
                shrunk(countx/til, county/til, countz/til) = awt(countx, county, countz, g);
            end
        end
    end

    % Plot results

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
        ', r2_{max}= ' num2str(m2) ', r3_{max}= ' num2str(m3)', ', g_{max}= ' num2str(g)]);
    
    % Create and label the colorbar
    cb = colorbar;
    cb.Label.String = 'Packages per hour';
    
    mg = NaN(100,1);
    
    for ng = 1:100
        mg(ng)=sum(awt(:,:,:,ng))./size(awt,1);
    end
    
    figure;
end