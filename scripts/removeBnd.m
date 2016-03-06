function FV = removeBnd(FV,Bnd)
% Author: Marta Sanzari, sanzari@diag.uniroma1.it
    iii = 1;
    while iii<=size(FV.faces,1)
        DD1 = FV.faces(iii,1);
        DD2 = FV.faces(iii,2);
        DD3 = FV.faces(iii,3);
        if ~isempty(find(DD1==Bnd, 1)) || ~isempty(find(DD2==Bnd, 1)) || ~isempty(find(DD3==Bnd, 1))
            FV.faces(iii,:)=[];
        else
            iii = iii+1;
        end
    end
    for iii=1:length(Bnd)
        find(FV.vertices(:,1)==Bnd(iii));
    end
    V2=FV.vertices;
    V2(Bnd,:)=[];

end