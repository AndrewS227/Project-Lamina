function cam_func(){
	// Exit if there's no player
	if !instance_exists(oPlayer) exit;

	// Get camera size
	camWidth = camera_get_view_width(view_camera[0]);
	camHeight = camera_get_view_height(view_camera[0]);

	// Get camera coordinates at start of room
	camX = oPlayer.x - camWidth/2;
	camY = oPlayer.y - camHeight/2;

	// Constrain cam. to room borders
	camX = clamp(camX, 0, room_width - camWidth);
	camY = clamp(camY, 0, room_height - camHeight);
}