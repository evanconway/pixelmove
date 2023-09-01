camera_init_basic(200, 112, 10);
smooth_move = new SmoothMove(x, y);
//game_set_speed(3, gamespeed_fps);

create_positions = function() {
	return array_create(1000, [smooth_move_get_x(smooth_move), smooth_move_get_y(smooth_move)]);
};

positions = create_positions();
positions_index = 0;


stick = gamepad_get_left_stick_data();
stick_mag = sqrt(sqr(stick.axis_h) + sqr(stick.axis_v));
stick_angle = arctan2(stick.axis_v, stick.axis_h) + pi/2;

prev_x = smooth_move_get_x(smooth_move);
prev_y = smooth_move_get_y(smooth_move);