within GDBP2;

model TSRcontrolNOPIDSOClimit

parameter Real SOC_soft = 0.98;
parameter Real SOC_max = 1;
parameter Modelica.Units.SI.Velocity minHullSpeed = 5.9;

parameter Real GearRatio = 10;
Real socFactor;
  Modelica.Blocks.Interfaces.RealInput turbineTorque annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-98, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput motorTorqueDemand annotation(
    Placement(transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput batterySOC annotation(
    Placement(transformation(origin = {2, -98}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {2, -98}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput hullSpeed annotation(
    Placement(transformation(origin = {2, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {2, 100}, extent = {{-20, -20}, {20, 20}})));
equation


socFactor =
  if batterySOC < SOC_soft then
    1.0
  elseif batterySOC < SOC_max then
    (SOC_max - batterySOC) / (SOC_max - SOC_soft)
  else
    0.0;

if hullSpeed < minHullSpeed then
  motorTorqueDemand = 0;
else
  motorTorqueDemand = socFactor * (turbineTorque / GearRatio);
end if;


end TSRcontrolNOPIDSOClimit;
