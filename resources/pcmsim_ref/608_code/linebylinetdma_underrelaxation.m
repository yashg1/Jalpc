function [u,iter]= linebylinetdma_underrelaxation(guess_value,urelax,...
    my_ap,my_an,my_as,my_ae,my_aw,my_b,my_CVx,my_CVy,my_TOL )
%LINE BY LINE TDMA
%Solving by line by line TDMA
error = 1;
iter =0;
u = guess_value;
while error> my_TOL
    iter = iter +1;
    uold = u;
% --------column sweeps from left to right-------------
for j = 2: my_CVx+1
   u(2:my_CVy+1,j) = tdma(my_ap(:,j-1),my_as(:,j-1),my_an(:,j-1),(my_aw(:,j-1).*u(2:my_CVy+1,j-1))+my_b(:,j-1)+(my_ae(:,j-1).*u(2:my_CVy+1,j+1)),my_CVy);   
end 
%-------------row sweeps from i = 1 to CVy ; top to bottom-----------------

for i = 2:my_CVy+1
 u(i,2:my_CVx+1) = tdma(my_ap(i-1,:),my_ae(i-1,:),my_aw(i-1,:),(my_an(i-1,:).*u(i-1,2:my_CVx+1))+my_b(i-1,:)+ (my_as(i-1,:).*u(i+1,2:my_CVx+1)),my_CVx);     
end

% <<<<---------Reverse sweeps------------------>>>>>

% --------column sweeps from right to left-------------
for j = my_CVx+1:-1:2
u(2:my_CVy+1,j) = tdma(my_ap(:,j-1),my_as(:,j-1),my_an(:,j-1),(my_aw(:,j-1).*u(2:my_CVy+1,j-1))+my_b(:,j-1)+(my_ae(:,j-1).*u(2:my_CVy+1,j+1)),my_CVy);
end 

% ------------row sweeps from bottom to top--------------

for i = my_CVy+1:-1:2
 u(i,2:my_CVx+1) = tdma(my_ap(i-1,:),my_ae(i-1,:),my_aw(i-1,:),(my_an(i-1,:).*u(i-1,2:my_CVx+1))+my_b(i-1,:)+ (my_as(i-1,:).*u(i+1,2:my_CVx+1)),my_CVx);
end

error= max(max(abs((uold-u)./u)));
% hold on
% subplot(3,2,4),plot(iter,error,'k*'),title('Iter vs error'),xlabel('iter'),ylabel('error')
u = uold + urelax.*(u-uold);
end
end

