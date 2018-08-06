%analysis

clc
clear
close all

% Folder names
folders = {'vertex', 'visual_cortex'};

% Experiment information: columns correspond to sub num; ori trained first; 
% ori trained second; untrained ori
subjects{1} =  ... %vertex
    [1	2	3	1
    2	3	2	1
    3	2	1	3
    4	2	3	1
    5	1	2	3
    7	3	2	1
    9	2	1	3
    10	2	3	1
    12	3	1	2
    13	2	3	1
    14	3	1	2
    16	3	2	1];
subjects{2} =  ... %visual cortex
    [1	3	2	1
    2	3	2	1
    3	1	2	3
    4	2	3	1
    6	3	1	2
    8	3	2	1
    9	1	2	3
    10	3	2	1
    11	2	1	3
    13	2	1	3
    15	2	3	1
    16	1	2	3
    17	1	3	2];

%% Load the data and compute threshold
% Loop over both TMS groups
for tms_site=1:2 %1 = vertex, 2 = visual cortex
    
    % Loop over all subjects within a group
    for sub=1:size(subjects{tms_site}, 1)
        sub_str = num2str(subjects{tms_site}(sub,1));
        
        % Loop over both testing days within a subject
        for day=1:2
            
            % Load the data file
            fileName = fullfile('data', folders{tms_site}, 'Test_Results', sub_str, [sub_str '_Day' num2str(day) '_Result_Test.mat']);
            load(fileName);
            
            % Determine the order in which the 3 orientations (10, 70, 130) were tested
            ori_test_order = [data(1).orientations(1), data(2).orientations(1), data(3).orientations(1)];
            
            % Determine threshold for each orientation organized by training (first, second, untrained)
            for training=1:3 %trained first, trained second, untrained
                
                % Determine the orientation number for this training
                ori_num = subjects{tms_site}(sub,training+1);
                
                % Determine in which block was this orientation tested
                testBlock_ori = find(ori_test_order==ori_num);
                
                % Determine the threshold for this test block
                thresh{tms_site}(sub,training,day) = geomean(data(testBlock_ori).reversal(end-5:end));
            end
        end
    end
end


%% Compute performance improvement for all subjects
for tms_site=1:2
    for sub=1:size(subjects{tms_site}, 1)
        for training=1:3 %trained first, trained second, untrained
            learnImprov{tms_site}(sub,training) = 100 * (1 - thresh{tms_site}(sub,training,2)/thresh{tms_site}(sub,training,1));
        end
    end
end


%% Stats
% Means
vertex_improvement = mean(learnImprov{1})
VC_improvement = mean(learnImprov{2})

% One-sample t-tests
disp('------ one-sample t-tests ------')
[~, p_vert1, ~, stats] = ttest(learnImprov{1}(:,1))
[~, p_VC1, ~, stats] = ttest(learnImprov{2}(:,1))
[~, p_vert2, ~, stats] = ttest(learnImprov{1}(:,2))
[~, p_VC2, ~, stats] = ttest(learnImprov{2}(:,2))
[~, p_vert3, ~, stats] = ttest(learnImprov{1}(:,3))
[~, p_VC3, ~, stats] = ttest(learnImprov{2}(:,3))

% Independent sample t-tests for each training
disp('------ independent sample t-tests ------')
[~, p_2cond_train1, ~, stats] = ttest2(learnImprov{1}(:,1), learnImprov{2}(:,1))
[~, p_2cond_train2, ~, stats] = ttest2(learnImprov{1}(:,2), learnImprov{2}(:,2))
[~, p_2cond_train3, ~, stats] = ttest2(learnImprov{1}(:,3), learnImprov{2}(:,3))

% Interaction between TMS site and training number
disp('------ interaction ------')
[~, p_interaction, ~, stats] = ttest2(learnImprov{1}(:,1)-learnImprov{1}(:,2), learnImprov{2}(:,1)-learnImprov{2}(:,2))


%% Plot all figures
plot_4bars({learnImprov{1}(:,1), learnImprov{2}(:,1), learnImprov{1}(:,2), learnImprov{2}(:,2)}, 0)
%plot_4bars({learnImprov{1}(:,1), learnImprov{2}(:,1), learnImprov{1}(:,2), learnImprov{2}(:,2)}, 1)
plot_2bars({learnImprov{1}(:,3), learnImprov{2}(:,3)})