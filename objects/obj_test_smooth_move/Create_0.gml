camera_init_basic(200, 112, 10);
smooth_move = new SmoothMove(x, y);

smooth_move.movements_on_angle_to_infer_from_line = 0;

create_positions = function() {
	return ds_map_create();
};

positions = create_positions();

/**
 * @param {real} _x
 * @param {real} _y
 */
position_add = function (_x, _y) {
	ds_map_set(positions,  $"{_x},{_y}", [_x, _y])
};

stick = gamepad_get_left_stick_data();
stick_mag = sqrt(sqr(stick.axis_h) + sqr(stick.axis_v));
stick_angle = arctan2(stick.axis_v, stick.axis_h) + pi/2;

angle = 0;
