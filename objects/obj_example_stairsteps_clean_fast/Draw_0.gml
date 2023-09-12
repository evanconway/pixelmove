if (!keyboard_check(vk_space)){
	draw_self();
	exit;
}

pixel_move_by_magnitudes(pixel_move, 0.5, -0.5);

x = pixel_move_get_x(pixel_move);
y = pixel_move_get_y(pixel_move);

draw_self();

if (x > 90 || y < 10) {
	pixel_move_set_position(pixel_move, original_x, original_y)
}
