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

position_x += _vel_x;
position_y += _vel_y;
diagonal_draw_time += 1;

if (diagonal_draw_time >= 90) {
	position_x = start_x;
	position_y = start_y;
	diagonal_draw_time = 0;
	diagonal_angle_state = (diagonal_angle_state + 1) % 4;
}

// draw location
draw_set_color(trail.position_color);
draw_point(position_x, position_y);

trail.add(position_x, position_y);
trail.draw();
