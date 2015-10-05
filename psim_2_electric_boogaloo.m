function [ avg, fail_1, fail_2, fail_3, prod_fail_1, prod_fail_2, prod_fail_3, remaining_packages ] = psim_2_electric_boogaloo( tmax, r1, r2, r3, g, reps )
% ASIM Intersection simulation
%   tmax - length of simulation in seconds
%   r1-3 - length of release on stations 1-3


    % Release pattern
    % Release pattern
    CP1 = [ones(1,r1) zeros(1,g*3+r2+r3)];
    CP2 = [zeros(1,r1+g) ones(1,r2) zeros(1,g*2+r3)];
    CP3 = [zeros(1,g*2+r1+r2) ones(1,r3) zeros(1,g)];
    
    
    % Sanity check
    if (tmax < 1)
        error('Incorrect simulation length.');
    end
    
    if (g < 20)
        error('Gap is less than 20 sec.');
    end
    

    QD_avg = 0;
    H_avg = []; 
    
    fail_1 = 0;
    fail_2 = 0;
    fail_3 = 0;
    prod_fail_1 = 0;
    prod_fail_2 = 0;
    prod_fail_3 = 0;
    
    for n = 1:reps

        % No. of pattern repeats
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
        


        % Package counter
        pak = 1;

        % Record queue length over time
        H = zeros(tmax,4);

        % Main loop
        fprintf('\nSimulating...\t');
        str = '';
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
            if(size(QM,1) >= 155 && C1(t))
                fail_1 = fail_1 + 1;
            end
            if(size(QM,1) >= 125 && C2(t))
                fail_2 = fail_2 + 1;
            end
            if(size(QM,1) >= 100 && C3(t))                
                fail_3 = fail_3 + 1;
            end            
            if size(Q1,2) >= 50 && w1(t) && not(C1(t))
                prod_fail_1 = prod_fail_1 + 1;
            end
            if size(Q2,2) >= 50 && w2(t) && not(C2(t))
                prod_fail_2 = prod_fail_2 + 1;
            end
            if size(Q3,2) >= 50 && w1(t) && not(C3(t))
                prod_fail_3 = prod_fail_3 + 1;
            end
            
            
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
            H(t,:) = [size(Q1,1) size(Q2,1) size(Q3,1), size(QM,1)];
            if(mod(t,tmax/100)==0)
                rem = repmat('\b',1,length(str)-1);
                str = [num2str(t/tmax*100,'%.0f') '%%'];
                fprintf([rem str]);
            end
        end
    
    if isempty(QD_avg)
        QD_avg = QD;
    else
        %QD_avg = QD_avg + QD;
    end
    if isempty(H_avg)
        H_avg = H;    
    else
        H_avg = H_avg + H;
    end
    avg = size(QD,1)/(tmax/3600);
    QD_avg = QD_avg + avg;
    
    end
    
    QD_avg = QD_avg ./ reps;
    H_avg = H_avg ./ reps;
    
    % Plost results
    close all;
    hold on;
    plot(H_avg(:,1),'r');
    plot(H_avg(:,2),'g');
    plot(H_avg(:,3),'b');
    plot(H_avg(:,4),'k');
    hold off;
    legend('1', '2', '3', 'M', 'Location', 'SouthEast');
    
   % Calculate avergae hourly throughput
   
   fail_3 = fail_3 / reps;
    avg = QD_avg;
    remaining_packages = size(Q1, 1) + size(Q2, 1) + size(Q3, 1);
end
