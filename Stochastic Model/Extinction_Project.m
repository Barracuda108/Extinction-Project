function Extinction_Project

% ID :Nirbhay Bondili & Emily Nikiforuk
% Solution to Project 2.7
% Calculates Birth and Death Rates prior to and after 1991
% Calculates Mean time to extinction
% Calculates mean and variance in population size as function to time before and after 1991


% Assumptions
% A mother wolf can only have one litter per year, and pups are always born in the spring
% Only One litter per pack as only alpha couple breed
% Average of 5 pups per litter
% Assume equal distribution between females and males
% Avergae pack of 10 wolfs, Assume pack splitting once pack > 20
% Average age of wolf = 12 years
% Inital population is mature (>2 years of age)


% According to report approx 0.25 birth rate from 1991 - 2001
% Heteroygosity Rate = 0.54

% colors
dill = [114/255,148/255,104/255]; % Green
peacock = [64/255,115/255,137/255]; % Blue
trumpet = [215/255,190/255,123/255]; % Yellow
earth_jub = [175/255,99/255,65/255]; % Red
off_white = [250/255,250/255,250/255]; % Off White

for i = 4:10
    clf(i)
end

% --------------------------------
% Initial plot for picture of entire dataset

pop_dat = readtable("Extinction Data.xlsx");

% PLot 1
figure(1)
scatter(pop_dat, "StartYear", ["Total_min", "Total_max", "Total_mean"], "filled")
hold on
plot(pop_dat.StartYear, pop_dat.Total_mean, 'color', dill);
plot(pop_dat.StartYear, pop_dat.Total_min, 'color', peacock);
plot(pop_dat.StartYear, pop_dat.Total_max, 'color', earth_jub);
legend('Min', 'Max','Mean', 'Location','northwest')
legend('boxoff')
ylabel("Wolf Population")
set(gca, 'Color', off_white)
set(gcf, 'Color', off_white)
hold off

% --------------------------------
% Before 1990 with deterministic model


pop_dat_pre = pop_dat(1:11, :);

% Fit of data using polyfit
fit_1 = fit(pop_dat_pre.StartYear, pop_dat_pre.Total_mean, 'poly1');

% Personal made model = P(n+1) = P(n) + 5*(1-d) , where d = pups rate of death 
start_wolf = 4;
r1 = 0.10;
wolf_pop = zeros(height(pop_dat_pre), 1); 
wolf_pop(1) = start_wolf;

    function pn = pop_n(~)
        for i = 2:height(pop_dat_pre)
         wolf_pop(i) = wolf_pop(i-1) + 5 * r1*ceil(wolf_pop(i-1)/10);
         pn = wolf_pop;
        end
    end


% Plot 2
figure(2)
stairs(pop_dat_pre.StartYear, pop_dat_pre.Total_mean, 'color', dill, 'LineWidth', 1.5);
hold on
scatter(pop_dat_pre.StartYear, pop_dat_pre.Total_mean, [], 'MarkerFaceColor', dill, 'MarkerEdgeColor', dill);
plot(pop_dat_pre.StartYear, fit_1(pop_dat_pre.StartYear),'--', 'color', earth_jub, 'LineWidth', 1.2);
plot(pop_dat_pre.StartYear, pop_n(pop_dat_pre.Total_mean),'--', 'color', peacock, 'LineWidth', 1.2);
legend('Mean', 'Mean','Linear Fit', 'Discrete Model', 'Location','northwest');
legend('boxoff')
xlabel('Start Year');
ylabel('Wolf Population');
title('Wolf Population Before 1990');
ylim([0, 12]);
set(gca, 'Color', off_white)
set(gcf, 'Color', off_white)
hold off

% --------------------------------
% After 1990 with deterministic model

pop_dat_post = pop_dat(12:21, :);

% Fit of data using ployfit
fit_2 = fit(pop_dat_post.StartYear, pop_dat_post.Total_mean, 'poly2');
fit_3 = fit(pop_dat_post.StartYear, pop_dat_post.Total_mean, 'exp1');

% Personal Discrete model

pn1 = [17,20,28,34,39,49,61,70,74];
pn2 = zeros(length(pn1), 1); 
r2=0.18;
pn2(1)=17;
function pnq = pop_nq(~)
        for i = 1:length(pn1)
         pn2(i+1) = pn1(i)*(1+r2);
         pnq = pn2;
        end
    end
pn3 = pop_nq(pn1);

% Plot 3

