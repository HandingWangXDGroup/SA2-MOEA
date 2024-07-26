function Network = TrainingSurrogateRBF(dec, obj, kernel)
    
    Network.kernel = kernel;
    [N, D] = size(dec);
    P = [dec, ones(N, 1)];
    
    R = zeros(N, D);
    R = pdist2(dec,dec,'euclidean');
%     rho=2;
    Sd=real(sqrt(dec.^2*ones(size(dec'))+ones(size(dec))*(dec').^2-2*dec*(dec')));    % For Gaussian basis function
    rho=max(max(Sd))/(N*D)^(1/D);     % For Gaussian basis function
    if strcmp(kernel,'cubic') %cubic RBF
        Phi= R.^3;
    elseif strcmp(kernel,'TPS') %thin plate spline RBF
        R(R==0)=1;
        Phi=R.^2.*log(R);
    elseif strcmp(kernel,'linear') %linear RBF
        Phi=R;
    elseif strcmp(kernel,'Gaussian')
        Phi=exp(-R.^2/rho^2);
    elseif strcmp(kernel,'multiquad')
        Phi=sqrt((R.^2 + rho^2));
    elseif strcmp(kernel,'invmultiquad')
        Phi=1./sqrt(R.^2 + rho^2);
    end
    
    A=[Phi,P;P', zeros(D+1,D+1)];
    RHS=[obj;zeros(D+1,1)];
    params=A\RHS;
    Network.lambda=params(1:N);
    Network.gamma=params(N+1:end);
    
end