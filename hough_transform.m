function [ro, theta, A, range_ro, x, y, shifted_int_ro] = hough_transform(image)
%Hough Transform using (ro, theta) parameterization
%Using accumulator cells with a resolution of 1 pixel in ro and 1 degree in theta.
%   Input: binary image
%   Outputs: ro, theta, A, range_ro, x, y
% ro = matrix, (# of points, corresponding ro values)
% theta = [-90,90]
% A = vote matrix for intersections
% range_ro = [-sqrt(x^2+y^2),sqrt(x^2+y^2)]
% (x,y) = point pairs

    %location of 1's
    [x,y]=find(image);
    %initializing theta from -90 to 90
    theta=-90:1:90;
    %calculating ro for each (x,y) pairs
    ro=zeros(size(x,1),size(theta,2));
    for i=1:1:size(x,1)
        for j=1:1:size(theta,2)
            ro(i,j)=x(i)*cos(theta(j)*pi/90)+y(i)*sin(theta(j)*pi/90);  %converting to radians
        end
    end
    %finding range of ro, -sqrt(x^2+y^2)<=range_ro<=sqrt(x^2+y^2)
    range_ro=zeros(1,size(x,1));
    for i=1:1:size(x,1)
        range_ro(i)=sqrt((x(i)^2)+(y(i)^2));
    end
    int_range_ro=int8(range_ro);
    %finding vote for each pixel
    int_ro=int8(ro);   %casting to int, resolution of 1
    %{
    ro_min=-max(int_range_ro);
    ro_max=max(int_range_ro);
    A=zeros(size(theta,2),ro_max*2+1);  %x=[theta_min, theta_max]; y=[ro_min, ro_max]
    for i=1:1:size(int_ro,1)    %iterations = number of points
        for j=1:1:size(theta,2)
            % for all (theta,int_ro) add a vote
            for k=ro_min:1:ro_max
                if(int_ro(i,j)==k)
                    A(j,k+ro_max+1)=A(j,k+ro_max+1)+1;  %offset=ro_max+1 to index from 1
                end
            end
        end
    end
    %}
    ro_max=max(int_range_ro);
    %x=[theta_min, theta_max]; y=[ro_min, ro_max]
    A=zeros(ro_max*2+1,size(theta,2));  %ro=rows, theta=columns
    shifted_int_ro=int_ro+ro_max+1; %shifted by 17, 17 is the 0 reference
    for i=1:1:size(shifted_int_ro,1)
        for j=1:1:size(theta,2)
            A(shifted_int_ro(i,j),j)=A(shifted_int_ro(i,j),j)+1;
        end
    end
end