function [Curr] = PVmod(Volt,Irrad,Temp,y,Rs,Rsh)
% This function calculates the current output given temperature, volt,
% irradiance
IL = IrradianceCurrent(Temp,Irrad);
Is1 = ReverseCurrentSTC(y);
Is = ReverseCurrent(Is1,Temp,y);
Curr = zeros(size(Volt));
for i= 1:1:length(Volt)
    Curr(i) = currentNewton(IL,0,Is,Volt(i),Rs,y,Temp,Rsh);
end
end