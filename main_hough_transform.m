%% part 2
clear all; close all; clc;

%constructing test image
    test_image=zeros(11);
    points=[1,1; 1,11; 11,1; 11,11; 6,6];
    for i=1:1:size(points,1)
        test_image(points(i,1), points(i,2))=1;
    end
%compute and display HT
    [ro, theta, A, range_ro, x, y, shifted_int_ro]=hough_transform(test_image);
    %image plots (with color bar)
    figure; imagesc(test_image); colorbar; title('Test image');
    xlabel('y'); ylabel('x');
    %theta from -90 to +90, ro from -16 to +16
    figure; imagesc(A); colorbar; title('Hough Transform');
    xlabel('theta (offset by 90+1)'); ylabel('ro (offset by 16+1)');

    %figure; plot(theta, ro(1,:)); hold on; plot(theta, ro(2,:)); plot(theta, ro(3,:));plot(theta, ro(2,:)); plot(theta, ro(4,:)); hold off;
    %figure; plot(theta, int_ro(1,:)); hold on; plot(theta, int_ro(2,:)); plot(theta, int_ro(3,:));plot(theta, int_ro(4,:)); hold off;


%threshold HT and plot corresponding lines over original image
    [ro_th,theta_th,v_th]=find(A>2);
    x=1:1:11;
    figure; hold on;
    
    for i=1:1:size(ro_th,1)
        y = -(cos(theta_th(i)*pi/90)/sin(theta_th(i)*pi/90))*x+(ro_th(i)/cos(theta_th(i)*pi/90));
        plot(y,x);
    end
    figure; imagesc(test_image); colorbar; title('Test image');
    
%% part 3
clear all; close all; clc;
    I=imread('lane.png');
    I=rgb2gray(I);
    E=edge(I, 'sobel');
% computing and displaying HT
    [ro, theta, A, range_ro, x, y, shifted_int_ro]=hough_transform(E);
%HT plot (with color bar)
    figure; imagesc(A); colorbar; title('Hough Transform');
    xlabel('theta (offset by 90+1)'); ylabel('ro (offset by 16+1)');
%Threshold
    [ro_th,theta_th,v_th]=find(A>0.75*max(HT(:)));
    x=1:1:11;
    figure; hold on;
    for i=1:1:size(ro_th,1)
        y = -(cos(theta_th(i))/sin(theta_th(i)))*x+(ro_th(i)/cos(theta_th(i)));
        plot(y,x);
    end