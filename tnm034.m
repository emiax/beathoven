%%%%%%%%%%%%%%%%%%%%%%%%%% 
function strout = tnm034(im) 
% 
% im: Input image of captured sheet music. Im should be in 
% double format, normalized to the interval [0,1] 
% 
% strout: The resulting character string of the detected notes. 
% The string must follow the pre-defined format, explained below. 
% 
% Your program code? 
%%%%%%%%%%%%%%%%%%%%%%%%%%

strout = beathoven(im);

