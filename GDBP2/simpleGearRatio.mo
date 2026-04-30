within GDBP2;

model simpleGearRatio
  parameter Real GearRatio=10;
  parameter Modelica.Units.SI.Efficiency efficiency=1;
  Modelica.Units.SI.AngularVelocity inputSpeed;
  Modelica.Units.SI.AngularVelocity outputSpeed;
  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-102, 0}, extent = {{-10, -10}, {10, 10}})));
equation
  flange_b.phi = GearRatio * flange_a.phi;
  if (flange_a.tau*der(flange_a.phi) >= 0) then
    flange_a.tau = GearRatio * flange_b.tau*efficiency;
  else
    flange_a.tau = GearRatio * flange_b.tau/efficiency;
  end if;
  inputSpeed = der(flange_a.phi);
  outputSpeed = der(flange_b.phi);
end simpleGearRatio;
