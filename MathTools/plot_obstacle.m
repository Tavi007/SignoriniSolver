function [] = plot_obstacle(problem)
%Plots the obstacle


min_ = problem.obstacle_minmax(1);
max_ = problem.obstacle_minmax(2);
    
x = min_:(max_ - min_)/200:max_;
y = x*0;
for i = 1:length(x)
    y(i) = problem.obstacle(x(i));
end
plot(x,y,'color','r')
end

