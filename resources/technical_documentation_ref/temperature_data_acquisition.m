%% README
%% Input Data: 2D Temperature maps (1 million pixels) recorded at 2 frames/second for 8 - 10 minutes
% Read DAT file containing temperatures using file input/output and reshape
% into Temperature array
%% Objective: Convert temperature movie data recorded from Infra-red camera into an array for post-processing:
%% Output: 3D Temperature array (Temp) of size (1024,1024,Total Number of
% Frames)
%% Code features:
% a. 2D surface temperature map using Image Processing (imagesc,imrotate)
% b. temperature variation of a point with time (find max temperature)
% c. line average temperature variation with time
% d. Generate, visualize and save movies of transient temperature variation
% Select region of interest (ROI) for data analysis using user inputs
% (ginput)
%% Contribution
% Yash Ganatra automated code to loop over multiple files, post-process data and generate movies. 
% File handling done by Prof Amy Marconnet, Purdue University. 
%% CODE STARTS
clear all, clc, close all
filepath = '\\caffeine.ecn.purdue.edu\mtec\Project Logs\Students\Yash Ganatra\Yash ref images\7_5_Paraffin62_Copper_15_15_5';
%my_filename = {'linpack_1'};      %  tmmovie files (and rawmovie if available)
my_filename = {'linpack_1'};
%timefile = '9_movie_linpack_2';      %  Text file with exported Temp vs Time data 
count =0;
Lens = 1;   % Magnification: 1, 4, or 20. Manually input if no rawmovie file
for filename_iter = my_filename
    count =count+1;
    filename = filename_iter{1}; % For indexing purposes only
    timefile = filename_iter{1}; 
    fprintf('%s\n',filename);
