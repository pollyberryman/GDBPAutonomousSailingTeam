model GDBPfullModel
  GDBPPackage.Sail sail annotation(
    Placement(transformation(origin = {42, 32}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.Environment environment1 annotation(
    Placement(transformation(origin = {-90, -10}, extent = {{-8, -8}, {8, 8}})));
  GDBPPackage.clock clock1(startDay = startDay, startHour = startHour, startMinute = startMinute, startMonth = startMonth, startSecond = startSecond, startYear = startYear) annotation(
    Placement(transformation(origin = {68, -54}, extent = {{-7, -7}, {7, 7}})));
  GDBPPackage.Hull hull(HullLength = 21.336, HullSpeedvsDragTable = [0, 0.672608; 0.3125, 0.602916; 0.625, 0.541445; 0.9375, 0.487153; 1.25, 0.439579; 1.5625, 0.398429; 1.875, 0.363488; 2.1875, 0.334589; 2.5, 0.311597; 2.8125, 0.294399; 3.125, 0.282896; 3.4375, 0.277004; 3.75, 0.392037; 4.0625, 0.538074; 4.375, 0.649634; 4.6875, 0.737963; 5, 0.826706; 5.3125, 0.911477; 5.625, 1.002663; 5.9375, 1.108756; 6.25, 1.219981; 6.5625, 1.366347; 6.875, 1.522114; 7.1875, 1.674229; 7.5, 1.82641; 7.8125, 2.021178; 8.125, 2.277001; 8.4375, 2.577729; 8.75, 3.085566; 9.0625, 3.598274; 9.375, 4.606401; 9.6875, 5.656928; 10, 6.941119; 10.3125, 8.331663; 10.625, 10.151944; 10.9375, 12.483191; 11.25, 14.588896; 11.5625, 15.883528; 11.875, 17.182855; 12.1875, 18.762756; 12.5, 20.351837; 12.8125, 22.366667; 13.125, 24.528263; 13.4375, 26.685699; 13.75, 28.839356; 14.0625, 30.808193; 14.375, 32.282674; 14.6875, 33.758396; 15, 35.156602; 15.3125, 36.559348; 15.625, 37.704948; 15.9375, 38.790738; 16.25, 39.945604; 16.5625, 41.154386; 16.875, 42.17088; 17.1875, 42.792704; 17.5, 43.427749; 17.8125, 44.151711; 18.125, 44.880114; 18.4375, 45.724786; 18.75, 46.592433; 19.0625, 47.598425; 19.375, 48.690396; 19.6875, 49.668618; 20, 50.462685; 20.3125, 51.457067; 20.625, 53.574975; 20.9375, 55.697243])  annotation(
    Placement(transformation(origin = {48, -6}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.motor motor annotation(
    Placement(transformation(origin = {-12, -12}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Batteries.BatteryStacks.CellStack cellStack annotation(
    Placement(transformation(origin = {-50, -16}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet dcpm annotation(
    Placement(transformation(origin = {-64, 44}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.constantWind constantWind(windSpeedInput = 13, windDirectionInput = 0.7853981633974483)  annotation(
    Placement(transformation(origin = {4, 32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant estimatedsailforce(k = 45000)  annotation(
    Placement(transformation(origin = {28, 14}, extent = {{-6, -6}, {6, 6}})));
  GDBPPackage.turbine turbine annotation(
    Placement(transformation(origin = {24, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Components.LossyGear lossyGear annotation(
    Placement(transformation(origin = {0, -62}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.turbineSimple turbineSimple annotation(
    Placement(transformation(origin = {30, -50}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.sailVPP sailVPP annotation(
    Placement(transformation(origin = {-20, 58}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.simpleGearRatio simpleGearRatio(GearRatio = 10, efficiency = 0.9)  annotation(
    Placement(transformation(origin = {38, 58}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(constantWind.windSpeed, sail.windSpeed) annotation(
    Line(points = {{13, 37}, {32, 37}, {32, 36}}, color = {0, 0, 127}));
  connect(constantWind.windDirection, sail.windDirection) annotation(
    Line(points = {{13, 31}, {22, 31}, {22, 32}, {32, 32}}, color = {0, 0, 127}));
  connect(estimatedsailforce.y, hull.SailForce) annotation(
    Line(points = {{34, 14}, {48, 14}, {48, 0}}, color = {0, 0, 127}));
  connect(hull.Translational, turbine.Translational) annotation(
    Line(points = {{38, -5}, {14, -5}, {14, -20}}, color = {0, 127, 0}));
  connect(cellStack.p, motor.pin_n) annotation(
    Line(points = {{-50, -6}, {-50, 6}, {-22, 6}, {-22, -4}}, color = {0, 0, 255}));
  connect(cellStack.n, motor.pin_p) annotation(
    Line(points = {{-50, -26}, {-50, -36}, {-22, -36}, {-22, -18}}, color = {0, 0, 255}));
  connect(turbine.Rotational, motor.shaft) annotation(
    Line(points = {{24, -10}, {10, -10}, {10, -11}, {-4, -11}}));
  connect(sail.flange_a, hull.Translational) annotation(
    Line(points = {{42, 22}, {38, 22}, {38, -4}}, color = {0, 127, 0}));
  annotation(
    uses(Modelica(version = "4.1.0")));
end GDBPfullModel;
