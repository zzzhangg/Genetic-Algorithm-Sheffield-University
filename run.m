clc, clear
close all

%% Plot the function
figure(1);
lbx = 65; ubx = 85;
lby = 25; uby = 50;
ezmesh('8*Y+10*X+14-(1.2*(10^-6)+0.6*(10^-6)*Y+2.16+0.22)', [lbx, ubx, lby, uby], 50);
hold on;

%% Define genetic algorithm parameters
nind = 40;      % Population size
maxgen = 50;    % Maximum genetic iterations
preci = 20;     % Individual length
ggap = 0.95;    % Generation gap
px = 0.7;       % Crossover probability
pm = 0.01;      % Mutation probability
trace = zeros(3, maxgen);               % Optimization result initialization
fieldd = [preci preci;lbx lby;ubx uby;1 1;0 0;1 1;1 1]; % Field descriptor
chrom = crtbp(nind, preci * 2);         % Population initialization (arbitrary discrete random population)

%% Optimization
gen = 0;                                                % Generation counter
XY = bs2rv(chrom, fieldd);                              % Initial population binary to decimal
X = XY(:, 1); Y = XY(:, 2); 
objv = 8*Y+10*X+14-(1.2*(10^-6)+0.6*(10^-6)*Y+2.16+0.22);     % Calculate objective function value
while gen < maxgen
    fitnv = ranking(-objv);                             % Allocate fitness values
    selch = select('sus', chrom, fitnv, ggap);          % Selection
    selch = recombin('xovsp', selch, px);               % Crossover
    selch = mut(selch, pm);                             % Mutation
    
    % Add constraint to ensure x + y is less than 100
    for i = 1:size(selch, 1)
        while true
            XY_sel = bs2rv(selch(i, :), fieldd);
            if sum(XY_sel) <= 100
                break;
            else
                selch(i, :) = crtbp(1, preci * 2);
            end
        end
    end
    
    XY = bs2rv(selch, fieldd);                          % Convert offspring individuals from binary to decimal
    X = XY(:, 1); Y = XY(:, 2);
    objvsel = X .* cos(2*pi*Y) + Y .* sin(2*pi*X);
    [chrom, objv] = reins(chrom, selch, 1, 1, objv, objvsel);   % Reinsert offspring into parents to get new population
    XY = bs2rv(chrom, fieldd);
    gen = gen + 1;
    % Get the optimal solution and its index for each generation, Y is the optimal solution, i is the index of the individual
    [Y, i] = max(objv);
    trace(1:2, gen) = XY(i, :);
    trace(3, gen) = Y;
end
plot3(trace(1, :), trace(2, :), trace(3, :), 'bo');   % Plot the optimal point for each generation
grid on;
plot3(XY(:, 1), XY(:, 2), objv, 'b*');
hold off

%% Plot the evolution
figure(2);
plot(1 : maxgen, trace(3, :));
grid on;
xlabel('Genetic Generation')
ylabel('Change in Solutions')
title('Evolution Process')
best_z = trace(3, end);
best_y = trace(2, end);
best_x = trace(1, end);
best_z = 8*best_y+10*best_x+14-(1.2*(10^-6)+0.6*(10^-6)*best_y+2.16+0.22);
fprintf(['Best Solution:\nX=', num2str(best_x), '\nY=', num2str(best_y), '\nZ=', num2str(best_z), '\n'])
