model itWILLwork2
  GDBPPackage.waterSupplySubsystemElectrical waterSupplySubsystemElectrical(desalON(start = true)) annotation(
    Placement(transformation(origin = {80, 46}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.auxLoadElectrical auxLoadElectrical annotation(
    Placement(transformation(origin = {80, 86}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.compressorElectrical compressorElectrical annotation(
    Placement(transformation(origin = {80, 16}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {106, -76}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.H2Tanks h2Tanks annotation(
    Placement(transformation(origin = {144, 18}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.batteryStack batteryStack(SOC_initial = 0.8)  annotation(
    Placement(transformation(origin = {82, -52}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Translational.Sources.Speed speed1 annotation(
    Placement(transformation(origin = {-206, -56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia1(J = 0.1) annotation(
    Placement(transformation(origin = {-134, -14}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(transformation(origin = {-132, -86}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed2 annotation(
    Placement(transformation(origin = {-72, -68}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const2(k = 6.7) annotation(
    Placement(transformation(origin = {-260, -58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = 10) annotation(
    Placement(transformation(origin = {-104, -86}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.powerManagement5 powerManagement5 annotation(
    Placement(transformation(origin = {6, 14}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.TSRcontroller tSRcontroller annotation(
    Placement(transformation(origin = {-96, -40}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.motorElectrical motorElectrical annotation(
    Placement(transformation(origin = {-46, -40}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.electrolyserElectrical electrolyserElectrical annotation(
    Placement(transformation(origin = {80, -20}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.turbineTSRoptPitchControl turbineTSRoptPitchControl annotation(
    Placement(transformation(origin = {-146, -52}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(compressorElectrical.mH2_out, h2Tanks.mH2_in) annotation(
    Line(points = {{80.4, 6}, {120.4, 6}, {120.4, 18}, {134.4, 18}}, color = {0, 0, 127}));
  connect(compressorElectrical.pin_n, ground.p) annotation(
    Line(points = {{90, 16}, {106, 16}, {106, -66}}, color = {0, 0, 255}));
  connect(waterSupplySubsystemElectrical.pin_n, ground.p) annotation(
    Line(points = {{90, 46}, {106, 46}, {106, -66}}, color = {0, 0, 255}));
  connect(ground.p, batteryStack.pin_n) annotation(
    Line(points = {{106, -66}, {106, -46}, {86, -46}}, color = {0, 0, 255}));
  connect(batteryStack.pin_p, compressorElectrical.pin_p) annotation(
    Line(points = {{78, -46.6}, {58, -46.6}, {58, 15.4}, {70, 15.4}}, color = {0, 0, 255}));
  connect(batteryStack.pin_p, waterSupplySubsystemElectrical.pin_p) annotation(
    Line(points = {{78, -46.6}, {58, -46.6}, {58, 45.4}, {70, 45.4}}, color = {0, 0, 255}));
  connect(batteryStack.pin_p, auxLoadElectrical.pin_p) annotation(
    Line(points = {{78, -46.6}, {58, -46.6}, {58, 85.4}, {70, 85.4}}, color = {0, 0, 255}));
  connect(auxLoadElectrical.pin_n, ground.p) annotation(
    Line(points = {{90, 86.2}, {106, 86.2}, {106, -65.8}}, color = {0, 0, 255}));
  connect(const2.y, speed1.v_ref) annotation(
    Line(points = {{-249, -58}, {-239, -58}, {-239, -56}, {-219, -56}}, color = {0, 0, 127}));
  connect(speedSensor.w, gain.u) annotation(
    Line(points = {{-121, -86}, {-117, -86}}, color = {0, 0, 127}));
  connect(gain.y, speed2.w_ref) annotation(
    Line(points = {{-93, -86}, {-95, -86}, {-95, -68}, {-85, -68}}, color = {0, 0, 127}));
  connect(powerManagement5.SOC, batteryStack.SOC) annotation(
    Line(points = {{6.2, 4}, {6.2, -58}, {82.2, -58}}, color = {0, 0, 127}));
  connect(powerManagement5.hullSpeed, const2.y) annotation(
    Line(points = {{16, 8.8}, {20, 8.8}, {20, -3.2}, {-240, -3.2}, {-240, -57.2}, {-248, -57.2}}, color = {0, 0, 127}));
  connect(powerManagement5.compressorDemand, compressorElectrical.compressorPowerDemand) annotation(
    Line(points = {{-4, 4}, {-12, 4}, {-12, 0}, {90, 0}, {90, 12}}, color = {0, 0, 127}));
  connect(powerManagement5.desalinatorDemand, waterSupplySubsystemElectrical.powerDemand) annotation(
    Line(points = {{-4, 10}, {-12, 10}, {-12, 36}, {80, 36}}, color = {0, 0, 127}));
  connect(powerManagement5.auxPower, auxLoadElectrical.auxPower) annotation(
    Line(points = {{-4, 24}, {-4, 96}, {80, 96}}, color = {0, 0, 127}));
  connect(const2.y, tSRcontroller.hullSpeed) annotation(
    Line(points = {{-249, -58}, {-241, -58}, {-241, -4}, {-97, -4}, {-97, -30}}, color = {0, 0, 127}));
  connect(tSRcontroller.batterySOC, batteryStack.SOC) annotation(
    Line(points = {{-95.8, -49.8}, {-95.8, -57.8}, {82.2, -57.8}}, color = {0, 0, 127}));
  connect(motorElectrical.pin_p, batteryStack.pin_p) annotation(
    Line(points = {{-56, -40}, {-60, -40}, {-60, -64}, {58, -64}, {58, -46}, {78, -46}}, color = {0, 0, 255}));
  connect(motorElectrical.pin_n, batteryStack.pin_n) annotation(
    Line(points = {{-36, -40}, {86, -40}, {86, -46}}, color = {0, 0, 255}));
  connect(batteryStack.pin_p, electrolyserElectrical.pin_p) annotation(
    Line(points = {{78, -46.6}, {58, -46.6}, {58, -20.6}, {70, -20.6}}, color = {0, 0, 255}));
  connect(electrolyserElectrical.pin_n, batteryStack.pin_n) annotation(
    Line(points = {{90, -20}, {106, -20}, {106, -46}, {86, -46}}, color = {0, 0, 255}));
  connect(tSRcontroller.motorTorqueDemand, motorElectrical.motorTorqueDemand) annotation(
    Line(points = {{-85.8, -40}, {-71.8, -40}, {-71.8, -30}, {-51.8, -30}}, color = {0, 0, 127}));
  connect(powerManagement5.electrolyserPowerSupply, electrolyserElectrical.allowedPower) annotation(
    Line(points = {{16.4, 18}, {42.4, 18}, {42.4, -10}, {80.4, -10}}, color = {0, 0, 127}));
  connect(powerManagement5.motorPowerActual, motorElectrical.motorPowerActual) annotation(
    Line(points = {{6, 24}, {6, 30}, {-40, 30}, {-40, -30}}, color = {0, 0, 127}));
  connect(powerManagement5.electrolyserDemand, electrolyserElectrical.powerDemand) annotation(
    Line(points = {{-4, 18}, {-20, 18}, {-20, -30}, {74, -30}}, color = {0, 0, 127}));
  connect(electrolyserElectrical.H2_flowrate, compressorElectrical.mH2) annotation(
    Line(points = {{80.4, -30}, {80.4, -36}, {98.4, -36}, {98.4, 26}, {80.4, 26}}, color = {0, 0, 127}));
  connect(electrolyserElectrical.H2O_flowrate, waterSupplySubsystemElectrical.H2Odemand) annotation(
    Line(points = {{87, -30}, {93, -30}, {93, 56}, {79, 56}}, color = {0, 0, 127}));
  connect(speed2.flange, motorElectrical.shaft) annotation(
    Line(points = {{-62, -68}, {-46, -68}, {-46, -50}}));
  connect(speed1.flange, turbineTSRoptPitchControl.Translational) annotation(
    Line(points = {{-196, -56}, {-172, -56}, {-172, -52}, {-156, -52}}, color = {0, 127, 0}));
  connect(turbineTSRoptPitchControl.Rotational, inertia1.flange_a) annotation(
    Line(points = {{-146, -42}, {-146, -14}, {-144, -14}}));
  connect(turbineTSRoptPitchControl.turbineTorque, tSRcontroller.turbineTorque) annotation(
    Line(points = {{-136.2, -47.8}, {-124.2, -47.8}, {-124.2, -39.8}, {-106.2, -39.8}}, color = {0, 0, 127}));
  connect(speedSensor.flange, turbineTSRoptPitchControl.Rotational) annotation(
    Line(points = {{-142, -86}, {-164, -86}, {-164, -42}, {-146, -42}}));
  annotation(
    uses(Modelica(version = "4.1.0")),
  experiment(StartTime = 0, StopTime = 400000, Tolerance = 1e-06, Interval = 0.1),
  Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
  Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
  version = "");
end itWILLwork2;
