function [corrCI,corr_h0,corry] = corrcoefslices_rank(dat,target,orbit7,dt,pad,sr1,sr2,srstep,adjust,red,nsim,plotn,slices,method)
% Modify from corrcoefsig.m, but replace display with a function of slices
% INPUT
%   dat: 2 column time series of depth and value. Unit of depth must be m
%           The first column must be evenly spaced
%   target: target series, generated from gentarget.m
%   orbit7: 7 orbital target frequencies
%   dt: sample rates of input series (the dat)
%   pad: zero-padding of periodogram of input series: dat. default = 5000
%   sr1: begining sedimentation rates to be estimated, unit must be cm/kyr
%   sr2: end sedimentation rates to be estimated for correlation and H0,
%           unit must be cm/kyr
%   srstep: step of sedimentation rates. unit must be cm/kyr
%       Note: (sr2-sr1)/srstep may be < 200 for a faster estimation
%   adjust:
%   red: 1 = remove AR1 noise
%   nsim: number of simulation for H0 significant level of correlation coefficient
%   plotn: 1 = plot results. else = no plot
% 
% OUTPUT
%   corrCI:     6-column series; 
%                   c1 = tested sedimentation rates
%                   c2 = correlation coefficient for each sed. rates
%                   c3 = p-value of c2
%                   c4 = lower limit of 95% confidence interval of c2
%                   c5 = upper limit of 95% confidence interval of c2
%                   c6 = nmi
%   corr_h0:    3-column series
%                   c1 = Monte carlo simulation significant level of the null
%                       hypothesis (H0) that there is no orbital forcing
%                       with dat series
%                   c2 = H0 SL X correlation coefficient
%                   c3 = H0 SL X (correlation coefficient - 0.3)
% 
% CALLS FOR
%   data_slices
%   targetrebuilt
%   theoredar1ML
%   target_real
%   findpeaks
%   cyclecorr4
%   cyclecorr4sig
%   randspec_sin
%   cyclecorr5   % Monte Carlo simulation for H0 significant level
%   
%   Mingsong Li, June 2017 @ Penn State
%%
if nargin > 14
    error('Too many input arguments')
    return;
end
if nargin < 14
    method = 'Pearson';
    if nargin < 13
        slices = 1;
        if nargin < 12
        plotn = 1;
            if nargin < 11
                nsim = 0;  % no Monte Carlo simulation for confidence level estimation
                if nargin < 10
                    red = 1;
                    if nargin < 9
                        adjust = 1;
                        if nargin < 8
                            srstep = 0.2;  % sedimentation rate is 0.2 cm/kyr
                            if nargin < 7
                                sr2 = 20;   % default sed. rate from 0.1 to 20 cm/kyr
                                if nargin < 6
                                    sr1 = 0.1;  % default sed. rate from 0.1 to 20 cm/kyr
                                    if nargin < 5
                                        pad = 5000; % zero-pading = 5000
                                        if nargin < 4
                                            %dt = dat(2,1)-dat(1,1);
                                            dt = median(diff(dat(:,1)));
                                            if nargin < 3
                                                error('Too few input arguments')
                                                return;
                                            end
                                        end
                                    end
                                end
                            end
                        end    
                    end
                end
            end
        end
    end
end
display = 1;  % show simulation steps

%% Slice
if isreal(slices) && slices > 0 && ~mod(slices,1)
   if slices > 1
       dat_slice = data_slices(dat,slices);  % remove mean value; cut into slices
       dat_demean = [dat(:,1),detrend(dat(:,2),0)];
   else
       time = dat(:,1);
       %value = (dat(:,2)-mean(dat(:,2)))/std(dat(:,2));  % standardized
       value = dat(:,2);
       dat_slice = [time,detrend(value,0)];  % subtract mean value
       dat_demean = dat_slice;
   end

else
    disp('Error: Number of split slices must be a real, positive AND integer number.')
    return;
end
%% data
dataf =[];
datap =[];
for j = 1: slices
    dat_nyq = 1/(2*dt);   % Nyquist
    dat_ray = 1/(length(dat_slice(:,1)) * dt);  % rayleigh
    [p,f] = periodogram(dat_slice(:,2*j),[],pad,1/dt);  % power of dat
    % remove AR1 noise
    if red == 1
        [theored]=theoredar1ML(dat(:,2),f,mean(p),dt);
        p = p ./ theored;
        p = p - 1;
        p(p<0) = 0;   % power removing AR(1) noise
    elseif red == 2
        [theored]=theoredar1ML(dat(:,2),f,mean(p),dt);
        p = p - theored;
        p(p<0) = 0;   % power removing AR(1) noise
    elseif and (red >= 50, red < 100)
        [theored]=theoredar1ML(dat(:,2),f,mean(p),dt);
        facchired = 2*gammaincinv(red/100,2)/(2*2);
        tabtchired = theored * facchired;
        p = p ./ tabtchired;
        p = p - 1;
        p(p<0) = 0;   % power removing AR(1) noise
    end
    dataf(:,j) = f;
    datap(:,j) = p;
