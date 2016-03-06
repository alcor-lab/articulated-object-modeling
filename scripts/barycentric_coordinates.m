function [Coords] = barycentric_coordinates(X, Y, nodes)
% Author: Marta Sanzari, sanzari@diag.uniroma1.it

    for ii=1:size(nodes,1)
        
        u1 = X(nodes(ii,1));
        v1 = Y(nodes(ii,1));
        
        u2 = X(nodes(ii,2));
        v2 = Y(nodes(ii,2));
        
        u3 = X(nodes(ii,3));
        v3 = Y(nodes(ii,3));

        a1 = u2*v3-u3*v2;
        b1 = v2-v3;
        c1 = u3-u2;

        a2 = u3*v1-u1*v3;
        b2 = v3-v1;
        c2 = u1-u3;

        a3 = u1*v2-u2*v1;
        b3 = v1-v2;
        c3 = u2-u1;

        area = (a1+a2+a3)/2; 
        
        Coords(ii).Vertices = [u1 v1;u2 v2;u3 v3];
        
        Coords(ii).L = [a1 b1 c1;a2 b2 c2;a3 b3 c3];
        Coords(ii).Area = area;
        
        Coords(ii).J1inv = (1/(2*area))*[b1 b2 b3;c1 c2 c3];
        Coords(ii).J2inv = (1/(4*area*area))*[b1*b1 2*b1*b2 b2*b2 2*b2*b3 b3*b3 2*b3*b1
                                              c1*c1 2*c1*c2 c2*c2 2*c2*c3 c3*c3 2*c3*c1
                                              2*b1*c1 2*(b1*c2+b2*c1) 2*b2*c2 2*(b2*c3+b3*c2) 2*b3*c3 2*(b3*c1+b1*c3)]; 
    end
    
end