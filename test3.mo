model test3
  GDBPPackage.turbine turbine annotation(
    Placement(transformation(origin = {-16, 2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Translational.Sources.Speed speed annotation(
    Placement(transformation(origin = {-56, 2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 1) annotation(
    Placement(transformation(origin = {6, 32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 6.7) annotation(
    Placement(transformation(origin = {-90, 2}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(speed.flange, turbine.Translational) annotation(
    Line(points = {{-46, 2}, {-26, 2}}, color = {0, 127, 0}));
  connect(inertia.flange_a, turbine.Rotational) annotation(
    Line(points = {{-4, 32}, {-16, 32}, {-16, 12}}));
  connect(const.y, speed.v_ref) annotation(
    Line(points = {{-78, 2}, {-68, 2}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.1));
end test3;
