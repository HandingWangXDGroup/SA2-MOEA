function A1 = InitialSelection(A2, N, kappa)
    Next = 1 : length(A2);
    [Fitness,I,C] = CalFitness(A2.objs,kappa);
    while length(Next) > N
        [~,x]   = min(Fitness(Next));
        Fitness = Fitness + exp(-I(Next(x),:)/C(Next(x))/kappa);
        Next(x) = [];
    end
    A1 = A2(Next);

end