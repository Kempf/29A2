function [ avg ] = asim( tmax, r1, r2, r3, g )
% ASIM Packaging factory simulation
%   tmax - length of simulation in seconds
%   r1-3 - length of release on stations 1-3
%   g - length of pause between releases

    % Generate release patterns
    CP1 = [ones(1,r1) zeros(1,g*3+r2+r3)];
    CP2 = [zeros(1,r1+g) ones(1,r2) zeros(1,g*2+r3)];
    CP3 = [zeros(1,g*2+r1+r2) ones(1,r3) zeros(1,g)];
    
    % Input check
    if (tmax < 1)
        error('Incorrect simulation length.');
    elseif (g < 20)
        error('Release gap must be over 20 seconds.');
    elseif (r1 < 0 || r2 < 0 || r3 < 0)
        error('Incorrect release lengths.');
    end
    
    % Calculate no. of pattern repeats
    nP = ceil(tmax/size(CP1,2));
    
    % Generate release cycles
    C1 = repmat(CP1,1,floor(nP));
    C2 = repmat(CP2,1,floor(nP));
    C3 = repmat(CP3,1,floor(nP));

    % Station work patterns
    W1 = poissrnd(50/3600,1,tmax);
    W2 = poissrnd(50/3600,1,tmax);
    W3 = poissrnd(50/3600,1,tmax);
    
    % Initialize conveyor queues
    QM = [];
    Q1 = [];
    Q2 = [];
    Q3 = [];
    QD = [];

    % Initialize package counter
    pak = 1;
    
    % Main simulation loop
    for t = 1:tmax
        % Add packages to station queues
        if(W1(t) && size(Q1,1) < 50 && not(C1(t)))
            Q1 = [Q1; [pak 1]];
            pak = pak + 1;
        end
        if(W2(t) && size(Q2,1) < 50 && not(C2(t)))
            Q2 = [Q2; [pak 2]];
            pak = pak + 1;
        end
        if(W3(t) && size(Q3,1) < 50 && not(C3(t)))
            Q3 = [Q3; [pak 3]];
            pak = pak + 1;
        end
        % Release packages to main queue
        if(not(isempty(Q1)) && C1(t) && size(QM,1) < 155)
            QM = [QM; Q1(1,:)];
            Q1 = Q1(2:end,:);
        elseif(not(isempty(Q2)) && C2(t) && size(QM,1) < 125)
            QM = [QM; Q2(1,:)];
            Q2 = Q2(2:end,:);
        elseif(not(isempty(Q3)) && C3(t) && size(QM,1) < 100)
            QM = [QM; Q3(1,:)];
            Q3 = Q3(2:end,:);
        end
        % Remove packages from main queue
        if(not(mod(t,24)) && not(isempty(QM)))
            QD = [QD; QM(1,:)];
            QM = QM(2:end,:);
        end
    end
    
   % Calculate avergae hourly throughput
    avg = size(QD,1)/(tmax/3600);
    
end