figure(3)
stairs(pop_dat_post.StartYear, pop_dat_post.Total_mean, 'color', dill, 'LineWidth', 1.5);
hold on
scatter(pop_dat_post.StartYear, pop_dat_post.Total_mean, [], 'MarkerFaceColor', dill, 'MarkerEdgeColor', dill);
plot(pop_dat_post.StartYear, fit_2(pop_dat_post.StartYear),'--', 'color', earth_jub, 'LineWidth', 1.5);
plot(pop_dat_post.StartYear, fit_3(pop_dat_post.StartYear),'--', 'color', peacock, 'LineWidth', 1.5);
plot(pop_dat_post.StartYear,pn3,'--', 'color', trumpet, 'LineWidth', 1.5);
legend('Mean', 'Mean', 'Quadratic Fit', 'Exponential Fit','Discrete Model ','Location','northwest');
legend('boxoff')
xlabel('Start Year');
ylabel('Wolf Population');
title(' Wolf Population After 1990');
ylim([0, 110]);
set(gca, 'Color', off_white)
set(gcf, 'Color', off_white)
hold off


% --------------------------------
% Stochastic model

% Parameters
int_pop1 = 4; % Initial population size
int_pop2 = 17; % Initial population size
num_sim = 999;     % Number of simulations
count = 0; % Number of extinctions
ext_date = []; %year at which extinction accoured, will be filled in later


% Birth and death rates before and after 1991
% we know r1 = 0.1 & r2 = 0.18
b1 = 0.2;
d1 = 0.1;

b2 = 0.5;
d2 = 0.32;

% Time Periods
t1 = 10;
t2 = 9;
t3 = 20;

pop_pre_91 = NaN(num_sim, t1);
pop_post_91 = NaN(num_sim, t2);
pop_extra = NaN(num_sim, t3);

for sim = 1:num_sim
    population1 = int_pop1;
    population2 = int_pop2;
    population3 = int_pop1;

    % Model before 1991
    for year = 1:t1
        if population1 <= 0 
            population1 = 0;
        else
            births = 5*sum(rand(ceil(population1/10), 1) < b1);
            deaths = sum(rand(population1, 1) < d1);
            population1 = population1 + births - deaths;
            population3 = population1;
            population1 = max(population1, 0);
            population3 = max(population3, 0);
        end
        pop_pre_91(sim, year) = population1;
        pop_extra(sim, year) = population3;
    end
    
    % Model after 1991
    for year = 1:t2
        if population2 <= 0
            population2 = 0;
        else
            births = sum(rand(population2, 1) < b2);
            deaths = sum(rand(population2, 1) < d2);
            population2 = population2 + births - deaths;
            population2 = max(population2, 0);
        end
        pop_post_91(sim, year) = population2;
    end
    

    % Extrapolate from 1980 to 2000
    for year = t1+1:t3
        if population2 <= 0 
            population2 = 0;
        else
            births = 5*sum(rand(ceil(population1/10), 1) < b1);
            deaths = sum(rand(population1, 1) < d1);
            population3 = population3 + births - deaths;
            population3 = max(population3, 0);
        end
        pop_extra(sim, year) = population3;
    end

    

end

% Plot simulations before 1991
figure(4)
hold on
for sim = 1:num_sim
    if any(pop_pre_91(sim,1:t1) == 0)
        plot(1980:1990, [int_pop1, pop_pre_91(sim, 1:t1)] ,  'color', earth_jub)
    else
        plot(1980:1990, [int_pop1, pop_pre_91(sim, 1:t1)] ,  'color', peacock)
    end
end
stairs(pop_dat_pre.StartYear, pop_dat_pre.Total_mean, 'k', 'LineWidth', 2);
xlabel('Start Year');
ylabel('Wolf Population');
title('Stochastic Simulation Before 1991');
set(gca, 'Color', off_white)
set(gcf, 'Color', off_white)
hold off

% Plot simulations after 1991
figure(5)
hold on
for sim = 1:num_sim
    if any(pop_post_91(sim,1:t2) == 0)
        plot(1991:2000, [int_pop2, pop_post_91(sim, 1:t2)] ,  'color', earth_jub)
    else
        plot(1991:2000, [int_pop2, pop_post_91(sim, 1:t2)] ,  'color', peacock)
    end
end
plot(pop_dat_post.StartYear, pop_dat_post.Total_mean, 'k', 'LineWidth', 1.5);
xlabel('Start Year');
ylabel('Wolf Population');
title('Stochastic Simulation After 1991');
set(gca, 'Color', off_white)
set(gcf, 'Color', off_white)
hold off

