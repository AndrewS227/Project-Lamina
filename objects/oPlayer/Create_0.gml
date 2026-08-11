// Control Setup
controlsSetup();

// Moving
moveDir = 0; // direction
moveSpd = 2; // movement spd
xSpd = 0;// horizontal spd
ySpd = 0; // vertical spd

grav = .275 // gravity
termVel = 4 // terminal velocity, fall spd cap
jumpMax = 2; // max. num. of jumps
jumpCount = 0; // num. of performed jumps
jumpHoldTimer = 0; // timer for holding jump btn.
jumpHoldFrames[0] = 18; // num. of frames holding jump is allowed
jSpd[0] = -3.15; // jump spd
jumpHoldFrames[1] = 10;
jSpd[1] = -2.85; 
onGround = true; // player's state of being on ground or not
