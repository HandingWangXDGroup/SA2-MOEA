function [threshold, improvecount, keepcount, improvecount1, keepcount2] = ProbabilityAdjustment(A2, New, threshold, improvecount, keepcount, improvecount1, keepcount2, cycle, flag)
    old_threshold = threshold;
    ND1 = NDSort(A2.objs,1);
    NPopObj1 = A2(ND1==1).objs;
    A3 = [A2, New];
    ND2 = NDSort(A3.objs,1);
    NPopObj2 = A3(ND2==1).objs;
    if PureDiversity(NPopObj1) ~= PureDiversity(NPopObj2)
        if flag == 0
            improvecount = improvecount + 1;
        else
            improvecount1 = improvecount1 + 1;
        end
    else
        if flag == 0
            keepcount = keepcount + 1;
        else
            keepcount2 = keepcount2 + 1;
        end
    end
    if (improvecount + keepcount + improvecount1 + keepcount2) == cycle
        threshold = (improvecount-keepcount+keepcount2)/cycle;
        if old_threshold < 0
            threshold = 0.5;
        end
        improvecount = 0; improvecount1 = 0;
        keepcount = 0; keepcount2 = 0;
    end
end