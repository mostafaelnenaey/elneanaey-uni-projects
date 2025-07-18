function [Is1] = ReverseCurrentSTC(y)
% This calculates the reverse current of the diode in STC
global q Voc K T1 n Isc1
x = exp((q*(Voc/n))/(y*K*T1));
Is1 = Isc1/(x-1);
end