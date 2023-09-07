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

smooth_move_by_magnitudes(smooth_move, _vel_x, _vel_y);
diagonal_draw_time += 1;

if (diagonal_draw_time >= 90) {
	smooth_move_set_position(smooth_move, start_x, start_y);
	diagonal_draw_time = 0;
	diagonal_angle_state = (diagonal_angle_state + 1) % 4;
}

var _x = smooth_move_get_x(smooth_move);
var _y = smooth_move_get_y(smooth_move);

// draw location
draw_set_color(trail.position_color);
draw_point(_x, _y);
trail.add(_x, _y);
trail.draw();
