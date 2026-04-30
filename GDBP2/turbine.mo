within GDBP2;

model turbine
  Modelica.Mechanics.Translational.Interfaces.Flange_a Translational annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
  parameter Real KtCurve[:, :] = [0.654,0.08;0.66,0.081;0.677,0.085;0.685,0.088;0.696,0.09;0.699,0.091;0.711,0.094;0.722,0.097;0.725,0.098;0.736,0.101;0.745,0.103;0.754,0.106;0.762,0.108;0.783,0.114;0.787,0.115;0.812,0.123;0.841,0.132;0.846,0.133;0.87,0.141;0.88,0.142;0.894,0.145;0.899,0.147;0.914,0.153;0.928,0.157;0.948,0.163;0.975,0.169;0.982,0.172;1.015,0.184;1.049,0.196;1.056,0.196;1.083,0.2;1.097,0.202;1.117,0.204;1.137,0.206;1.178,0.206;1.218,0.211;1.421,0.217]
;
parameter Real KqCurve [:,:] =[0.654,0.0064;0.66,0.0065;0.677,0.0071;0.685,0.0074;0.696,0.0077;0.699,0.0079;0.711,0.0082;0.722,0.0087;0.725,0.0088;0.736,0.0092;0.745,0.0095;0.754,0.0099;0.762,0.0102;0.783,0.0111;0.787,0.0112;0.812,0.0123;0.841,0.0137;0.846,0.0139;0.87,0.0151;0.88,0.0155;0.894,0.0161;0.899,0.0165;0.914,0.0174;0.928,0.0181;0.948,0.0191;0.975,0.0207;0.982,0.0211;1.015,0.0231;1.049,0.0258;1.056,0.0261;1.083,0.0277;1.097,0.0282;1.117,0.0287;1.137,0.0293;1.178,0.0306;1.218,0.0319;1.421,0.0353]
;
  parameter Modelica.Units.SI.Density waterDensity = 1025; // kg/m^3
  parameter Modelica.Units.SI.Length rotordiameter = 1.52; // m
  Modelica.Units.SI.AngularVelocity omega(start = 0.01); // rad/s
  Real n(start=0.001); // turbine rotational speed (rps)
  Real rpm; // turbine rotational speed (rpm)
  Real TSR;
  Modelica.Units.SI.Length rotorRadius;
  Modelica.Units.SI.Force Drag;
  Modelica.Units.SI.Force Torque;
  Modelica.Units.SI.Velocity HullSpeed;
  Real Kt;
  Real Kq;
  Real J;     //Advance Velocity Ratio
  //Modelica.Units.SI.Efficiency efficiency;
  Modelica.Units.SI.Power turbinePower;
Modelica.Blocks.Tables.CombiTable1Ds KtTable(table = KtCurve, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint)  annotation(
    Placement(transformation(origin = {0, -2}, extent = {{-10, -10}, {10, 10}})));
Modelica.Blocks.Tables.CombiTable1Ds KqTable(table = KqCurve, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation(
    Placement(transformation(origin = {20, -44}, extent = {{-10, -10}, {10, 10}})));
Modelica.Mechanics.Rotational.Interfaces.Flange_b Rotational annotation(
    Placement(transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}})));
Modelica.Blocks.Interfaces.RealOutput PowerTurbine annotation(
    Placement(transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}})));
equation
  
  rotorRadius = rotordiameter/2;
  TSR = (abs(omega)*rotorRadius)/HullSpeed;

  HullSpeed = der(Translational.s);
  omega = der(Rotational.phi);
  
  n = rpm/60;
  rpm = omega*(30/Modelica.Constants.pi);
  
  J = abs(HullSpeed) / (max(abs(n), 1e-3) * rotordiameter);
  
  KtTable.u = J;
  KqTable.u = J;
  Kt = KtTable.y[1];
  Kq = KqTable.y[1];

  
  Drag =  waterDensity  * abs(n) * n * rotordiameter^4 * Kt;
  Torque =  waterDensity  * abs(n) * n * rotordiameter^5 * Kq;
  
   Translational.f = -Drag;
   Rotational.tau = -Torque;
//efficiency = (J/(2*Modelica.Constants.pi)) * (Kt/Kq);
  turbinePower = Torque * omega;
  
  turbinePower = PowerTurbine;
  
  annotation(
    Icon(graphics = {Ellipse(fillPattern = FillPattern.Solid, extent = {{-20, 20}, {20, -20}}), Ellipse(origin = {30, -18}, rotation = 60, fillPattern = FillPattern.Solid, extent = {{8, 34}, {-8, -34}}), Ellipse(origin = {-30, -18}, rotation = -60, fillPattern = FillPattern.Solid, extent = {{8, 34}, {-8, -34}}), Ellipse(origin = {0, 34}, fillPattern = FillPattern.Solid, extent = {{8, 34}, {-8, -34}}), Text(origin = {0, 4}, textColor = {255, 0, 0}, extent = {{-28, 22}, {28, -22}}, textString = "Kt and Kq")}),
    Diagram(graphics));
end turbine;
