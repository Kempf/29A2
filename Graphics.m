tiling = 5;

[ m1, m2, m3, mtp, awt] = osim( 1000, tiling, 1 );

shrunk = zeros(100/tiling);

for countx = tiling:tiling:100
    for county = tiling:tiling:100
        for countz = tiling:tiling:100
            shrunk(countx/tiling, county/tiling, countz/tiling) = awt(countx, county, countz);
        end
    end
end


xslice = [m1];  %#ok<*NBRAK>
yslice = [m2]; %yslice = [tiling, m2]; If extra panes desired
zslice = [m3];

x = tiling:tiling:100;
y = tiling:tiling:100;
z = tiling:tiling:100;

slice(x, y, z, shrunk, xslice, yslice, zslice)    % display the slices
ylim([-5 105])
view(135, 45)
xlabel('r1');
ylabel('r2');
zlabel('r3');

cb = colorbar;                                  % create and label the colorbar
cb.Label.String = 'Packages per Hour';
