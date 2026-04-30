model youcandoit3
  GDBP2.TSRcontrolNOPID tSRcontrolNOPID annotation(
    Placement(transformation(origin = {56, 22}, extent = {{-10, -10}, {10, 10}})));
  GDBP2.perfectTurbineTSRopt perfectTurbineTSRopt annotation(
    Placement(transformation(origin = {-18, 12}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Translational.Sources.Speed speed1 annotation(
    Placement(transformation(origin = {-68, 8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.1) annotation(
    Placement(transformation(origin = {4, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(transformation(origin = {12, -64}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed annotation(
    Placement(transformation(origin = {66, -4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 6.7) annotation(
    Placement(transformation(origin = {-122, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = 10) annotation(
    Placement(transformation(origin = {34, -22}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.motorTorqueDemandElectrical motorTorqueDemandElectrical annotation(
    Placement(transformation(origin = {102, 18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {134, -38}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.battery3 battery3(SOC_initial = 0.3)  annotation(
    Placement(transformation(origin = {102, 54}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(speed1.flange, perfectTurbineTSRopt.Translational) annotation(
    Line(points = {{-58, 8}, {-28, 8}, {-28, 12}}, color = {0, 127, 0}));
  connect(perfectTurbineTSRopt.turbineTorque, tSRcontrolNOPID.turbineTorque) annotation(
    Line(points = {{-8.2, 16.2}, {16.8, 16.2}, {16.8, 22.2}, {45.8, 22.2}}, color = {0, 0, 127}));
  connect(inertia.flange_a, perfectTurbineTSRopt.Rotational) annotation(
    Line(points = {{-6, 50}, {-18, 50}, {-18, 22}}));
  connect(perfectTurbineTSRopt.Rotational, speedSensor.flange) annotation(
    Line(points = {{-18, 22}, {2, 22}, {2, -64}}));
  connect(const.y, speed1.v_ref) annotation(
    Line(points = {{-111, 6}, {-101, 6}, {-101, 8}, {-81, 8}}, color = {0, 0, 127}));
  connect(speedSensor.w, gain.u) annotation(
    Line(points = {{23, -64}, {21, -64}, {21, -22}}, color = {0, 0, 127}));
  connect(gain.y, speed.w_ref) annotation(
    Line(points = {{45, -22}, {43, -22}, {43, -4}, {53, -4}}, color = {0, 0, 127}));
  connect(motorTorqueDemandElectrical.motorTorqueDemand, tSRcontrolNOPID.motorTorqueDemand) annotation(
    Line(points = {{96, 28}, {66, 28}, {66, 22}}, color = {0, 0, 127}));
  connect(motorTorqueDemandElectrical.shaft, speed.flange) annotation(
    Line(points = {{102, 8}, {102, -4}, {76, -4}}));
  connect(battery3.pin_p, motorTorqueDemandElectrical.pin_p) annotation(
    Line(points = {{98, 59}, {80, 59}, {80, 18}, {92, 18}}, color = {0, 0, 255}));
  connect(battery3.pin_n, motorTorqueDemandElectrical.pin_n) annotation(
    Line(points = {{106, 59}, {128, 59}, {128, 18}, {112, 18}}, color = {0, 0, 255}));
  connect(ground.p, battery3.pin_n) annotation(
    Line(points = {{134, -28}, {130, -28}, {130, 59}, {106, 59}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 4600, Tolerance = 1e-06, Interval = 0.1));
end youcandoit3;
