// Control Setup
controlsSetup();

function checkForSemiSolidPlatform(_x, _y)
{
	// Create a return var.
	var _rtrn = noone;
	
	// Not moving upwards, then check for normal collision
	if ySpd >= 0 && place_meeting(_x, _y, oSemiSolidWall)
	{
		// Create a ds list to store all colliding instances
		var _list = ds_list_create();
		var _listSize = instance_place_list(_x, _y, oSemiSolidWall, _list, false);
		
		// Loop through the coll. instances and only return one if it's top is below the player
		for(var i = 0; i< _listSize; i++)
		{
			var _listInst = _list[| i];
			if floor(bbox_bottom) <= ceil(_listInst.bbox_top - _listInst.ySpd)
			{
				_rtrn = _listInst;
				// Exit loop early
				i = _listSize;
			}
		}
		ds_list_destroy(_list);
	}
	return _rtrn;
}

// Sprites
maskSpr = sPlayerIdle;
idleSpr = sPlayerIdle;
moveSpr = sPlayerMove;
sprintSpr = sPlayerSprint;
jumpSpr = sPlayerFirstJump;
sJumpSpr = sPlayerSecondJump;

depth = -30;

// Moving
face = 1; // player facing to the right or to the left (1 or -1)
moveDir = 0; // direction (-1, 0, 1)
runType = 0; // base move spd or sprint spd, 0 or 1
moveSpd[0] = 2; // base movement spd
moveSpd[1] = 3.5; // sprint spd
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

// Moving platforms
myFloorPlat = noone; // for storing the floor platfrom that the player stands on
downSlopeSemiSolid = noone; // returns a semosolid platf. while moving down a slope
movePlatXSpd = 0; // for tracking the moving platforms horizontal movement
movePlatMaxYSpd = termVel; // how fast the player follows a downwards moving platform