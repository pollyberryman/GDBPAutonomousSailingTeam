model ahsfbd
  GDBPPackage.powerManagement4 powerManagement4 annotation(
    Placement(transformation(origin = {72, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 2)  annotation(
    Placement(transformation(origin = {30, -8}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(const.y, powerManagement4.compressorDemand) annotation(
    Line(points = {{41, -8}, {42, -8}, {42, -10}, {62, -10}}, color = {0, 0, 127}));
  connect(const.y, powerManagement4.desalinatorDemand) annotation(
    Line(points = {{42, -8}, {62, -8}, {62, -4}}, color = {0, 0, 127}));
  connect(const.y, powerManagement4.electrolyserDemand) annotation(
    Line(points = {{42, -8}, {50, -8}, {50, 4}, {62, 4}}, color = {0, 0, 127}));
  connect(const.y, powerManagement4.auxPower) annotation(
    Line(points = {{42, -8}, {48, -8}, {48, 10}, {62, 10}}, color = {0, 0, 127}));
  connect(const.y, powerManagement4.motorPowerActual) annotation(
    Line(points = {{42, -8}, {48, -8}, {48, 20}, {72, 20}, {72, 10}}, color = {0, 0, 127}));

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
    uses(Modelica(version = "4.1.0")));
end ahsfbd;
