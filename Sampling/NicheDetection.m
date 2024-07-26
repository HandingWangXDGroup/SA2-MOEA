function New = NicheDetection(Popdec, A1)
        
        New = [];
        while isempty(New)
            while ~isempty(Popdec)
               dist2 = pdist2(real(Popdec(1, :)), real(A1.decs));
               if min(dist2) > 1e-4
                   New = Popdec(1, :);
                   break;
               else
                   t = 1;
                   dec = Popdec(1, :);
                   while t~=0
                       Popdec(1, :) = [];
                       [t, loc] = ismember(dec,Popdec,'rows');
                       if t == 1
                          Popdec(loc, :) = [];
                       end
                       [t, ~] = ismember(dec,Popdec,'rows');
                   end
               end
               
            end
            if isempty(Popdec)
               break; 
            end
        end

end