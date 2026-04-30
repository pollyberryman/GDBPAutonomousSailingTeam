model hydrogenSystem2
  GDBPPackage.simpleGearRatio simpleGearRatio(GearRatio = 0.1, efficiency = 1)  annotation(
    Placement(transformation(origin = {78, 80}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 1e-3)  annotation(
    Placement(transformation(origin = {42, 80}, extent = {{-10, -10}, {10, 10}})));
  //Modelica.Units.SI.AngularVelocity outputSpeed;
  //Modelica.Units.SI.Power inputPower;
  //Modelica.Units.SI.Power outputPower;
  GDBPPackage.simpleCompressor simpleCompressor annotation(
    Placement(transformation(origin = {4, 40}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  GDBPPackage.waterSupplySubsystem waterSupplySubsystem annotation(
    Placement(transformation(origin = {42, 6}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.H2Tanks h2Tanks annotation(
    Placement(transformation(origin = {-26, 40}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  //Modelica.Units.SI.Energy E_electrolyser(start=0);
  //Modelica.Units.SI.Energy E_compressor(start=0);
  //Modelica.Units.SI.Energy E_desal(start=0);
  //Real kWh_per_kg_H2;
  GDBPPackage.auxLoad auxLoad annotation(
    Placement(transformation(origin = {-60, -30}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.turbine turbine annotation(
    Placement(transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Translational.Sources.ConstantSpeed constantSpeed(v_fixed = 6.7)  annotation(
    Placement(transformation(origin = {-30, 70}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.powerManagement2 powerManagement2 annotation(
    Placement(transformation(origin = {2, -30}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.simpleElectrolyser2 simpleElectrolyser2 annotation(
    Placement(transformation(origin = {44, 40}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  GDBPPackage.motorLookuptablePowerDemand motorLookuptablePowerDemand annotation(
    Placement(transformation(origin = {76, 42}, extent = {{10, -10}, {-10, 10}})));
equation
//  der(E_electrolyser) = simpleElectrolyser.inputPower;
// der(E_compressor) = simpleCompressor.compressorPower;
// der(E_desal) = waterSupplySubsystem.powerDemand;
//kWh_per_kg_H2 = (E_electrolyser + E_compressor + E_desal)/3.6e6/h2Tanks.H2_mass;
//outputSpeed = der(simpleGearRatio.flange_b.phi);
//inputPower = speed.flange.tau*der(speed.flange.phi);
// outputPower = simpleGearRatio.flange_b.tau*der(simpleGearRatio.flange_b.phi);
  connect(inertia.flange_b, simpleGearRatio.flange_a) annotation(
    Line(points = {{52, 80}, {68, 80}}));
  connect(simpleCompressor.mH2_out, h2Tanks.mH2_in) annotation(
    Line(points = {{-6, 44}, {-16, 44}, {-16, 40}}, color = {0, 0, 127}));
  connect(turbine.Rotational, inertia.flange_a) annotation(
    Line(points = {{0, 80}, {32, 80}}));
  connect(constantSpeed.flange, turbine.Translational) annotation(
    Line(points = {{-20, 70}, {-10, 70}}, color = {0, 127, 0}));
  connect(simpleElectrolyser2.powerDemand, powerManagement2.electrolyserDemand) annotation(
    Line(points = {{34, 46}, {22, 46}, {22, -6}, {-24, -6}, {-24, -26}, {-8, -26}}, color = {0, 0, 127}));
  connect(auxLoad.auxPower, powerManagement2.auxPower) annotation(
    Line(points = {{-60, -20}, {-8, -20}}, color = {0, 0, 127}));
  connect(waterSupplySubsystem.H2Odemand, simpleElectrolyser2.H2O_flowrate) annotation(
    Line(points = {{32, 6}, {26, 6}, {26, 36}, {34, 36}}, color = {0, 0, 127}));
  connect(simpleElectrolyser2.H2_flowrate, simpleCompressor.mH2) annotation(
    Line(points = {{34, 40}, {14, 40}}, color = {0, 0, 127}));
  connect(simpleCompressor.compressorPower, powerManagement2.compressorDemand) annotation(
    Line(points = {{-6, 38}, {-6, -4}, {-26, -4}, {-26, -40}, {-8, -40}}, color = {0, 0, 127}));
  connect(waterSupplySubsystem.powerDemand, powerManagement2.desalinatorDemand) annotation(
    Line(points = {{52, 6}, {54, 6}, {54, -14}, {-18, -14}, {-18, -34}, {-8, -34}}, color = {0, 0, 127}));
  connect(motorLookuptablePowerDemand.motorPowerActual, powerManagement2.motorPowerActual) annotation(
    Line(points = {{66, 42}, {60, 42}, {60, -16}, {2, -16}, {2, -20}}, color = {0, 0, 127}));
  connect(powerManagement2.electrolyserPowerSupply, simpleElectrolyser2.allowedPower) annotation(
    Line(points = {{12, -26}, {58, -26}, {58, 40}, {54, 40}}, color = {0, 0, 127}));
  connect(powerManagement2.motorPowerDemand, motorLookuptablePowerDemand.motorPowerDemand) annotation(
    Line(points = {{12, -34}, {64, -34}, {64, 52}, {76, 52}}, color = {0, 0, 127}));
  connect(simpleGearRatio.flange_b, motorLookuptablePowerDemand.shaft) annotation(
    Line(points = {{88, 80}, {94, 80}, {94, 42}, {86, 42}}));
  annotation(
    uses(Modelica(version = "4.1.0")),
  experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.01));
end hydrogenSystem2;
