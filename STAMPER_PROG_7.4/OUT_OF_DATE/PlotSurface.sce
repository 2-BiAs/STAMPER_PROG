pGrooveProfile = scf();
axGrooveProfile = gca();

plot(axGrooveProfile, vPoints(:,1)', vPoints(:,2)', 'r--');
//plot(axGrooveProfile, [0; vPoints($,1)], [0; 0], 'k--')
//plot(axGrooveProfile, [0; vPoints($,1)], [fZ_Clearance; fZ_Clearance], 'g--')

axGrooveProfile.isoview = "on"
//axGrooveProfile.axes_reverse = ["off" "on" "off"];
axGrooveProfile.x_label.text = "$X \tt(mm)$"
axGrooveProfile.y_label.text = "$Z \tt(mm)$"
axGrooveProfile.title.text = "$\tt \huge{Groove \ Profile \ and \ Toolpath}$"
