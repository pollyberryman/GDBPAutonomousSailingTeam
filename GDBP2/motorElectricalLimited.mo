within GDBP2;

model motorElectricalLimited
  parameter Modelica.Units.SI.Efficiency motorEfficiency = 0.95;
  Modelica.Blocks.Tables.CombiTable1Ds torqueLookup(table = [0, 450; 52.3598775598299, 450; 104.71975511966, 450; 157.07963267949, 450; 209.43951023932, 450; 261.799387799149, 450; 311.017672705389, 450; 366.519142918809, 380; 418.879020478639, 335; 471.238898038469, 298; 523.598775598299, 269], extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2) annotation(
    Placement(transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Units.SI.AngularVelocity omega(start = 100);
  Modelica.Units.SI.Torque tau_max;
  Modelica.Units.SI.Torque tau_generator;
  Modelica.Units.SI.Torque tau_actual;
  Modelica.Units.SI.AngularVelocity omega_min = 1e-3;
  Modelica.Units.SI.Power MechPower;
  Modelica.Units.SI.Power ElecPower;
  parameter Modelica.Units.SI.Time Te = 0.01;
  Modelica.Units.SI.Current i_cmd;
  parameter Modelica.Units.SI.Time tau_delay = 0.2;
  Modelica.Blocks.Interfaces.RealInput motorTorqueDemand "Torque command from TSR controller" annotation(
    Placement(transformation(origin = {-10, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-60, 100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput motorPowerActual "Electrical power actually generated" annotation(
    Placement(transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {50, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {-100, 30}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor annotation(
    Placement(transformation(origin = {2, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent annotation(
    Placement(transformation(origin = {2, 66}, extent = {{-10, -10}, {10, 10}})));
equation
  omega = der(shaft.phi);
  torqueLookup.u = abs(omega);
  tau_max = torqueLookup.y[1];
  tau_generator = -min(max(motorTorqueDemand, 0), tau_max);
  der(tau_actual) = (tau_generator - tau_actual)/tau_delay;
  shaft.tau = -tau_actual;
  MechPower = -tau_actual*omega;
  ElecPower = MechPower*motorEfficiency;
  motorPowerActual = ElecPower;
  i_cmd = motorPowerActual/max(abs(voltageSensor.v), 1e-3);
  der(signalCurrent.i) = (i_cmd - signalCurrent.i)/Te;
//signalCurrent.i = motorPowerActual/max(abs(voltageSensor.v), 1e-3) * sign(voltageSensor.v);
  connect(voltageSensor.p, pin_p) annotation(
    Line(points = {{-8, 42}, {-100, 42}, {-100, 30}}, color = {0, 0, 255}));
  connect(voltageSensor.n, pin_n) annotation(
    Line(points = {{12, 42}, {100, 42}, {100, 0}}, color = {0, 0, 255}));
  connect(signalCurrent.p, pin_p) annotation(
    Line(points = {{-8, 66}, {-100, 66}, {-100, 30}}, color = {0, 0, 255}));
  connect(signalCurrent.n, pin_n) annotation(
    Line(points = {{12, 66}, {100, 66}, {100, 0}}, color = {0, 0, 255}));
  annotation(
    Diagram(graphics),
    Icon(graphics = {Rectangle(origin = {2.835, 10}, fillColor = {0, 128, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-60, -60}, {60, 60}}), Rectangle(origin = {2.835, 10}, fillColor = {128, 128, 128}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-80, -60}, {-60, 60}}), Rectangle(origin = {2.835, 10}, fillColor = {95, 95, 95}, fillPattern = FillPattern.HorizontalCylinder, extent = {{60, -10}, {80, 10}}), Rectangle(origin = {2.835, 10}, lineColor = {95, 95, 95}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-60, 50}, {20, 70}}), Polygon(origin = {2.835, 10}, fillPattern = FillPattern.Solid, points = {{-70, -90}, {-60, -90}, {-30, -20}, {20, -20}, {50, -90}, {60, -90}, {60, -100}, {-70, -100}, {-70, -90}})}),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
end motorElectricalLimited;
