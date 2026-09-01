// Get Inputs
getControls();

// X Movement
	moveDir = rightKey - leftKey; // determines player's move direction
	
	// what direction the player is facing
	if moveDir != 0 { face = moveDir };
	
	runType = sprintKey; // movement type
	
	xSpd = moveDir * moveSpd[runType]; // determines player's x movement speed

	// X Collision
	var _subPixel = .5; // for matching up up the resolution of the art and the logic of the game

	if place_meeting(x + xSpd, y, oWall)
	{
		// First check if there's a slope to go up
		if !place_meeting(x + xSpd, y - abs(xSpd) - 1, oWall)
		{
			while place_meeting(x + xSpd, y, oWall) { y -= _subPixel };
		}
		// If there's no slope -> regular collision
		else
		{
			// Scoot up to wall precisely
			var _pixelCheck = _subPixel * sign(xSpd);
			while !place_meeting(x + _pixelCheck, y, oWall){ x += _pixelCheck };
	
			// xSpd set to zero on collision
			xSpd = 0;
		}
		
		
	}

	// Go Down Slopes
	if ySpd >= 0 && !place_meeting(x + xSpd, y + 1, oWall) && place_meeting(x + xSpd, y + abs(xSpd) + 1, oWall)
	{
		while ! place_meeting(x + xSpd, y + _subPixel, oWall) { y += _subPixel };
	}
	// Move
	x += xSpd;

// Y Movement
	// Gravity
	if coyoteHangTimer > 0
	{
		coyoteHangTimer--;
	}
	else
	{
		// Apply grav. to player
		ySpd += grav;
		// Player is no longer on the ground
		setOnGround(false);
	}
	
	
	// Reset/Prepare jumping variables
	if onGround
	{
		jumpCount = 0;
		jumpHoldTimer = 0;
		coyoteJumpTimer = coyoteJumpFrames;
	}
	else
	{
		// player can't jump twice in air
		coyoteJumpTimer--;
		if jumpCount == 0 && coyoteJumpTimer <= 0 { jumpCount = 1; }
	}
	
	// Initiate the Jump
	if jumpKeyBuffered && jumpCount < jumpMax
	{
		// Reset buffer
		jumpKeyBuffered = false;
		jumpKeyBufferTimer = 0;
		
		// Increrase num. of jumps
		jumpCount++;
		
		// Set the jump hold timer
		jumpHoldTimer = jumpHoldFrames[jumpCount-1];
		
		// Player is no longer on the ground
		setOnGround(false);
	}
	
	// Jump based on the timer/holding the btn.
	if jumpHoldTimer > 0
	{
		// Constantly set the ySpd to be the jumping speed
		ySpd = jSpd[jumpCount-1];
		// Count down the timer
		jumpHoldTimer--;
	}
	
	//Cut off the jump by releasing the jump button
	if !jumpKey
	{
		jumpHoldTimer = 0;
	}

// Y Collision and movement
	// Cap falling spd
	if ySpd > termVel { ySpd = termVel; }
	
	// Collision
	if place_meeting(x, y + ySpd, oWall)
	{
		// Scoot up to wall precisely
		var _pixelCheck = _subPixel * sign(ySpd);
		while !place_meeting(x, y + _pixelCheck, oWall){ y += _pixelCheck; }
		
		// Bonk code (if player bonks head into ceiling, player moves downwards)
		if ySpd < 0
		{
			jumpHoldTimer = 0;
		}
		
		// xSpd set to zero to collide
		ySpd = 0;
	}
	
	// Set if player is on the ground
	if ySpd >= 0 && place_meeting(x,y+1,oWall)
	{
		 setOnGround(true);
	}
	
	// Move
	y += ySpd;
	
// Sprite Control
	// Move, walking
	if abs(xSpd) > 0 { sprite_index = moveSpr };
	// Sprint
	if abs(xSpd) >= moveSpd[1] { sprite_index = sprintSpr };
	// Not moving
	if xSpd == 0 { sprite_index = idleSpr };
	// In the air
	if !onGround && jumpCount == 1 { sprite_index = jumpSpr }
	if !onGround && jumpCount == 2 { sprite_index = sJumpSpr }; // second jump
	
	// Set collision mask
	mask_index = maskSpr;