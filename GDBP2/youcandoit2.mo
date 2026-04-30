model youcandoit2
  GDBP2.TSRcontrolNOPID tSRcontrolNOPID annotation(
    Placement(transformation(origin = {90, -2}, extent = {{-10, -10}, {10, 10}})));
  GDBP2.perfectTurbineTSRopt perfectTurbineTSRopt annotation(
    Placement(transformation(origin = {16, -12}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Translational.Sources.Speed speed1 annotation(
    Placement(transformation(origin = {-34, -16}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.1)  annotation(
    Placement(transformation(origin = {38, 26}, extent = {{-10, -10}, {10, 10}})));
  GDBP2.motorTorqueDemand motorTorqueDemand annotation(
    Placement(transformation(origin = {132, -18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(transformation(origin = {46, -88}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed annotation(
    Placement(transformation(origin = {100, -28}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 8.23)  annotation(
    Placement(transformation(origin = {-88, -18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = 10)  annotation(
    Placement(transformation(origin = {68, -46}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(speed1.flange, perfectTurbineTSRopt.Translational) annotation(
    Line(points = {{-24, -16}, {6, -16}, {6, -12}}, color = {0, 127, 0}));
  connect(perfectTurbineTSRopt.turbineTorque, tSRcontrolNOPID.turbineTorque) annotation(
    Line(points = {{26, -8}, {51, -8}, {51, -2}, {80, -2}}, color = {0, 0, 127}));
  connect(inertia.flange_a, perfectTurbineTSRopt.Rotational) annotation(
    Line(points = {{28, 26}, {16, 26}, {16, -2}}));
  connect(tSRcontrolNOPID.motorTorqueDemand, motorTorqueDemand.motorTorqueDemand) annotation(
    Line(points = {{100, -2}, {132, -2}, {132, -8}}, color = {0, 0, 127}));
  connect(perfectTurbineTSRopt.Rotational, speedSensor.flange) annotation(
    Line(points = {{16, -2}, {36, -2}, {36, -88}}));
  connect(speed.flange, motorTorqueDemand.shaft) annotation(
    Line(points = {{110, -28}, {110, -18}, {122, -18}}));
  connect(const.y, speed1.v_ref) annotation(
    Line(points = {{-76, -18}, {-66, -18}, {-66, -16}, {-46, -16}}, color = {0, 0, 127}));
  connect(speedSensor.w, gain.u) annotation(
    Line(points = {{58, -88}, {56, -88}, {56, -46}}, color = {0, 0, 127}));
  connect(gain.y, speed.w_ref) annotation(
    Line(points = {{80, -46}, {78, -46}, {78, -28}, {88, -28}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.1.0")),
  experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.1));
end youcandoit2;
