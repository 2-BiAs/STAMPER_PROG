pCut = listCompedCutPath;

scf();
axGrooveProfile = gca();
axGrooveProfile.isoview = "on"
axGrooveProfile.axes_visible = ["on" "on" "off"];
axGrooveProfile.data_bounds=[min(listCompedCutPath(:,1)),min(listCompedCutPath(:,2));max(listCompedCutPath(:,1)),max(listCompedCutPath(:,2))];

    xpoly(listCompedCutPath(:,1), listCompedCutPath(:,2));
    xpPath = get("hdl");
    
    xpPath.line_style = 4;
    xpPath.polyline_style = 4;
    xpPath.mark_style = 2;
    xpPath.thickness = 2;
    xpPath.foreground = 2;
//
//comet(pCut(:,1), pCut(:,2))
