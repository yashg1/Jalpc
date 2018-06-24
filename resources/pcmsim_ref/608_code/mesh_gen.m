function [x_increment,y_increment,xface,yface,xx,yy,xp,yp,x,y] = mesh_gen(CVx,CVy,l,w)
x_increment = l./CVx;
y_increment= w./CVy;
[xface,yface] = meshgrid(0:x_increment:l,0:y_increment:w);%check
for i = 1:(size(xface,2)-1) %Generate cell centroids in x
    xp(i) = (xface(1,i)+xface(1,i+1))./2; 
end
for i = 1:(size(yface,1)-1)%Generate cell centroids in y 
    yp(i) = (yface(i,1)+yface(i+1,1))./2; 
end
[xx,yy] = meshgrid(xp,yp); %Generate 2d gridpoints
x = zeros([1,(CVx+2)]);
y = zeros([(CVy+2),1]);
x(1,2:(CVx+1)) = xp;
y(2:(CVy+1),1) = yp;
x(1,1) = 0.0;
x(1,CVx+2) = l;
y(1,1) = 0;
y(CVy+2,1) = w;


end

