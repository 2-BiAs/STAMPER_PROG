function DuperPlot(plA)
    if typeof(plA) == 'list' then
        for i=1:size(plA)
            DuperPlot(plA(i));
        end
    end
            axGrooveProfile = gca();
            axGrooveProfile.isoview = "on"
            axGrooveProfile.axes_visible = ["on" "on" "off"];
            axGrooveProfile.data_bounds=[min(plA(:,1)),min(plA(:,2));max(plA(:,1)),max(plA(:,2))];

            xpoly(plA(:,1), plA(:,2));
            xpPath = get("hdl");

            xpPath.line_style = 1;
            xpPath.polyline_style = 1;
            xpPath.mark_style = 1;
            xpPath.thickness = 2;
            xpPath.foreground = round(rand()*16);
endfunction
