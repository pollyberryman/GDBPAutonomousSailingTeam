package GDGPAutonomousVessel
  Hull hull annotation(
    Placement(transformation(origin = {22, -26}, extent = {{-10, -10}, {10, 10}})));
  Sail sail annotation(
    Placement(transformation(origin = {20, -4}, extent = {{-10, -10}, {10, 10}})));
  Weather weather annotation(
    Placement(transformation(origin = {28, 36}, extent = {{-10, -10}, {10, 10}})));

  model Foils
  equation

  annotation(
      Icon(graphics = {Polygon(origin = {3, 10}, fillPattern = FillPattern.Solid, points = {{-23, 50}, {-23, -50}, {-19, -50}, {-9, -44}, {1, -38}, {11, -30}, {17, -20}, {23, -4}, {23, 4}, {23, 50}, {-23, 50}})}));
end Foils;

  model Environment
  equation
  
  annotation(
      Icon(graphics = {Ellipse(origin = {-56, 57}, lineColor = {255, 220, 24}, fillColor = {255, 220, 24}, fillPattern = FillPattern.Solid, extent = {{-15, 15}, {15, -15}}), Rectangle(origin = {-56, 26}, rotation = 90, lineColor = {255, 220, 24}, fillColor = {255, 220, 24}, fillPattern = FillPattern.Solid, extent = {{-11, -3}, {11, 3}}), Rectangle(origin = {-80, 82}, rotation = -45, lineColor = {255, 220, 24}, fillColor = {255, 220, 24}, fillPattern = FillPattern.Solid, extent = {{-11, -3}, {11, 3}}), Rectangle(origin = {-87, 57}, lineColor = {255, 220, 24}, fillColor = {255, 220, 24}, fillPattern = FillPattern.Solid, extent = {{-11, -3}, {11, 3}}), Rectangle(origin = {-32, 81}, rotation = 45, lineColor = {255, 220, 24}, fillColor = {255, 220, 24}, fillPattern = FillPattern.Solid, extent = {{-11, -3}, {11, 3}}), Rectangle(origin = {-25, 57}, lineColor = {255, 220, 24}, fillColor = {255, 220, 24}, fillPattern = FillPattern.Solid, extent = {{-11, -3}, {11, 3}}), Rectangle(origin = {-56, 88}, rotation = 90, lineColor = {255, 220, 24}, fillColor = {255, 220, 24}, fillPattern = FillPattern.Solid, extent = {{-11, -3}, {11, 3}}), Rectangle(origin = {-79, 33}, rotation = 45, lineColor = {255, 220, 24}, fillColor = {255, 220, 24}, fillPattern = FillPattern.Solid, extent = {{-11, -3}, {11, 3}}), Rectangle(origin = {-32, 34}, rotation = -45, lineColor = {255, 220, 24}, fillColor = {255, 220, 24}, fillPattern = FillPattern.Solid, extent = {{-11, -3}, {11, 3}}), Polygon(origin = {35, 14}, points = {{45, 16}, {45, -25}, {-45, -14}, {-45, 6}, {45, 16}}), Polygon(origin = {0, 10}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, points = {{10, 12}, {10, -12}, {-10, -10}, {-10, 10}, {-10, 10}, {10, 12}}), Polygon(origin = {44.5, 10}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, points = {{-9.5, 15}, {9.5, 17}, {9.5, -18}, {-9.5, -15}, {-9.5, 15}}), Polygon(origin = {83, -25}, fillPattern = FillPattern.Solid, points = {{-3, 55}, {3, 55}, {2, -55}, {-3, -55}, {-3, 55}}), Polygon(origin = {-0.5, 0}, fillColor = {255, 255, 255}, points = {{-99.5, 100}, {100.5, 100}, {100.5, -100}, {-99.5, -100}, {-99.5, 100}}), Polygon(origin = {-49, -63}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, points = {{-39, -24}, {-38, -20}, {-34, -9}, {-26, 3}, {-18, 12}, {-9, 18}, {8, 23}, {24, 26}, {35, 22}, {36, 17}, {31, 13}, {24, 10}, {18, 1}, {18, -2}, {18, -5}, {21, -13}, {26, -18}, {30, -21}, {35, -25}, {-39, -25}, {-39, -24}}), Polygon(origin = {-34, -73}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, points = {{-26, -17}, {-24, -10}, {-21, 1}, {-15, 8}, {-5, 15}, {7, 17}, {15, 18}, {19, 15}, {18, 10}, {14, 8}, {11, 4}, {12, -2}, {16, -9}, {21, -12}, {27, -17}, {-26, -17}, {-26, -17}})}, coordinateSystem(grid = {1, 1})),
      Diagram(coordinateSystem(grid = {1, 1}), graphics),
      version = "",
      uses(Modelica(version = "4.1.0")));
  end Environment;

  model Wings
    Modelica.Blocks.Interfaces.RealOutput SailPower annotation(
      Placement(transformation(origin = {6, -80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {18, -80}, extent = {{-10, -10}, {10, 10}})));
  equation
  
  annotation(
      Icon(graphics = {Polygon(origin = {-20, 20}, fillPattern = FillPattern.Solid, points = {{40, 60}, {40, -60}, {-40, -60}, {40, 60}}), Polygon(origin = {15, -60}, fillPattern = FillPattern.Solid, points = {{5, 20}, {-5, 20}, {-5, -20}, {5, -20}, {5, 20}})}),
      uses(Modelica(version = "4.1.0")));

  end Wings;

  model Hull
    parameter Modelica.Units.SI.Length HullLength;  
    //parameter Real HullSpeedvsDragTable(0,0;1,10;2,20;3,30);
  
    Modelica.Units.SI.Velocity HullSpeed;
    Modelica.Units.SI.Force HullDrag;
    
    
    Modelica.Blocks.Tables.CombiTable1Ds HullSpeedvsDragTable ;
    Modelica.Mechanics.Translational.Interfaces.Flange_a flange_a annotation(
      Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-80, 10}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealInput SailPower annotation(
      Placement(transformation(origin = {-6, 40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {2, 40}, extent = {{-10, -10}, {10, 10}})));
  equation
  
  //HullSpeed = HullSpeedvsDragTable(1,:);
  //HullDrag = HullSpeedvsDragTable(2,:);
  
  annotation(
      Icon(graphics = {Line(origin = {-0.03, 10}, points = {{80.0257, 30}, {-79.9743, 30}, {-79.9743, -30}, {-19.9743, -30}, {0.0256584, -28}, {20.0257, -24}, {40.0257, -16}, {60.0257, -4}, {74.0257, 12}, {80.0257, 30}}), Rectangle(origin = {-50, 10}, fillPattern = FillPattern.Solid, extent = {{-30, 30}, {30, -30}}), Polygon(origin = {30, 10}, fillPattern = FillPattern.Solid, points = {{-50, -30}, {-30, -28}, {-10, -24}, {10, -16}, {30, -4}, {44, 12}, {50, 30}, {-50, 30}, {-50, 30}, {-50, 30}, {-50, -30}})}),
      uses(Modelica(version = "4.1.0")));

  end Hull;
equation
  connect(sail.SailPower, hull.SailPower) annotation(
    Line(points = {{21.8, -12}, {21.8, -22}}, color = {0, 0, 127}));
end GDGPAutonomousVessel;
