fToolBiasAngle = d2r(-85);  //Bias angle shared by all tool setups (corresponds to 5 degrees off-parallel to Z-axis)

toolRough_R250 = BuildTool("FULL_RADIUS", .250, d2r(35), fToolBiasAngle);
toolRough_R50 = BuildTool("FULL_RADIUS", .050, d2r(35), fToolBiasAngle);
