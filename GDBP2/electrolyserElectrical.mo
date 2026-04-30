within GDBP2;

model electrolyserElectrical

  Modelica.Blocks.Interfaces.RealInput allowedPower annotation(
    Placement(transformation(origin = {-104, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {2, 108}, extent = {{-10, -10}, {10, 10}})));
  parameter Real fractPowervsElectrolyserEff[:, :] =[0,0;0.1,0.22;0.15,0.3;0.2,0.42;0.25,0.5;0.3,0.55;0.35,0.58;0.4,0.6;0.45,0.64;0.5, 0.66;0.55,0.65;0.6,0.645;0.65,0.64;0.7,0.63;0.75,0.625;0.8,0.62;0.85,0.615;0.9,0.61;0.95,0.605;1,0.6];
  parameter Modelica.Units.SI.Power ratedPower = 120000;
  parameter Real HHVH2 = 142e6 "Higher heating value of Hydrogen (J/kg)";
  parameter Real waterPerKgH2 = 9.9 "Water consumption per kg of H2 made (L/kg = kg/kg)";
  parameter Modelica.Units.SI.Pressure H2deliveryPressure(displayUnit = "bar")= 3e6;
  Modelica.Units.SI.Efficiency efficiency;
  Modelica.Units.SI.Power actualPower;
  Modelica.Units.SI.Mass massH2;
  //Modelica.Units.SI.Mass massH2O; //////do i need mass or volume h2o?
  Real fractionofPower;
  Modelica.Units.SI.MassFlowRate mH2;
  Modelica.Units.SI.MassFlowRate mH2O;
  Real mH2_kgph;
  
  
  Modelica.Blocks.Tables.CombiTable1Ds electrolyserEff(table = fractPowervsElectrolyserEff, smoothness = Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation(
    Placement(transformation(origin = {-10, 32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput H2_flowrate annotation(
    Placement(transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {4, -100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput H2O_flowrate annotation(
    Placement(transformation(origin = {104, -42}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {70, -100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput powerDemand annotation(
    Placement(transformation(origin = {102, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-70, -100}, extent = {{-10, -10}, {10, 10}})));
Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(transformation(origin = {-100, 72}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(transformation(origin = {98, 72}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent annotation(
    Placement(transformation(origin = {0, 76}, extent = {{-10, -10}, {10, 10}})));
Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor annotation(
    Placement(transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}})));
equation
  powerDemand = ratedPower; // The electrolyser would LIKE to run at rated powerDemand
  
  
actualPower = min(powerDemand, allowedPower); // But it only gets what power management allows
 
signalCurrent.i = -actualPower / max(abs(voltageSensor.v), 1e-3);

  fractionofPower = actualPower/ratedPower;
  electrolyserEff.u = fractionofPower;
  electrolyserEff.y[1] = efficiency;
  mH2 = (actualPower*efficiency)/HHVH2;
  mH2_kgph = mH2*3600;


der(massH2) =  max(mH2, 0);

  
  mH2O = waterPerKgH2 * mH2;
// Real outputs
  H2_flowrate = mH2;
  H2O_flowrate = mH2O;
connect(signalCurrent.p, pin_p) annotation(
    Line(points = {{-10, 76}, {-100, 76}, {-100, 72}}, color = {0, 0, 255}));
connect(signalCurrent.n, pin_n) annotation(
    Line(points = {{10, 76}, {98, 76}, {98, 72}}, color = {0, 0, 255}));
connect(pin_p, voltageSensor.p) annotation(
    Line(points = {{-100, 72}, {-40, 72}, {-40, 0}, {-8, 0}}, color = {0, 0, 255}));
connect(pin_n, voltageSensor.n) annotation(
    Line(points = {{98, 72}, {60, 72}, {60, 0}, {12, 0}}, color = {0, 0, 255}));
annotation(
    Diagram(graphics),
    Icon(graphics = {Polygon(rotation = -90,lineColor = {0, 170, 0}, fillColor = {0, 170, 0}, fillPattern = FillPattern.Solid, points = {{-90, 30}, {-100, 30}, {-110, 10}, {-110, -10}, {-100, -30}, {-90, -30}, {-90, 30}}), Rectangle(rotation = -90,lineColor = {0, 85, 0}, extent = {{-90, 60}, {90, -60}}, radius = 10), Rectangle(rotation = -90,lineColor = {0, 85, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{90, 40}, {110, -40}}), Rectangle(rotation = -90,lineColor = {0, 170, 0}, fillColor = {0, 170, 0}, fillPattern = FillPattern.Solid, extent = {{70, -40}, {-70, 40}}), Rectangle(origin = {0, 56}, extent = {{-34, 8}, {34, -8}}), Rectangle(origin = {0, 34}, extent = {{-34, 8}, {34, -8}}), Rectangle(origin = {0, 12}, extent = {{-34, 8}, {34, -8}}), Rectangle(origin = {0, -10}, extent = {{-34, 8}, {34, -8}}), Rectangle(origin = {0, -32}, extent = {{-34, 8}, {34, -8}}), Rectangle(origin = {0, -54}, extent = {{-34, 8}, {34, -8}})}),
experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
end electrolyserElectrical;
