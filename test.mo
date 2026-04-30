model test
  GDBPPackage.simpleCompressor simpleCompressor annotation(
    Placement(transformation(origin = {0, 36}, extent = {{10, -10}, {-10, 10}})));
  GDBPPackage.waterSupplySubsystem waterSupplySubsystem annotation(
    Placement(transformation(origin = {38, 2}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.H2Tanks h2Tanks annotation(
    Placement(transformation(origin = {-30, 36}, extent = {{10, -10}, {-10, 10}})));
  GDBPPackage.auxLoad auxLoad annotation(
    Placement(transformation(origin = {-64, -34}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.powerManagement2 powerManagement2 annotation(
    Placement(transformation(origin = {-2, -34}, extent = {{-10, -10}, {10, 10}})));
  GDBPPackage.simpleElectrolyser2 simpleElectrolyser2(ratedPower = 120000, waterPerKgH2 = 9.9555)  annotation(
    Placement(transformation(origin = {40, 36}, extent = {{10, -10}, {-10, 10}})));
  GDBPPackage.motorLookuptablePowerDemand motorLookuptablePowerDemand annotation(
    Placement(transformation(origin = {72, 38}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 1e-3)  annotation(
    Placement(transformation(origin = {118, 38}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Mechanics.Rotational.Components.Damper damper(d = 1e-3)  annotation(
    Placement(transformation(origin = {170, 38}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Mechanics.Rotational.Components.Fixed fixed annotation(
    Placement(transformation(origin = {198, 24}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(simpleCompressor.mH2_out, h2Tanks.mH2_in) annotation(
    Line(points = {{-9.8, 39}, {-19.8, 39}, {-19.8, 35}}, color = {0, 0, 127}));
  connect(simpleElectrolyser2.powerDemand, powerManagement2.electrolyserDemand) annotation(
    Line(points = {{29.8, 41}, {17.8, 41}, {17.8, -11}, {-28.2, -11}, {-28.2, -31}, {-12.2, -31}}, color = {0, 0, 127}));
  connect(auxLoad.auxPower, powerManagement2.auxPower) annotation(
    Line(points = {{-63.8, -24}, {-11.8, -24}}, color = {0, 0, 127}));
  connect(waterSupplySubsystem.H2Odemand, simpleElectrolyser2.H2O_flowrate) annotation(
    Line(points = {{28.2, 2}, {22.2, 2}, {22.2, 32}, {30.2, 32}}, color = {0, 0, 127}));
  connect(simpleElectrolyser2.H2_flowrate, simpleCompressor.mH2) annotation(
    Line(points = {{29.8, 36}, {9.8, 36}}, color = {0, 0, 127}));
  connect(simpleCompressor.compressorPower, powerManagement2.compressorDemand) annotation(
    Line(points = {{-10, 33}, {-10, -9}, {-30, -9}, {-30, -45}, {-12, -45}}, color = {0, 0, 127}));
  connect(waterSupplySubsystem.powerDemand, powerManagement2.desalinatorDemand) annotation(
    Line(points = {{48.2, 2}, {50.2, 2}, {50.2, -18}, {-21.8, -18}, {-21.8, -38}, {-11.8, -38}}, color = {0, 0, 127}));
  connect(motorLookuptablePowerDemand.motorPowerActual, powerManagement2.motorPowerActual) annotation(
    Line(points = {{61.8, 38}, {55.8, 38}, {55.8, -20}, {-2.2, -20}, {-2.2, -24}}, color = {0, 0, 127}));
  connect(powerManagement2.electrolyserPowerSupply, simpleElectrolyser2.allowedPower) annotation(
    Line(points = {{8.4, -30}, {52.4, -30}, {52.4, 36}, {50.4, 36}}, color = {0, 0, 127}));
  connect(powerManagement2.motorPowerDemand, motorLookuptablePowerDemand.motorPowerDemand) annotation(
    Line(points = {{8.4, -38}, {60.4, -38}, {60.4, 48}, {72.4, 48}}, color = {0, 0, 127}));
  connect(motorLookuptablePowerDemand.shaft, inertia.flange_b) annotation(
    Line(points = {{82, 38}, {108, 38}}));
  connect(damper.flange_b, inertia.flange_a) annotation(
    Line(points = {{160, 38}, {128, 38}}));
  connect(damper.flange_a, fixed.flange) annotation(
    Line(points = {{180, 38}, {198, 38}, {198, 24}}));
  annotation(
    uses(Modelica(version = "4.1.0")),
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.1));
end test;
