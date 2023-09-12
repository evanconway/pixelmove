camera_init_basic(200, 112, 10);
pixel_move = new PixelMove(x, y);

pixel_move_set_movement_type_smooth(pixel_move);

//pixel_move_set_movement_type_hybrid(pixel_move);
show_debug_message($"Pixel move type is: {pixel_move.movement_type}");

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

position_x = x;
position_y = y;

/*
var _flawed = false;

var _count = 0;
while (!_flawed)  {	
	var _vel = 1;
	angle +=  random_range(-0.03, 0.03);
	
	position_x += __pixelmove_util_get_x_component(angle, _vel);
	position_y += __pixelmove_util_get_y_component(angle, _vel);
	
	pixel_move_by_vector(pixel_move, angle, _vel);
	_flawed = abs(pixel_move.get_real_x() - position_x) > 0.0001 || abs(pixel_move.get_real_y() - position_y) > 0.0001;	
	_count++;
}

pixel_move_set_position(pixel_move, room_width/2, room_height/2);

pixel_move_set_position(pixel_move, x, y);
position_x = x;
position_y = y;
*/
