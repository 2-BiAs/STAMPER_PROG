function LoadLibs()

    [output, bOK] = dos("FOR /D %I IN (BIN\*) DO @ECHO %~nxI");
    output = stripblanks(output);
    for i=1:size(output,1)
        try
            lib("BIN\" + output(i));
        catch
            printf('WARNING: lib: %s library cannot be loaded\n', output(i));
        end
    end
endfunction
