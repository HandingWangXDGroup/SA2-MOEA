function Network = TrainingSurrogateRBFN(dec, obj, num, kernel)
         
         
         Network.kernal=kernel;          
         Network.centers=center_obtain(dec,num);
         Network.sigma = mean(pdist(Network.centers));
         Output = Output_Hidden(dec,Network);
         Network.weight=inv(Output'*Output)*Output'*obj;
         
end