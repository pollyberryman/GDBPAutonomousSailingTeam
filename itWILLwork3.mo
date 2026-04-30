model itWILLwork3
parameter Modelica.Units.SI.Velocity hullSpeed_param = 10;
parameter Real initialSOC_param = 0.9;
parameter Boolean desalON_param = true ;
  GDBPPackage.waterSupplySubsystemElectrical waterSupplySubsystemElectrical(desalON(start = desalON_param)) annotation(
    Placement(transformation(origin = {80, 46}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.auxLoadElectrical auxLoadElectrical annotation(
    Placement(transformation(origin = {80, 86}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.compressorElectrical compressorElectrical annotation(
    Placement(transformation(origin = {80, 16}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {106, -76}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.H2Tanks h2Tanks annotation(
    Placement(transformation(origin = {144, 18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Translational.Sources.Speed speed1 annotation(
    Placement(transformation(origin = {-206, -56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia1(J = 0.1) annotation(
    Placement(transformation(origin = {-134, -14}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(transformation(origin = {-132, -86}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed2 annotation(
    Placement(transformation(origin = {-72, -68}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const2(k = hullSpeed_param) annotation(
    Placement(transformation(origin = {-278, -56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = 10) annotation(
    Placement(transformation(origin = {-104, -86}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.motorElectrical motorElectrical annotation(
    Placement(transformation(origin = {-46, -40}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.electrolyserElectrical electrolyserElectrical annotation(
    Placement(transformation(origin = {80, -20}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.turbineTSRoptPitchControl turbineTSRoptPitchControl(maxTurbinePower = 137000)  annotation(
    Placement(transformation(origin = {-146, -52}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.batteryStackNEW batteryStackNEW(SOC_initial = initialSOC_param)  annotation(
    Placement(transformation(origin = {82, -50}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.TSRcontrollerNEW tSRcontrollerNEW(minHullSpeed = 5.93)  annotation(
    Placement(transformation(origin = {-82, -30}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.powerManagement6 powerManagement6(electrolyserMINpower = 60000)  annotation(
    Placement(transformation(origin = {-10, 12}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(compressorElectrical.mH2_out, h2Tanks.mH2_in) annotation(
    Line(points = {{80.4, 6}, {120.4, 6}, {120.4, 18}, {134.4, 18}}, color = {0, 0, 127}));
  connect(compressorElectrical.pin_n, ground.p) annotation(
    Line(points = {{90, 16}, {106, 16}, {106, -66}}, color = {0, 0, 255}));
  connect(waterSupplySubsystemElectrical.pin_n, ground.p) annotation(
    Line(points = {{90, 46}, {106, 46}, {106, -66}}, color = {0, 0, 255}));
  connect(auxLoadElectrical.pin_n, ground.p) annotation(
    Line(points = {{90, 86.2}, {106, 86.2}, {106, -65.8}}, color = {0, 0, 255}));
  connect(const2.y, speed1.v_ref) annotation(
    Line(points = {{-267, -56}, {-219, -56}}, color = {0, 0, 127}));
  connect(speedSensor.w, gain.u) annotation(
    Line(points = {{-121, -86}, {-117, -86}}, color = {0, 0, 127}));
  connect(gain.y, speed2.w_ref) annotation(
    Line(points = {{-93, -86}, {-95, -86}, {-95, -68}, {-85, -68}}, color = {0, 0, 127}));
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
  connect(speedSensor.flange, turbineTSRoptPitchControl.Rotational) annotation(
    Line(points = {{-142, -86}, {-164, -86}, {-164, -42}, {-146, -42}}));
  connect(tSRcontrollerNEW.batterySOC, batteryStackNEW.SOC) annotation(
    Line(points = {{-82, -40}, {-82, -58}, {82, -58}, {82, -56}}, color = {0, 0, 127}));
  connect(turbineTSRoptPitchControl.turbineTorque, tSRcontrollerNEW.turbineTorque) annotation(
    Line(points = {{-136, -48}, {-112, -48}, {-112, -30}, {-92, -30}}, color = {0, 0, 127}));
  connect(tSRcontrollerNEW.hullSpeed, const2.y) annotation(
    Line(points = {{-82, -20}, {-90, -20}, {-90, -4}, {-240, -4}, {-240, -56}, {-266, -56}}, color = {0, 0, 127}));
  connect(tSRcontrollerNEW.motorTorqueDemand, motorElectrical.motorTorqueDemand) annotation(
    Line(points = {{-72, -30}, {-52, -30}}, color = {0, 0, 127}));
  connect(motorElectrical.pin_p, batteryStackNEW.pin_p) annotation(
    Line(points = {{-56, -40}, {-62, -40}, {-62, -54}, {66, -54}, {66, -44}, {78, -44}}, color = {0, 0, 255}));
  connect(motorElectrical.pin_n, batteryStackNEW.pin_n) annotation(
    Line(points = {{-36, -40}, {96, -40}, {96, -46}, {86, -46}, {86, -44}}, color = {0, 0, 255}));
  connect(batteryStackNEW.pin_p, electrolyserElectrical.pin_p) annotation(
    Line(points = {{78, -44}, {52, -44}, {52, -20}, {70, -20}}, color = {0, 0, 255}));
  connect(batteryStackNEW.pin_p, compressorElectrical.pin_p) annotation(
    Line(points = {{78, -44}, {52, -44}, {52, 16}, {70, 16}}, color = {0, 0, 255}));
  connect(batteryStackNEW.pin_p, waterSupplySubsystemElectrical.pin_p) annotation(
    Line(points = {{78, -44}, {52, -44}, {52, 46}, {70, 46}}, color = {0, 0, 255}));
  connect(batteryStackNEW.pin_p, auxLoadElectrical.pin_p) annotation(
    Line(points = {{78, -44}, {52, -44}, {52, 84}, {70, 84}, {70, 86}}, color = {0, 0, 255}));
  connect(electrolyserElectrical.pin_n, batteryStackNEW.pin_n) annotation(
    Line(points = {{90, -20}, {106, -20}, {106, -44}, {86, -44}}, color = {0, 0, 255}));
  connect(batteryStackNEW.pin_n, ground.p) annotation(
    Line(points = {{86, -44}, {106, -44}, {106, -66}}, color = {0, 0, 255}));
  connect(powerManagement6.SOC, batteryStackNEW.SOC) annotation(
    Line(points = {{-10, 2}, {-10, -58}, {82, -58}, {82, -56}}, color = {0, 0, 127}));
  connect(powerManagement6.electrolyserPowerSupply, electrolyserElectrical.allowedPower) annotation(
    Line(points = {{2, 12}, {36, 12}, {36, -10}, {80, -10}}, color = {0, 0, 127}));
  connect(powerManagement6.compressorDemand, compressorElectrical.compressorPowerDemand) annotation(
    Line(points = {{-20, 2}, {-20, -4}, {90, -4}, {90, 12}}, color = {0, 0, 127}));
  connect(powerManagement6.desalinatorDemand, waterSupplySubsystemElectrical.powerDemand) annotation(
    Line(points = {{-20, 8}, {-32, 8}, {-32, 36}, {80, 36}}, color = {0, 0, 127}));
  connect(powerManagement6.electrolyserDemand, electrolyserElectrical.powerDemand) annotation(
    Line(points = {{-20, 16}, {-26, 16}, {-26, -30}, {74, -30}}, color = {0, 0, 127}));
  connect(powerManagement6.auxPower, auxLoadElectrical.auxPower) annotation(
    Line(points = {{-20, 22}, {-20, 96}, {80, 96}}, color = {0, 0, 127}));
  connect(powerManagement6.motorPowerActual, motorElectrical.motorPowerActual) annotation(
    Line(points = {{-10, 22}, {-10, 30}, {-40, 30}, {-40, -30}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.1.0")),
  experiment(StartTime = 0, StopTime = 100000, Tolerance = 1e-06, Interval = 0.5),
  Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
  Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
  version = "");
end itWILLwork3;
