function [Il] = IrradianceCurrent(temp,irradiance)
%This functions computes current due to tempreature and irradiance 
global Isc1 S1 Ko T1;
Il = Isc1 * (irradiance/S1) * (1 + Ko * (temp - T1));
end