if (!keyboard_check(vk_space)) {
	draw_self();
	trail.draw();
	exit;
}

pixel_move_by_vector(pixel_move, 7*pi/4 + 0.05, 0.5);

x = pixel_move_get_x(pixel_move);
y = pixel_move_get_y(pixel_move);

trail.add(x, y);

draw_self();
trail.draw();

if (x > 90 || y < 10) {
	pixel_move_set_position(pixel_move, original_x, original_y)
}
