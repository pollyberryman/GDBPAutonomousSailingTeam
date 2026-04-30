model itWILLwork2
  GDBPPackage.waterSupplySubsystemElectrical waterSupplySubsystemElectrical(desalON(start = true)) annotation(
    Placement(transformation(origin = {30, 46}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.auxLoadElectrical auxLoadElectrical annotation(
    Placement(transformation(origin = {30, 86}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.compressorElectrical compressorElectrical annotation(
    Placement(transformation(origin = {30, 16}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {56, -76}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.H2Tanks h2Tanks annotation(
    Placement(transformation(origin = {94, 18}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.batteryStack batteryStack(SOC_initial = 0.8)  annotation(
    Placement(transformation(origin = {32, -52}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Translational.Sources.Speed speed1 annotation(
    Placement(transformation(origin = {-256, -56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia1(J = 0.1) annotation(
    Placement(transformation(origin = {-184, -14}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(transformation(origin = {-182, -86}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed2 annotation(
    Placement(transformation(origin = {-122, -68}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const2(k = 6.7) annotation(
    Placement(transformation(origin = {-310, -58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = 10) annotation(
    Placement(transformation(origin = {-154, -86}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.powerManagement5 powerManagement5 annotation(
    Placement(transformation(origin = {-44, 14}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.TSRcontroller tSRcontroller annotation(
    Placement(transformation(origin = {-146, -40}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.motorElectrical motorElectrical annotation(
    Placement(transformation(origin = {-96, -40}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.electrolyserElectrical electrolyserElectrical annotation(
    Placement(transformation(origin = {30, -20}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.turbineTSRoptPitchControl turbineTSRoptPitchControl annotation(
    Placement(transformation(origin = {-196, -52}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(compressorElectrical.mH2_out, h2Tanks.mH2_in) annotation(
    Line(points = {{30.4, 6}, {70.4, 6}, {70.4, 18}, {84.4, 18}}, color = {0, 0, 127}));
  connect(compressorElectrical.pin_n, ground.p) annotation(
    Line(points = {{40, 16}, {56, 16}, {56, -66}}, color = {0, 0, 255}));
  connect(waterSupplySubsystemElectrical.pin_n, ground.p) annotation(
    Line(points = {{40, 46}, {56, 46}, {56, -66}}, color = {0, 0, 255}));
  connect(ground.p, batteryStack.pin_n) annotation(
    Line(points = {{56, -66}, {56, -46}, {36, -46}}, color = {0, 0, 255}));
  connect(batteryStack.pin_p, compressorElectrical.pin_p) annotation(
    Line(points = {{28, -46}, {8, -46}, {8, 16}, {20, 16}}, color = {0, 0, 255}));
  connect(batteryStack.pin_p, waterSupplySubsystemElectrical.pin_p) annotation(
    Line(points = {{28, -46}, {8, -46}, {8, 46}, {20, 46}}, color = {0, 0, 255}));
  connect(batteryStack.pin_p, auxLoadElectrical.pin_p) annotation(
    Line(points = {{28, -46}, {8, -46}, {8, 86}, {20, 86}}, color = {0, 0, 255}));
  connect(auxLoadElectrical.pin_n, ground.p) annotation(
    Line(points = {{40, 86}, {56, 86}, {56, -66}}, color = {0, 0, 255}));
  connect(const2.y, speed1.v_ref) annotation(
    Line(points = {{-299, -58}, {-289, -58}, {-289, -56}, {-269, -56}}, color = {0, 0, 127}));
  connect(speedSensor.w, gain.u) annotation(
    Line(points = {{-171, -86}, {-167, -86}}, color = {0, 0, 127}));
  connect(gain.y, speed2.w_ref) annotation(
    Line(points = {{-143, -86}, {-145, -86}, {-145, -68}, {-135, -68}}, color = {0, 0, 127}));
  connect(powerManagement5.SOC, batteryStack.SOC) annotation(
    Line(points = {{-44, 4}, {-44, -58}, {32, -58}}, color = {0, 0, 127}));
  connect(powerManagement5.hullSpeed, const2.y) annotation(
    Line(points = {{-34, 8}, {-30, 8}, {-30, -4}, {-290, -4}, {-290, -58}, {-298, -58}}, color = {0, 0, 127}));
  connect(powerManagement5.compressorDemand, compressorElectrical.compressorPowerDemand) annotation(
    Line(points = {{-54, 4}, {-62, 4}, {-62, 0}, {40, 0}, {40, 12}}, color = {0, 0, 127}));
  connect(powerManagement5.desalinatorDemand, waterSupplySubsystemElectrical.powerDemand) annotation(
    Line(points = {{-54, 10}, {-62, 10}, {-62, 36}, {30, 36}}, color = {0, 0, 127}));
  connect(powerManagement5.auxPower, auxLoadElectrical.auxPower) annotation(
    Line(points = {{-54, 24}, {-54, 96}, {30, 96}}, color = {0, 0, 127}));
  connect(const2.y, tSRcontroller.hullSpeed) annotation(
    Line(points = {{-298, -58}, {-290, -58}, {-290, -4}, {-146, -4}, {-146, -30}}, color = {0, 0, 127}));
  connect(tSRcontroller.batterySOC, batteryStack.SOC) annotation(
    Line(points = {{-146, -50}, {-146, -58}, {32, -58}}, color = {0, 0, 127}));
  connect(motorElectrical.pin_p, batteryStack.pin_p) annotation(
    Line(points = {{-106, -40}, {-110, -40}, {-110, -64}, {8, -64}, {8, -46}, {28, -46}}, color = {0, 0, 255}));
  connect(motorElectrical.pin_n, batteryStack.pin_n) annotation(
    Line(points = {{-86, -40}, {36, -40}, {36, -46}}, color = {0, 0, 255}));
  connect(batteryStack.pin_p, electrolyserElectrical.pin_p) annotation(
    Line(points = {{28, -46}, {8, -46}, {8, -20}, {20, -20}}, color = {0, 0, 255}));
  connect(electrolyserElectrical.pin_n, batteryStack.pin_n) annotation(
    Line(points = {{40, -20}, {56, -20}, {56, -46}, {36, -46}}, color = {0, 0, 255}));
  connect(tSRcontroller.motorTorqueDemand, motorElectrical.motorTorqueDemand) annotation(
    Line(points = {{-136, -40}, {-122, -40}, {-122, -30}, {-102, -30}}, color = {0, 0, 127}));
  connect(powerManagement5.electrolyserPowerSupply, electrolyserElectrical.allowedPower) annotation(
    Line(points = {{-34, 18}, {-8, 18}, {-8, -10}, {30, -10}}, color = {0, 0, 127}));
  connect(powerManagement5.motorPowerActual, motorElectrical.motorPowerActual) annotation(
    Line(points = {{-44, 24}, {-44, 30}, {-90, 30}, {-90, -30}}, color = {0, 0, 127}));
  connect(powerManagement5.electrolyserDemand, electrolyserElectrical.powerDemand) annotation(
    Line(points = {{-54, 18}, {-70, 18}, {-70, -30}, {24, -30}}, color = {0, 0, 127}));
  connect(electrolyserElectrical.H2_flowrate, compressorElectrical.mH2) annotation(
    Line(points = {{30, -30}, {30, -36}, {48, -36}, {48, 26}, {30, 26}}, color = {0, 0, 127}));
  connect(electrolyserElectrical.H2O_flowrate, waterSupplySubsystemElectrical.H2Odemand) annotation(
    Line(points = {{38, -30}, {44, -30}, {44, 56}, {30, 56}}, color = {0, 0, 127}));
  connect(speed2.flange, motorElectrical.shaft) annotation(
    Line(points = {{-112, -68}, {-96, -68}, {-96, -50}}));
  connect(speed1.flange, turbineTSRoptPitchControl.Translational) annotation(
    Line(points = {{-246, -56}, {-222, -56}, {-222, -52}, {-206, -52}}, color = {0, 127, 0}));
  connect(turbineTSRoptPitchControl.Rotational, inertia1.flange_a) annotation(
    Line(points = {{-196, -42}, {-196, -14}, {-194, -14}}));
  connect(turbineTSRoptPitchControl.turbineTorque, tSRcontroller.turbineTorque) annotation(
    Line(points = {{-186, -48}, {-174, -48}, {-174, -40}, {-156, -40}}, color = {0, 0, 127}));
  connect(speedSensor.flange, turbineTSRoptPitchControl.Rotational) annotation(
    Line(points = {{-192, -86}, {-214, -86}, {-214, -42}, {-196, -42}}));
  annotation(
    uses(Modelica(version = "4.1.0")),
  experiment(StartTime = 0, StopTime = 400000, Tolerance = 1e-06, Interval = 0.1));
end itWILLwork2;
