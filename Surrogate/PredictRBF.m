function y = PredictRBF(decs, centers, Network)

    [mX,nX]=size(decs); 
    [mS,nS]=size(centers); 
    if nX~=nS  
        decs=decs';
        [mX,nX]=size(decs);
    end

    R=zeros(mX,mS);  
    R = pdist2(decs,centers,'euclidean');
    %rho=2;
    Sd=real(sqrt(centers.^2*ones(size(centers'))+ones(size(centers))*(centers').^2-2*centers*(centers')));    % For Gaussian basis function
    rho=max(max(Sd))/(mS*nS)^(1/nS);     % For Gaussian basis function
    
    if strcmp(Network.kernel,'cubic')
        Phi= R.^3;
    elseif strcmp(Network.kernel,'TPS')
        R(R==0)=1;
        Phi=R.^2.*log(R);
    elseif strcmp(Network.kernel,'linear')
        Phi=R;
    elseif strcmp(Network.kernel,'Gaussian')
        Phi=exp(-R.^2/rho^2);
    elseif strcmp(Network.kernel,'multiquad')
        Phi=sqrt((R.^2 + rho^2));
    elseif strcmp(Network.kernel,'invmultiquad')
        Phi=1./sqrt(R.^2 + rho^2);
    end
    y1=Phi*Network.lambda; 
    y2=[decs,ones(mX,1)]*Network.gamma; 
    y=y1+y2;  

end