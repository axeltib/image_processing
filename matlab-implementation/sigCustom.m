function sig = sigCustom(x, k)
%SIGCUSTOM Summary of this function goes here

b = 1; c = 1;
sig = 1 ./ (1+exp(-k*x+b) * (c+1)); 

end

