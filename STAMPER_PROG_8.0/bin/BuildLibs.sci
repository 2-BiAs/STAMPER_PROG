function BuildLibs()
    dos("\BIN\BUILD_NAMES.BAT");
    [output, bOK] = dos("FOR /D %I IN (BIN\*) DO @ECHO %~nxI");
    output = stripblanks(output);
    for i=1:size(output,1)
        printf("%s\n",output(i));
        genlib(output(i),path="BIN\" + output(i));
//        pause;
    end
endfunction
