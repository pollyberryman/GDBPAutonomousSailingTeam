model test2
  GDBPPackage.turbine turbine annotation(
    Placement(transformation(origin = {16, 8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Translational.Sources.Speed speed1 annotation(
    Placement(transformation(origin = {-18, 8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 6.7) annotation(
    Placement(transformation(origin = {-58, 8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.ConstantSpeed constantSpeed(w_fixed(displayUnit = "rpm") = 31.415926535897935)  annotation(
    Placement(transformation(origin = {34, 48}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(const.y, speed1.v_ref) annotation(
    Line(points = {{-47, 8}, {-30, 8}}, color = {0, 0, 127}));
  connect(speed1.flange, turbine.Translational) annotation(
    Line(points = {{-8, 8}, {6, 8}}, color = {0, 127, 0}));
  connect(constantSpeed.flange, turbine.Rotational) annotation(
    Line(points = {{44, 48}, {54, 48}, {54, 18}, {16, 18}}));
  annotation(
    uses(Modelica(version = "4.1.0")),
  experiment(StartTime = 0, StopTime = 30000, Tolerance = 1e-06, Interval = 1));
end test2;
