clear
clc

plPoints(:,1) = linspace(0,5,20)';
a = rand([1:1:20], "normal")'

plPoints(:,2) = sin(plPoints(:,1))+a;

//plot(x,y)

figMain = scf();
axMain = gca();
figMain.user_data.fZoomScaleFactor = .1;

axMain.isoview = "on";
axMain.axes_visible = ["on" "on" "off"];
//axMain.data_bounds=[min(plPoints(:,1)),min(plPoints(:,2));max(plPoints(:,1)),max(plPoints(:,2))];//
axMain.data_bounds=[min(plPoints(:,1)),min(plPoints(:,2));max(plPoints(:,1)),max(plPoints(:,2))];

zbFixed = axMain.zoom_box;

xpoly(plPoints(:,1), plPoints(:,2));
xpCurrent = get("hdl");

xpCurrent.line_style = 1;
xpCurrent.polyline_style = 1;
xpCurrent.mark_style = 1;
xpCurrent.thickness = 2;
xpCurrent.foreground = round(rand()*16);

figMain.immediate_drawing = "off";

axMain.auto_scale = "on"

function my_eventhandler(win, x, y, iBtn)
    if iBtn==-1000 then return,end
    [x,y]=xchange(x,y,'i2f')
    f = get_figure_handle(win);
    xinfo(msprintf('Event code %d at mouse position is (%f,%f)', iBtn, x, y))
    //f.children.zoom_box = zbFixed;
    f.children.rotation_angles = [0, 270];
    f.immediate_drawing = "on";
    //f.immediate_drawing = "off";

select iBtn
case -1000
    return
case 2
    f.user_data.RightMouseDown = %T;
    f.user_data.RightDownPos = [x,y];
case -3
    f.user_data.RightMouseDown = %F;
case -1
    disp("Trying!")
    try
        if f.user_data.RightMouseDown == %T then
            vLastPos = f.user_data.LastPos;
            fDeltaY = y - vLastPos(2);
//            f.children.zoom_box = f.children.zoom_box * (1 + fDeltaY * f.user_data.fZoomScaleFactor);
            
            //Calculate Relative Zoom Center
            vZoomCenter = f.user_data.RightDownPos - f.children.zoom_box(1:2);
            fWidth = f.children.zoom_box(3) - f.children.zoom_box(1);
            fHeight = f.children.zoom_box(4) - f.children.zoom_box(2);
            boxZoomScale = [1 - vZoomCenter(1)/fWidth, 1 - vZoomCenter(2)/fHeight, -vZoomCenter(1)/fWidth, -vZoomCenter(2)/fHeight, 0, 0];
            f.children.zoom_box = f.children.zoom_box + boxZoomScale * f.user_data.fZoomScaleFactor * fDeltaY * fWidth;
            disp("Zoomin!")
        end
    catch 
       disp("WTF!")
    end
 
    f.user_data.LastPos = [x, y];
else
end

endfunction

figMain.event_handler = "my_eventhandler";
figMain.event_handler_enable = "on";

function my_resizefcn(varargin)
    disp(varargin);
    disp(gcbo);
    xinfo(msprintf('Resizing'))
endfunction

figMain.resizefcn = "my_resizefcn";
//figMain.resize = "off";