end
    data = [f,mean(datap,2)];
% plot power spectra
    if plotn == 1
        ax2 = subplot(2,1,2); 
        plot(ax2,f,data(:,2),'r','LineWidth',1);
        hold on
        if slices > 1
            plot(ax2,f,datap,'LineWidth',.3);
        end
        xlabel(ax2,'Frequency (cycle/m)');
        ylabel(ax2,'Power');
        title(ax2,'Data power spectrum');
        legend(ax2,'Power spectrum of data series')
        set(ax2,'XMinorTick','on','YMinorTick','on')
    % save data to workspace
        assignin('base','dataf',dataf)
        assignin('base','datap',datap)
        assignin('base','data',data)
    end
%% target
target_real= target;  % save target frequencies-power series
targetnew = targetrebuilt(target);  % get peaks from given target
targetf = targetnew(:,2);
targetp = targetnew(:,1);
%  Number of peaks in the power spectrum of real data series?
[pks,~] = findpeaks(data(:,2));
npks = length(pks);
assignin('base','targetnew',targetnew)

%% sr0 - a key boundary sedimentary rate
f_nyq_target = target_real(length(target_real(:,1)),1);
sr0 = f_nyq_target * 100/dat_nyq;
assignin('base','sr0',sr0)
%% correlation coefficient and its 95% significant level

% [corrxch,corry_rch,corrpych,corrloch,corrupch,nmi] = ...
%     cyclecorr4(data,targetf,targetp,target_real,orbit7,dat_ray,sr1,sr2,srstep,sr0,adjust);
[corrxch,corry_rch,corrpych,nmi] = ...
    cyclecorr(data,targetf,targetp,target_real,orbit7,dat_ray,sr1,sr2,srstep,sr0,adjust,method);
corrCI = [corrxch,corry_rch,corrpych,nmi];

%% simulation:  corry (sr x nsim) correlation coefficient
sr_range = sr1:srstep:sr2;
mpts = length(sr_range);
%critical = 100/mpts;% critical significance level by Steve Meyers

if nsim > 0
    % Waitbar
    hwaitbar = waitbar(0,'Monte Carlo. Heavy loads, processing ...',...    
       'WindowStyle','modal');
    hwaitbar_find = findobj(hwaitbar,'Type','Patch');
    set(hwaitbar_find,'EdgeColor',[0 0.9 0],'FaceColor',[0 0.9 0]) % changes the color to blue
    setappdata(hwaitbar,'canceling',0)
    steps = 100;
    % step estimation for waitbar
    nmc_n = round(nsim/steps);
    waitbarstep = 1;
    waitbar(waitbarstep / steps)
    %% Monte Carlo simulation
    corry = zeros(mpts,nsim);
    for i = 1: nsim
        randspectrum = randspec_sin(f,npks,dat_ray);
        sim_spectum = [f,randspectrum];
        %[prand,frand] = randpermperiodogram(dat_demean,dt,pad); % Mingsong Li, 20180417
        %sim_spectum = [frand,prand]; % Mingsong Li, 20180417
        corryi = cyclecorrsig(sim_spectum,targetf,targetp,target_real,orbit7,dat_ray,sr1,sr2,srstep,sr0,adjust,method);
        if display == 1
            disp(['>> Step 2: Simulation ',num2str(i),' of ',num2str(nsim)])
            %disp(['>> Step 2: Simulation ',num2str(i),' of ',num2str(nsim),'. mpts ',num2str(mpts),' corryi ',num2str(length(corryi))])
        end
        corry(:,i) = corryi;

        if rem(i,nmc_n) == 0
            waitbarstep = waitbarstep+1; 
            if waitbarstep > steps; waitbarstep = steps; end
            pause(0.001);%
            waitbar(waitbarstep / steps)
        end
        if getappdata(hwaitbar,'canceling')
            break
            %delete(hwaitbar)
        end
    end
    if ishandle(hwaitbar); 
        close(hwaitbar);
    end
    assignin('base','sim_spectum',sim_spectum)
    %% MC results
    corry_sim_sort = sort(corry,2);
    corrlength = length(corry_rch);  % number of tested sed. rate
    corry_per = zeros(corrlength,1);
    %
    %assignin('base','corry_rch',corry_rch)
    %assignin('base','corry',corry)
    %
    for i = 1: corrlength
        corry_r1 = corry_rch(i);
        corry_sim_sort1 = corry_sim_sort(i,:);
        %corry_sim_sort2 = [];
        corry_sim_sort2 = corry_sim_sort1(corry_sim_sort1<corry_r1); % number of corr-value that is less than real data
        totallength = length(corry_sim_sort1(~isnan(corry_sim_sort1))); % number of not-null value
        %corry_per(i) = (totallength-length(corry_sim_sort2))/nsim;
        corry_per(i) = (totallength-length(corry_sim_sort2)+1)/(totallength+1); % Dec. 29, 2017 revised by M. Li
        if corry_per(i) == 0
            corry_per(i) = 1/(totallength+1);
        end
    end
    %% confidence interval estimation for correlation coefficient
    
    corr_h0 = corry_per;  % percentile of the value
    corr_h0(:,2) = (7-corrCI(:,end));   % number of orbits involved
    if plotn == 1
        
        figure;
        ax1 = subplot(3,1,1);
        plot(ax1,corrxch,corry_rch,'r','LineWidth',1);
        xlabel(ax1,'Sedimentation rate (cm/kyr)')
        ylabel(ax1,'\rho')
