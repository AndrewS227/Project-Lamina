// Get Inputs
getControls();

// Get out of solid moveplats. that have positioned themselves into the player in the begin step
	var _rightWall = noone;
	var _leftWall = noone;
	var _bottomWall = noone;
	var _topWall = noone;
	var _list = ds_list_create();
	var _listSize = instance_place_list(x, y, oMovePlat, _list, false);
	
	// Loop through colliding moveplats.
	for(var i = 0; i < _listSize; i++)
	{
		var _listInst = _list[| i];
		
		// Find closest wall in each dir.
			// Right walls
			if _listInst.bbox_left - _listInst.xSpd >= bbox_right - 1
			{
				if !instance_exists(_rightWall) || _listInst.bbox_left < _rightWall.bbox_left
				{
					_rightWall = _listInst;
				}
			}
			// Left walls
			if _listInst.bbox_right - _listInst.xSpd <= bbox_left + 1
			{
				if !instance_exists(_leftWall) || _listInst.bbox_right > _leftWall.bbox_right
				{
					_leftWall = _listInst
				}
			}
			// Bottom walls
			if _listInst.bbox_top - _listInst.ySpd >= bbox_bottom - 1
			{
				if !instance_exists(_bottomWall) || _listInst.bbox_top < _bottomWall.bbox_top
				{
					_bottomWall = _listInst;
				}
			}
			// Top walls
			if _listInst.bbox_bottom - _listInst.ySpd <= bbox_top + 1
			{
				if !instance_exists(_topWall) || _listInst.bbox_bottom > _topWall.bbox_bottom
				{
					_topWall = _listInst;
				}
			}
	}
	
	// destroy ds list
	ds_list_destroy(_list);
	
	// Get out of walls
		// Right wall
		if instance_exists(_rightWall)
		{
			var _rightDist = bbox_right - x;
			x = _rightWall.bbox_left - _rightDist;
		}
		// Left wall
		if instance_exists(_leftWall)
		{
			var _leftDist = x - bbox_left;
			x = _leftWall.bbox_right + _leftDist;
		}
		// Bottom wall
		if instance_exists(_bottomWall)
		{
			var _bottomDist = y - bbox_bottom;
			y = _bottomWall.bbox_top - _bottomDist;
		}
		// Top wall (coll. for polish and crouching features)
		if instance_exists(_topWall)
		{
			var _topDist = y - bbox_top;
			var _targetY = _topWall.bbox_bottom + _topDist;
			// Check for wall in the way
			if !place_meeting(x, _targetY, oWall)
			{
				y = _targetY;
			}
		}


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
		// Next check for ceiling slopes. If there's no slope -> regular collision
		else
		{
			// Ceiling slopes
			if !place_meeting(x + xSpd, y + abs(xSpd) + 1, oWall)
			{
				while place_meeting(x + xSpd, y, oWall) { y += _subPixel };
			}
			// Normal x collision
			else
			{
				// Scoot up to wall precisely
				var _pixelCheck = _subPixel * sign(xSpd);
				while !place_meeting(x + _pixelCheck, y, oWall){ x += _pixelCheck };
	
				// xSpd set to zero on collision
				xSpd = 0;
			}
		}
	}

	// Go Down Slopes
	downSlopeSemiSolid = noone;
	if ySpd >= 0 && !place_meeting(x + xSpd, y + 1, oWall) && place_meeting(x + xSpd, y + abs(xSpd) + 1, oWall)
	{
		// Check for a semisolid in the way
		downSlopeSemiSolid = checkForSemiSolidPlatform(x + xSpd, y + abs(xSpd) + 1);
		// Precisely move down slope if there's no semisolid in the way
		if !instance_exists(downSlopeSemiSolid)
		{
			while ! place_meeting(x + xSpd, y + _subPixel, oWall) { y += _subPixel };
		}
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
	var _floorIsSolid = false;
	if instance_exists(myFloorPlat)
	&& (myFloorPlat.object_index == oWall || object_is_ancestor(myFloorPlat.object_index, oWall))
	{
		_floorIsSolid = true;
	}
	if  jumpKeyBuffered && jumpCount < jumpMax && (!downKey || _floorIsSolid)
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
	
	// Y Collision
	// Upwards Y Collision (w. ceiling slopes)
	if ySpd < 0 && place_meeting(x, y + ySpd, oWall)
	{
		// Jump into sloped ceilings
		var _slopeSlide = false;
		
		// Slide up left
		if moveDir == 0 && !place_meeting(x - abs(ySpd)-1, y + ySpd, oWall)
		{
			while place_meeting(x, y + ySpd, oWall) { x -= 1 };
			_slopeSlide = true;
		}
		
		// Slide up right
		if moveDir == 0 && !place_meeting(x + abs(ySpd) + 1, y + ySpd, oWall)
		{
			while place_meeting(x, y + ySpd, oWall) { x += 1 };
			_slopeSlide = true;
		}
		
		// Normal Y Collision
		if !_slopeSlide
		{
			// Scoot up to wall precisely
			var _pixelCheck = _subPixel * sign(ySpd);
			while !place_meeting(x, y + _pixelCheck, oWall){ y += _pixelCheck };
		
			// Bonk code (if player bonks head into ceiling, player moves downwards)
			if ySpd < 0 { jumpHoldTimer = 0 };
		
			// xSpd set to zero to collide
			ySpd = 0;
		}
	}
	
	// Floor Y Collision
	
	// Check for solid and semisolid platforms under the player
	var _clampYSpd = max(0, ySpd);
	var _list = ds_list_create(); // create ds_list to store all objects player runs into
	var _array = array_create(0);
	array_push(_array, oWall, oSemiSolidWall);
	
	// Do the acttual check and add objects to list
	var _listSize = instance_place_list(x, y + 1 + _clampYSpd + movePlatMaxYSpd, _array, _list, false);
	
	// FIX FOR HIGH RES./HIGH SPEED PROJECTS
	var _yCheck = y + 1 + _clampYSpd;
	if instance_exists(myFloorPlat) { _yCheck += max(0, myFloorPlat.ySpd) };
	var _semiSolid = checkForSemiSolidPlatform(x, _yCheck);
	
	// Loop through colliding instances
	// only returning one if it's top is below the player
	for(var i = 0; i < _listSize; i++)
	{
		// Get an instance of oWall or oSemiSolidWall from the list
		var _listInst = _list[| i];
		
		// Avoid magnetism
		if (_listInst != forgetSemiSolid
		&& (_listInst.ySpd <= ySpd || instance_exists(myFloorPlat))
		&& (_listInst.ySpd > 0 || place_meeting(x, y + 1 + _clampYSpd, _listInst)))
		|| _listInst == _semiSolid // HIGH SPEED FIX
		{
			// Return solid- or semisolid walls that are below the player
			if _listInst.object_index == oWall
			|| object_is_ancestor(_listInst.object_index, oWall)
			|| floor(bbox_bottom) <= ceil(_listInst.bbox_top - _listInst.ySpd)
			{
				// Return "highest" wall obj.
				if !instance_exists(myFloorPlat)
				|| _listInst.bbox_top + _listInst.ySpd <= myFloorPlat.bbox_top + myFloorPlat.ySpd
				|| _listInst.bbox_top + _listInst.ySpd <= bbox_bottom
				{
					myFloorPlat = _listInst;
				}
			}
		}
	}
	// Destroy ds list to avoid a memory leak
	ds_list_destroy(_list);
	
	// Downslope semisolid for making sure the player doesn't miss any while going down slopes
	if instance_exists(downSlopeSemiSolid) { myFloorPlat = downSlopeSemiSolid };
	
	// One last check for the floor platform below the player
	if instance_exists(myFloorPlat) && !place_meeting(x, y + movePlatMaxYSpd, myFloorPlat)
	{
		myFloorPlat = noone;
	}
	
	// Land on ground platform if there's one
	// Very precise coll. w. ground to avoid clipping
	if instance_exists(myFloorPlat)
	{
		while !place_meeting(x, y + _subPixel, myFloorPlat) && !place_meeting(x, y, oWall) { y += _subPixel };
		
		// Make sure player doesn't end up below the top of a semisolid
		if myFloorPlat.object_index == oSemiSolidWall 
		|| object_is_ancestor(myFloorPlat.object_index, oSemiSolidWall)
		{
			while place_meeting(x, y, myFloorPlat) { y -= _subPixel };
		}
		// Floor y var.
		y = floor(y);
		
		// Collide w. ground
		ySpd = 0;
		setOnGround(true);
	}
	
	// Manually fall through a semisolid platf.
	if downKey && jumpKeyPressed
	{
		// making sure there's a semisolid platf.
		if instance_exists(myFloorPlat)
		&& (myFloorPlat.object_index == oSemiSolidWall 
		|| object_is_ancestor(myFloorPlat.object_index, oSemiSolidWall))
		{
			// Check if player can go below semisolid
			var _yCheck = max(1, myFloorPlat.ySpd + 1);
			if !place_meeting(x, y + _yCheck, oWall)
			{
				// Move below the platf.
				y += 1;
				
				// Inherit any downward spd from the platf. so it doesn't catch the player
				ySpd = _yCheck - 1;
				
				// Forget this platf. briefly for not getting caught
				forgetSemiSolid = myFloorPlat;
				
				// No more floor platf.
				setOnGround(false);
			}
		}
	}
	
	// Move
	y += ySpd;
	
	// Reset forgetSemiSolid var.
	if instance_exists(forgetSemiSolid) && !place_meeting(x, y, forgetSemiSolid)
	{
		forgetSemiSolid = noone;
	}
	
// Final moving platform collisions and movement

	// X - movePlatXSpd and collision
	// Get movePlatXSpd
	movePlatXSpd = 0;
	if instance_exists(myFloorPlat) { movePlatXSpd = myFloorPlat.xSpd };
	
	// Move w. movePlatXSpd
	if place_meeting(x + movePlatXSpd, y, oWall)
	{
		// Scoot up to wall precisely
		var _subPixel = .5;
		var _pixelCheck = _subPixel * sign(movePlatXSpd);
		while !place_meeting(x + _pixelCheck, y, oWall) { x += _pixelCheck };
		
		// Set movePlatXSpd to 0 to finish collision
		movePlatXSpd = 0;
	}
	// Move
	x += movePlatXSpd;
	
	// Y - Snap myself to myFloorPlat if it's moving vertically
	if instance_exists(myFloorPlat) 
	&& (myFloorPlat.ySpd != 0
	|| myFloorPlat.object_index == oMovePlat
	|| object_is_ancestor(myFloorPlat.object_index, oMovePlat)
	|| myFloorPlat.object_index == oSemiSolidMovePlat
	|| object_is_ancestor(myFloorPlat.object_index, oSemiSolidMovePlat))
	{
		// Snap to the top of the floor platform (un-flooring the y var. so it's no longer choppy)
		if !place_meeting(x, myFloorPlat.bbox_top, oWall)
		&& myFloorPlat.bbox_top >= bbox_bottom - movePlatMaxYSpd
		{
			y = myFloorPlat.bbox_top;
		}
		
		// Going up into a sloid wall while on a semisolid platf.
		if myFloorPlat.ySpd < 0 && place_meeting(x, y + myFloorPlat.ySpd, oWall)
		{
			// Get pushed down through the semisolid floor platf.
			if myFloorPlat.object_index == oSemiSolidWall
			|| object_is_ancestor(myFloorPlat.object_index, oSemiSolidWall)
			{
				// Get pushed down through the semisolid
				var _subPixel = .25;
				while place_meeting(x, y + myFloorPlat.ySpd, oWall) { y += _subPixel };
				
				// If player gets pushed down into a solid wall, push them back out
				while place_meeting(x, y, oWall) { y -= _subPixel };
				y = round(y)
			}
			
			// Cancel myFloorPlat var.
			setOnGround(false);
		}
	}
	
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