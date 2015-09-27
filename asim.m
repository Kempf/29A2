function [ avg ] = asim( tmax, r1, r2, r3 )
% ASIM Intersection simulation
%   nP - length of simulation in cycles
%   r1-3 - length of release on stations 1-3
%   seq - sequence 1 2 3 or 1 3 2

    % Release pattern
    CP1 = [ones(1,r1) zeros(1,60+r2+r3)];
    CP2 = [zeros(1,r1+20) ones(1,r2) zeros(1,40+r3)];
    CP3 = [zeros(1,40+r1+r2) ones(1,r3) zeros(1,20)];
    
    % Sanity check
    if (tmax < 1)
        error('Incorrect simulation length.');
    elseif (and(not(all(size(CP1) == size(CP2))),not(all(size(CP2) == size(CP3)))))
        error('Release pattern lenghts do not match.');
    elseif (any(CP1 .* CP2 .* CP3))
        error ('Incorrect patterns.');
    end

    nP = ceil(tmax/size(CP1,2));
    
    % Release cycle
    C1 = repmat(CP1,1,floor(nP));
    C2 = repmat(CP2,1,floor(nP));
    C3 = repmat(CP3,1,floor(nP));

    % Station work patterns
    W1 = poissrnd(50/3600,1,tmax);
    W2 = poissrnd(50/3600,1,tmax);
    W3 = poissrnd(50/3600,1,tmax);
    
    % Queues
    QM = [];
    Q1 = [];
    Q2 = [];
    Q3 = [];
    QD = [];

    % Vehicle counter
    veh = 1;
    
    % Main loop
    for t = 1:tmax
        % Add packages to station queues
        if(W1(t) && size(Q1,1) < 50 && not(C1(t)))
            Q1 = [Q1; [veh 1]];
            veh = veh + 1;
        end
        if(W2(t) && size(Q2,1) < 50 && not(C2(t)))
            Q2 = [Q2; [veh 2]];
            veh = veh + 1;
        end
        if(W3(t) && size(Q3,1) < 50 && not(C3(t)))
            Q3 = [Q3; [veh 3]];
            veh = veh + 1;
        end
        % Release packages to main queue
        if(not(isempty(Q1)) && C1(t) && size(QM,1) < 155)
            QM = [QM; Q1(1,:)];
            Q1 = Q1(2:end,:);
        end
        if(not(isempty(Q2)) && C2(t) && size(QM,1) < 125)
            QM = [QM; Q2(1,:)];
            Q2 = Q2(2:end,:);
        end
        if(not(isempty(Q3)) && C3(t) && size(QM,1) < 100)
            QM = [QM; Q3(1,:)];
            Q3 = Q3(2:end,:);
        end
        % Remove packages from main queue
        if(not(mod(t,24)) && not(isempty(QM)))
            QD = [QD; QM(1,:)];
            QM = QM(2:end,:);
        end
    end
    
   % Analysis
    avg = size(QD,1)/(tmax/3600);
    
end

