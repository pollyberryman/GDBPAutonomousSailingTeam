within GDBP2;

model TSRcontrolNOPID

parameter Real GearRatio = 10;
  Modelica.Blocks.Interfaces.RealInput turbineTorque annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-98, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput motorTorqueDemand annotation(
    Placement(transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}})));

equation

motorTorqueDemand = turbineTorque / GearRatio;

end TSRcontrolNOPID;
