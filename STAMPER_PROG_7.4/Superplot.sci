function SuperPlot(listPolylines, varargin)
    for i=1:size(listPolylines)
        plTemp = listPolylines(i);
        if typeof(plTemp) == 'list' then
            //pause
            SuperPlot(plTemp, varargin);
        else
            if argn(2) == 1 then
                plot2d(plTemp(:,1), plTemp(:,2), style=color(int(rand()*256), int(rand()*256), int(rand()*256)));
            else
                sLineStyles = varargin(1)
                sLineStyle = sLineStyles(min(i, size(varargin(1))));
                //pause;
//                xpoly(plTemp(:,1), plTemp(:,2));
//                e = get("hdl");
//                e.thickness = 4;
//                //e.color_map = autumncolormap(32);;
//                e.foreground = int(rand()*16) + 1 
                
                plot2d(plTemp(:,1), plTemp(:,2), style=color(int(rand()*256), int(rand()*256), int(rand()*256))); //sLineStyle);
            end
        end        
    end
    //a = gca();
    //a.isoview = "on";
endfunction
