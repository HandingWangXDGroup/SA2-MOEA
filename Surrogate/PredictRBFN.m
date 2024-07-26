function y = PredictRBFN(decs, Network)
    %%
    [N, ~] = size(decs);
    objs = zeros(N, 1);
    %% calculate for every model && return the average predict
    kernal_name = Network.kernal;
    eval(['Z = ', kernal_name, '(decs, Network.centers, Network.sigma);']);
    Z    = [Z, ones(size(Z, 1), 1)];
    objs = Z*Network.weight+objs;
    %%
    y = objs;
end