// Get Inputs
getControls();

// X Movement
	moveDir = rightKey - leftKey; // determines player's move direction
	xSpd = moveDir * moveSpd; // determines player's x movement speed

	// X Collision
	var _subPixel = .5; // for matching up up the resolution of the art and the logic of the game

	if place_meeting(x + xSpd, y, oWall)
	{
		// Scoot up to wall precisely
		var _pixelCheck = _subPixel * sign(xSpd); // 
		while !place_meeting(x + _pixelCheck, y, oWall)
		{
			x += _pixelCheck;
		}
	
		// xSpd set to zero on collision
		xSpd = 0;
	}

	// Move
	x += xSpd;

// Y Movement
	// Gravity
	ySpd += grav;
	
	// Reset/Prepare jumping variables
	if onGround
	{
		jumpCount = 0;
		jumpHoldTimer = 0;
	}
	else
	{
		// player can't jump twice in air
		if jumpCount == 0 { jumpCount = 1; }
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
		onGround = true;
	}
	else
	{
		onGround = false;
	}
	
	// Move
	y += ySpd;