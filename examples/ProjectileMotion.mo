model ProjectileMotion
  "Parametric projectile motion"

  // Parametric variables (can be varied by Funz)
  parameter Real v0 = ${velocity~20.0} "Initial velocity (m/s)";
  parameter Real angle = ${launch_angle~45.0} "Launch angle (degrees)";

  // Fixed parameters
  parameter Real g = 9.81 "Gravitational acceleration (m/s^2)";
  parameter Real m = 1.0 "Mass (kg)";

  // State variables
  Real x(start = 0.0) "Horizontal position (m)";
  Real y(start = 0.0) "Vertical position (m)";
  Real vx(start = v0 * cos(angle * 3.14159265359 / 180.0)) "Horizontal velocity (m/s)";
  Real vy(start = v0 * sin(angle * 3.14159265359 / 180.0)) "Vertical velocity (m/s)";

equation
  // Equations of motion
  der(x) = vx;
  der(y) = vy;
  der(vx) = 0;  // No horizontal acceleration
  der(vy) = -g; // Gravitational acceleration downward

end ProjectileMotion;
