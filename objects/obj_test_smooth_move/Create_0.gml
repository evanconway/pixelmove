camera_init_basic(200, 112, 10);
smooth_move = new SmoothMove(x, y);

create_positions = function() {
	var _result = ds_map_create();
	ds_map_set(_result, $"{smooth_move_get_x(smooth_move)},{smooth_move_get_y(smooth_move)}", [smooth_move_get_x(smooth_move), smooth_move_get_y(smooth_move), c_green]);
	return _result;
};

positions = create_positions();

position_add = function () {
	var _key = $"{smooth_move_get_x(smooth_move)},{smooth_move_get_y(smooth_move)}";
	if (ds_map_exists(positions, _key)) return;
	ds_map_set(positions, _key, [smooth_move_get_x(smooth_move), smooth_move_get_y(smooth_move), c_green]);
};

stick = gamepad_get_left_stick_data();
stick_mag = sqrt(sqr(stick.axis_h) + sqr(stick.axis_v));
stick_angle = arctan2(stick.axis_v, stick.axis_h) + pi/2;

// debug stair step

/*
smooth_move_set_position(smooth_move, 0, 0);
angle = 0;
for (var _i = 0; _i < 200; _i++) {
	smooth_move_by_vector(smooth_move, angle, 1);
	position_add(smooth_move_get_x(smooth_move), smooth_move_get_y(smooth_move));
	angle += random(0.03);
}
*/

angle = 0;
