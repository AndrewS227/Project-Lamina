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
	
	// Jump and collision w. ground
	if jumpKeyBuffered && onGround
	{
		// Reset buffer
		jumpKeyBuffered = false;
		jumpKeyBufferTimer = 0;
		// Set ySpd to jump speed
		ySpd = jSpd;
	}

// Y Collision and movement
	// Cap falling spd
	if ySpd > termVel { ySpd = termVel; }
	
	// Collision
	if place_meeting(x, y + ySpd, oWall)
	{
		// Scoot up to wall precisely
		var _pixelCheck = _subPixel * sign(ySpd);
		while !place_meeting(x, y + _pixelCheck, oWall)
		{
			y += _pixelCheck;
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