if ~exist([filepath '\' timefile '.mat'], 'file')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                     Load Time Data (seconds)                                    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if exist( [filepath '\' timefile], 'file')
        [Data,delim_out] = importdata([filepath '\' timefile]);
        if(size(Data,2)==4) %some imports have the conversion from msec -> mins built in
            disp('enter1')
            t = Data(:,3); %%check for which files mins -> sec
        else
             t = Data(:,2).*0.001; % msec -> sec
        end
       
        Nf = length(t);
    elseif exist( [filepath '\' timefile '.txt'], 'file')
        [Data,delim_out] = importdata([filepath '\' timefile '.txt']);
        if(size(Data,2)==4) % some imports have the conversion from msec -> mins built in
            t = Data(:,3);% mins -> sec
            disp('enter2')
        else
             t = Data(:,2).*0.001; % msec -> sec
        end
        Nf = length(t);
    else
        Nf = 1000;  % approximate maximum number of frames (overestimate if unknown)
        t = [1:Nf];
        warning('No Time Data');
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                     Convert Movie to Data                              %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    file = [filepath '\' filename '.tmmovie'];
    fID = fopen(file,'r');
    Temp = NaN.*ones(1024,1024,Nf); Rad = Temp; % 3D array with time sweeps
    fseek(fID,-1-4*1024*1024,'eof'); % Starting from end of line, move fID towards beginning of line 
    %% fread(fid, count, precision)
    %%
    % N(1) = ftell(fID);
    Temp(:,:,1) = reshape(fread(fID,1024*1024,'real*4'),1024,1024);
    fseek(fID,-10-2*4*1024*1024,'cof');
    Rad(:,:,1) = reshape(fread(fID,1024*1024,'real*4'),1024,1024);
    % figure(1)
    %  subplot(1,2,1), imagesc(Temp(:,:,1)), colorbar
    %  subplot(1,2,2), imagesc(Rad(:,:,1)), colorbar

    for i2 = 1:Nf
        if ftell(fID)-(4*1024*1024*2)-220 <= 0 
            disp(['Reached beginning of file at ' num2str(i2) ' frames'])
            break
        end
        fseek(fID,-(4*1024*1024*2)-220,'cof');    
    %     N(i2) = ftell(fID);
        Temp(:,:,i2) = reshape(fread(fID,1024*1024,'real*4'),1024,1024);
    %     subplot(1,2,1)
    %     imagesc(Temp(:,:,i2)), colorbar, title(i2)
    %     pause(0.1)

        fseek(fID,-(4*1024*1024*2)-10,'cof');
        Rad(:,:,i2) = reshape(fread(fID,1024*1024,'real*4'),1024,1024);
    %     subplot(1,2,2)
    %     imagesc(Rad(:,:,i2)), colorbar
    %     title(i2)
    %     pause(0.1)

        if rem(i2, 100) == 0
            disp(['processing frame ', num2str(i2)])
        end
    end
    fclose(fID);
    disp(i2);
    Nf = i2;
    Temp = Temp(:,:,end:-1:1); Temp = Temp(:,:,1:Nf);
    Rad = Rad(:,:,end:-1:1); Rad = Rad(:,:,1:Nf);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                         Determine Pixel Size                           %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if exist([filepath '\' filename '.rawmovie'],'file')
        file = [filepath '\' filename '.rawmovie'];
        fID = fopen(file,'r');
        info = fgetl(fID);
        fclose(fID);

        i1 = strfind(info,'x MWIR');
        Lens = info(i1-1);
        switch Lens
            case '1'
                PS = 11.7188;
            case '4'
                PS = 2.9297;
            case '0'
                PS = 0.5859;
        end
    else
        switch Lens
            case 1
                warning('Manual Input Pixel Size Info - 1x')
                PS = 11.7188;
            case 4
                warning('Manual Input Pixel Size Info - 4x')
                PS = 2.9297;
            case 20
                warning('Manual Input Pixel Size Info - 20x')
                PS = 0.5859;
            otherwise 
                warning('No Pixel Size Info - Assuming 1x')
                PS = 11.7188;
        end
    end


    save([filepath '\' timefile '.mat'], 'Temp','PS','t','-v7.3')
else
    disp('Loading data from *.mat file')
    load([filepath '\' timefile '.mat'])
    Nf = length(t);
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Rotate & Crop Images                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[a IN] = max(mean(mean(Temp)));    % find hottest frame (frame -> IN)
T1 = Temp(:,:,IN);
figure(1), imagesc(T1), hold all  
axis equal 
colorbar 
axis([1 1024 1 1024])

title(['\fontsize{16}  \color{red} Pick 2 points to specify angle of heater']);
% if (count==1)
[g,h] = ginput(2);
disp('Values of heater angle')
fprintf('g = %d\n h = %d\n ',g,h);
%keyboard
% end
title(' ')
% g = [179.9504;856.9796];
% h = [ 154.5991; 145.6516];
plot(g,h,'w')
th = atan(diff(h)/diff(g))*180/pi;
T1 = imrotate(T1,th);
T1(T1 == 0) = NaN;
clf, imagesc(T1), hold all  
axis equal 
colorbar 
a = axis;
de = 15;
axis([a(1)-de a(2)+de a(3)-de a(4)+de])
figure(1)
title(['\fontsize{16}  \color{red} Pick 2 points to specify bounding box for averaging']);
[c,d] = ginput(2); % pick 2 points ; c-> xdata, d->ydata
title(' ')
disp('Values of bounding box');
fprintf('g = %d\n h = %d\n ',g,h);
% d = [157;925];
% c = [158;884];
c = round(c); d=round(d);
plot([c(1) c(1) c(2) c(2) c(1)], [d(1) d(2) d(2) d(1) d(1)],'w')

check_ginput = [min(d):max(d),min(c):max(c)];
for i1 = 1:Nf
    T1 = Temp(:,:,i1);
    T1 = imrotate(T1,th);  
    I(:,:,i1) = T1(min(d):max(d),min(c):max(c));
end
check_shape_I = size(I,3);
% I: after selecting bounding box
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Plot the data                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot the Tavg(t) [Tavg is average over selected region]
figure(10)
Tavg = mean(mean(I,1),2);           % average entire bounding box at each timestep
Tavg = reshape(Tavg,size(Tavg,3),1);
check_size = size(Tavg,3);
plot(t,Tavg)
xlabel('t')
ylabel('T')

% Plot the T(y) at all times - averaging each row of pixels
figure(11)
T1 = mean(I,2); %average out x (rows)
T1 = reshape(T1,size(T1,1),size(T1,3));
check_T1_row = size(T1,1);
check_T1_columns = size(T1,3);

y = [0:size(T1,1)-1].*PS;
plot(y,T1)
xlabel('y')
ylabel('T')


% Plot the T(x) at all times - averaging each column of pixels
figure(12)
T2 = mean(I,1); 
T2 = reshape(T2,size(T2,2),size(T2,3));
x = [0:size(T2,1)-1].*PS;
plot(x,T2)
xlabel('x')
ylabel('T')

% 
%% Savefigs - change for Different movies
%%
switch filename
    case my_filename{1}
        append = 'linpack_1';
    case my_filename{2}
        append = 'linpack_2';
    case my_filename(3)
        append = 'linpack_3';
end
disp(append)
saveas(1,([filepath '\Results\' append '\' timefile   '_box']),'jpeg')
saveas(10,([filepath '\Results\' append '\' timefile   '_thist']),'jpeg')
saveas(10,([filepath '\Results\' append '\' timefile  '_thist']),'fig')
saveas(11,([filepath '\Results\' append '\' timefile  '_T_y']),'jpeg')
saveas(11,([filepath '\Results\' append '\' timefile  '_T_y']),'fig')
saveas(12,([filepath '\Results\' append '\' timefile  '_T_x']),'jpeg')
saveas(12,([filepath '\Results\' append '\' timefile '_T_x']),'fig')

%%
% % Plot the T(t) at one selected point
% cont = 1;
% while cont == 1
%     T1 = Temp(:,:,IN);
%     figure(13)
%     subplot(2,5,[1:2,6:7]), imagesc(T1), hold all  
%         axis equal 
%     %     colorbar 
%         axis([1 1024 1 1024])
%         axis off
%         title(['\fontsize{16}  \color{red} Pick 1 point']);
%         [g,h] = ginput(1);
%         title(' ')
%         plot(g,h,'w*')
%     subplot(2,5,[4:5,9:10])
%         Ti = Temp(round(h),round(g),:); Ti = reshape(Ti,1,size(Ti,3));
%         plot(t,Ti,'.'), hold all
%         xlabel('t'), ylabel('T')
%     cont = input('Continue (1 = yes, else = no): ')
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %Play Movie                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(count==3)
    break
end
% filename = ['tx_' num2str(rate) 'Mhz'];  
file_path_movie = ([filepath '\Results\' append '_movie\']);
figure(20),clf
disp(file_path_movie)
for i1 = 1:10:Nf %every 10 frames
     imagesc(Temp(:,:,i1)), colorbar
     colormap jet
     axis equal
     axis off
     caxis([min(min(min(Temp))) max(max(max(Temp)))]) %note
     title(i1)
     saveas(20,[file_path_movie '\f_' num2str(i1)],'jpeg');
     saveas(20,[file_path_movie '\f_' num2str(i1)],'fig');
     pause(0.01)
end
end