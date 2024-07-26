function [Train_A, Test_A] = DataDivision(A1)
    num =  size(A1, 2);
    train_num = ceil(0.8 * num);
    index = randperm(num, train_num);
    indexArray = zeros(1,num);
    indexArray(1,index) = true;
    Train_A = A1(1,logical(indexArray));
    Test_A = A1(1, logical(~indexArray));
end