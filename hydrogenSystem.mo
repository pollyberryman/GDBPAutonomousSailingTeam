model hydrogenSystem
  GDBPPackage.simpleGearRatio simpleGearRatio(GearRatio = 0.1, efficiency = 1)  annotation(
    Placement(transformation(origin = {70, 80}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 1e-6)  annotation(
    Placement(transformation(origin = {42, 80}, extent = {{-10, -10}, {10, 10}})));

//Modelica.Units.SI.AngularVelocity outputSpeed;
  //Modelica.Units.SI.Power inputPower;
  //Modelica.Units.SI.Power outputPower;
  GDBPPackage.motorLookuptable motorLookuptable annotation(
    Placement(transformation(origin = {72, 36}, extent = {{10, -10}, {-10, 10}})));
  GDBPPackage.simpleElectrolyser simpleElectrolyser(ratedPower = 120000, waterPerKgH2 = 9.9555, fractPowervsElectrolyserEff = [0, 0; 0.1, 0.22; 0.15, 0.3; 0.2, 0.42; 0.25, 0.5; 0.3, 0.55; 0.35, 0.58; 0.4, 0.6; 0.45, 0.64; 0.5, 0.66; 0.55, 0.65; 0.6, 0.645; 0.65, 0.64; 0.7, 0.63; 0.75, 0.625; 0.8, 0.62; 0.85, 0.615; 0.9, 0.61; 0.95, 0.605; 1, 0.6])  annotation(
    Placement(transformation(origin = {42, 38}, extent = {{10, -10}, {-10, 10}})));
  GDBPPackage.simpleCompressor simpleCompressor annotation(
    Placement(transformation(origin = {2, 42}, extent = {{10, -10}, {-10, 10}})));
  GDBPPackage.waterSupplySubsystem waterSupplySubsystem(desalON(start = true))  annotation(
    Placement(transformation(origin = {42, 6}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.H2Tanks h2Tanks annotation(
    Placement(transformation(origin = {-26, 40}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));

//Modelica.Units.SI.Energy E_electrolyser(start=0);
  //Modelica.Units.SI.Energy E_compressor(start=0);
  //Modelica.Units.SI.Energy E_desal(start=0);
  //Real kWh_per_kg_H2;
  GDBPPackage.powerManagement powerManagement annotation(
    Placement(transformation(origin = {-2, -28}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.auxLoad auxLoad annotation(
    Placement(transformation(origin = {-60, -32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.ConstantSpeed constantSpeed(w_fixed (displayUnit = "rpm")= 36.65191429188092)  annotation(
    Placement(transformation(origin = {-12, 80}, extent = {{-10, -10}, {10, 10}})));
equation
//  der(E_electrolyser) = simpleElectrolyser.inputPower;
// der(E_compressor) = simpleCompressor.compressorPower;
// der(E_desal) = waterSupplySubsystem.powerDemand;
//kWh_per_kg_H2 = (E_electrolyser + E_compressor + E_desal)/3.6e6/h2Tanks.H2_mass;
//outputSpeed = der(simpleGearRatio.flange_b.phi);
//inputPower = speed.flange.tau*der(speed.flange.phi);
// outputPower = simpleGearRatio.flange_b.tau*der(simpleGearRatio.flange_b.phi);
  connect(inertia.flange_b, simpleGearRatio.flange_a) annotation(
    Line(points = {{52, 80}, {60, 80}}));
  connect(simpleGearRatio.flange_b, motorLookuptable.shaft) annotation(
    Line(points = {{80, 80}, {92, 80}, {92, 36}, {82, 36}}));
  connect(simpleElectrolyser.H2_flowrate, simpleCompressor.mH2) annotation(
    Line(points = {{32, 41}, {32, 42}, {12, 42}}, color = {0, 0, 127}));
  connect(simpleElectrolyser.H2O_flowrate, waterSupplySubsystem.H2Odemand) annotation(
    Line(points = {{32, 36}, {24, 36}, {24, 6}, {32, 6}}, color = {0, 0, 127}));
  connect(simpleCompressor.mH2_out, h2Tanks.mH2_in) annotation(
    Line(points = {{-8, 45}, {-8, 40}, {-16, 40}}, color = {0, 0, 127}));
  connect(waterSupplySubsystem.powerDemand, powerManagement.desalinatorDemand) annotation(
    Line(points = {{52, 6}, {58, 6}, {58, -8}, {-24, -8}, {-24, -32}, {-12, -32}}, color = {0, 0, 127}));
  connect(simpleCompressor.compressorPower, powerManagement.compressorDemand) annotation(
    Line(points = {{-8, 39}, {-10, 39}, {-10, -4}, {-34, -4}, {-34, -38}, {-12, -38}}, color = {0, 0, 127}));
  connect(powerManagement.electrolyserPower, simpleElectrolyser.inputPower) annotation(
    Line(points = {{8, -28}, {66, -28}, {66, 26}, {52, 26}, {52, 38}}, color = {0, 0, 127}));
  connect(motorLookuptable.motorPower, powerManagement.motorPower) annotation(
    Line(points = {{62, 36}, {60, 36}, {60, -12}, {-18, -12}, {-18, -24}, {-12, -24}}, color = {0, 0, 127}));
  connect(auxLoad.auxPower, powerManagement.auxPower) annotation(
    Line(points = {{-60, -22}, {-60, -18}, {-12, -18}}, color = {0, 0, 127}));
  connect(constantSpeed.flange, inertia.flange_a) annotation(
    Line(points = {{-2, 80}, {32, 80}}));
  annotation(
    uses(Modelica(version = "4.1.0")),
  experiment(StartTime = 0, StopTime = 30000, Tolerance = 1e-06, Interval = 1));
end hydrogenSystem;
