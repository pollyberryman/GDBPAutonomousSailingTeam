model batterytest
  GDBPPackage.simpleElectrolyserElectrical simpleElectrolyserElectrical annotation(
    Placement(transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.waterSupplySubsystemElectrical waterSupplySubsystemElectrical(desalON(start = true)) annotation(
    Placement(transformation(origin = {0, 30}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.powerManagement4 powerManagement4 annotation(
    Placement(transformation(origin = {-64, -4}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.auxLoadElectrical auxLoadElectrical annotation(
    Placement(transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.compressorElectrical compressorElectrical annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.battery3 battery3(SOC_initial = 0.8, min_SOC = 0.01)  annotation(
    Placement(transformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {26, -92}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.H2Tanks h2Tanks annotation(
    Placement(transformation(origin = {64, 2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Sine sine(amplitude = 30000, f = 0.005, offset = 60000)  annotation(
    Placement(transformation(origin = {-136, 36}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(battery3.pin_p, auxLoadElectrical.pin_p) annotation(
    Line(points = {{-4, -64}, {-28, -64}, {-28, 70}, {-10, 70}}, color = {0, 0, 255}));
  connect(auxLoadElectrical.pin_n, battery3.pin_n) annotation(
    Line(points = {{10, 70}, {26, 70}, {26, -64}, {4, -64}}, color = {0, 0, 255}));
  connect(simpleElectrolyserElectrical.H2_flowrate, compressorElectrical.mH2) annotation(
    Line(points = {{0, -40}, {1, -40}, {1, -44}, {18, -44}, {18, 10}, {0, 10}}, color = {0, 0, 127}));
  connect(battery3.pin_n, ground.p) annotation(
    Line(points = {{4, -64}, {26, -64}, {26, -82}}, color = {0, 0, 255}));
  connect(compressorElectrical.mH2_out, h2Tanks.mH2_in) annotation(
    Line(points = {{0, -10}, {40, -10}, {40, 2}, {54, 2}}, color = {0, 0, 127}));
  connect(powerManagement4.electrolyserPowerSupply, simpleElectrolyserElectrical.allowedPower) annotation(
    Line(points = {{-54, 0}, {-40, 0}, {-40, -20}, {0, -20}}, color = {0, 0, 127}));
  connect(powerManagement4.auxPower, auxLoadElectrical.auxPower) annotation(
    Line(points = {{-74, 6}, {-104, 6}, {-104, 84}, {0, 84}, {0, 80}}, color = {0, 0, 127}));
  connect(powerManagement4.electrolyserDemand, simpleElectrolyserElectrical.powerDemand) annotation(
    Line(points = {{-74, 0}, {-100, 0}, {-100, -40}, {-6, -40}}, color = {0, 0, 127}));
  connect(powerManagement4.desalinatorDemand, waterSupplySubsystemElectrical.powerDemand) annotation(
    Line(points = {{-74, -8}, {-92, -8}, {-92, 16}, {0, 16}, {0, 20}}, color = {0, 0, 127}));
  connect(powerManagement4.compressorDemand, compressorElectrical.compressorPowerDemand) annotation(
    Line(points = {{-74, -14}, {-92, -14}, {-92, -18}, {-18, -18}, {-18, -14}, {10, -14}, {10, -4}}, color = {0, 0, 127}));
  connect(compressorElectrical.mH2, simpleElectrolyserElectrical.H2_flowrate) annotation(
    Line(points = {{0, 10}, {18, 10}, {18, -48}, {0, -48}, {0, -40}}, color = {0, 0, 127}));
  connect(simpleElectrolyserElectrical.H2O_flowrate, waterSupplySubsystemElectrical.H2Odemand) annotation(
    Line(points = {{8, -40}, {14, -40}, {14, 40}, {0, 40}}, color = {0, 0, 127}));
  connect(ground.p, battery3.pin_n) annotation(
    Line(points = {{26, -82}, {26, -64}, {4, -64}}, color = {0, 0, 255}));
  connect(simpleElectrolyserElectrical.pin_n, ground.p) annotation(
    Line(points = {{10, -30}, {26, -30}, {26, -82}}, color = {0, 0, 255}));
  connect(compressorElectrical.pin_n, ground.p) annotation(
    Line(points = {{10, 0}, {26, 0}, {26, -82}}, color = {0, 0, 255}));
  connect(waterSupplySubsystemElectrical.pin_n, ground.p) annotation(
    Line(points = {{10, 30}, {26, 30}, {26, -82}}, color = {0, 0, 255}));
  connect(simpleElectrolyserElectrical.pin_p, battery3.pin_p) annotation(
    Line(points = {{-10, -30}, {-28, -30}, {-28, -64}, {-4, -64}}, color = {0, 0, 255}));
  connect(compressorElectrical.pin_p, battery3.pin_p) annotation(
    Line(points = {{-10, 0}, {-28, 0}, {-28, -64}, {-4, -64}}, color = {0, 0, 255}));
  connect(waterSupplySubsystemElectrical.pin_p, battery3.pin_p) annotation(
    Line(points = {{-10, 30}, {-28, 30}, {-28, -64}, {-4, -64}}, color = {0, 0, 255}));
  connect(sine.y, powerManagement4.motorPowerActual) annotation(
    Line(points = {{-124, 36}, {-64, 36}, {-64, 6}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.1.0")),
  experiment(StartTime = 0, StopTime = 3600, Tolerance = 1e-06, Interval = 0.002));
end batterytest;
