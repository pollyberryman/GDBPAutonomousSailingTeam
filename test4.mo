model test4
  GDBPPackage.motorTorqueDemand motorTorqueDemand annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Translational.Sources.Speed speed1 annotation(
    Placement(transformation(origin = {-10, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 6.7) annotation(
    Placement(transformation(origin = {-50, 50}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.turbine turbine annotation(
    Placement(transformation(origin = {8, -10}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.simpleGearRatio simpleGearRatio annotation(
    Placement(transformation(origin = {34, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  GDBPPackage.TSRcontrol2 tSRcontrol2(PID_Kp = 50, PID_Ki = 0.1, PID_Kd = 0) annotation(
    Placement(transformation(origin = {48, 48}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 1)  annotation(
    Placement(transformation(origin = {66, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(transformation(origin = {20, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Translational.Sensors.SpeedSensor speedSensor1 annotation(
    Placement(transformation(origin = {24, 78}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(const.y, speed1.v_ref) annotation(
    Line(points = {{-39, 50}, {-22, 50}}, color = {0, 0, 127}));
  connect(speed1.flange, turbine.Translational) annotation(
    Line(points = {{0, 50}, {0, 29}, {-2, 29}, {-2, -10}}, color = {0, 127, 0}));
  connect(simpleGearRatio.flange_a, turbine.Rotational) annotation(
    Line(points = {{24, 0}, {8, 0}}));
  connect(inertia.flange_a, simpleGearRatio.flange_b) annotation(
    Line(points = {{56, 0}, {44, 0}}));
  connect(inertia.flange_b, motorTorqueDemand.shaft) annotation(
    Line(points = {{76, 0}, {90, 0}}));
  connect(tSRcontrol2.motorTorqueDemand, motorTorqueDemand.motorTorqueDemand) annotation(
    Line(points = {{58, 48}, {70, 48}, {70, 20}, {100, 20}, {100, 10}}, color = {0, 0, 127}));
  connect(speedSensor1.flange, speed1.flange) annotation(
    Line(points = {{14, 78}, {0, 78}, {0, 50}}, color = {0, 127, 0}));
  connect(speedSensor.flange, turbine.Rotational) annotation(
    Line(points = {{10, 42}, {10, 30}, {8, 30}, {8, 0}}));
  connect(tSRcontrol2.omega, speedSensor.w) annotation(
    Line(points = {{38, 52}, {32, 52}, {32, 42}}, color = {0, 0, 127}));
  connect(speedSensor1.v, tSRcontrol2.HullSpeed) annotation(
    Line(points = {{36, 78}, {48, 78}, {48, 56}}, color = {0, 0, 127}));
  connect(turbine.PowerTurbine, tSRcontrol2.turbinePower) annotation(
    Line(points = {{18, -10}, {20, -10}, {20, 32}, {48, 32}, {48, 42}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.1),
    uses(Modelica(version = "4.1.0")));
end test4;
