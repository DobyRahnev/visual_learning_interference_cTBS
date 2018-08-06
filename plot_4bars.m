function plot_4bars(data, plotIndividualData)

locations = [1,2,4,5];

figure
ax = axes;
bar(locations(1), mean(data{1}), 'b');
hold
bar(locations(2), mean(data{2}), 'r');
bar(locations(3), mean(data{3}), 'b');
bar(locations(4), mean(data{4}), 'r');

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
xlim([.5, locations(end)+.5]);
set(ax,'XTick',[1.5, 4.5]);
xlabel('Training', 'FontSize', 30);
legend('cTBS to vertex', 'cTBS to visual cortex')

% Plot individual data
if plotIndividualData
    shift1 = .05+rand(length(data{1}), 1)/5;
    shift2 = .05+rand(length(data{2}), 1)/5;
    plot([1+shift1, 4+shift1], [data{1}, data{3}], 'o')
    plot([2+shift2, 5+shift2], [data{2}, data{4}], 'o')
end