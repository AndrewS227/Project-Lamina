// Helping func. for setting onGround variable's value

function setOnGround(_val = true){
	if _val == true
	{
		onGround = true;
		coyoteHangTimer = coyoteHangFrames;
	}
	else
	{
		onGround = false;
		myFloorPlat = noone;
		coyoteHangTimer = 0;
	}
}