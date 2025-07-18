function [Is] = ReverseCurrent(Is1,temp,y)
%This function calculates the Reverse current w.r.t temp and gamma
global T1 Vg K q
t = (temp/T1)^(3/y);
r = ((-1*q*Vg)*((1/temp)-(1/T1)))/(y*K);
Is = Is1 * t * exp(r);
end