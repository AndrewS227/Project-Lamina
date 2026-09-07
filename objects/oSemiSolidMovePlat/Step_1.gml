// Move in a circle
dir += rotSpd;

// Get target pos.
var _targetX = xstart + lengthdir_x(radius, dir);
var _targetY = ystart + lengthdir_y(radius, dir);

// Get xSpd and ySpd
xSpd = _targetX - x;
ySpd = _targetY - y;

// Move
x += xSpd;
y += ySpd;