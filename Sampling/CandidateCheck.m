function [y, decs, MSE, FrontNo, CrowdDis] = CandidateCheck(dec, decs, MSE, FrontNo, CrowdDis, A)
    dist2 = pdist2(real(dec), real(A.decs));
    if min(dist2) > 1e-5
       y = dec; 
    else
       y = [];
       t = 1;
       while t~=0
           [t, loc] = ismember(dec,decs,'rows');
           decs(loc, :) = [];
           MSE(loc, :) = [];
           FrontNo(loc) = [];
           CrowdDis(loc) = [];
           [t, loc] = ismember(dec,decs,'rows');
       end
    end
end