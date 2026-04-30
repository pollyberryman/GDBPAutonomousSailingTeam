model test5electricity
  GDBPPackage.motor motor(resistance = 0.042, backEMF = 1.3)  annotation(
    Placement(transformation(origin = {42, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {66, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.ConstantTorque constantTorque(tau_constant = 300)  annotation(
    Placement(transformation(origin = {100, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  GDBPPackage.myCellStack myCellStack(SOC(start = 0.1), Ns = 10, Np = 2)  annotation(
    Placement(transformation(origin = {-8, 4}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant const(k = -400)  annotation(
    Placement(transformation(origin = {12, 64}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(ground.p, motor.pin_n) annotation(
    Line(points = {{66, 40}, {32, 40}, {32, 8}}, color = {0, 0, 255}));
  connect(constantTorque.flange, motor.shaft) annotation(
    Line(points = {{90, 0}, {56, 0}, {56, 2}, {50, 2}}));
  connect(const.y, motor.motorDemand) annotation(
    Line(points = {{23, 64}, {42, 64}, {42, 10}}, color = {0, 0, 127}));
  connect(myCellStack.p, motor.pin_n) annotation(
    Line(points = {{-8, 14}, {-8, 24}, {32, 24}, {32, 8}}, color = {0, 0, 255}));
  connect(myCellStack.n, motor.pin_p) annotation(
    Line(points = {{-8, -6}, {-8, -18}, {32, -18}, {32, -6}}, color = {0, 0, 255}));
  annotation(
    uses(Modelica(version = "4.1.0")),
  experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.002));
end test5electricity;
