// Control Setup
controlsSetup();

// Sprites
idleSpr = sPlayerIdle;
moveSpr = sPlayerMove;
runSpr = sPlayerSprint;
jumpSpr = sPlayerFirstJump;
sJumpSpr = sPlayerSecondJump;

// Moving
face = 1; // player facing to the right or to the left (1 or -1)
moveDir = 0; // direction (-1, 0, 1)
moveSpd = 2; // movement spd
xSpd = 0;// horizontal spd
ySpd = 0; // vertical spd

// Gravity, terminal velocity, jumps and holding jumps
grav = .275 // gravity
termVel = 4 // terminal velocity, fall spd cap
onGround = true; // player's state of being on ground or not
jumpMax = 2; // max. num. of jumps
jumpCount = 0; // num. of performed jumps
jumpHoldTimer = 0; // timer for holding jump btn.

// Jump values for each successive jump
jumpHoldFrames[0] = 18; // num. of frames holding jump is allowed
jSpd[0] = -3.15; // jump spd
jumpHoldFrames[1] = 10;
jSpd[1] = -2.85; 

// Coyote time
// Hang time
coyoteHangFrames = 2;
coyoteHangTimer = 0;
// Jump buffer time
coyoteJumpFrames = 4; // how long 'til jump reset in air
coyoteJumpTimer = 0;