% 1991 model up to 2000
figure(6)
hold on
for sim = 1:num_sim
    if any(pop_extra(sim,1:t3) == 0)
        plot(1980:2000, [int_pop1, pop_extra(sim, 1:t3)] ,  'color', earth_jub)
        count = count +1;
        for i = 1:t3
            if pop_extra(sim,i) == 0
                ext_date = [ext_date ; 1980+i];
                break
            end
        end
    else
        plot(1980:2000, [int_pop1, pop_extra(sim, 1:t3)] ,  'color', peacock)
    end
end
xlabel('Start Year');
ylabel('Wolf Population');
title('Extrapolation of Stochastic Simulation 1980-2000');
xlim([1980 2000])
set(gca, 'Color', off_white)
set(gcf, 'Color', off_white)
hold off

% Mean and variance of populations

% Before 1991

pre_91_mean = [];

for i = 1:t1
    for sim = 1:num_sim
        a = mean(pop_pre_91(sim,i));
    end
    pre_91_mean = [pre_91_mean, a];
end

pre_91_var = [];

for i = 1:t1
    time_slice_var = [];
    for sim = 1:num_sim
        a = (pop_pre_91(sim,i));
        time_slice_var = [time_slice_var, a];
    end
    pre_91_var = [pre_91_var, var(time_slice_var)];
end

figure(7)
stairs(pop_dat_pre.StartYear, pop_dat_pre.Total_mean, 'color', dill, 'LineWidth', 1.5);
hold on
scatter(pop_dat_pre.StartYear, pop_dat_pre.Total_mean, [], 'MarkerFaceColor', dill, 'MarkerEdgeColor', dill);
stairs(1980:1990,[4,pre_91_mean], 'color', trumpet, 'LineWidth', 1.5 )
scatter(1980:1990,[4,pre_91_mean], [], 'MarkerFaceColor', trumpet, 'MarkerEdgeColor', trumpet);
legend('Mean', 'Mean','Stochastic Mean', 'Stochastic Mean','Location','northwest');
legend('boxoff')
xlabel('Start Year');
ylabel('Wolf Population');
if max(pre_91_mean+2) > 12
    ylim([0,max(pre_91_mean+2)]);
else
    ylim([0,12])
end
title(' Mean Stochastic Models Vs. Data Before 1991 ');
set(gca, 'Color', off_white)
set(gcf, 'Color', off_white)
hold off

figure(8)
plot(1980:1990,[4,pre_91_mean], 'color', trumpet, 'LineWidth', 1.5 )
legend( 'Stochastic Variance','Location','northwest');
legend('boxoff')
xlabel('Start Year');
ylabel('Wolf Population');
title(' Stochastic Variance Before 1991 ');
set(gca, 'Color', off_white)
set(gcf, 'Color', off_white)


% After 1991

post_91_mean = [];

for i = 1:t2
    for sim = 1:num_sim
        a = mean(pop_post_91(sim,i));
    end
    post_91_mean = [post_91_mean, a];
end

post_91_var = [];

for i = 1:t2
    time_slice_var = [];
    for sim = 1:num_sim
        a = (pop_post_91(sim,i));
        time_slice_var = [time_slice_var, a];
    end
    post_91_var = [post_91_var, var(time_slice_var)];
end

figure(9)
stairs(pop_dat_post.StartYear, pop_dat_post.Total_mean, 'color', dill, 'LineWidth', 1.5);
hold on
scatter(pop_dat_post.StartYear, pop_dat_post.Total_mean, [], 'MarkerFaceColor', dill, 'MarkerEdgeColor', dill);
stairs(1991:2000,[17,post_91_mean], 'color', trumpet, 'LineWidth', 1.5 )
scatter(1991:2000,[17,post_91_mean], [], 'MarkerFaceColor', trumpet, 'MarkerEdgeColor', trumpet);
legend('Mean', 'Mean','Stochastic Mean', 'Stochastic Mean','Location','northwest');
legend('boxoff')
xlabel('Start Year');
ylabel('Wolf Population');
title(' Mean Stochastic Models Vs. Data After 1991 ');
set(gca, 'Color', off_white)
set(gcf, 'Color', off_white)
hold off

figure(10)
plot(1991:2000,[17,post_91_var], 'color', trumpet, 'LineWidth', 1.5 )
legend( 'Stochastic Variance','Location','northwest');
legend('boxoff')
xlabel('Start Year');
ylabel('Wolf Population');
title(' Stochastic Variance After 1991 ');
set(gca, 'Color', off_white)
set(gcf, 'Color', off_white)



%__________________________________________________________________________

fprintf('\n Total number of extinctions if new wolf not added = %d \n' , count)
disp(mean(ext_date-1980))

end
