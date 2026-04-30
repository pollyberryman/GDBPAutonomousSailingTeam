model youcandoit1
  GDBP2.perfectTurbineTSRopt perfectTurbineTSRopt annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Translational.Sources.Speed speed1 annotation(
    Placement(transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 7.97) annotation(
    Placement(transformation(origin = {-70, 6}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(const.y, speed1.v_ref) annotation(
    Line(points = {{-59, 6}, {-50.5, 6}, {-50.5, 0}, {-42, 0}}, color = {0, 0, 127}));
  connect(speed1.flange, perfectTurbineTSRopt.Translational) annotation(
    Line(points = {{-20, 0}, {-10, 0}}, color = {0, 127, 0}));
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
end youcandoit1;
