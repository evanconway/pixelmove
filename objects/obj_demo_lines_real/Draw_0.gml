var _vel = sqrt(2)/2;
var _vel_x = cos(angle) * _vel;
var _vel_y = sin(angle) * _vel;

position_x += _vel_x;
position_y += _vel_y;
draw_time += 1;

if (draw_time >= 60) {
	position_x = start_x;
	position_y = start_y;
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

trail.add(position_x, position_y);
trail.draw();
