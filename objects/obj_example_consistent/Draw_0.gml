if (!keyboard_check(vk_anykey)) {
	pixel_move_set_position(pixel_move, original_x, original_y);
	x = pixel_move_get_x(pixel_move);
	y = pixel_move_get_y(pixel_move);
	draw_self();
	exit;
}

if (keyboard_check(vk_left)) pixel_move_by_magnitudes(pixel_move, -0.1, 0);
if (keyboard_check(vk_right)) pixel_move_by_magnitudes(pixel_move, 0.1, 0);

x = pixel_move_get_x(pixel_move);
y = pixel_move_get_y(pixel_move);

draw_self();
