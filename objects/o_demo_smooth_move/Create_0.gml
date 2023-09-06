camera_init_basic(200, 112, 10);
smooth_move = new SmoothMove(x, y);
//game_set_speed(240, gamespeed_fps);

create_positions = function() {
	var _result = ds_map_create();
	ds_map_set(_result, $"{smooth_move_get_x(smooth_move)},{smooth_move_get_y(smooth_move)}", [smooth_move_get_x(smooth_move), smooth_move_get_y(smooth_move), c_lime]);
	return _result;
};

positions = create_positions();
positions_index = 0;

stick = gamepad_get_left_stick_data();
stick_mag = sqrt(sqr(stick.axis_h) + sqr(stick.axis_v));
stick_angle = arctan2(stick.axis_v, stick.axis_h) + pi/2;
