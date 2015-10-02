function [] = vis (str)
%VIS graphs saved data
%   str - saved variable name

    % Load results
    load(str);

    [mtp,ind] = max(awt(:));
    [m1, m2, m3] = ind2sub(size(awt),ind);
    
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
%     xslice = [m1];
%     yslice = [m2];
%     zslice = [m3];

    xslice = [5];
    yslice = [5];
    zslice = [5];

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
        ', r2_{max}= ' num2str(m2) ', r3_{max}= ' num2str(m3)']);
    
    % Create and label the colorbar
    cb = colorbar;
    cb.Label.String = 'Packages per hour';
end