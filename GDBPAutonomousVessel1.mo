model GDBPAutonomousVessel1
  Hull hull annotation(
    Placement(transformation(origin = {30, -12}, extent = {{-10, -10}, {10, 10}})));
  Sail sail annotation(
    Placement(transformation(origin = {28, 10}, extent = {{-10, -10}, {10, 10}})));
  Weather weather annotation(
    Placement(transformation(origin = {36, 50}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(hull.flange_a, weather.flange_a) annotation(
    Line(points = {{22, -11}, {2, -11}, {2, 50}, {26, 50}}, color = {0, 127, 0}));
  connect(sail.SailPower, hull.SailPower) annotation(
    Line(points = {{30, 2}, {30, -8}}, color = {0, 0, 127}));
end GDBPAutonomousVessel1;
