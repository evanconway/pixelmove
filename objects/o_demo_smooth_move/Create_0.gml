camera_init_basic(200, 112, 10);
smooth_move = new SmoothMove(x, y);
//game_set_speed(240, gamespeed_fps);

create_positions = function() {
	var _result = ds_map_create();
	ds_map_set(_result, $"{smooth_move_get_x(smooth_move)},{smooth_move_get_y(smooth_move)}", [smooth_move_get_x(smooth_move), smooth_move_get_y(smooth_move), c_lime]);
	return _result;
};

position_add = function () {
	ds_map_set(positions, $"{smooth_move_get_x(smooth_move)},{smooth_move_get_y(smooth_move)}", [smooth_move_get_x(smooth_move), smooth_move_get_y(smooth_move), c_green]);
};

positions = create_positions();

stick = gamepad_get_left_stick_data();
stick_mag = sqrt(sqr(stick.axis_h) + sqr(stick.axis_v));
stick_angle = arctan2(stick.axis_v, stick.axis_h) + pi/2;

// debug jumping
/*
smooth_move_set_position(smooth_move, 0, 0);
position_add();

var _vel = 0.13;

for (var _i = 0; _i < 20; _i++) {
	smooth_move_by_vector(smooth_move, 0, _vel);
	position_add();
}

var _angle = 0;
for (var _i = 0; _i < 60; _i++) {
	smooth_move_by_vector(smooth_move, _angle, _vel);
	position_add();
	_angle += 0.02
}

for (var _i = 0; _i < 1000; _i++) {
	smooth_move_by_vector(smooth_move, _angle, _vel);
	var _check_x = smooth_move_get_x(smooth_move);
	var _check_y = smooth_move_get_y(smooth_move);
	position_add();
}
*/
