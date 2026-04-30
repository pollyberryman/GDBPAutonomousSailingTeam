package GDBPPackage
  model Sail
    Modelica.Blocks.Interfaces.RealInput windDirection annotation(
      Placement(transformation(origin = {-110, -28}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-96, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealInput windSpeed annotation(
      Placement(transformation(origin = {-110, 30}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-96, 40}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Mechanics.Translational.Interfaces.Flange_a flange_a annotation(
      Placement(transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Units.SI.Velocity apparentWindVelocity;
    Modelica.Units.SI.Angle apparentWindDirection;
    Modelica.Units.SI.Angle trueWindDirection;
    Modelica.Units.SI.Velocity boatSpeed;
    Modelica.Units.SI.Force sailDriveForce;
    Modelica.Units.SI.Force aeroForce;
    parameter Modelica.Units.SI.Density airDensity = 1.225;
    parameter Modelica.Units.SI.Area sailArea;
    parameter Real Cd "Effective sail force coefficient";
    parameter Modelica.Units.SI.Angle boatHeading;
  equation
    boatSpeed = der(flange_a.s);
    trueWindDirection = windDirection - boatHeading;
    apparentWindVelocity = (boatSpeed^2 + windSpeed^2 + (2*windSpeed*cos(trueWindDirection)))^0.5;
    apparentWindDirection = arctan((windSpeed*sin(trueWindDirection))/(boatSpeed + windSpeed*cos(trueWindDirection)));
    aeroForce = 0.5*airDensity*sailArea*Cd*apparentWindVelocity^2;
    sailDriveForce = max(0, aeroForce*cos(apparentWindDirection));
    flange_a.f = sailDriveForce;
    annotation(
      Icon(graphics = {Polygon(origin = {-20, 20}, fillPattern = FillPattern.Solid, points = {{40, 60}, {40, -60}, {-40, -60}, {40, 60}}), Polygon(origin = {15, -60}, fillPattern = FillPattern.Solid, points = {{5, 20}, {-5, 20}, {-5, -20}, {5, -20}, {5, 20}})}),
      uses(Modelica(version = "4.1.0")));
  end Sail;

  model Hull
    parameter Modelica.Units.SI.Length HullLength = 21.34;
    parameter Modelica.Units.SI.Mass Mass = 31700;
    parameter Real HullSpeedvsDragTable[:, :] = [0, 0; 3.88768, 500; 7.77536, 1500; 11.66304, 4000; 15.55072, 6500; 19.4384, 10000; 23.32608, 15000; 27.21376, 22000; 31.10144, 28000; 34.98912, 33000];
    Modelica.Units.SI.Velocity HullSpeed;
    Modelica.Units.SI.Force HullDrag;
    Modelica.Units.SI.Force ResultantForce;
    Modelica.Units.SI.Acceleration HullAcceleration;
    Modelica.Blocks.Tables.CombiTable1Ds hullTable(table = HullSpeedvsDragTable);
    Modelica.Mechanics.Translational.Interfaces.Flange_a Translational annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 10}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealInput SailForce annotation(
      Placement(transformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, 60}, extent = {{-20, -20}, {20, 20}})));
  equation
    ResultantForce = SailForce - HullDrag + Translational.f;
    ResultantForce = Mass*HullAcceleration;
    HullAcceleration = der(HullSpeed);
    HullSpeed = hullTable.u;
    HullDrag = hullTable.y[1];
    der(flange_a.s) = HullSpeed;
    annotation(
      Icon(graphics = {Line(origin = {-0.03, 10}, points = {{80.0257, 30}, {-79.9743, 30}, {-79.9743, -30}, {-19.9743, -30}, {0.0256584, -28}, {20.0257, -24}, {40.0257, -16}, {60.0257, -4}, {74.0257, 12}, {80.0257, 30}}), Rectangle(origin = {-50, 10}, fillPattern = FillPattern.Solid, extent = {{-30, 30}, {30, -30}}), Polygon(origin = {30, 10}, fillPattern = FillPattern.Solid, points = {{-50, -30}, {-30, -28}, {-10, -24}, {10, -16}, {30, -4}, {44, 12}, {50, 30}, {-50, 30}, {-50, 30}, {-50, 30}, {-50, -30}})}),
      uses(Modelica(version = "4.1.0")));
  end Hull;

  expandable connector EnvironmentBus
    annotation(
      Icon(graphics = {Rectangle(fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}})}));
  end EnvironmentBus;

  model Environment
    Modelica.Units.SI.Angle WindDirection;
    Modelica.Units.SI.Velocity WindSpeed;
    Modelica.Units.SI.Time WavePeriod;
    Modelica.Units.SI.Length WaveHeight;
    Modelica.Units.SI.Angle WaveDirection;
    Modelica.Units.SI.Time currentTime;
    Modelica.Units.SI.Time StartUnix;
    parameter Integer startYear = 2025;
    parameter Integer startMonth = 1;
    parameter Integer startDay = 1;
    parameter Integer startHour = 0;
    parameter Integer startSecond = 0;
    parameter Real EnvironmentData[:, :] = [0, 0, 0; 1, 0, 0; 2, 0, 1];
    Modelica.Blocks.Tables.CombiTable1Ds EnvDataTable(table = EnvironmentData) annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealOutput windSpeed annotation(
      Placement(transformation(origin = {106, 75}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 99}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealOutput windDirection annotation(
      Placement(transformation(origin = {106, 45}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 60}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealOutput waveHeight annotation(
      Placement(transformation(origin = {106, -15}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, -19}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealOutput waveDirection annotation(
      Placement(transformation(origin = {106, 15}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 20}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealOutput wavePeriod annotation(
      Placement(transformation(origin = {106, -45}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, -60}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealOutput solarPower annotation(
      Placement(transformation(origin = {106, -75}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, -100}, extent = {{-10, -10}, {10, 10}})));
    clock clock1(startYear = startYear, startMonth = startMonth, startDay = startDay, startHour = startHour, startMinute = startMinute, startSecond = startSecond) annotation(
      Placement(transformation(origin = {-29, 71}, extent = {{-10, -10}, {10, 10}})));
  equation
//Calculation of Unix time//
//UnixTime = StartYear, StartMonth, StartDay
    currentTime = StartUnix + time;
    currentTime = EnvDataTable.u;
    envBus.year = EnvDataTable.y[1];
//these shouldn't be outputs. these are kinda inputs. or actually useless. i will calculate unix from start date info and use that as u for table
    envBus.month = EnvDataTable.y[2];
    envBus.day = EnvDataTable.y[3];
    envBus.hour = EnvDataTable.y[4];
    envBus.windSpeed = EnvDataTable.y[7];
    envBus.windDirection = EnvDataTable.y[8];
// (rads)
    envBus.waveDirection = EnvDataTable.y[9];
// (rads)
    envBus.wavePeriod = EnvDataTable.y[10];
    envBus.waveHeight = EnvDataTable.y[11];
    annotation(
      Icon(graphics = {Ellipse(origin = {-56, 57}, lineColor = {255, 220, 24}, fillColor = {255, 220, 24}, fillPattern = FillPattern.Solid, extent = {{-15, 15}, {15, -15}}), Rectangle(origin = {-56, 26}, rotation = 90, lineColor = {255, 220, 24}, fillColor = {255, 220, 24}, fillPattern = FillPattern.Solid, extent = {{-11, -3}, {11, 3}}), Rectangle(origin = {-80, 82}, rotation = -45, lineColor = {255, 220, 24}, fillColor = {255, 220, 24}, fillPattern = FillPattern.Solid, extent = {{-11, -3}, {11, 3}}), Rectangle(origin = {-87, 57}, lineColor = {255, 220, 24}, fillColor = {255, 220, 24}, fillPattern = FillPattern.Solid, extent = {{-11, -3}, {11, 3}}), Rectangle(origin = {-32, 81}, rotation = 45, lineColor = {255, 220, 24}, fillColor = {255, 220, 24}, fillPattern = FillPattern.Solid, extent = {{-11, -3}, {11, 3}}), Rectangle(origin = {-25, 57}, lineColor = {255, 220, 24}, fillColor = {255, 220, 24}, fillPattern = FillPattern.Solid, extent = {{-11, -3}, {11, 3}}), Rectangle(origin = {-56, 88}, rotation = 90, lineColor = {255, 220, 24}, fillColor = {255, 220, 24}, fillPattern = FillPattern.Solid, extent = {{-11, -3}, {11, 3}}), Rectangle(origin = {-79, 33}, rotation = 45, lineColor = {255, 220, 24}, fillColor = {255, 220, 24}, fillPattern = FillPattern.Solid, extent = {{-11, -3}, {11, 3}}), Rectangle(origin = {-32, 34}, rotation = -45, lineColor = {255, 220, 24}, fillColor = {255, 220, 24}, fillPattern = FillPattern.Solid, extent = {{-11, -3}, {11, 3}}), Polygon(origin = {35, 14}, points = {{45, 16}, {45, -25}, {-45, -14}, {-45, 6}, {45, 16}}), Polygon(origin = {0, 10}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, points = {{10, 12}, {10, -12}, {-10, -10}, {-10, 10}, {-10, 10}, {10, 12}}), Polygon(origin = {44.5, 10}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, points = {{-9.5, 15}, {9.5, 17}, {9.5, -18}, {-9.5, -15}, {-9.5, 15}}), Polygon(origin = {83, -25}, fillPattern = FillPattern.Solid, points = {{-3, 55}, {3, 55}, {2, -55}, {-3, -55}, {-3, 55}}), Polygon(origin = {-0.5, 0}, fillColor = {255, 255, 255}, points = {{-99.5, 100}, {100.5, 100}, {100.5, -100}, {-99.5, -100}, {-99.5, 100}}), Polygon(origin = {-51, -53}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, points = {{-39, -24}, {-38, -20}, {-34, -9}, {-26, 3}, {-18, 12}, {-9, 18}, {8, 23}, {24, 26}, {35, 22}, {36, 17}, {31, 13}, {24, 10}, {18, 1}, {18, -2}, {18, -5}, {21, -13}, {26, -18}, {30, -21}, {35, -25}, {-39, -25}, {-39, -24}}), Polygon(origin = {-36, -63}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, points = {{-26, -17}, {-24, -10}, {-21, 1}, {-15, 8}, {-5, 15}, {7, 17}, {15, 18}, {19, 15}, {18, 10}, {14, 8}, {11, 4}, {12, -2}, {16, -9}, {21, -12}, {27, -17}, {-26, -17}, {-26, -17}})}, coordinateSystem(grid = {1, 1})),
      Diagram(coordinateSystem(grid = {1, 1}), graphics),
      version = "",
      uses(Modelica(version = "4.1.0")));
  end Environment;

  model clock "YYYY-MM-DD HH:mm:ss real-time calendar clock"
    parameter Integer startYear = 2025;
    parameter Integer startMonth = 1;
    parameter Integer startDay = 1;
    parameter Integer startHour = 0;
    parameter Integer startMinute = 0;
    parameter Integer startSecond = 0;
    Modelica.Blocks.Interfaces.IntegerOutput year annotation(
      Placement(transformation(origin = {120, 60}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.IntegerOutput month annotation(
      Placement(transformation(origin = {120, 40}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.IntegerOutput day annotation(
      Placement(transformation(origin = {120, 20}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.IntegerOutput hour annotation(
      Placement(transformation(origin = {120, -20}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.IntegerOutput minute annotation(
      Placement(transformation(origin = {120, -40}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.IntegerOutput second annotation(
      Placement(transformation(origin = {120, -60}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.IntegerOutput dateTime[6] annotation(
      Placement(transformation(origin = {0, -120}, extent = {{-20, -10}, {20, 10}})));
  protected
    Integer totalSeconds;
    Integer y, m, d, hh, mm, ss;
    constant Integer monthDays[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

    function isLeapYear
      input Integer Y;
      output Boolean leap;
    algorithm
      leap := (mod(Y, 4) == 0 and mod(Y, 100) <> 0) or (mod(Y, 400) == 0);
    end isLeapYear;

    function dateTimeToSeconds
      input Integer Y, M, D, h, mi, s;
      output Integer seconds;
    protected
      Integer yy, mm, days;
    algorithm
      days := 0;
      for yy in 1970:Y - 1 loop
        if isLeapYear(yy) then
          days := days + 366;
        else
          days := days + 365;
        end if;
      end for;
      for mm in 1:M - 1 loop
        days := days + monthDays[mm];
        if mm == 2 and isLeapYear(Y) then
          days := days + 1;
        end if;
      end for;
      days := days + (D - 1);
      seconds := days*86400 + h*3600 + mi*60 + s;
    end dateTimeToSeconds;

    function secondsToDateTime
      input Integer seconds;
      output Integer Y, M, D, h, mi, s;
    protected
      Integer days;
      Integer yy;
      Integer mm;
      Integer dpm;
      Integer yearLength;
    algorithm
      days := integer(floor(seconds/86400));
      s := mod(seconds, 60);
      mi := integer(floor(mod(seconds, 3600)/60));
      h := integer(floor(mod(seconds, 86400)/3600));
// Year
      yy := 1970;
      for i in 1:300 loop
// supports years up to ~2270
        if isLeapYear(yy) then
          yearLength := 366;
        else
          yearLength := 365;
        end if;
        if days < yearLength then
          break;
        end if;
        days := days - yearLength;
        yy := yy + 1;
      end for;
      Y := yy;
// Month
      mm := 1;
      for i in 1:12 loop
        dpm := monthDays[mm];
        if mm == 2 and isLeapYear(Y) then
          dpm := dpm + 1;
        end if;
        if days < dpm then
          break;
        end if;
        days := days - dpm;
        mm := mm + 1;
      end for;
      M := mm;
      D := days + 1;
    end secondsToDateTime;
  equation
    totalSeconds = dateTimeToSeconds(startYear, startMonth, startDay, startHour, startMinute, startSecond) + integer(floor(time));
    (y, m, d, hh, mm, ss) = secondsToDateTime(totalSeconds);
    year = y;
    month = m;
    day = d;
    hour = hh;
    minute = mm;
    second = ss;
    dateTime = {year, month, day, hour, minute, second};
    annotation(
      Icon(graphics = {Ellipse(lineThickness = 5, extent = {{-100, 100}, {100, -100}}), Rectangle(origin = {0, 70}, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {-60, -34}, rotation = -66, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {61, 32}, rotation = -66, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {38, 60}, rotation = -33, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {-35, -61}, rotation = -33, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {63, -32}, rotation = 66, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {-60, 35}, rotation = 66, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {38, -60}, rotation = 33, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {-38, 58}, rotation = 33, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {-70, 0}, rotation = 90, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {0, -70}, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {70, 0}, rotation = 90, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Polygon(origin = {0, 22}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, points = {{-3, -22}, {-3, 8}, {-10, 8}, {0, 22}, {9, 8}, {2, 8}, {2, -22}, {-3, -22}}), Polygon(origin = {38, 35}, rotation = -45, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-6.53553, -52.4056}, {-3, 8}, {-10, 8}, {0, 22}, {9, 8}, {2, 8}, {-0.828427, -53.1127}, {-6.53553, -52.4056}})}, coordinateSystem(grid = {1, 1})),
      Diagram(coordinateSystem(grid = {1, 1}), graphics));
  end clock;

  //annotation(
  //    Icon(graphics = {Ellipse(lineThickness = 5, extent = {{-100, 100}, {100, -100}}), Rectangle(origin = {0, 70}, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {-60, -34}, rotation = -66, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {61, 32}, rotation = -66, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {38, 60}, rotation = -33, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {-35, -61}, rotation = -33, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {63, -32}, rotation = 66, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {-60, 35}, rotation = 66, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {38, -60}, rotation = 33, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {-38, 58}, rotation = 33, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {-70, 0}, rotation = 90, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {0, -70}, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Rectangle(origin = {70, 0}, rotation = 90, fillPattern = FillPattern.Solid, extent = {{-3, 20}, {3, -20}}), Polygon(origin = {0, 22}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, points = {{-3, -22}, {-3, 8}, {-10, 8}, {0, 22}, {9, 8}, {2, 8}, {2, -22}, {-3, -22}}), Polygon(origin = {38, 35}, rotation = -45, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-6.53553, -52.4056}, {-3, 8}, {-10, 8}, {0, 22}, {9, 8}, {2, 8}, {-0.828427, -53.1127}, {-6.53553, -52.4056}})}, coordinateSystem(grid = {1, 1})),
  //Diagram(coordinateSystem(grid = {1, 1}), graphics));
  //end clock;

  model Battery
    import Modelica.Electrical.Analog.Interfaces.Pin;
    // --- Electrical pins ---
    // --- Parameters ---
    parameter Real C_nom(unit = "A.h") = 2.5 "Battery capacity (Ah)";
    parameter Real R_internal(unit = "Ohm") = 0.05 "Internal resistance";
    parameter Real SOC_initial = 0.8 "Initial state of charge (0..1)";
    parameter Real V_oc0 = 3.0 "Open-circuit voltage at SOC=0";
    parameter Real V_oc1 = 4.2 "Open-circuit voltage at SOC=1";
    // --- Variables ---
    Real SOC(start = SOC_initial, min = 0, max = 1);
    Real I "Battery current (+ discharging)";
    Real V_oc "Open-circuit voltage";
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
      Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-40, 54}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {40, 54}, extent = {{-10, -10}, {10, 10}})));
  equation
// Electrical current direction: p -> n
    I = pin_p.i;
    pin_p.i + pin_n.i = 0;
// Terminal voltage:
    pin_p.v - pin_n.v = V_oc - I*R_internal;
// OCV as linear approximation
    V_oc = V_oc0 + SOC*(V_oc1 - V_oc0);
// SOC dynamics:
    der(SOC) = -I/(C_nom*3600);
// convert Ah capacity to Coulombs
    annotation(
      Icon(graphics = {Rectangle(origin = {0, -9}, lineColor = {0, 0, 127}, fillColor = {0, 0, 135}, lineThickness = 5, extent = {{-80, -51}, {80, 51}}), Rectangle(origin = {1, -10}, lineColor = {255, 255, 255}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, lineThickness = 5, extent = {{-69, 40}, {69, -40}})}));
  end Battery;

  model battery2
    parameter Real C_nom(unit = "A.h") = 2.5 "Battery capacity (Ah)";
    parameter Real R_internal(unit = "Ohm") = 0.05 "Internal resistance";
    parameter Integer SOC_initial = 0.8 "Initial state of charge (0..1)";
    //parameter Real V_oc0 = 3.0 "Open-circuit voltage at SOC=0";
    //parameter Real V_oc1 = 4.2 "Open-circuit voltage at SOC=1";
    Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
      Placement(transformation(origin = {-96, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Math.Gain gain(k = -1/(C_nom*3600)) annotation(
      Placement(transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Continuous.Integrator integrator(y_start = SOC_initial) annotation(
      Placement(transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Nonlinear.Limiter limiter(uMax = 1, uMin = 0) annotation(
      Placement(transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table = [0.0, 3.0; 0.2, 3.4; 0.5, 3.7; 0.8, 4.0; 1.0, 4.2]) annotation(
      Placement(transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
      Placement(transformation(origin = {-90, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-40, 54}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
      Placement(transformation(origin = {90, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {40, 54}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor annotation(
      Placement(transformation(origin = {-46, 76}, extent = {{-10, -10}, {10, 10}})));
  equation
    pin_p.i = -pin_n.i;
    pin_p.v - pin_n.v = combiTable1Ds.y[1] - currentSensor.i*R_internal;
    connect(currentSensor.i, gain.u) annotation(
      Line(points = {{-85, 0}, {-63, 0}}, color = {0, 0, 127}));
    connect(gain.y, integrator.u) annotation(
      Line(points = {{-39, 0}, {-23, 0}}, color = {0, 0, 127}));
    connect(integrator.y, limiter.u) annotation(
      Line(points = {{1, 0}, {17, 0}}, color = {0, 0, 127}));
    connect(limiter.y, combiTable1Ds.u) annotation(
      Line(points = {{42, 0}, {58, 0}}, color = {0, 0, 127}));
    connect(currentSensor.p, pin_p) annotation(
      Line(points = {{-96, -10}, {-132, -10}, {-132, 50}, {-90, 50}}, color = {0, 0, 255}));
    connect(currentSensor.n, pin_n) annotation(
      Line(points = {{-96, 10}, {-68, 10}, {-68, 50}, {90, 50}}, color = {0, 0, 255}));
    connect(voltageSensor.p, pin_p) annotation(
      Line(points = {{-56, 76}, {-90, 76}, {-90, 50}}, color = {0, 0, 255}));
    connect(voltageSensor.n, pin_n) annotation(
      Line(points = {{-36, 76}, {90, 76}, {90, 50}}, color = {0, 0, 255}));
    annotation(
      Diagram(graphics),
      Icon(graphics = {Rectangle(origin = {0, -9}, lineColor = {0, 0, 127}, fillColor = {0, 0, 135}, lineThickness = 5, extent = {{-80, -51}, {80, 51}}), Rectangle(origin = {1, -10}, lineColor = {255, 255, 255}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, lineThickness = 5, extent = {{-69, 40}, {69, -40}})}));
  end battery2;

  model battery3
    parameter Real C_nom(unit = "A.h") = 2500 "Battery capacity (Ah)";
    parameter Real R_internal(unit = "Ohm") = 0.05 "Internal resistance";
    parameter Real SOC_initial = 0.8 "Initial state of charge (0..1)";
    parameter Real min_SOC = 0.1 "Minimum allowable SOC"; 
    
    Modelica.Units.SI.Power batteryPower;
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-40, 54}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
      Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {40, 54}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Electrical.Analog.Sources.SignalVoltage signalVoltage annotation(
      Placement(transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Electrical.Analog.Basic.Resistor resistor(R = R_internal) annotation(
      Placement(transformation(origin = {6, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
    Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
      Placement(transformation(origin = {-34, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
    Modelica.Blocks.Continuous.Integrator integrator(y_start = 0, initType = Modelica.Blocks.Types.Init.InitialState) annotation(
      Placement(transformation(origin = {-16, -30}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Math.Gain gain(k = 1/(C_nom*3600)) annotation(
      Placement(transformation(origin = {30, -30}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Math.Add add(k1 = 1, k2 = -1) annotation(
      Placement(transformation(origin = {78, -24}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Sources.Constant const(k = SOC_initial) annotation(
      Placement(transformation(origin = {51, -17}, extent = {{-5, -5}, {5, 5}})));
    Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table  = [0,2.6;0.05,3.41;0.1,3.46;0.15,3.49;0.2,3.54;0.25,3.58;0.3,3.6;0.35,3.61;0.4,3.62; 0.45,3.64;0.5,3.65;0.55,3.67;0.6,3.7;0.65,3.75;0.7,3.79;0.75,3.83;0.8,3.87;0.85,3.93;0.9,3.99;0.95,4.03;1,4.1]) annotation(
      Placement(transformation(origin = {118, -24}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealOutput SOC annotation(
      Placement(transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {4, -60}, extent = {{-10, -10}, {10, 10}})));
  equation
  
    when SOC <= min_SOC then
      terminate("Battery SOC limit reached");
     end when;
     
    when SOC <= min_SOC then
      terminate("Battery SOC limit reached");
     end when;
    
    batteryPower = pin_p.v * pin_p.i;
    
    connect(signalVoltage.n, pin_n) annotation(
      Line(points = {{60, 0}, {100, 0}}, color = {0, 0, 255}));
    connect(currentSensor.i, integrator.u) annotation(
      Line(points = {{-34, -11}, {-34, -30.5}, {-28, -30.5}, {-28, -30}}, color = {0, 0, 127}));
    connect(integrator.y, gain.u) annotation(
      Line(points = {{-5, -30}, {18, -30}}, color = {0, 0, 127}));
    connect(combiTable1Ds.u, add.y) annotation(
      Line(points = {{106, -24}, {89, -24}}, color = {0, 0, 127}));
    connect(add.y, SOC) annotation(
      Line(points = {{89, -24}, {92, -24}, {92, 60}, {0, 60}}, color = {0, 0, 127}));
    connect(const.y, add.u1) annotation(
      Line(points = {{56, -16}, {66, -16}, {66, -18}}, color = {0, 0, 127}));
    connect(gain.y, add.u2) annotation(
      Line(points = {{42, -30}, {66, -30}}, color = {0, 0, 127}));
  connect(currentSensor.p, pin_p) annotation(
      Line(points = {{-44, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(currentSensor.n, resistor.p) annotation(
      Line(points = {{-24, 0}, {-4, 0}}, color = {0, 0, 255}));
  connect(resistor.n, signalVoltage.p) annotation(
      Line(points = {{16, 0}, {40, 0}}, color = {0, 0, 255}));
  connect(combiTable1Ds.y[1], signalVoltage.v) annotation(
      Line(points = {{130, -24}, {140, -24}, {140, 30}, {50, 30}, {50, 12}}, color = {0, 0, 127}));
    annotation(
      Diagram(graphics),
      Icon(graphics = {Rectangle(origin = {0, -9}, lineColor = {0, 0, 127}, fillColor = {0, 0, 135}, lineThickness = 5, extent = {{-80, -51}, {80, 51}}), Rectangle(origin = {1, -10}, lineColor = {255, 255, 255}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, lineThickness = 5, extent = {{-69, 40}, {69, -40}})}));
  end battery3;

  model motor
    parameter Real resistance;
    parameter Real backEMF;
    Modelica.Units.SI.Power mechanicalPower;
    Modelica.Units.SI.Power electricalPower;
    Modelica.Units.SI.AngularVelocity omega;
    Modelica.Units.SI.Torque motorTorque;
    
    
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
      Placement(transformation(origin = {-100, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-102, -70}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
      Placement(transformation(origin = {-100, -50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 70}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft annotation(
      Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {80, 10}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Electrical.Analog.Basic.Inductor inductor(L = 0.001) annotation(
      Placement(transformation(origin = {2, -40}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Electrical.Analog.Basic.RotationalEMF emf(k = backEMF) annotation(
      Placement(transformation(origin = {20, 0}, extent = {{-10, 10}, {10, -10}}, rotation = -0)));
    Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 0.6) annotation(
      Placement(transformation(origin = {64, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor(R = resistance)  annotation(
      Placement(transformation(origin = {-30, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sources.SignalVoltage signalVoltage annotation(
      Placement(transformation(origin = {-48, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput motorDemand annotation(
      Placement(transformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {4, 100}, extent = {{-20, -20}, {20, 20}})));
  equation
    omega = der(shaft.phi);
    motorTorque = shaft.tau;
    mechanicalPower = omega*motorTorque;
    electricalPower = pin_p.v*pin_p.i;
    connect(emf.flange, inertia.flange_a) annotation(
      Line(points = {{30, 0}, {54, 0}}));
    connect(inertia.flange_b, shaft) annotation(
      Line(points = {{74, 0}, {100, 0}}));
    connect(resistor.n, inductor.p) annotation(
      Line(points = {{-20, -40}, {-8, -40}}, color = {0, 0, 255}));
    connect(inductor.n, emf.p) annotation(
      Line(points = {{12, -40}, {12, -39}, {20, -39}, {20, -10}}, color = {0, 0, 255}));
  connect(signalVoltage.n, resistor.p) annotation(
      Line(points = {{-48, -10}, {-48, -40}, {-40, -40}}, color = {0, 0, 255}));
  connect(signalVoltage.p, emf.n) annotation(
      Line(points = {{-48, 10}, {-46, 10}, {-46, 38}, {20, 38}, {20, 10}}, color = {0, 0, 255}));
  connect(signalVoltage.p, pin_p) annotation(
      Line(points = {{-48, 10}, {-50, 10}, {-50, 40}, {-100, 40}}, color = {0, 0, 255}));
  connect(signalVoltage.n, pin_n) annotation(
      Line(points = {{-48, -10}, {-52, -10}, {-52, -50}, {-100, -50}}, color = {0, 0, 255}));
  connect(signalVoltage.v, motorDemand) annotation(
      Line(points = {{-36, 0}, {-12, 0}, {-12, 100}, {0, 100}}, color = {0, 0, 127}));
    annotation(
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(origin = {2.835, 10}, fillColor = {0, 128, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-60, -60}, {60, 60}}), Rectangle(origin = {2.835, 10}, fillColor = {128, 128, 128}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-80, -60}, {-60, 60}}), Rectangle(origin = {2.835, 10}, fillColor = {95, 95, 95}, fillPattern = FillPattern.HorizontalCylinder, extent = {{60, -10}, {80, 10}}), Rectangle(origin = {2.835, 10}, lineColor = {95, 95, 95}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-60, 50}, {20, 70}}), Polygon(origin = {2.835, 10}, fillPattern = FillPattern.Solid, points = {{-70, -90}, {-60, -90}, {-30, -20}, {20, -20}, {50, -90}, {60, -90}, {60, -100}, {-70, -100}, {-70, -90}})}),
      experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
  end motor;

  model myCellStack
    extends Modelica.Electrical.Batteries.BatteryStacks.CellStack(cellData(Qnom(displayUnit = "C") = 2.5, useLinearSOCDependency = true, OCVmax = 4.2, OCVmin = 3, Ri = 0.05));
  equation

  end myCellStack;

  model constantWind
    parameter Modelica.Units.SI.Velocity windSpeedInput;
    parameter Modelica.Units.SI.Angle windDirectionInput;
    Modelica.Blocks.Interfaces.RealOutput windSpeed annotation(
      Placement(transformation(origin = {98, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {86, 50}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealOutput windDirection annotation(
      Placement(transformation(origin = {96, -8}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {86, -10}, extent = {{-10, -10}, {10, 10}})));
  equation
    windSpeed = windSpeedInput;
    windDirection = windDirectionInput;
    annotation(
      Diagram(coordinateSystem(grid = {2, 2})),
      Icon(graphics = {Polygon(origin = {-31, 26}, points = {{97, 54}, {97, -7}, {-29, 4}, {-29, 34}, {97, 54}}), Polygon(origin = {-50, 50}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, points = {{30, 16}, {30, -24}, {-10, -20}, {-10, 10}, {-10, 10}, {30, 16}}), Polygon(origin = {20.5, 56}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, points = {{-9.5, 17}, {17.5, 21}, {17.5, -36}, {-9.5, -33}, {-9.5, 17}}), Polygon(origin = {69, 25}, fillPattern = FillPattern.Solid, points = {{-3, 55}, {11, 55}, {11, -105}, {-3, -105}, {-3, 55}})}, coordinateSystem(grid = {2, 2})));
  end constantWind;

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
    Real J;             //Advance Velocity Ratio
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

  model turbineSimple
    Modelica.Mechanics.Translational.Interfaces.Flange_a Translational annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a Rotational annotation(
      Placement(transformation(origin = {0, 98}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, 98}, extent = {{-10, -10}, {10, 10}})));
    //parameter Modelica.Units.SI.Density waterDensity = 1250;
    //parameter Modelica.Units.SI.Length diameter = 1;
    parameter Real HullSpeedvsTurbineDragTable[:, :];
    parameter Real HullSpeedvsTurbineTorqueTable[:, :];
    Modelica.Units.SI.AngularVelocity TurbineSpeed;
    //******* SOMETHING ABOUT RPS VS RAD/S ************
    Modelica.Units.SI.Force Drag;
    Modelica.Units.SI.Torque Torque;
    Modelica.Units.SI.Velocity HullSpeed;
    Modelica.Units.SI.Power TranslationalPower;
    Modelica.Units.SI.Power ShaftPower;
    Modelica.Units.SI.Efficiency efficiency;
    Modelica.Blocks.Tables.CombiTable1Ds TurbineDragvsHullSpeed(table = HullSpeedvsTurbineDragTable) annotation(
      Placement(transformation(origin = {0, 30}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Tables.CombiTable1Ds TurbineTorquevsHullSpeed(table = HullSpeedvsTurbineTorqueTable) annotation(
      Placement(transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}})));
  equation
    HullSpeed = der(Translational.s);
    TurbineSpeed = der(Rotational.phi);
    TurbineDragvsHullSpeed.u = HullSpeed;
    TurbineTorquevsHullSpeed.u = HullSpeed;
    Drag = TurbineDragvsHullSpeed.y[1];
    Torque = TurbineTorquevsHullSpeed.y[1];
    -Drag = Translational.f;
    -Torque = Rotational.tau;
    TranslationalPower = Drag*HullSpeed;
    ShaftPower = Torque*TurbineSpeed;
    Efficiency = ShaftPower/abs(TranslationalPower);
    annotation(
      Icon(graphics = {Ellipse(fillPattern = FillPattern.Solid, extent = {{-20, 20}, {20, -20}}), Ellipse(origin = {30, -18}, rotation = 60, fillPattern = FillPattern.Solid, extent = {{8, 34}, {-8, -34}}), Ellipse(origin = {-30, -18}, rotation = -60, fillPattern = FillPattern.Solid, extent = {{8, 34}, {-8, -34}}), Ellipse(origin = {0, 34}, fillPattern = FillPattern.Solid, extent = {{8, 34}, {-8, -34}})}),
      Diagram(graphics));
  end turbineSimple;

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

  model sailVPP
    Modelica.Blocks.Interfaces.RealInput windDirection annotation(
      Placement(transformation(origin = {-34, -62}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-96, -20}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealInput windSpeed annotation(
      Placement(transformation(origin = {-34, -4}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-96, 20}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Mechanics.Translational.Interfaces.Flange_a flange_a annotation(
      Placement(transformation(origin = {76, -134}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}})));
    parameter Real VPPdataSailForce[:, :];
    parameter Real VPPdataBoatSpeed[:, :];
    Modelica.Units.SI.Force sailForce;
    Modelica.Units.SI.Velocity boatSpeed;
    Modelica.Blocks.Tables.CombiTable2Ds windspeeddirectionSailForce(table = VPPdataSailForce);
    Modelica.Blocks.Tables.CombiTable2Ds windspeeddirectionBoatSpeed(table = VPPdataBoatSpeed);
  equation
    sailForce = windspeeddirectionSailForce.y[1];
    windspeeddirectionSailForce.u[1] = windSpeed;
    windspeeddirectionSailForce.u[2] = windDirection;
    boatSpeed = windspeeddirectionBoatSpeed.y[1];
    windspeeddirectionBoatSpeed.u[1] = windSpeed;
    windspeeddirectionBoatSpeed.u[2] = windDirection;
    flange_a.f = sailForce;
//der(flange_a.s) = boatSpeed;
    annotation(
      Diagram(graphics),
      Icon(graphics = {Polygon(origin = {-20, 20}, fillPattern = FillPattern.Solid, points = {{40, 60}, {40, -60}, {-40, -60}, {40, 60}}), Polygon(origin = {15, -60}, fillPattern = FillPattern.Solid, points = {{5, 20}, {-5, 20}, {-5, -20}, {5, -20}, {5, 20}}), Text(origin = {-10, 0}, textColor = {255, 0, 0}, extent = {{-58, -46}, {58, 0}}, textString = "VPP")}));
  end sailVPP;

  model electrolyser
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
      Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealOutput H2_rate annotation(
      Placement(transformation(origin = {18, 56}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {18, 56}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealOutput P_out annotation(
      Placement(transformation(origin = {-50, 58}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-50, 58}, extent = {{-10, -10}, {10, 10}})));
  equation

  end electrolyser;

  model motorLookuptable
    Modelica.Blocks.Tables.CombiTable1Ds torqueLookup(table = [0,450;52.3598775598299,450;104.71975511966,450;157.07963267949,450;209.43951023932,450;261.799387799149,450;311.017672705389,450;366.519142918809,380;418.879020478639,335;471.238898038469,298;523.598775598299,269]
  , extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation(
      Placement(transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Units.SI.AngularVelocity shaftspeed;
    Modelica.Units.SI.Torque motorTorque;
    Modelica.Blocks.Interfaces.RealOutput motorPower annotation(
      Placement(transformation(origin = {104, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {104, 0}, extent = {{-10, -10}, {10, 10}})));
  equation
    shaftspeed = der(shaft.phi);
    shaft.tau = motorTorque;
//-sign(shaftspeed)
    torqueLookup.u = abs(shaftspeed);
    motorTorque = torqueLookup.y[1];
    motorPower = abs(shaft.tau*shaftspeed);
    annotation(
      Diagram(graphics),
      Icon(graphics = {Rectangle(origin = {2.835, 10}, fillColor = {0, 128, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-60, -60}, {60, 60}}), Rectangle(origin = {2.835, 10}, fillColor = {128, 128, 128}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-80, -60}, {-60, 60}}), Rectangle(origin = {2.835, 10}, fillColor = {95, 95, 95}, fillPattern = FillPattern.HorizontalCylinder, extent = {{60, -10}, {80, 10}}), Rectangle(origin = {2.835, 10}, lineColor = {95, 95, 95}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-60, 50}, {20, 70}}), Polygon(origin = {2.835, 10}, fillPattern = FillPattern.Solid, points = {{-70, -90}, {-60, -90}, {-30, -20}, {20, -20}, {50, -90}, {60, -90}, {60, -100}, {-70, -100}, {-70, -90}}), Text(origin = {-1, 20}, extent = {{-51, 20}, {51, -20}}, textString = "TABLE")}));
  end motorLookuptable;

  model simpleElectrolyser
    Modelica.Blocks.Interfaces.RealInput inputPower annotation(
      Placement(transformation(origin = {-104, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-98, -1.77636e-15}, extent = {{-10, -10}, {10, 10}})));
    parameter Real fractPowervsElectrolyserEff[:, :] = [0, 0; 0.1, 0.25; 0.15, 0.4; 0.2, 0.53; 0.25, 0.65; 0.3, 0.68; 0.35, 0.68; 0.4, 0.675; 0.45, 0.67; 0.5, 0.67; 0.55, 0.67; 0.6, 0.665; 0.65, 0.66; 0.7, 0.655; 0.75, 0.65; 0.8, 0.645; 0.85, 0.64; 0.9, 0.635; 0.95, 0.63; 1, 0.625];
    parameter Modelica.Units.SI.Power ratedPower = 174000;
    parameter Real LHVH2 = 120e6 "Lower heating value of Hydrogen (J/kg)";
    parameter Real waterPerKgH2 = 9.9 "Water consumption per kg of H2 made (L/kg = kg/kg)";
    parameter Modelica.Units.SI.Pressure H2deliveryPressure(displayUnit = "bar")= 3e6;
    Modelica.Units.SI.Efficiency efficiency;
    Modelica.Units.SI.Mass massH2;
    //Modelica.Units.SI.Mass massH2O; //////do i need mass or volume h2o?
    Real fractionofPower;
    Modelica.Units.SI.MassFlowRate mH2;
    Modelica.Units.SI.MassFlowRate mH2O;
    Real mH2_kgph;
    Modelica.Blocks.Tables.CombiTable1Ds electrolyserEff(table = fractPowervsElectrolyserEff, smoothness = Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation(
      Placement(transformation(origin = {-10, 32}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealOutput H2_flowrate annotation(
      Placement(transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {104, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput H2O_flowrate annotation(
      Placement(transformation(origin = {104, -42}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {104, -30}, extent = {{-10, -10}, {10, 10}})));
  equation
    fractionofPower = inputPower/ratedPower;
    electrolyserEff.u = fractionofPower;
    electrolyserEff.y[1] = efficiency;
    mH2 = (inputPower*efficiency)/LHVH2;
    mH2_kgph = mH2*3600;
  
    der(massH2) = mH2;
    
    mH2O = waterPerKgH2 * mH2;
// Real outputs
    H2_flowrate = mH2;
    H2O_flowrate = mH2O;
  
  annotation(
      Diagram(graphics),
      Icon(graphics = {Polygon(rotation = -90,lineColor = {0, 170, 0}, fillColor = {0, 170, 0}, fillPattern = FillPattern.Solid, points = {{-90, 30}, {-100, 30}, {-110, 10}, {-110, -10}, {-100, -30}, {-90, -30}, {-90, 30}}), Rectangle(rotation = -90,lineColor = {0, 85, 0}, extent = {{-90, 60}, {90, -60}}, radius = 10), Rectangle(rotation = -90,lineColor = {0, 85, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{90, 40}, {110, -40}}), Rectangle(rotation = -90,lineColor = {0, 170, 0}, fillColor = {0, 170, 0}, fillPattern = FillPattern.Solid, extent = {{70, -40}, {-70, 40}}), Rectangle(origin = {0, 56}, extent = {{-34, 8}, {34, -8}}), Rectangle(origin = {0, 34}, extent = {{-34, 8}, {34, -8}}), Rectangle(origin = {0, 12}, extent = {{-34, 8}, {34, -8}}), Rectangle(origin = {0, -10}, extent = {{-34, 8}, {34, -8}}), Rectangle(origin = {0, -32}, extent = {{-34, 8}, {34, -8}}), Rectangle(origin = {0, -54}, extent = {{-34, 8}, {34, -8}})}),
  experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
end simpleElectrolyser;

  model simpleCompressor
  Modelica.Blocks.Interfaces.RealInput mH2 annotation(
      Placement(transformation(origin = {-104, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}})));
  parameter Real compkWhPerKgH2 = 1.84 "Compressor energy per kg H2 (kWh/kg)"; // this comes from Energy and the Hydrogen Economy graph, output comp pressure vs comp energy required
  Real compJperkg;
  Modelica.Blocks.Interfaces.RealOutput compressorPower annotation(
      Placement(transformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput mH2_out annotation(
      Placement(transformation(origin = {98, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {98, 30}, extent = {{-10, -10}, {10, 10}})));
  equation
  compJperkg = 3.6*10^6 * compkWhPerKgH2;
  compressorPower = mH2 * compJperkg;
  mH2_out = mH2;
  
  annotation(
      Icon(graphics = {Ellipse(fillColor = {0, 0, 255}, fillPattern = FillPattern.Sphere, extent = {{-60, 60}, {60, -60}}), Rectangle(origin = {0, -65}, fillPattern = FillPattern.Solid, extent = {{-80, 5}, {80, -5}}), Line(origin = {0.99, -44.82}, points = {{-52.9881, 14.8235}, {-66.9881, -15.1765}, {67.0119, -15.1765}, {51.0119, 14.8235}}, thickness = 2), Text(origin = {-2, 3}, textColor = {255, 255, 255}, extent = {{-50, 31}, {50, -31}}, textString = "H2 comp")}));
annotation(
      Icon(graphics = {Ellipse(origin = {0, 10}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Sphere, extent = {{-70, 70}, {70, -70}}), Rectangle(origin = {0, -70}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, extent = {{-80, 10}, {80, -10}}), Line(origin = {-69, -45}, points = {{11, 15}, {-9, -15}, {11, 15}}, thickness = 3), Line(origin = {68, -46}, points = {{10, -16}, {-14, 14}}, thickness = 3), Text(origin = {1, 12}, textColor = {255, 255, 255}, extent = {{-69, 54}, {69, -54}}, textString = "compressor")}));
end simpleCompressor;

  model H2Tanks
    parameter Integer numberOfTanks = 23;
    parameter Modelica.Units.SI.Mass massH2perTank = 21.7;
    parameter Modelica.Units.SI.Mass initialH2stored = 0;
    Modelica.Blocks.Interfaces.RealInput mH2_in annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}})));
    parameter Modelica.Units.SI.Mass H2_max = numberOfTanks * massH2perTank;
    Modelica.Units.SI.Mass H2_stored(start = initialH2stored);
    Modelica.Blocks.Interfaces.RealOutput tankSOC annotation(
      Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {104, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput H2_mass annotation(
      Placement(transformation(origin = {102, 48}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 48}, extent = {{-10, -10}, {10, 10}})));
  equation
  
    when H2_mass >= H2_max then
      terminate("H2 tanks full: 500kg H2 stored");
     end when;
     
     
    der(H2_stored) =
      if H2_stored < H2_max then 
        mH2_in 
      else
        0;
  tankSOC = H2_stored / H2_max;
  
  H2_mass = H2_stored;
  
  annotation(
      Icon(graphics = {Rectangle(origin = {-40, 4}, lineColor = {0, 0, 127}, fillColor = {0, 0, 255}, pattern = LinePattern.None, fillPattern = FillPattern.VerticalCylinder, extent = {{-30, 70}, {30, -70}}), Ellipse(origin = {-40, 73}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, extent = {{-30, -13}, {30, 13}}), Ellipse(origin = {-40, -66}, lineColor = {0, 0, 127}, fillColor = {0, 0, 255}, pattern = LinePattern.None, fillPattern = FillPattern.VerticalCylinder, extent = {{-30, -14}, {30, 14}}), Rectangle(origin = {40, 4}, lineColor = {0, 0, 127}, fillColor = {0, 0, 255}, pattern = LinePattern.None, fillPattern = FillPattern.VerticalCylinder, extent = {{-30, 70}, {30, -70}}), Ellipse(origin = {40, 73}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, extent = {{-30, -13}, {30, 13}}), Ellipse(origin = {40, -66}, lineColor = {0, 0, 127}, fillColor = {0, 0, 255}, pattern = LinePattern.None, fillPattern = FillPattern.VerticalCylinder, extent = {{-30, -14}, {30, 14}}), Text(origin = {-39, 2}, textColor = {255, 255, 255}, extent = {{-21, 14}, {21, -14}}, textString = "H2"), Text(origin = {41, 2}, textColor = {255, 255, 255}, extent = {{-21, 14}, {21, -14}}, textString = "H2")}),
  Diagram(graphics));
end H2Tanks;

  model waterSupplySubsystem
  parameter Modelica.Units.SI.Power desalintorPower = 750;
  parameter Integer desalinatorProductionRate = 60 "Desalinator water production rate (L/h)";
  parameter Modelica.Units.SI.Mass initialWaterMass = 40 "Initial mass of water in tank";
  parameter Modelica.Units.SI.Mass waterTankCapacity = 60;
  parameter Modelica.Units.SI.Mass waterTankMIN = 20;
  parameter Modelica.Units.SI.Mass waterTankMAX = 55;
  Modelica.Units.SI.Mass waterStored(start = initialWaterMass);
  parameter Modelica.Units.SI.MassFlowRate desalRate = desalinatorProductionRate/3600 "Water production rate (kg/s)";
  Boolean desalON(start = false);
  Modelica.Units.SI.MassFlowRate waterIN;
  Modelica.Units.SI.Power P_desal_avg;
  Modelica.Units.SI.Energy desalEnergy;
  Modelica.Blocks.Interfaces.RealInput H2Odemand annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput powerDemand annotation(
      Placement(transformation(origin = {102, 2}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}})));
  equation

  der(waterStored) = waterIN - H2Odemand;
  
  when waterStored <= waterTankMIN then
  desalON = true;
  elsewhen waterStored >= waterTankMAX then
  desalON = false;
  end when;
  
  waterIN = if desalON then desalRate else 0;
  powerDemand = if desalON then desalintorPower else 0;
  
  der(desalEnergy) = powerDemand;  // J
  P_desal_avg  = desalEnergy / time;
  
  annotation(
      Icon(graphics = {Line(origin = {0, -10}, points = {{-80, 90}, {-80, -70}, {80, -70}, {80, 90}, {60, 90}, {60, -48}, {-60, -48}, {-60, 90}, {-80, 90}}, thickness = 3.75), Line(origin = {-54, 24}, points = {{0, 0}}), Polygon(origin = {0, -12}, fillColor = {0, 170, 255}, fillPattern = FillPattern.Solid, points = {{-58, 86}, {58, 86}, {58, -46}, {-58, -44}, {-58, 86}}), Rectangle(origin = {-70, 0}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, extent = {{-8, 78}, {8, -78}}), Rectangle(origin = {1, -69}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, extent = {{63, 9}, {-63, -9}}), Rectangle(origin = {70, 0}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, extent = {{8, 78}, {-8, -78}}), Text(origin = {1, 13}, textColor = {255, 255, 255}, extent = {{-53, 47}, {53, -47}}, textString = "H2O")}),
  Diagram(graphics));
end waterSupplySubsystem;

  model powerManagement
  parameter Modelica.Units.SI.Power maxElectrolyserPower = 120000;
  Modelica.Blocks.Interfaces.RealInput motorPower annotation(
      Placement(transformation(origin = {-100, 30}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, 40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput electrolyserPower annotation(
      Placement(transformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput desalinatorDemand annotation(
      Placement(transformation(origin = {-100, -30}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, -40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput compressorDemand annotation(
      Placement(transformation(origin = {-100, -90}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, -100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput auxPower annotation(
      Placement(transformation(origin = {-100, 90}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, 100}, extent = {{-20, -20}, {20, 20}})));
  equation
  electrolyserPower = min(max(0,motorPower - desalinatorDemand - compressorDemand  - auxPower),maxElectrolyserPower);
  
  annotation(
      Icon(graphics = {Rectangle(fillColor = {182, 182, 182}, fillPattern = FillPattern.Sphere, extent = {{-94, 94}, {94, -94}}), Text(origin = {-3, 15}, extent = {{-77, 69}, {77, -69}}, textString = "1")}));
end powerManagement;

  model auxLoad
  Modelica.Blocks.Interfaces.RealOutput auxPower annotation(
      Placement(transformation(origin = {2, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {2, 100}, extent = {{-10, -10}, {10, 10}})));
  parameter Modelica.Units.SI.Power auxiliaryPower = 5000  "Base auxiliary power consumption (W)";
  
  equation

  auxPower = auxiliaryPower;
  
  annotation(
      Icon(graphics = {Polygon(origin = {20, 0}, fillColor = {0, 0, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-18, 40}, {-60, -20}, {-20, -20}, {-32, -72}, {6, -20}, {20, 0}, {-20, 0}, {-8, 54}, {-18, 40}, {-18, 40}})}));
end auxLoad;
  
  model motorLookuptablePowerDemand
    Modelica.Blocks.Tables.CombiTable1Ds torqueLookup(table = [0,450;52.3598775598299,450;104.71975511966,450;157.07963267949,450;209.43951023932,450;261.799387799149,450;311.017672705389,450;366.519142918809,380;418.879020478639,335;471.238898038469,298;523.598775598299,269]
  , extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation(
      Placement(transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Units.SI.AngularVelocity omega(start=100);
    Modelica.Units.SI.Torque tau_required;
    Modelica.Units.SI.Torque tau_max;
    Modelica.Units.SI.Torque tau_generator;
    Modelica.Units.SI.AngularVelocity omega_min = 1e-3;
  Modelica.Blocks.Interfaces.RealInput motorPowerDemand annotation(
      Placement(transformation(origin = {-10, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput motorPowerActual annotation(
      Placement(transformation(origin = {104, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}})));
  equation
    omega = der(shaft.phi);
    
    tau_required = 
      if abs(omega) > omega_min then
        abs(motorPowerDemand) / abs(omega)
      else
        0;
    torqueLookup.u = abs(omega);
    tau_max = torqueLookup.y[1];
    tau_generator = min(tau_required, tau_max);
    shaft.tau = -tau_generator * sign(omega);
    motorPowerActual = tau_generator * abs(omega);
    
    annotation(
      Diagram(graphics),
      Icon(graphics = {Rectangle(origin = {2.835, 10}, fillColor = {0, 128, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-60, -60}, {60, 60}}), Rectangle(origin = {2.835, 10}, fillColor = {128, 128, 128}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-80, -60}, {-60, 60}}), Rectangle(origin = {2.835, 10}, fillColor = {95, 95, 95}, fillPattern = FillPattern.HorizontalCylinder, extent = {{60, -10}, {80, 10}}), Rectangle(origin = {2.835, 10}, lineColor = {95, 95, 95}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-60, 50}, {20, 70}}), Polygon(origin = {2.835, 10}, fillPattern = FillPattern.Solid, points = {{-70, -90}, {-60, -90}, {-30, -20}, {20, -20}, {50, -90}, {60, -90}, {60, -100}, {-70, -100}, {-70, -90}}), Text(origin = {-1, 20}, extent = {{-51, 20}, {51, -20}}, textString = "TABLE")}));
  end motorLookuptablePowerDemand;
  
  model powerManagement2
  Modelica.Blocks.Interfaces.RealInput electrolyserDemand annotation(
      Placement(transformation(origin = {-100, 30}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, 40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput motorPowerDemand(start=140000) annotation(
      Placement(transformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {104, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput desalinatorDemand annotation(
      Placement(transformation(origin = {-100, -30}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, -40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput compressorDemand annotation(
      Placement(transformation(origin = {-100, -90}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, -100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput auxPower annotation(
      Placement(transformation(origin = {-100, 90}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, 100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput electrolyserPowerSupply annotation(
      Placement(transformation(origin = {98, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {104, 40}, extent = {{-10, -10}, {10, 10}})));
  
  Modelica.Units.SI.Power P_fixed;
  Modelica.Units.SI.Power P_remaining;
  Modelica.Blocks.Interfaces.RealInput motorPowerActual annotation(
      Placement(transformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}})));
  equation
  P_fixed = desalinatorDemand + compressorDemand  + auxPower;
  
  P_remaining = max(motorPowerActual - P_fixed, 0);
  
  
  electrolyserPowerSupply = min(electrolyserDemand, P_remaining);
  motorPowerDemand = P_fixed + electrolyserDemand;
  
  
  annotation(
      Icon(graphics = {Rectangle(fillColor = {182, 182, 182}, fillPattern = FillPattern.Sphere, extent = {{-94, 94}, {94, -94}}), Text(origin = {0, 5}, extent = {{-68, 63}, {68, -63}}, textString = "2")}));
  
end powerManagement2;
  
  model simpleElectrolyser2
    Modelica.Blocks.Interfaces.RealInput allowedPower annotation(
      Placement(transformation(origin = {-104, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-98, -1.77636e-15}, extent = {{-10, -10}, {10, 10}})));
    parameter Real fractPowervsElectrolyserEff[:, :] = [0, 0; 0.1, 0.25; 0.15, 0.4; 0.2, 0.53; 0.25, 0.65; 0.3, 0.68; 0.35, 0.68; 0.4, 0.675; 0.45, 0.67; 0.5, 0.67; 0.55, 0.67; 0.6, 0.665; 0.65, 0.66; 0.7, 0.655; 0.75, 0.65; 0.8, 0.645; 0.85, 0.64; 0.9, 0.635; 0.95, 0.63; 1, 0.625];
    parameter Modelica.Units.SI.Power ratedPower = 174000;
    parameter Real LHVH2 = 120e6 "Lower heating value of Hydrogen (J/kg)";
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
      Placement(transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealOutput H2O_flowrate annotation(
      Placement(transformation(origin = {104, -42}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, -50}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealOutput powerDemand annotation(
      Placement(transformation(origin = {102, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 50}, extent = {{-10, -10}, {10, 10}})));
  
  
  equation
    powerDemand = ratedPower; // The electrolyser would LIKE to run at rated powerDemand
    actualPower = min(powerDemand, allowedPower); // But it only gets what power management allows
    fractionofPower = actualPower/ratedPower;
    electrolyserEff.u = fractionofPower;
    electrolyserEff.y[1] = efficiency;
    mH2 = (actualPower*efficiency)/LHVH2;
    mH2_kgph = mH2*3600;
  
    der(massH2) = mH2;
    
    mH2O = waterPerKgH2 * mH2;
// Real outputs
    H2_flowrate = mH2;
    H2O_flowrate = mH2O;
  
  annotation(
      Diagram(graphics),
      Icon(graphics = {Polygon(rotation = -90,lineColor = {0, 170, 0}, fillColor = {0, 170, 0}, fillPattern = FillPattern.Solid, points = {{-90, 30}, {-100, 30}, {-110, 10}, {-110, -10}, {-100, -30}, {-90, -30}, {-90, 30}}), Rectangle(rotation = -90,lineColor = {0, 85, 0}, extent = {{-90, 60}, {90, -60}}, radius = 10), Rectangle(rotation = -90,lineColor = {0, 85, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{90, 40}, {110, -40}}), Rectangle(rotation = -90,lineColor = {0, 170, 0}, fillColor = {0, 170, 0}, fillPattern = FillPattern.Solid, extent = {{70, -40}, {-70, 40}}), Rectangle(origin = {0, 56}, extent = {{-34, 8}, {34, -8}}), Rectangle(origin = {0, 34}, extent = {{-34, 8}, {34, -8}}), Rectangle(origin = {0, 12}, extent = {{-34, 8}, {34, -8}}), Rectangle(origin = {0, -10}, extent = {{-34, 8}, {34, -8}}), Rectangle(origin = {0, -32}, extent = {{-34, 8}, {34, -8}}), Rectangle(origin = {0, -54}, extent = {{-34, 8}, {34, -8}})}),
  experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
  end simpleElectrolyser2;
  
  model powerManagement3
  
  Modelica.Blocks.Interfaces.RealInput electrolyserDemand annotation(
      Placement(transformation(origin = {-100, 30}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, 40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput motorPowerDemand(start=140000) annotation(
      Placement(transformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {104, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput desalinatorDemand annotation(
      Placement(transformation(origin = {-100, -30}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, -40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput compressorDemand annotation(
      Placement(transformation(origin = {-100, -90}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, -100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput auxPower annotation(
      Placement(transformation(origin = {-100, 90}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, 100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput electrolyserPowerSupply annotation(
      Placement(transformation(origin = {98, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {104, 40}, extent = {{-10, -10}, {10, 10}})));
  
  Modelica.Units.SI.Power P_fixed;
  Modelica.Units.SI.Power P_remaining;
  Modelica.Blocks.Interfaces.RealInput motorPowerActual annotation(
      Placement(transformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft annotation(
      Placement(transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}})));
  equation
  P_fixed = desalinatorDemand + compressorDemand  + auxPower;
  
  P_remaining = max(motorPowerActual - P_fixed, 0);
  
  
  electrolyserPowerSupply = min(electrolyserDemand, P_remaining);
  motorPowerDemand = P_fixed + electrolyserDemand;
  
  
  annotation(
      Icon(graphics = {Rectangle(fillColor = {182, 182, 182}, fillPattern = FillPattern.Sphere, extent = {{-94, 94}, {94, -94}}), Text(origin = {0, 5}, extent = {{-68, 63}, {68, -63}}, textString = "3")}));
  
  end powerManagement3;
  
  model Hull2
    parameter Modelica.Units.SI.Length HullLength = 21.34;
    parameter Modelica.Units.SI.Mass Mass = 31700;
    parameter Real HullSpeedvsDragTable[:, :] = [0,0.672608;0.3125,0.602916;0.625,0.541445;0.9375,0.487153;1.25,0.439579;1.5625,0.398429;1.875,0.363488;2.1875,0.334589;2.5,0.311597;2.8125,0.294399;3.125,0.282896;3.4375,0.277004;3.75,0.392037;4.0625,0.538074;4.375,0.649634;4.6875,0.737963;5,0.826706;5.3125,0.911477;5.625,1.002663;5.9375,1.108756;6.25,1.219981;6.5625,1.366347;6.875,1.522114;7.1875,1.674229;7.5,1.82641;7.8125,2.021178;8.125,2.277001;8.4375,2.577729;8.75,3.085566;9.0625,3.598274;9.375,4.606401;9.6875,5.656928;10,6.941119;10.3125,8.331663;10.625,10.151944;10.9375,12.483191;11.25,14.588896;11.5625,15.883528;11.875,17.182855;12.1875,18.762756;12.5,20.351837;12.8125,22.366667;13.125,24.528263;13.4375,26.685699;13.75,28.839356;14.0625,30.808193;14.375,32.282674;14.6875,33.758396;15,35.156602;15.3125,36.559348;15.625,37.704948;15.9375,38.790738;16.25,39.945604;16.5625,41.154386;16.875,42.17088;17.1875,42.792704;17.5,43.427749;17.8125,44.151711;18.125,44.880114;18.4375,45.724786;18.75,46.592433;19.0625,47.598425;19.375,48.690396;19.6875,49.668618;20,50.462685;20.3125,51.457067;20.625,53.574975;20.9375,55.697243];
    Modelica.Units.SI.Velocity HullSpeed(start = 1e-3);
    Modelica.Units.SI.Force HullDrag;
    Modelica.Units.SI.Force ResultantForce;
    Modelica.Units.SI.Force SailForce;
    Modelica.Units.SI.Acceleration HullAcceleration;
    Modelica.Blocks.Tables.CombiTable1Ds hullTable(table = HullSpeedvsDragTable);
    Modelica.Mechanics.Translational.Interfaces.Flange_a Translational annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 10}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealInput SailForceInput annotation(
      Placement(transformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, 60}, extent = {{-20, -20}, {20, 20}})));
  equation
    HullAcceleration = ResultantForce/ Mass;
    der(HullSpeed) = HullAcceleration;
    
    hullTable.u = HullSpeed;
    HullDrag = hullTable.y[1];
    
    ResultantForce = SailForce - HullDrag + Translational.f;
    
    der(Translational.s) = HullSpeed;
    SailForceInput = SailForce;
  
    annotation(
      Icon(graphics = {Line(origin = {-0.03, 10}, points = {{80.0257, 30}, {-79.9743, 30}, {-79.9743, -30}, {-19.9743, -30}, {0.0256584, -28}, {20.0257, -24}, {40.0257, -16}, {60.0257, -4}, {74.0257, 12}, {80.0257, 30}}), Rectangle(origin = {-50, 10}, fillPattern = FillPattern.Solid, extent = {{-30, 30}, {30, -30}}), Polygon(origin = {30, 10}, fillPattern = FillPattern.Solid, points = {{-50, -30}, {-30, -28}, {-10, -24}, {10, -16}, {30, -4}, {44, 12}, {50, 30}, {-50, 30}, {-50, 30}, {-50, 30}, {-50, -30}})}),
      uses(Modelica(version = "4.1.0")));
  end Hull2;
  
  model motorTorqueDemand
    Modelica.Blocks.Tables.CombiTable1Ds torqueLookup(table = [0,450;52.3598775598299,450;104.71975511966,450;157.07963267949,450;209.43951023932,450;261.799387799149,450;311.017672705389,450;366.519142918809,380;418.879020478639,335;471.238898038469,298;523.598775598299,269]
  , extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2) annotation(
      Placement(transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Units.SI.AngularVelocity omega(start=100);
    Modelica.Units.SI.Torque tau_max;
    Modelica.Units.SI.Torque tau_generator;
    Modelica.Units.SI.Torque tau_actual;
    Modelica.Units.SI.AngularVelocity omega_min = 1e-3;
    
    parameter Modelica.Units.SI.Time tau_delay = 0.2;
  Modelica.Blocks.Interfaces.RealInput motorTorqueDemand "Torque command from TSR controller" annotation(
      Placement(transformation(origin = {-10, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}}))); 
  Modelica.Blocks.Interfaces.RealOutput motorPowerActual "Electrical power actually generated" annotation(
      Placement(transformation(origin = {104, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}})));
  equation
    omega = der(shaft.phi);
    
    torqueLookup.u = abs(omega);
    tau_max = torqueLookup.y[1];
    
    tau_generator = min(abs(motorTorqueDemand), tau_max) * sign(motorTorqueDemand);
    der(tau_actual) = (tau_generator - tau_actual) / tau_delay;
    shaft.tau = -tau_actual;
    
    motorPowerActual = tau_generator * omega;
    annotation(
      Diagram(graphics),
      Icon(graphics = {Rectangle(origin = {2.835, 10}, fillColor = {0, 128, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-60, -60}, {60, 60}}), Rectangle(origin = {2.835, 10}, fillColor = {128, 128, 128}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-80, -60}, {-60, 60}}), Rectangle(origin = {2.835, 10}, fillColor = {95, 95, 95}, fillPattern = FillPattern.HorizontalCylinder, extent = {{60, -10}, {80, 10}}), Rectangle(origin = {2.835, 10}, lineColor = {95, 95, 95}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-60, 50}, {20, 70}}), Polygon(origin = {2.835, 10}, fillPattern = FillPattern.Solid, points = {{-70, -90}, {-60, -90}, {-30, -20}, {20, -20}, {50, -90}, {60, -90}, {60, -100}, {-70, -100}, {-70, -90}}), Text(origin = {-1, 20}, extent = {{-51, 20}, {51, -20}}, textString = "TABLE")}),
  experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
  end motorTorqueDemand;

  model TSRcontrol
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Translational.Interfaces.Flange_a translational annotation(
      Placement(transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {2, 100}, extent = {{-10, -10}, {10, 10}})));
  parameter Real TSR_opt = 4;
  parameter Modelica.Units.SI.Length rotorRadius = 0.76;
  parameter Modelica.Units.SI.Velocity minHullSpeed = 0.3;
  parameter Real PID_k = 10;
  parameter Real PID_Ti = 1;
  parameter Real PID_yMax = 450;
  Real TSR;
  
  Modelica.Units.SI.AngularVelocity omega;
  Modelica.Units.SI.Velocity HullSpeed;
  Modelica.Blocks.Continuous.LimPID PID(controllerType = Modelica.Blocks.Types.SimpleController.PI, k  = PID_k, Ti = PID_Ti, yMax = PID_yMax )  annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput motorTorqueDemand annotation(
      Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  equation

  omega = der(shaft.phi);
  HullSpeed = der(translational.s);
  translational.f = 0;
  shaft.tau = 0;
  
  TSR = (abs(omega) * rotorRadius) / max(HullSpeed, minHullSpeed);
  
  PID.u_s = TSR_opt;
  PID.u_m = TSR;
  
  
  if HullSpeed < minHullSpeed then
    motorTorqueDemand = 0;
  else
    motorTorqueDemand = PID.y;
  end if;
  
  
  
  annotation(
      Icon(graphics = {Rectangle(origin = {1, -1}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Sphere, extent = {{-91, 91}, {91, -91}}), Text(origin = {1, 4}, extent = {{-57, 54}, {57, -54}}, textString = "TSR")}));
end TSRcontrol;
  
  model TSRcontrol2
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
  
  desiredOmega = (TSR_opt * HullSpeed) / rotorRadius;
  e_omega = desiredOmega - omega;
  der(integral_omegae) = e_omega;
  e_omegadot = der(e_omega);
  
  torqueDemand = PID_Kp * e_omega + PID_Ki * integral_omegae + PID_Kd * e_omegadot;
  
  
  TSR = (abs(omega) * rotorRadius) / max(HullSpeed, minHullSpeed);
  
  e = TSR_opt - TSR;
  der(integral_e) = e;
  e_dot = der(e);
//torqueDemand = PID_Kp * e + PID_Ki * integral_e + PID_Kd * e_dot;
  if HullSpeed > minHullSpeed then
    if turbinePower < 60e3 then
// Below cut-in: freewheel
      motorTorqueDemand = 0;
    else
// Above cut-in: regulate speed (braking only)
      if torqueDemand > 0 then
        motorTorqueDemand = min(torqueDemand, tau_max);
      else
        motorTorqueDemand = 0;
      end if;
    end if;
  else
    motorTorqueDemand = 0;
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
  end TSRcontrol2;

  model turbine2
  equation

  end turbine2;
  
  model compressorElectrical
  Modelica.Blocks.Interfaces.RealInput mH2 annotation(
      Placement(transformation(origin = {-104, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {4, 100}, extent = {{-10, -10}, {10, 10}})));
  parameter Real compkWhPerKgH2 = 1.84 "Compressor energy per kg H2 (kWh/kg)"; // this comes from Energy and the Hydrogen Economy graph, output comp pressure vs comp energy required
  Real compJperkg;
  Modelica.Units.SI.Power compressorPower ;
  Modelica.Blocks.Interfaces.RealOutput mH2_out annotation(
      Placement(transformation(origin = {98, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {4, -100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
      Placement(transformation(origin = {-98, 32}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
      Placement(transformation(origin = {92, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent annotation(
      Placement(transformation(origin = {0, 34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor annotation(
      Placement(transformation(origin = {0, 74}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput compressorPowerDemand annotation(
      Placement(transformation(origin = {98, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {98, -40}, extent = {{-10, -10}, {10, 10}})));
  equation
  compJperkg = 3.6*10^6 * compkWhPerKgH2;
  compressorPower = mH2 * compJperkg;
  mH2_out = mH2;
  
  compressorPowerDemand = compressorPower;
  
  signalCurrent.i = -abs(compressorPower)/max(voltageSensor.v,1e-3);
  connect(signalCurrent.p, pin_p) annotation(
      Line(points = {{-10, 34}, {-98, 34}, {-98, 32}}, color = {0, 0, 255}));
  connect(signalCurrent.n, pin_n) annotation(
      Line(points = {{10, 34}, {60, 34}, {60, 20}, {92, 20}}, color = {0, 0, 255}));
  connect(voltageSensor.p, pin_p) annotation(
      Line(points = {{-10, 74}, {-98, 74}, {-98, 32}}, color = {0, 0, 255}));
  connect(voltageSensor.n, pin_n) annotation(
      Line(points = {{10, 74}, {72, 74}, {72, 20}, {92, 20}}, color = {0, 0, 255}));
  annotation(
      Icon(graphics = {Ellipse(fillColor = {0, 0, 255}, fillPattern = FillPattern.Sphere, extent = {{-60, 60}, {60, -60}}), Rectangle(origin = {0, -65}, fillPattern = FillPattern.Solid, extent = {{-80, 5}, {80, -5}}), Line(origin = {0.99, -44.82}, points = {{-52.9881, 14.8235}, {-66.9881, -15.1765}, {67.0119, -15.1765}, {51.0119, 14.8235}}, thickness = 2), Text(origin = {-2, 3}, textColor = {255, 255, 255}, extent = {{-50, 31}, {50, -31}}, textString = "H2 comp")}));
  annotation(
      Icon(graphics = {Ellipse(origin = {0, 10}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Sphere, extent = {{-70, 70}, {70, -70}}), Rectangle(origin = {0, -70}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, extent = {{-80, 10}, {80, -10}}), Line(origin = {-69, -45}, points = {{11, 15}, {-9, -15}, {11, 15}}, thickness = 3), Line(origin = {68, -46}, points = {{10, -16}, {-14, 14}}, thickness = 3), Text(origin = {1, 12}, textColor = {255, 255, 255}, extent = {{-69, 54}, {69, -54}}, textString = "compressor")}));
  end compressorElectrical;
  
  model auxLoadElectrical
  Modelica.Blocks.Interfaces.RealOutput auxPower annotation(
      Placement(transformation(origin = {2, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {2, 100}, extent = {{-10, -10}, {10, 10}})));
  parameter Modelica.Units.SI.Power auxiliaryPower = 5000  "Base auxiliary power consumption (W)";
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-98, 2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
      Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent annotation(
      Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor annotation(
      Placement(transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}})));
  equation
  
  auxPower = auxiliaryPower;
  signalCurrent.i = -abs(auxiliaryPower)/max(voltageSensor.v,1e-3);
  connect(signalCurrent.p, pin_p) annotation(
      Line(points = {{-10, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(signalCurrent.n, pin_n) annotation(
      Line(points = {{10, 0}, {100, 0}}, color = {0, 0, 255}));
  connect(voltageSensor.p, pin_p) annotation(
      Line(points = {{-10, 60}, {-100, 60}, {-100, 0}}, color = {0, 0, 255}));
  connect(voltageSensor.n, pin_n) annotation(
      Line(points = {{10, 60}, {100, 60}, {100, 0}}, color = {0, 0, 255}));
  annotation(
      Icon(graphics = {Polygon(origin = {20, 0}, fillColor = {0, 0, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-18, 40}, {-60, -20}, {-20, -20}, {-32, -72}, {6, -20}, {20, 0}, {-20, 0}, {-8, 54}, {-18, 40}, {-18, 40}})}));
  end auxLoadElectrical;
  
  model waterSupplySubsystemElectrical
  parameter Modelica.Units.SI.Power desalintorPower = 750;
  parameter Integer desalinatorProductionRate = 60 "Desalinator water production rate (L/h)";
  parameter Modelica.Units.SI.Mass initialWaterMass = 40 "Initial mass of water in tank";
  parameter Modelica.Units.SI.Mass waterTankCapacity = 60;
  parameter Modelica.Units.SI.Mass waterTankMIN = 20;
  parameter Modelica.Units.SI.Mass waterTankMAX = 55;
  Modelica.Units.SI.Mass waterStored(start = initialWaterMass);
  parameter Modelica.Units.SI.MassFlowRate desalRate = desalinatorProductionRate/3600 "Water production rate (kg/s)";
  Boolean desalON(start = false);
  Modelica.Units.SI.MassFlowRate waterIN;
  Modelica.Units.SI.Power P_desal_avg;
  Modelica.Units.SI.Energy desalEnergy;
  Modelica.Blocks.Interfaces.RealInput H2Odemand annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {4, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput powerDemand annotation(
      Placement(transformation(origin = {102, 2}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {4, -100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
      Placement(transformation(origin = {-98, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
      Placement(transformation(origin = {100, 52}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent annotation(
      Placement(transformation(origin = {0, 52}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor annotation(
      Placement(transformation(origin = {0, 88}, extent = {{-10, -10}, {10, 10}})));
  equation
  
  der(waterStored) = waterIN - H2Odemand;
  
  when waterStored <= waterTankMIN then
  desalON = true;
  elsewhen waterStored >= waterTankMAX then
  desalON = false;
  end when;
  
  waterIN = if desalON then desalRate else 0;
  powerDemand = if desalON then desalintorPower else 0;
  
  der(desalEnergy) = powerDemand;  // J
  P_desal_avg  = desalEnergy / time;
  
  signalCurrent.i = -abs(powerDemand)/max(voltageSensor.v,1e-3);
  connect(signalCurrent.p, pin_p) annotation(
      Line(points = {{-10, 52}, {-98, 52}, {-98, 50}}, color = {0, 0, 255}));
  connect(signalCurrent.n, pin_n) annotation(
      Line(points = {{10, 52}, {100, 52}}, color = {0, 0, 255}));
  connect(voltageSensor.p, pin_p) annotation(
      Line(points = {{-10, 88}, {-98, 88}, {-98, 50}}, color = {0, 0, 255}));
  connect(voltageSensor.n, pin_n) annotation(
      Line(points = {{10, 88}, {100, 88}, {100, 52}}, color = {0, 0, 255}));
  annotation(
      Icon(graphics = {Line(origin = {0, -10}, points = {{-80, 90}, {-80, -70}, {80, -70}, {80, 90}, {60, 90}, {60, -48}, {-60, -48}, {-60, 90}, {-80, 90}}, thickness = 3.75), Line(origin = {-54, 24}, points = {{0, 0}}), Polygon(origin = {0, -12}, fillColor = {0, 170, 255}, fillPattern = FillPattern.Solid, points = {{-58, 86}, {58, 86}, {58, -46}, {-58, -44}, {-58, 86}}), Rectangle(origin = {-70, 0}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, extent = {{-8, 78}, {8, -78}}), Rectangle(origin = {1, -69}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, extent = {{63, 9}, {-63, -9}}), Rectangle(origin = {70, 0}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, extent = {{8, 78}, {-8, -78}}), Text(origin = {1, 13}, textColor = {255, 255, 255}, extent = {{-53, 47}, {53, -47}}, textString = "H2O")}),
  Diagram(graphics));
  end waterSupplySubsystemElectrical;
  
  model simpleElectrolyserElectrical
  Boolean electrolyserON(start=false);
  
  
  parameter Modelica.Units.SI.Time tau_on = 10;
  Modelica.Units.SI.Power allowedPower_f;
  
  
  parameter Modelica.Units.SI.Power P_on  = 60000 "Turn-on threshold (W)";
  parameter Modelica.Units.SI.Power P_off = 50000 "Turn-off threshold (W)";
  
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
    der(allowedPower_f) = (allowedPower - allowedPower_f) / tau_on;
    
  actualPower =
    if electrolyserON then
      min(powerDemand, allowedPower)
    else
      0; // But it only gets what power management allows
  signalCurrent.i =
    if electrolyserON then
      -actualPower / max(abs(voltageSensor.v), 1e-3)
    else
      0;
  
   
  
  when allowedPower_f >= P_on then
    electrolyserON = true;
  elsewhen allowedPower_f <= P_off then
    electrolyserON = false;
  end when;
  
  
  
    fractionofPower = actualPower/ratedPower;
    electrolyserEff.u = fractionofPower;
    electrolyserEff.y[1] = efficiency;
    mH2 = (actualPower*efficiency)/HHVH2;
    mH2_kgph = mH2*3600;
  
  
  der(massH2) =
    if electrolyserON then
      max(mH2, 0)
    else
      0;
  
    
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
  end simpleElectrolyserElectrical;
  
  model powerManagement4
  parameter Modelica.Units.SI.Time tau_avg = 60 "Rolling average time constant (s) for electrolyser power calc";
  parameter Modelica.Units.SI.Power electrolyserMINpower = 60000 "Minimum electrolyser efficiency";
  Modelica.Blocks.Interfaces.RealInput electrolyserDemand annotation(
      Placement(transformation(origin = {-100, 30}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, 40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput desalinatorDemand annotation(
      Placement(transformation(origin = {-100, -30}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, -40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput compressorDemand annotation(
      Placement(transformation(origin = {-100, -90}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, -100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput auxPower annotation(
      Placement(transformation(origin = {-100, 90}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, 100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput electrolyserPowerSupply annotation(
      Placement(transformation(origin = {98, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {104, 40}, extent = {{-10, -10}, {10, 10}})));
  
  Modelica.Units.SI.Power P_fixed;
  Modelica.Units.SI.Power P_remaining;
  Modelica.Units.SI.Power motorPowerAvg(start=10000);
  Modelica.Blocks.Interfaces.RealInput motorPowerActual annotation(
      Placement(transformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}})));
  equation
  
  
  der(motorPowerAvg) = (motorPowerActual - motorPowerAvg) / tau_avg;
  P_fixed = desalinatorDemand + compressorDemand  + auxPower;
  P_remaining = max(motorPowerAvg - P_fixed, 0);
      
  electrolyserPowerSupply = max(min(electrolyserDemand, P_remaining), 0);
  
  
  annotation(
      Icon(graphics = {Rectangle(fillColor = {182, 182, 182}, fillPattern = FillPattern.Sphere, extent = {{-94, 94}, {94, -94}}), Text(origin = {0, 5}, extent = {{-68, 63}, {68, -63}}, textString = "4")}));
  
  end powerManagement4;
  
  model motorTorqueDemandElectrical
  parameter Modelica.Units.SI.Efficiency motorEfficiency = 0.95;
    Modelica.Blocks.Tables.CombiTable1Ds torqueLookup(table = [0,450;52.3598775598299,450;104.71975511966,450;157.07963267949,450;209.43951023932,450;261.799387799149,450;311.017672705389,450;366.519142918809,380;418.879020478639,335;471.238898038469,298;523.598775598299,269]
  , extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2) annotation(
      Placement(transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Units.SI.AngularVelocity omega(start=100);
    Modelica.Units.SI.Torque tau_max;
    Modelica.Units.SI.Torque tau_generator;
    Modelica.Units.SI.Torque tau_actual;
    Modelica.Units.SI.AngularVelocity omega_min = 1e-3;
    Modelica.Units.SI.Power MechPower;
    Modelica.Units.SI.Power ElecPower;
    parameter Modelica.Units.SI.Time Te = 0.01;
    
    Modelica.Units.SI.Current i_cmd;
    
    parameter Modelica.Units.SI.Time tau_delay = 0.2;
  Modelica.Blocks.Interfaces.RealInput motorTorqueDemand "Torque command from TSR controller" annotation(
      Placement(transformation(origin = {-10, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-60, 100}, extent = {{-20, -20}, {20, 20}}))); 
  Modelica.Blocks.Interfaces.RealOutput motorPowerActual "Electrical power actually generated" annotation(
      Placement(transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {50, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
      Placement(transformation(origin = {-100, 30}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
      Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor annotation(
      Placement(transformation(origin = {2, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent annotation(
      Placement(transformation(origin = {2, 66}, extent = {{-10, -10}, {10, 10}})));
  equation
    omega = der(shaft.phi);
    
    torqueLookup.u = abs(omega);
    tau_max = torqueLookup.y[1];
    
    tau_generator = -min(max(motorTorqueDemand, 0), tau_max); 
    der(tau_actual) = (tau_generator - tau_actual) / tau_delay;
    shaft.tau = -tau_actual;
  
    MechPower = -tau_actual * omega;
    ElecPower = MechPower * motorEfficiency;
    motorPowerActual = ElecPower;
    
    i_cmd = motorPowerActual / max(abs(voltageSensor.v), 1e-3);
  
    der(signalCurrent.i) = (i_cmd - signalCurrent.i) / Te;
//signalCurrent.i = motorPowerActual/max(abs(voltageSensor.v), 1e-3) * sign(voltageSensor.v);
  connect(voltageSensor.p, pin_p) annotation(
      Line(points = {{-8, 42}, {-100, 42}, {-100, 30}}, color = {0, 0, 255}));
  connect(voltageSensor.n, pin_n) annotation(
      Line(points = {{12, 42}, {100, 42}, {100, 0}}, color = {0, 0, 255}));
  connect(signalCurrent.p, pin_p) annotation(
      Line(points = {{-8, 66}, {-100, 66}, {-100, 30}}, color = {0, 0, 255}));
  connect(signalCurrent.n, pin_n) annotation(
      Line(points = {{12, 66}, {100, 66}, {100, 0}}, color = {0, 0, 255}));
    annotation(
      Diagram(graphics),
      Icon(graphics = {Rectangle(origin = {2.835, 10}, fillColor = {0, 128, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-60, -60}, {60, 60}}), Rectangle(origin = {2.835, 10}, fillColor = {128, 128, 128}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-80, -60}, {-60, 60}}), Rectangle(origin = {2.835, 10}, fillColor = {95, 95, 95}, fillPattern = FillPattern.HorizontalCylinder, extent = {{60, -10}, {80, 10}}), Rectangle(origin = {2.835, 10}, lineColor = {95, 95, 95}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-60, 50}, {20, 70}}), Polygon(origin = {2.835, 10}, fillPattern = FillPattern.Solid, points = {{-70, -90}, {-60, -90}, {-30, -20}, {20, -20}, {50, -90}, {60, -90}, {60, -100}, {-70, -100}, {-70, -90}})}),
  experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
  end motorTorqueDemandElectrical;
  
  model batteryStack
    parameter Real C_nom_cell(unit = "A.h") = 250 "Battery capacity (Ah)";
    parameter Real R_internal_cell(unit = "Ohm") = 0.0015 "Internal resistance";
    parameter Real SOC_initial = 0.8 "Initial state of charge (0..1)";
    parameter Real min_SOC = 0.1 "Minimum allowable SOC"; 
    parameter Integer Ns = 13 "cells in series";
    parameter Integer Np = 10  "cells in parallel";
    parameter Real C_pack = Np * C_nom_cell;
    Modelica.Units.SI.Current i_batt_effective;
    Modelica.Units.SI.Current i_batt_rejected;
    
    parameter Modelica.Units.SI.Current I_charge_max = 500;
    Modelica.Units.SI.Voltage V_pack;
    Modelica.Units.SI.Voltage V_cell;
    Modelica.Units.SI.Power batteryPower;
    //Modelica.Units.SI.Resistance R_internal_pack;
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-40, 54}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
      Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {40, 54}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Electrical.Analog.Sources.SignalVoltage signalVoltage annotation(
      Placement(transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Electrical.Analog.Basic.Resistor resistor(R = R_internal_cell * Ns / Np) annotation(
      Placement(transformation(origin = {6, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
    Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
      Placement(transformation(origin = {-34, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
    Modelica.Blocks.Continuous.Integrator integrator(y_start = 0, initType = Modelica.Blocks.Types.Init.InitialState) annotation(
      Placement(transformation(origin = {-16, -30}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Math.Gain gain(k = 1/(C_pack*3600)) annotation(
      Placement(transformation(origin = {30, -30}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Math.Add add(k1 = 1, k2 = -1) annotation(
      Placement(transformation(origin = {78, -24}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Sources.Constant const(k = SOC_initial) annotation(
      Placement(transformation(origin = {51, -17}, extent = {{-5, -5}, {5, 5}})));
    Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table  = [0,2.6;0.05,3.41;0.1,3.46;0.15,3.49;0.2,3.54;0.25,3.58;0.3,3.6;0.35,3.61;0.4,3.62; 0.45,3.64;0.5,3.65;0.55,3.67;0.6,3.7;0.65,3.75;0.7,3.79;0.75,3.83;0.8,3.87;0.85,3.93;0.9,3.99;0.95,4.03;1,4.1]) annotation(
      Placement(transformation(origin = {118, -24}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealOutput SOC annotation(
      Placement(transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {4, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput currentRejectionFract annotation(
      Placement(transformation(origin = {4, -100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {4, -100}, extent = {{-10, -10}, {10, 10}})));
  
  Modelica.Blocks.Continuous.FirstOrder rejectFilter(T = 60, y_start = 0);
  Modelica.Blocks.Interfaces.RealOutput battery_power annotation(
      Placement(transformation(origin = {50, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {50, 100}, extent = {{-10, -10}, {10, 10}})));
  equation
  
    when SOC <= min_SOC then
      terminate("Battery SOC limit reached");
     end when;
    
    combiTable1Ds.y[1] = V_cell;
    V_pack = Ns * V_cell;
    signalVoltage.v = V_pack;
    
    batteryPower = pin_p.i * pin_p.v;
    
  i_batt_effective =
    if SOC >= 1 and currentSensor.i < 0 then
      0
    else
      max(currentSensor.i, -I_charge_max);
  integrator.u = i_batt_effective;
  i_batt_rejected = currentSensor.i - i_batt_effective;
  
  
  
  rejectFilter.u = max(0, -i_batt_rejected) / max(1e-6, -currentSensor.i);
  
  currentRejectionFract = rejectFilter.y;
  
  battery_power = batteryPower;
    
    connect(signalVoltage.n, pin_n) annotation(
      Line(points = {{60, 0}, {100, 0}}, color = {0, 0, 255}));
    connect(integrator.y, gain.u) annotation(
      Line(points = {{-5, -30}, {18, -30}}, color = {0, 0, 127}));
    connect(combiTable1Ds.u, add.y) annotation(
      Line(points = {{106, -24}, {89, -24}}, color = {0, 0, 127}));
    connect(add.y, SOC) annotation(
      Line(points = {{89, -24}, {92, -24}, {92, 60}, {0, 60}}, color = {0, 0, 127}));
    connect(const.y, add.u1) annotation(
      Line(points = {{56, -16}, {66, -16}, {66, -18}}, color = {0, 0, 127}));
    connect(gain.y, add.u2) annotation(
      Line(points = {{42, -30}, {66, -30}}, color = {0, 0, 127}));
  connect(currentSensor.p, pin_p) annotation(
      Line(points = {{-44, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(currentSensor.n, resistor.p) annotation(
      Line(points = {{-24, 0}, {-4, 0}}, color = {0, 0, 255}));
  connect(resistor.n, signalVoltage.p) annotation(
      Line(points = {{16, 0}, {40, 0}}, color = {0, 0, 255}));
    annotation(
      Diagram(graphics),
      Icon(graphics = {Rectangle(origin = {0, -9}, lineColor = {0, 0, 127}, fillColor = {0, 0, 135}, lineThickness = 5, extent = {{-80, -51}, {80, 51}}), Rectangle(origin = {1, -10}, lineColor = {255, 255, 255}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, lineThickness = 5, extent = {{-69, 40}, {69, -40}})}),
  experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
  end batteryStack;
  
  model powerManagement5
  parameter Modelica.Units.SI.Time tau_avg = 60 "Rolling average time constant (s) for electrolyser power calc";
  parameter Modelica.Units.SI.Power electrolyserMINpower = 60000 "Minimum electrolyser power";
  parameter Real SOC_stop  = 0.5 "SOC below which battery will not power electrolyser if HullSpeed < minHullSpeed"; 
  parameter Modelica.Units.SI.Time tau_electrolyser = 3700 "Electrolyser power command smoothing time constant (s)";
  
  Boolean electrolyserAllowed;
  Boolean continuousHydrogen;
  Boolean batteryAssistedHydrogen;
  //Modelica.Units.SI.Power P_deficit;
  Modelica.Blocks.Interfaces.RealInput electrolyserDemand annotation(
      Placement(transformation(origin = {-100, 30}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, 40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput desalinatorDemand annotation(
      Placement(transformation(origin = {-100, -30}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, -40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput compressorDemand annotation(
      Placement(transformation(origin = {-100, -90}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, -100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput auxPower annotation(
      Placement(transformation(origin = {-100, 90}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, 100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput electrolyserPowerSupply  annotation(
      Placement(transformation(origin = {98, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {104, 40}, extent = {{-10, -10}, {10, 10}})));
  
  Modelica.Units.SI.Power P_fixed;
  Modelica.Units.SI.Power P_remaining;
  Modelica.Units.SI.Power motorPowerAvg(start=10000);
  Modelica.Units.SI.Power electrolyserPowerCmdFilt;
  Modelica.Units.SI.Power electrolyserPowerSupply_raw;
  Modelica.Blocks.Interfaces.RealInput motorPowerActual annotation(
      Placement(transformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput SOC annotation(
      Placement(transformation(origin = {0, -100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {2, -100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput hullSpeed annotation(
      Placement(transformation(origin = {100, -52}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {100, -52}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput batteryPower annotation(
      Placement(transformation(origin = {64, -100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {64, -100}, extent = {{-20, -20}, {20, 20}})));
  equation
  
  der(motorPowerAvg) = (motorPowerActual - motorPowerAvg) / tau_avg;
  P_fixed = desalinatorDemand + compressorDemand  + auxPower;
  //P_deficit = max(electrolyserMINpower - motorPowerAvg, 0);
  electrolyserAllowed = SOC > SOC_stop;
  continuousHydrogen = motorPowerAvg >= electrolyserMINpower;
  batteryAssistedHydrogen = (motorPowerAvg < electrolyserMINpower) and electrolyserAllowed;
  
  P_remaining = max(motorPowerAvg + max(batteryPower, 0) - P_fixed, 0);
  
  electrolyserPowerSupply_raw =
    if continuousHydrogen then
      max(min(electrolyserDemand, P_remaining), 0)
    elseif batteryAssistedHydrogen then
      electrolyserMINpower
    else
      0;
      
  der(electrolyserPowerCmdFilt) =
    (electrolyserPowerSupply_raw - electrolyserPowerCmdFilt)
    / tau_electrolyser;
  
  //electrolyserPowerSupply = electrolyserPowerCmdFilt;
  electrolyserPowerSupply = 120000;
  annotation(
      Icon(graphics = {Rectangle(fillColor = {182, 182, 182}, fillPattern = FillPattern.Sphere, extent = {{-94, 94}, {94, -94}}), Text(origin = {0, 5}, extent = {{-68, 63}, {68, -63}}, textString = "5")}));
  
  end powerManagement5;

  model turbineTSRoptPitchControl
  
    Modelica.Mechanics.Translational.Interfaces.Flange_a Translational annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
    parameter Real KtCurve[:, :] = [0.654,0.08;0.66,0.081;0.677,0.085;0.685,0.088;0.696,0.09;0.699,0.091;0.711,0.094;0.722,0.097;0.725,0.098;0.736,0.101;0.745,0.103;0.754,0.106;0.762,0.108;0.783,0.114;0.787,0.115;0.812,0.123;0.841,0.132;0.846,0.133;0.87,0.141;0.88,0.142;0.894,0.145;0.899,0.147;0.914,0.153;0.928,0.157;0.948,0.163;0.975,0.169;0.982,0.172;1.015,0.184;1.049,0.196;1.056,0.196;1.083,0.2;1.097,0.202;1.117,0.204;1.137,0.206;1.178,0.206;1.218,0.211;1.421,0.217]
  ;
  parameter Real KqCurve [:,:] =[0.654,0.0064;0.66,0.0065;0.677,0.0071;0.685,0.0074;0.696,0.0077;0.699,0.0079;0.711,0.0082;0.722,0.0087;0.725,0.0088;0.736,0.0092;0.745,0.0095;0.754,0.0099;0.762,0.0102;0.783,0.0111;0.787,0.0112;0.812,0.0123;0.841,0.0137;0.846,0.0139;0.87,0.0151;0.88,0.0155;0.894,0.0161;0.899,0.0165;0.914,0.0174;0.928,0.0181;0.948,0.0191;0.975,0.0207;0.982,0.0211;1.015,0.0231;1.049,0.0258;1.056,0.0261;1.083,0.0277;1.097,0.0282;1.117,0.0287;1.137,0.0293;1.178,0.0306;1.218,0.0319;1.421,0.0353]
  ;
    parameter Modelica.Units.SI.Power maxTurbinePower = 130000;
    Modelica.Units.SI.Torque maxTorque;
    Modelica.Units.SI.Torque limitedTorque;
    parameter Modelica.Units.SI.Density waterDensity = 1025; // kg/m^3
    parameter Modelica.Units.SI.Length rotordiameter = 1.52; // m
    Modelica.Units.SI.AngularVelocity omega(start = 0.01); // rad/s
    Real n(start=0.001); // turbine rotational speed (rps)
    Real rpm; // turbine rotational speed (rpm)
    parameter Real TSR_opt = 4;
    Modelica.Units.SI.Length rotorRadius;
    Modelica.Units.SI.Force Drag;
    Modelica.Units.SI.Torque Torque;
    Modelica.Units.SI.Velocity HullSpeed;
    Real Kt;
    Real Kq;
    Real J;         //Advance Velocity Ratio
    //Modelica.Units.SI.Efficiency efficiency;
    Modelica.Units.SI.Power turbinePower;
  Modelica.Blocks.Tables.CombiTable1Ds KtTable(table = KtCurve, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint)  annotation(
      Placement(transformation(origin = {0, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Tables.CombiTable1Ds KqTable(table = KqCurve, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation(
      Placement(transformation(origin = {20, -44}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b Rotational annotation(
      Placement(transformation(origin = {2, 98}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput PowerTurbine annotation(
      Placement(transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Mechanics.Rotational.Sources.Speed speed annotation(
      Placement(transformation(origin = {-72, 40}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Mechanics.Rotational.Sensors.TorqueSensor torqueSensor annotation(
      Placement(transformation(origin = {-30, 40}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealOutput turbineTorque annotation(
      Placement(transformation(origin = {102, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {98, 42}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
      Placement(transformation(origin = {-4, 62}, extent = {{-10, -10}, {10, 10}})));
  equation
    rotorRadius = rotordiameter/2;
//TSR = (abs(omega)*rotorRadius)/HullSpeed;
    omega = TSR_opt*HullSpeed/rotorRadius;
    speed.w_ref = omega;
    HullSpeed = der(Translational.s);
//omega = der(Rotational.phi);
    n = rpm/60;
    rpm = omega*(30/Modelica.Constants.pi);
    J = abs(HullSpeed)/(max(abs(n), 1e-3)*rotordiameter);
    KtTable.u = J;
    KqTable.u = J;
    Kt = KtTable.y[1];
    Kq = KqTable.y[1];
    Drag = waterDensity*abs(n)*n*rotordiameter^4*Kt;
    Torque = waterDensity*abs(n)*n*rotordiameter^5*Kq;
    Translational.f = -Drag;
//Rotational.tau = -Torque;
//efficiency = (J/(2*Modelica.Constants.pi)) * (Kt/Kq);
    turbinePower = limitedTorque*omega;
    turbinePower = PowerTurbine;
    
    maxTorque = maxTurbinePower / max(abs(omega),1e-3);
    limitedTorque = min(Torque, maxTorque);
    
  torque.tau = -limitedTorque;
    
    connect(torqueSensor.flange_a, speed.flange) annotation(
      Line(points = {{-40, 40}, {-40, 37}, {-62, 37}, {-62, 40}}));
    connect(torqueSensor.tau, turbineTorque) annotation(
      Line(points = {{-38, 29}, {-38, 20}, {102, 20}}, color = {0, 0, 127}));
    connect(torqueSensor.flange_b, torque.flange) annotation(
      Line(points = {{-20, 40}, {6, 40}, {6, 62}}));
    connect(torque.flange, Rotational) annotation(
      Line(points = {{6, 62}, {6, 80}, {2, 80}, {2, 98}}));
    annotation(
      Icon(graphics = {Ellipse(fillPattern = FillPattern.Solid, extent = {{-20, 20}, {20, -20}}), Ellipse(origin = {30, -18}, rotation = 60, fillPattern = FillPattern.Solid, extent = {{8, 34}, {-8, -34}}), Ellipse(origin = {-30, -18}, rotation = -60, fillPattern = FillPattern.Solid, extent = {{8, 34}, {-8, -34}}), Ellipse(origin = {0, 34}, fillPattern = FillPattern.Solid, extent = {{8, 34}, {-8, -34}}), Text(origin = {0, 4}, textColor = {255, 0, 0}, extent = {{-28, 22}, {28, -22}}, textString = "Kt and Kq")}),
      Diagram(graphics),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
  end turbineTSRoptPitchControl;

  model TSRcontroller
  
  parameter Real SOC_soft = 0.98;
  parameter Real SOC_max = 1;
  parameter Modelica.Units.SI.Velocity minHullSpeed = 5.9;
  
  parameter Real GearRatio = 10;
  Real socFactor;
  Real socFactorEffective;
    Modelica.Blocks.Interfaces.RealInput turbineTorque annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-98, 0}, extent = {{-20, -20}, {20, 20}})));
    Modelica.Blocks.Interfaces.RealOutput motorTorqueDemand annotation(
      Placement(transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealInput batterySOC annotation(
      Placement(transformation(origin = {2, -98}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {2, -98}, extent = {{-20, -20}, {20, 20}})));
    Modelica.Blocks.Interfaces.RealInput hullSpeed annotation(
      Placement(transformation(origin = {2, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {2, 100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.BooleanInput continuousH2mode annotation(
      Placement(transformation(origin = {98, 66}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {98, 66}, extent = {{-20, -20}, {20, 20}})));
  equation
  
  
    /* Raw SOC protection logic (battery-only) */
    socFactor =
      if batterySOC < SOC_soft then
        1.0
      elseif batterySOC < SOC_max then
        (SOC_max - batterySOC) / (SOC_max - SOC_soft)
      else
        0.0;
  
    /* Mode-gated SOC protection */
    socFactorEffective =
      if continuousH2mode and batterySOC < SOC_max then
        1.0
      else
        socFactor;
  
    /* Torque demand */
    if hullSpeed < minHullSpeed then
      motorTorqueDemand = 0;
    else
      motorTorqueDemand =
        socFactorEffective * (turbineTorque / GearRatio);
    end if;
  
  
  annotation(
      Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Sphere, extent = {{-92, 92}, {92, -92}}), Text(extent = {{-84, 74}, {84, -74}}, textString = "TSR
  control")}),
  Diagram);
  end TSRcontroller;

  model motorElectrical
  parameter Modelica.Units.SI.Efficiency motorEfficiency = 0.95;
    Modelica.Blocks.Tables.CombiTable1Ds torqueLookup(table = [0,450;52.3598775598299,450;104.71975511966,450;157.07963267949,450;209.43951023932,450;261.799387799149,450;311.017672705389,450;366.519142918809,380;418.879020478639,335;471.238898038469,298;523.598775598299,269]
  , extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2) annotation(
      Placement(transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Units.SI.AngularVelocity omega(start=100);
    Modelica.Units.SI.Torque tau_max;
    Modelica.Units.SI.Torque tau_generator;
    Modelica.Units.SI.Torque tau_actual;
    Modelica.Units.SI.AngularVelocity omega_min = 1e-3;
    Modelica.Units.SI.Power MechPower;
    Modelica.Units.SI.Power ElecPower;
    parameter Modelica.Units.SI.Time Te = 0.01;
    
    Modelica.Units.SI.Current i_cmd;
    
    parameter Modelica.Units.SI.Time tau_delay = 0.2;
  Modelica.Blocks.Interfaces.RealInput motorTorqueDemand "Torque command from TSR controller" annotation(
      Placement(transformation(origin = {-10, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-60, 100}, extent = {{-20, -20}, {20, 20}}))); 
  Modelica.Blocks.Interfaces.RealOutput motorPowerActual "Electrical power actually generated" annotation(
      Placement(transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {50, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
      Placement(transformation(origin = {-100, 30}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
      Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor annotation(
      Placement(transformation(origin = {2, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent annotation(
      Placement(transformation(origin = {2, 66}, extent = {{-10, -10}, {10, 10}})));
  equation
    omega = der(shaft.phi);
    
    torqueLookup.u = abs(omega);
    tau_max = torqueLookup.y[1];
    
    tau_generator = -min(max(motorTorqueDemand, 0), tau_max); 
    der(tau_actual) = (tau_generator - tau_actual) / tau_delay;
    shaft.tau = -tau_actual;
  
    MechPower = -tau_actual * omega;
    ElecPower = MechPower * motorEfficiency;
    motorPowerActual = ElecPower;
    
    i_cmd = motorPowerActual / max(abs(voltageSensor.v), 1e-3);
  
    der(signalCurrent.i) = (i_cmd - signalCurrent.i) / Te;
//signalCurrent.i = motorPowerActual/max(abs(voltageSensor.v), 1e-3) * sign(voltageSensor.v);
  connect(voltageSensor.p, pin_p) annotation(
      Line(points = {{-8, 42}, {-100, 42}, {-100, 30}}, color = {0, 0, 255}));
  connect(voltageSensor.n, pin_n) annotation(
      Line(points = {{12, 42}, {100, 42}, {100, 0}}, color = {0, 0, 255}));
  connect(signalCurrent.p, pin_p) annotation(
      Line(points = {{-8, 66}, {-100, 66}, {-100, 30}}, color = {0, 0, 255}));
  connect(signalCurrent.n, pin_n) annotation(
      Line(points = {{12, 66}, {100, 66}, {100, 0}}, color = {0, 0, 255}));
    annotation(
      Diagram(graphics),
      Icon(graphics = {Rectangle(origin = {2.835, 10}, fillColor = {0, 128, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-60, -60}, {60, 60}}), Rectangle(origin = {2.835, 10}, fillColor = {128, 128, 128}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-80, -60}, {-60, 60}}), Rectangle(origin = {2.835, 10}, fillColor = {95, 95, 95}, fillPattern = FillPattern.HorizontalCylinder, extent = {{60, -10}, {80, 10}}), Rectangle(origin = {2.835, 10}, lineColor = {95, 95, 95}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-60, 50}, {20, 70}}), Polygon(origin = {2.835, 10}, fillPattern = FillPattern.Solid, points = {{-70, -90}, {-60, -90}, {-30, -20}, {20, -20}, {50, -90}, {60, -90}, {60, -100}, {-70, -100}, {-70, -90}})}),
  experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));

  end motorElectrical;

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

  model turbineTSRopt
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
    parameter Real TSR_opt = 4;
    Modelica.Units.SI.Length rotorRadius;
    Modelica.Units.SI.Force Drag;
    Modelica.Units.SI.Torque Torque;
    Modelica.Units.SI.Velocity HullSpeed;
    Real Kt;
    Real Kq;
    Real J;         //Advance Velocity Ratio
    //Modelica.Units.SI.Efficiency efficiency;
    Modelica.Units.SI.Power turbinePower;
  Modelica.Blocks.Tables.CombiTable1Ds KtTable(table = KtCurve, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint)  annotation(
      Placement(transformation(origin = {0, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Tables.CombiTable1Ds KqTable(table = KqCurve, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation(
      Placement(transformation(origin = {20, -44}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b Rotational annotation(
      Placement(transformation(origin = {2, 98}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput PowerTurbine annotation(
      Placement(transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Mechanics.Rotational.Sources.Speed speed annotation(
      Placement(transformation(origin = {-72, 40}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Mechanics.Rotational.Sensors.TorqueSensor torqueSensor annotation(
      Placement(transformation(origin = {-30, 40}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealOutput turbineTorque annotation(
      Placement(transformation(origin = {102, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {98, 42}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
      Placement(transformation(origin = {-4, 62}, extent = {{-10, -10}, {10, 10}})));
  equation
    rotorRadius = rotordiameter/2;
//TSR = (abs(omega)*rotorRadius)/HullSpeed;
    omega = TSR_opt*HullSpeed/rotorRadius;
    speed.w_ref = omega;
    HullSpeed = der(Translational.s);
//omega = der(Rotational.phi);
    n = rpm/60;
    rpm = omega*(30/Modelica.Constants.pi);
    J = abs(HullSpeed)/(max(abs(n), 1e-3)*rotordiameter);
    KtTable.u = J;
    KqTable.u = J;
    Kt = KtTable.y[1];
    Kq = KqTable.y[1];
    Drag = waterDensity*abs(n)*n*rotordiameter^4*Kt;
    Torque = waterDensity*abs(n)*n*rotordiameter^5*Kq;
    Translational.f = -Drag;
//Rotational.tau = -Torque;
//efficiency = (J/(2*Modelica.Constants.pi)) * (Kt/Kq);
    turbinePower = Torque*omega;
    turbinePower = PowerTurbine;
  
    
  torque.tau = -Torque;
    
    connect(torqueSensor.flange_a, speed.flange) annotation(
      Line(points = {{-40, 40}, {-40, 37}, {-62, 37}, {-62, 40}}));
    connect(torqueSensor.tau, turbineTorque) annotation(
      Line(points = {{-38, 29}, {-38, 20}, {102, 20}}, color = {0, 0, 127}));
    connect(torqueSensor.flange_b, torque.flange) annotation(
      Line(points = {{-20, 40}, {6, 40}, {6, 62}}));
    connect(torque.flange, Rotational) annotation(
      Line(points = {{6, 62}, {6, 80}, {2, 80}, {2, 98}}));
    annotation(
      Icon(graphics = {Ellipse(fillPattern = FillPattern.Solid, extent = {{-20, 20}, {20, -20}}), Ellipse(origin = {30, -18}, rotation = 60, fillPattern = FillPattern.Solid, extent = {{8, 34}, {-8, -34}}), Ellipse(origin = {-30, -18}, rotation = -60, fillPattern = FillPattern.Solid, extent = {{8, 34}, {-8, -34}}), Ellipse(origin = {0, 34}, fillPattern = FillPattern.Solid, extent = {{8, 34}, {-8, -34}}), Text(origin = {0, 4}, textColor = {255, 0, 0}, extent = {{-28, 22}, {28, -22}}, textString = "Kt and Kq")}),
      Diagram(graphics),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));

  end turbineTSRopt;
  
  model TSRcontrollerSIMPLE
  
  parameter Modelica.Units.SI.Velocity minHullSpeed = 5.9;
  
  parameter Real GearRatio = 10;
  Real generationScale;
    Modelica.Blocks.Interfaces.RealInput turbineTorque annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-98, 0}, extent = {{-20, -20}, {20, 20}})));
    Modelica.Blocks.Interfaces.RealOutput motorTorqueDemand annotation(
      Placement(transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}})));
    
    Modelica.Blocks.Interfaces.RealInput hullSpeed annotation(
      Placement(transformation(origin = {2, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {2, 100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput currentRejectionFract annotation(
      Placement(transformation(origin = {6, -100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {6, -100}, extent = {{-20, -20}, {20, 20}})));
  equation
  generationScale = max(0, min(1, 1 - currentRejectionFract));
  
    if hullSpeed < minHullSpeed then
      motorTorqueDemand = 0;
    else
      motorTorqueDemand = generationScale * (turbineTorque / GearRatio);
  end if;
  
  
  annotation(
      Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Sphere, extent = {{-92, 92}, {92, -92}}), Text(extent = {{-84, 74}, {84, -74}}, textString = "TSR
  control")}),
  Diagram);
  end TSRcontrollerSIMPLE;
  
  model TSRcontrollerNEW
  
  parameter Modelica.Units.SI.Velocity minHullSpeed = 5.9;
   
  
  parameter Real SOC_soft = 0.98;
  parameter Real SOC_max = 1;
  
  parameter Real GearRatio = 10;
  Real socFactor;
    Modelica.Blocks.Interfaces.RealInput turbineTorque annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-98, 0}, extent = {{-20, -20}, {20, 20}})));
    Modelica.Blocks.Interfaces.RealOutput motorTorqueDemand annotation(
      Placement(transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealInput hullSpeed annotation(
      Placement(transformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {2, 100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput batterySOC annotation(
      Placement(transformation(origin = {0, -100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {2, -100}, extent = {{-20, -20}, {20, 20}})));
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
  
  
  annotation(
      Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Sphere, extent = {{-92, 92}, {92, -92}}), Text(extent = {{-84, 74}, {84, -74}}, textString = "TSR
  control")}),
  Diagram);
  end TSRcontrollerNEW;
  
  model batteryStackNEW
    parameter Real C_nom_cell(unit = "A.h") = 250 "Battery capacity (Ah)";
    parameter Real R_internal_cell(unit = "Ohm") = 0.0015 "Internal resistance";
    parameter Real SOC_initial = 0.8 "Initial state of charge (0..1)";
    parameter Real min_SOC = 0.1 "Minimum allowable SOC"; 
    parameter Integer Ns = 13 "cells in series";
    parameter Integer Np = 10  "cells in parallel";
    parameter Real C_pack = Np * C_nom_cell;
    
    parameter Modelica.Units.SI.Current I_charge_max = 500;
    Modelica.Units.SI.Voltage V_pack;
    Modelica.Units.SI.Voltage V_cell;
    Modelica.Units.SI.Power batteryPower;
    //Modelica.Units.SI.Resistance R_internal_pack;
    Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-40, 54}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
      Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {40, 54}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Electrical.Analog.Sources.SignalVoltage signalVoltage annotation(
      Placement(transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Electrical.Analog.Basic.Resistor resistor(R = R_internal_cell * Ns / Np) annotation(
      Placement(transformation(origin = {6, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
    Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
      Placement(transformation(origin = {-34, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
    Modelica.Blocks.Continuous.Integrator integrator(y_start = 0, initType = Modelica.Blocks.Types.Init.InitialState) annotation(
      Placement(transformation(origin = {-16, -30}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Math.Gain gain(k = 1/(C_pack*3600)) annotation(
      Placement(transformation(origin = {30, -30}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Math.Add add(k1 = 1, k2 = -1) annotation(
      Placement(transformation(origin = {78, -24}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Sources.Constant const(k = SOC_initial) annotation(
      Placement(transformation(origin = {51, -17}, extent = {{-5, -5}, {5, 5}})));
    Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table  = [0,2.6;0.05,3.41;0.1,3.46;0.15,3.49;0.2,3.54;0.25,3.58;0.3,3.6;0.35,3.61;0.4,3.62; 0.45,3.64;0.5,3.65;0.55,3.67;0.6,3.7;0.65,3.75;0.7,3.79;0.75,3.83;0.8,3.87;0.85,3.93;0.9,3.99;0.95,4.03;1,4.1]) annotation(
      Placement(transformation(origin = {118, -24}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealOutput SOC annotation(
      Placement(transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {4, -60}, extent = {{-10, -10}, {10, 10}})));
  
  Modelica.Blocks.Interfaces.RealOutput battery_power annotation(
      Placement(transformation(origin = {6, -100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {88, -10}, extent = {{-10, -10}, {10, 10}})));
  equation
  
    when SOC <= min_SOC then
      terminate("Battery SOC limit reached");
     end when;
    
    combiTable1Ds.y[1] = V_cell;
    V_pack = Ns * V_cell;
    signalVoltage.v = V_pack;
    
    batteryPower = pin_p.i * pin_p.v;
    
  
  battery_power = batteryPower;
    
    connect(signalVoltage.n, pin_n) annotation(
      Line(points = {{60, 0}, {100, 0}}, color = {0, 0, 255}));
    connect(integrator.y, gain.u) annotation(
      Line(points = {{-5, -30}, {18, -30}}, color = {0, 0, 127}));
    connect(combiTable1Ds.u, add.y) annotation(
      Line(points = {{106, -24}, {89, -24}}, color = {0, 0, 127}));
    connect(add.y, SOC) annotation(
      Line(points = {{89, -24}, {92, -24}, {92, 60}, {0, 60}}, color = {0, 0, 127}));
    connect(const.y, add.u1) annotation(
      Line(points = {{56, -16}, {66, -16}, {66, -18}}, color = {0, 0, 127}));
    connect(gain.y, add.u2) annotation(
      Line(points = {{42, -30}, {66, -30}}, color = {0, 0, 127}));
  connect(currentSensor.p, pin_p) annotation(
      Line(points = {{-44, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(currentSensor.n, resistor.p) annotation(
      Line(points = {{-24, 0}, {-4, 0}}, color = {0, 0, 255}));
  connect(resistor.n, signalVoltage.p) annotation(
      Line(points = {{16, 0}, {40, 0}}, color = {0, 0, 255}));
  connect(currentSensor.i, integrator.u) annotation(
      Line(points = {{-34, -10}, {-34, -30}, {-28, -30}}, color = {0, 0, 127}));
    annotation(
      Diagram(graphics),
      Icon(graphics = {Rectangle(origin = {0, -9}, lineColor = {0, 0, 127}, fillColor = {0, 0, 135}, lineThickness = 5, extent = {{-80, -51}, {80, 51}}), Rectangle(origin = {1, -10}, lineColor = {255, 255, 255}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, lineThickness = 5, extent = {{-69, 40}, {69, -40}})}),
  experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
  end batteryStackNEW;
  
  model powerManagement6
  parameter Modelica.Units.SI.Time tau_avg = 60 "Rolling average time constant (s) for electrolyser power calc";
  parameter Modelica.Units.SI.Power electrolyserMINpower = 60000 "Minimum electrolyser power";
  parameter Real SOC_stop  = 0.5 "SOC below which battery will not power electrolyser if HullSpeed < minHullSpeed"; 
  
  Boolean electrolyserAllowed;
  
  Modelica.Blocks.Interfaces.RealInput electrolyserDemand annotation(
      Placement(transformation(origin = {-100, 30}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, 40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput desalinatorDemand annotation(
      Placement(transformation(origin = {-100, -30}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, -40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput compressorDemand annotation(
      Placement(transformation(origin = {-100, -90}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, -100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput auxPower annotation(
      Placement(transformation(origin = {-100, 90}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, 100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput electrolyserPowerSupply  annotation(
      Placement(transformation(origin = {108, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  
  Modelica.Units.SI.Power P_fixed;
  Modelica.Units.SI.Power P_remaining;
  Modelica.Units.SI.Power motorPowerAvg(start=10000);
  Modelica.Blocks.Interfaces.RealInput motorPowerActual annotation(
      Placement(transformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput SOC annotation(
      Placement(transformation(origin = {0, -100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {2, -100}, extent = {{-20, -20}, {20, 20}})));
  
  equation
  
  der(motorPowerAvg) = (motorPowerActual - motorPowerAvg) / tau_avg;
  P_fixed = desalinatorDemand + compressorDemand  + auxPower;
  
  electrolyserAllowed = SOC > SOC_stop;
  
  P_remaining = motorPowerActual  - P_fixed;
  
  electrolyserPowerSupply = 
  if (P_remaining >= electrolyserMINpower) then
      min(electrolyserDemand, P_remaining)
    elseif (SOC > SOC_stop) then
      electrolyserMINpower
    else
      0;
  
  annotation(
      Icon(graphics = {Rectangle(fillColor = {182, 182, 182}, fillPattern = FillPattern.Sphere, extent = {{-94, 94}, {94, -94}}), Text(origin = {0, 5}, extent = {{-68, 63}, {68, -63}}, textString = "6")}));
  
  end powerManagement6;
  annotation(
    uses(Modelica(version = "4.1.0")));
end GDBPPackage;
