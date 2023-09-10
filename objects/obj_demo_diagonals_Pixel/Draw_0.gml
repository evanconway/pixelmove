var _vel_x = 0;
var _vel_y = 0;
var _vel = 0.5;

if (diagonal_angle_state == 0) {
	_vel_x += _vel;
	_vel_y += _vel;
} else if (diagonal_angle_state == 1) {
	_vel_x -= _vel;
	_vel_y += _vel;
} else if (diagonal_angle_state == 2) {
	_vel_x -= _vel;
	_vel_y -= _vel;
} else if (diagonal_angle_state == 3) {
	_vel_x += _vel;
	_vel_y -= _vel;
}

pixel_move_by_magnitudes(pixel_move, _vel_x, _vel_y);
diagonal_draw_time += 1;

if (diagonal_draw_time >= 90) {
	pixel_move_set_position(pixel_move, start_x, start_y);
	diagonal_draw_time = 0;
	diagonal_angle_state = (diagonal_angle_state + 1) % 4;
}

var _x = pixel_move_get_x(pixel_move);
var _y = pixel_move_get_y(pixel_move);

// draw location
draw_set_color(trail.position_color);
draw_point(_x, _y);
trail.add(_x, _y);
trail.draw();
