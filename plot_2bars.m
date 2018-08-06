function plot_2bars(data)

figure
locations = [1,2];
ax = axes;
bar(locations(1), mean(data{1}), 'b');
hold
bar(locations(2), mean(data{2}), 'r');

%Plot confidence intervals
for loc=1:length(data)
    plot([locations(loc),locations(loc)], [mean(data{loc})-std(data{loc})/sqrt(length(data{loc})), ...
        mean(data{loc})+std(data{loc})/sqrt(length(data{loc}))], 'k', 'LineWidth',2);
    plot([locations(loc)-.05,locations(loc)+.05], [mean(data{loc})-std(data{loc})/sqrt(length(data{loc})), ...
        mean(data{loc})-std(data{loc})/sqrt(length(data{loc}))], 'k', 'LineWidth',2);
    plot([locations(loc)-.05,locations(loc)+.05], [mean(data{loc})+std(data{loc})/sqrt(length(data{loc})), ...
        mean(data{loc})+std(data{loc})/sqrt(length(data{loc}))], 'k', 'LineWidth',2);
end

% Create labels and ticks
ylabel('Performance improvement (%)','FontSize',30);
xlim([.5, 2.5]);
set(ax,'XTick',[1, 2]);
xlabel('cTBS site', 'FontSize', 30);

% Plot individual data
shift1 = .05+rand(length(data{1}), 1)/5;
shift2 = .05+rand(length(data{2}), 1)/5;
plot(1+shift1, data{1}, 'o')
plot(2+shift2, data{2}, 'o')
