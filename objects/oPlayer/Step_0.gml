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
	
	// Cap falling spd
	if ySpd > termVel { ySpd = termVel; }
	
	// Jump
	if jumpKeyPressed && place_meeting(x,y+1,oWall)
	{
		ySpd = jSpd;
	}

	if place_meeting(x, y + ySpd, oWall)
	{
		// Scoot up to wall precisely
		var _pixelCheck = _subPixel * sign(ySpd);
		while !place_meeting(x, y + _pixelCheck, oWall)
		{
			y += _pixelCheck;
		}
	
		// xSpd set to zero on collision
		ySpd = 0;
	}
	
	// Move
	y += ySpd;