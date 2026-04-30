within GDBP2;

model TSRcontrol
  Modelica.Blocks.Interfaces.RealOutput motorTorqueDemand annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  parameter Modelica.Units.SI.Torque tau_max = 450;
  parameter Real TSR_opt = 4;
  parameter Modelica.Units.SI.Length rotorRadius = 0.76;
  parameter Modelica.Units.SI.Velocity minHullSpeed = 0.3;
  parameter Real PID_Kp = 1;
  parameter Real PID_Ki = 1;
  parameter Real PID_Kd = 1;
  //parameter Real tau_max = 450;
  Real TSR;
  Real e;
  Real integral_e(start = 0);
  Real e_dot;
  Real e_omega;
  Real integral_omegae;
  Real e_omegadot;
  Modelica.Units.SI.AngularVelocity desiredOmega;
  Modelica.Units.SI.Torque torqueDemand;
  Modelica.Blocks.Interfaces.RealInput HullSpeed annotation(
    Placement(transformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, 80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput omega annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-98, 40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput turbinePower annotation(
    Placement(transformation(origin = {-4, -100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {4, -60}, extent = {{-20, -20}, {20, 20}})));
equation
  desiredOmega = (TSR_opt*HullSpeed)/rotorRadius;
  e_omega = desiredOmega - omega;
  der(integral_omegae) = e_omega;
  e_omegadot = der(e_omega);
  torqueDemand = PID_Kp*e_omega + PID_Ki*integral_omegae + PID_Kd*e_omegadot;
  TSR = (abs(omega)*rotorRadius)/max(HullSpeed, minHullSpeed);
  e = TSR_opt - TSR;
  der(integral_e) = e;
  e_dot = der(e);
//torqueDemand = PID_Kp * e + PID_Ki * integral_e + PID_Kd * e_dot;
  if HullSpeed > minHullSpeed then
    if turbinePower < 60e3 then
// Below cut-in: freewheel
      GDBPPackage.motorTorqueDemand = 0;
    else
// Above cut-in: regulate speed (braking only)
      if torqueDemand > 0 then
        GDBPPackage.motorTorqueDemand = min(torqueDemand, tau_max);
      else
        GDBPPackage.motorTorqueDemand = 0;
      end if;
    end if;
  else
    GDBPPackage.motorTorqueDemand = 0;
  end if;
//if HullSpeed > minHullSpeed then
// if turbinePower < 60e3 then
//   motorTorqueDemand = 0;
//  else
//motorTorqueDemand = tau_max - torqueDemand;
//motorTorqueDemand = torqueDemand;
//motorTorqueDemand = min(max(torqueDemand,0),tau_max);
//motorTorqueDemand = max(0, min(torqueDemand, tau_max));
//  motorTorqueDemand = max(0, min(torqueDemand + tau_max, tau_max));
//  end if
//else
//  motorTorqueDemand = 0;
//end if;
  annotation(
    Icon(graphics = {Rectangle(origin = {1, -1}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Sphere, extent = {{-91, 91}, {91, -91}}), Text(origin = {1, 4}, extent = {{-57, 54}, {57, -54}}, textString = "TSR - 2")}));
end TSRcontrol;
