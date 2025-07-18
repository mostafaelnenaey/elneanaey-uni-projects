function [yfinal,Rsfinal,Rshfinal] = modelDesigner(Il,Voc,VMPP,IMPP)
% This function determines the model parameters
global Isc1
yfinal = -1;
Rsfinal = -1;
Rshfinal = -1;
    for i = 1:0.01:2      % Loop through y
        Is1 = ReverseCurrentSTC(i);
        for j = 50:1:800 % Loop through Rsh
            for k = 0.005:0.001:0.02 % Loop through Rs
                %check for Voc
                I = currentNewton(Il,0,Is1,Voc,k,i,298,j);
                if(abs(I) < 0.001)
                    % Check for 0 voltage
                    I = currentNewton(Il,0,Is1,0,k,i,298,j);
                    if((abs(I-Isc1)/Isc1) < 0.001)
                        % Check for IMPP at VMPP
                        I = currentNewton(Il,0,Is1,VMPP,k,i,298,j);
                         if((abs(I-IMPP)/IMPP) < 0.001)
                            yfinal = i;
                            Rsfinal = k;
                            Rshfinal = j;
                            I = currentNewton(Il,0,Is1,Voc,k,i,298,j);
                            disp(I);

                            return
                         end
                    end
            
                end


    
            end
        end
    end
end