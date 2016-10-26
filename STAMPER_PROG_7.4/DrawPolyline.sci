function plOutput = DrawPolyline(hdlFigure)
    sca(hdlFigure);
    show_window(); //put the window on the top
    
    rep=xgetmouse();
    xc = rep(1);
    yc = rep(2);
    
    xpoly(xc, yc);
    plObj = gce();
    set(plObj,"mark_style",1)
    
    bDrawingFinished = %F;
    bMouseDown = %F;
    while ~bDrawingFinished
        rep=xgetmouse();
        xc($) = rep(1);
        yc($) = rep(2);
        select rep(3)
        case 3
            xc($+1) = xc($);
            yc($+1) = yc($);
        case 4
            xc($) = [];
            yc($) = [];
            bDrawingFinished = %T;
        end
        plObj.data = [xc, yc];
    end
    
    plOutput = plObj.data;
endfunction
