function p = pitch(x, topLine, bottomLine)
    
    %x = topLine;
    lineHeight = (bottomLine - topLine) / 8;
    p = mod(round((bottomLine - x)/lineHeight)+4, 7);
    

    %p = strcat(num2str(p), '//');
    p = char('a' + p);
    
end

