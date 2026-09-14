if place_meeting(x + xSpd, y, oWall)
{
	dir *= -1;
	xSpd = 0;
}

x += xSpd;