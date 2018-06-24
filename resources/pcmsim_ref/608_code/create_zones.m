function [ zone ] = create_zones(CVx,CVy)
zone = zeros([CVy,CVx]);
zone(2:(CVy-1),2:(CVx-1)) = 1; %interior nodes
zone(1,2:(CVx-1)) = 2; %top boundary
zone(CVy,2:(CVx-1)) = 3; %bottom boundary
zone(2:(CVy-1),1) = 4; %left boundary
zone(2:(CVy-1),CVx) = 5; %right boundary
zone(1,1) = 6; %Left top
zone(1,CVx) = 7; %Right top
zone(CVy,1) = 8; %Left bottom
zone(CVy,CVx) =9 ; %Right bottom
end

