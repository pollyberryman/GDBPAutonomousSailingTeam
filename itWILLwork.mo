model itWILLwork
  GDBPPackage.simpleElectrolyserElectrical simpleElectrolyserElectrical annotation(
    Placement(transformation(origin = {30, -14}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.waterSupplySubsystemElectrical waterSupplySubsystemElectrical(desalON(start = true)) annotation(
    Placement(transformation(origin = {30, 46}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.powerManagement4 powerManagement4 annotation(
    Placement(transformation(origin = {-34, 12}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.auxLoadElectrical auxLoadElectrical annotation(
    Placement(transformation(origin = {30, 86}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.compressorElectrical compressorElectrical annotation(
    Placement(transformation(origin = {30, 16}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {56, -76}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.H2Tanks h2Tanks annotation(
    Placement(transformation(origin = {94, 18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 4167)  annotation(
    Placement(transformation(origin = {-138, -26}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.1)  annotation(
    Placement(transformation(origin = {-136, -62}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed annotation(
    Placement(transformation(origin = {-170, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = 421) annotation(
    Placement(transformation(origin = {-214, -62}, extent = {{-10, -10}, {10, 10}})));
  GDBP2.motorTorqueDemandElectrical motorTorqueDemandElectrical annotation(
    Placement(transformation(origin = {-98, -40}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.batteryStack batteryStack annotation(
    Placement(transformation(origin = {32, -52}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(simpleElectrolyserElectrical.H2_flowrate, compressorElectrical.mH2) annotation(
    Line(points = {{30.4, 26}, {48.4, 26}, {48.4, -32}, {30.4, -32}, {30.4, -24}}, color = {0, 0, 127}));
  connect(compressorElectrical.mH2_out, h2Tanks.mH2_in) annotation(
    Line(points = {{30.4, 6}, {70.4, 6}, {70.4, 18}, {84.4, 18}}, color = {0, 0, 127}));
  connect(powerManagement4.electrolyserPowerSupply, simpleElectrolyserElectrical.allowedPower) annotation(
    Line(points = {{-23.6, 16}, {-9.6, 16}, {-9.6, -4}, {30.4, -4}}, color = {0, 0, 127}));
  connect(powerManagement4.auxPower, auxLoadElectrical.auxPower) annotation(
    Line(points = {{-44, 22}, {-74, 22}, {-74, 100}, {30, 100}, {30, 96}}, color = {0, 0, 127}));
  connect(powerManagement4.electrolyserDemand, simpleElectrolyserElectrical.powerDemand) annotation(
    Line(points = {{-44, 16}, {-70, 16}, {-70, -24}, {24, -24}}, color = {0, 0, 127}));
  connect(powerManagement4.desalinatorDemand, waterSupplySubsystemElectrical.powerDemand) annotation(
    Line(points = {{-44, 8}, {-62, 8}, {-62, 32}, {30, 32}, {30, 36}}, color = {0, 0, 127}));
  connect(powerManagement4.compressorDemand, compressorElectrical.compressorPowerDemand) annotation(
    Line(points = {{-44, 2}, {-62, 2}, {-62, -2}, {12, -2}, {12, 2}, {40, 2}, {40, 12}}, color = {0, 0, 127}));
  connect(simpleElectrolyserElectrical.H2O_flowrate, waterSupplySubsystemElectrical.H2Odemand) annotation(
    Line(points = {{37, -24}, {43, -24}, {43, 56}, {29, 56}}, color = {0, 0, 127}));
  connect(simpleElectrolyserElectrical.pin_n, ground.p) annotation(
    Line(points = {{40, -14}, {56, -14}, {56, -66}}, color = {0, 0, 255}));
  connect(compressorElectrical.pin_n, ground.p) annotation(
    Line(points = {{40, 16}, {56, 16}, {56, -66}}, color = {0, 0, 255}));
  connect(waterSupplySubsystemElectrical.pin_n, ground.p) annotation(
    Line(points = {{40, 46}, {56, 46}, {56, -66}}, color = {0, 0, 255}));
  connect(speed.flange, inertia.flange_a) annotation(
    Line(points = {{-160, -60}, {-144, -60}, {-144, -62}, {-146, -62}}));
  connect(const1.y, speed.w_ref) annotation(
    Line(points = {{-202, -62}, {-192, -62}, {-192, -60}, {-182, -60}}, color = {0, 0, 127}));
  connect(const.y, motorTorqueDemandElectrical.motorTorqueDemand) annotation(
    Line(points = {{-126, -26}, {-104, -26}, {-104, -30}}, color = {0, 0, 127}));
  connect(motorTorqueDemandElectrical.motorPowerActual, powerManagement4.motorPowerActual) annotation(
    Line(points = {{-92, -30}, {-98, -30}, {-98, 28}, {-34, 28}, {-34, 22}}, color = {0, 0, 127}));
  connect(inertia.flange_b, motorTorqueDemandElectrical.shaft) annotation(
    Line(points = {{-126, -62}, {-96, -62}, {-96, -50}, {-98, -50}}));
  connect(ground.p, batteryStack.pin_n) annotation(
    Line(points = {{56, -66}, {56, -46}, {36, -46}}, color = {0, 0, 255}));
  connect(batteryStack.pin_p, simpleElectrolyserElectrical.pin_p) annotation(
    Line(points = {{28, -46}, {8, -46}, {8, -14}, {20, -14}}, color = {0, 0, 255}));
  connect(batteryStack.pin_p, compressorElectrical.pin_p) annotation(
    Line(points = {{28, -46}, {8, -46}, {8, 16}, {20, 16}}, color = {0, 0, 255}));
  connect(batteryStack.pin_p, waterSupplySubsystemElectrical.pin_p) annotation(
    Line(points = {{28, -46}, {8, -46}, {8, 46}, {20, 46}}, color = {0, 0, 255}));
  connect(batteryStack.pin_p, auxLoadElectrical.pin_p) annotation(
    Line(points = {{28, -46}, {8, -46}, {8, 86}, {20, 86}}, color = {0, 0, 255}));
  connect(auxLoadElectrical.pin_n, ground.p) annotation(
    Line(points = {{40, 86}, {56, 86}, {56, -66}}, color = {0, 0, 255}));
  connect(motorTorqueDemandElectrical.pin_p, batteryStack.pin_p) annotation(
    Line(points = {{-108, -40}, {-116, -40}, {-116, -56}, {8, -56}, {8, -46}, {28, -46}}, color = {0, 0, 255}));
  connect(motorTorqueDemandElectrical.pin_n, batteryStack.pin_n) annotation(
    Line(points = {{-88, -40}, {36, -40}, {36, -46}}, color = {0, 0, 255}));
  annotation(
    uses(Modelica(version = "4.1.0")),
  experiment(StartTime = 0, StopTime = 40000, Tolerance = 1e-06, Interval = 0.1));
end itWILLwork;
