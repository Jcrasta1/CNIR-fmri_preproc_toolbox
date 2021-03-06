function fmri_plot_diff(plotname, rp_file, thresh, run)
%Plot differential plots
%PlotName usually is Run1 or Run2, etc.
%Rpfile is the full path to the rp file
% order is the differential you'd want 0 is normal motion plot

%
%{
params= load(rp_file);

%grab current directory
rep_dir = cd
%grab the path that the rp file is in- putting motion file in here
path = regexp(rp_file, 'rp', 'split')
path = path{1,1}
cd(path)
%}
%Jan 10, 2016 modified MB Nebel: added labels to points on plots above threshold

if(~exist('thresh', 'var'))
    thresh = 3;
end

old_path= pwd;

[rpath, rfile, rext] = fileparts(rp_file);

dat = load(rp_file);

for order = 1:2
    clear it jt IC C vals itrans irot iro jro
    if (order == 0)
        diff_dat = dat;
    else
        diff_dat = diff(dat, order, 1);
    end
    [itrans] = find(diff_dat(:, 1:3)>thresh);   
    [it, jt] = ind2sub(size(diff_dat), itrans);
    [C, IA, ~] = unique(it);
    vals = diff_dat(sub2ind(size(diff_dat), it(IA), jt(IA)));
    
    fig = figure('Visible', 'off');
    subplot(2, 1, 1)
    axis normal
    plot(diff_dat(:,1), 'R')
    hold on
    plot(diff_dat(:,2),'G')
    plot(diff_dat(:,3),'B')
    text(C, vals, num2str(C), 'HorizontalAlignment', 'center')
    hold off
    grid on
    xlabel('scans')
    ylabel('Difference in millimeters')
    title(strcat(['Order ', num2str(order)], ' Difference in Translational Motion for run', num2str(run)));
%     legend('X', 'Y', 'Z')
    
    clear IC C vals 
    [irot] = find(diff_dat(:, 4:6)*180/pi>thresh);   
    [iro, jro] = ind2sub(size(diff_dat), irot);
    [C, IA, ~] = unique(iro);
    vals = diff_dat(sub2ind(size(diff_dat), iro(IA), jro(IA)));

    subplot(2, 1, 2)
    plot(diff_dat(:, 4)*180/pi,'R');
    hold on
    plot(diff_dat(:,5)*180/pi,'G');
    plot(diff_dat(:,6)*180/pi,'B');
    text(C, vals, num2str(C), 'HorizontalAlignment', 'center')
    hold off
    grid on
    xlabel('scans');
    ylabel('Difference in Degrees');
    title(strcat(['Order ', num2str(order)], ' Difference in Rotation for run', num2str(run)));
%     legend('Pitch','Roll','Yaw');
    print(fig, '-dpsc2', plotname, '-append')
    
%     if(isunix)
%         print(fig, '-dpsc2', plotname, '-append')
%     else
%         print(fig, '-dwinc', plotname, '-append')
%     end
    
end




