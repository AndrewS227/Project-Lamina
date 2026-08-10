function getControls() 
{
	// Directional Inputs
	rightKey =  keyboard_check(ord("D")) + gamepad_button_check(0,gp_padr);
	// if both right arrow and "D" is pressed, rightKey value would be 2
	// clamp is needed to maximize this value in 1
		rightKey = clamp(rightKey, 0, 1);
	
	leftKey =  keyboard_check(ord("A")) + gamepad_button_check(0,gp_padl);
		leftKey = clamp(leftKey, 0, 1);
	
	// Action Inputs
	jumpKeyPressed = keyboard_check_pressed(vk_space) +  gamepad_button_check(0,gp_face1);
		jumpKeyPressed = clamp(jumpKeyPressed, 0, 1); // not necessary, since this value isn't used in any calculations
}