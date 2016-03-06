function [gamma12, gamma23, gamma31] = Gammaij(Vert)
% Author: Marta Sanzari, sanzari@diag.uniroma1.it
    if size(Vert,1)~=3
        error('Vert should be a column array of size 3');
    end
    x1 = Vert(1,1);
    y1 = Vert(1,2);
    
    x2 = Vert(2,1);
    y2 = Vert(2,2);
    
    x3 = Vert(3,1);
    y3 = Vert(3,2);
    
    Ed1 = [x2-x1, y2-y1];
    Ed2 = [x1-x3, y1-y3];
    Ed3 = [x3-x2, y3-y2];
    
    Ed1 = Ed1./norm(Ed1);
    Ed2 = Ed1./norm(Ed2);
    Ed3 = Ed1./norm(Ed3);
    
    gamma12 = acos(dot([1 0],Ed1));
    gamma31 = acos(dot([1 0],Ed2));
    gamma23 = acos(dot([1 0],Ed3));
    
    if gamma12==2*pi
        gamma12 = 0;
    elseif gamma23==2*pi
        gamma23 = 0;
    elseif gamma31==2*pi
        gamma31 = 0;
    end
    
%     M1 = [(x1+x2)/2 (y1+y2)/2];
%     M2 = [(x1+x3)/2 (y1+y3)/2];
%     M3 = [(x3+x2)/2 (y3+y2)/2];
    
    
    if gamma12>=(pi/2) && gamma12<(3*pi)/2
        gamma12 = mod(gamma12+pi,2*pi);
%         figure;
%         plot([Vert(:,1);Vert(1,1)],[Vert(:,2);Vert(1,2)]); hold on;
%         plot(M1(1),M1(2),'r+'); hold on;
%         plot([M1(1);(M1(1)+0.5)],[M1(2);M1(2)]); hold on;
%         plot_arc(0,gamma12,M1(1),M1(2),0.2)
%         axis equal
    end
    
    if gamma23>=(pi/2) && gamma23<(3*pi)/2
        gamma23 = mod(gamma23+pi,2*pi);
%         figure;
%         plot([Vert(:,1);Vert(1,1)],[Vert(:,2);Vert(1,2)]); hold on;
%         plot(M2(1),M2(2),'g+'); hold on;
%         plot([M2(1);(M2(1)+0.5)],[M2(2);M2(2)]); hold on;
%         plot_arc(0,gamma23,M2(1),M2(2),0.2)
%         axis equal
    end
    
    if gamma31>=(pi/2) && gamma31<(3*pi)/2
        gamma31 = mod(gamma31+pi,2*pi);
%         figure;
%         plot([Vert(:,1);Vert(1,1)],[Vert(:,2);Vert(1,2)]); hold on;
%         plot(M3(1),M3(2),'y+'); hold on;
%         plot([M3(1);(M3(1)+0.5)],[M3(2);M3(2)]); hold on;
%         plot_arc(0,gamma31,M3(1),M3(2),0.2)
%         axis equal
    end
    
    
    
    if gamma12>=(pi/2) && gamma12<(3*pi)/2
        error('gamma12 wrong');
    end
    if gamma23>=(pi/2) && gamma23<(3*pi)/2
        error('gamma23 wrong');
    end
    if gamma31>=(pi/2) && gamma31<(3*pi)/2
        error('gamma31 wrong');
    end
    
    
    
%     NN(1,:) = [Ed1(2), -Ed1(1)];
%     NN(2,:) = [Ed2(2), -Ed2(1)];
%     NN(3,:) = [Ed3(2), -Ed3(1)];
%     
%     D1 = dot(NN(1,:),Ed2);
%     if D1>0
%         NN(1,:) = -NN(1,:);
%     end
%     
%     D2 = dot(NN(2,:),Ed1);
%     if D2>0
%         NN(2,:) = -NN(2,:);
%     end
%     
%     D3 = dot(NN(3,:),Ed1);
%     if D3>0
%         NN(3,:) = -NN(3,:);
%     end
%     
    
%     M1 = [(x1+x2)/2 (y1+y2)/2];
%     M2 = [(x1+x3)/2 (y1+y3)/2];
%     M3 = [(x3+x2)/2 (y3+y2)/2];
%     figure;
%     plot([Vert(:,1);Vert(1,1)],[Vert(:,2);Vert(1,2)]); hold on;
%     plot(M1(1),M1(2),'r+'); hold on;
%     plot(M2(1),M2(2),'g+'); hold on;
%     plot(M3(1),M3(2),'y+'); hold on;
%     plot([M1(1);M1(1)+M1(1)*NN(1,1)],[M1(2);M1(2)+M1(2)*NN(1,2)]); hold on;
%     plot([M2(1);M2(1)+M2(1)*NN(2,1)],[M2(2);M2(2)+M2(2)*NN(2,2)]); hold on;
%     plot([M3(1);M3(1)+M3(1)*NN(3,1)],[M3(2);M3(2)+M3(2)*NN(3,2)]); hold on;
%     axis equal
    
end