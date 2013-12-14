function p = pitch(x, topLine, bottomLine)
    
    %x = topLine;
    lineHeight = (bottomLine - topLine) / 8;
    p = round((bottomLine - x)/lineHeight); % 0 is e2.
    
    pFromA1 = p + 4;
    pFromC1 = p + 9;
    
    octave = floor((pFromC1 + 1)/ 8) + 1;
    
    
    
    moddedPitch =  mod(pFromA1, 7);
    %p = strcat(num2str(p), '//');
    p = char('a' + moddedPitch);
    
    p = strcat(p, int2str(octave));
    
end

