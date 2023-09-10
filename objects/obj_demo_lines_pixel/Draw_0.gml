var _vel = sqrt(2)/2;

pixel_move_by_vector(pixel_move, angle, _vel);

draw_time += 1;

if (draw_time >= 60) {
	pixel_move_set_position(pixel_move, start_x, start_y);
	draw_time = 0;
	draw_state = (draw_state + 1) % 4;
	if (draw_state == 0) {
		angle = 7*pi/4 + angle_mod;
	} else if (draw_state == 1) {
		angle = 1*pi/4 + angle_mod;
	} else if (draw_state == 2) {
		angle = 3*pi/4 + angle_mod;
	} else if (draw_state == 3) {
		angle = 5*pi/4 + angle_mod;
		angle_mod += 0.12;
	}
}

var _x = pixel_move_get_x(pixel_move);
var _y = pixel_move_get_y(pixel_move);

// draw location
draw_point(_x, _y);

trail.add(_x, _y);
trail.draw();
