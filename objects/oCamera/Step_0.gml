// There's a built in object following option
// This code is for smoother player tracking
// Persistent should be ticked off -> persistent game wide behaviour

// Fullscreen toggle
if keyboard_check_pressed(vk_f1)
{
	window_set_fullscreen(!window_get_fullscreen());
}

// Exits if there's no player
// Gets cam. size
// Gets coordinates at the start of the room
// Constrains cam. to room borders
cam_func();

// Set cam coordinate variables
// For smoother tracking
finalCamX += (camX - finalCamX) * camTrailSpd;
finalCamY += (camY - finalCamY) * camTrailSpd;

// Set camera coordinates
camera_set_view_pos(view_camera[0], finalCamX, finalCamY);