%       legend('Corrcoef','95% CI ch','95% CI ch')
        %legend(['Corrcoef ',method])
        %line([sr1, sr2],[.5, .5],'LineStyle','--','Color','b')
        %line([sr1, sr2],[.3, .3],'LineStyle',':','Color','b')
        title(ax1,'Correlation coefficient')
        set(ax1,'XMinorTick','on','YMinorTick','on')
        % plot H0 test of Monte carlo simulation
        ax2 = subplot(3,1,2);
        semilogy(ax2,corrxch,corry_per,'r','LineWidth',1); 
        xlabel(ax2,'Sedimentation rate (cm/kyr)')
        ylabel(ax2,'H_0 significance level')
        title(ax2,'Null hypothesis')
        ylim(ax2,[0.5*min(corry_per) 1])
        line([sr1, sr2],[.10, .10],'LineStyle',':','Color','k')
        line([sr1, sr2],[.05, .05],'LineStyle',':','Color','k')
        line([sr1, sr2],[.01, .01],'LineStyle','--','Color','k')
        line([sr1, sr2],[.001, .001],'LineStyle',':','Color','k')
        %legend(ax2,'H_0 Sig.level','10%','5%','1 %','0.1%')
        set(ax2,'Ydir','reverse')
        set(ax1,'XMinorTick','on')
        % Plot number of orbital cycles
        ax3 = subplot(3,1,3);
        plot(ax3,corrxch,corr_h0(:,2),'b','LineWidth',1);
        xlabel(ax3,'Sedimentation rate (cm/kyr)')
        ylabel(ax3,'#')
        title(ax3,'Number of contributing astronomical parameters')
        ylim(ax3,[0 7.5])
        set(ax1,'XMinorTick','on')
        %yticks(ax3,[1 2 3 4 5 6 7])
        %legend('# orbits')
    end
else
    corr_h0 = zeros(mpts,1);
    corry = [];
end

%%
function datanew = data_slices(dat, slices)
    % INPUT: data input
    datanew = [];
    if slices <= 1
        return
    end
    x = dat(:,1);
    data_size = size(x);
    data_length = data_size(1,1);
    t1 = dat(1,1);
    tn = dat(data_length,1);
    slice = linspace(t1, tn, slices+1);
    
    for i = 1: slices
        data_int = select_interval(dat,slice(i),slice(i+1));
        time = data_int(:,1);
        value = (data_int(:,2)-mean(data_int(:,2)))/std(data_int(:,2));
        data_int = [time,detrend(value,0)];
        time_len(i) = length(time);
        if max(time_len) > time_len(i)
            datanew(1:time_len(i),(2*i-1):(2*i)) = data_int;
        elseif max(time_len) < time_len(i)
            datanew((time_len(i-1)+1):time_len(i),(2*i-3):(2*i-2)) = 0;
            datanew(:,(2*i-1):(2*i)) = data_int;
        else
            datanew(:,(2*i-1):(2*i)) = data_int;
        end
    end