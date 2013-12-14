function p = pitch(x, topLine, bottomLine)
    
    %x = topLine;
    lineHeight = (bottomLine - topLine) / 8;
    
    %(bottomLine - x)/lineHeight
    
    %p = round((bottomLine - x)/lineHeight + 0.4); % 0 is e2.
    p = round((bottomLine - x)/lineHeight); % 0 is e2.
    
    pFromA1 = p + 4;
    octave = floor((pFromA1 + 7)/ 8) + 1;
    
    moddedPitch =  mod(pFromA1, 7);
    p = char('a' + moddedPitch);
    
    p = strcat(p, int2str(octave));
    
end

