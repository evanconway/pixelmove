/**
 * @param {real} _width width of view
 * @param {real} _height width of view
 * @param {real} _window_multiplier scale of view
 */
function camera_init_basic(_width, _height, _window_multiplier = 1) {
	view_enabled = true;
	view_visible[0] = true;
	camera_set_view_size(view_camera[0], _width, _height);
	window_set_size(_width * _window_multiplier, _height * _window_multiplier);
	surface_resize(application_surface, _width, _height);
	display_set_gui_size(_width, _height);
}

function gamepad_get_left_stick_data() {
	var _result = {
		axis_h: 0,
		axis_v: 0,
	};
	for (var _i = 0; _i < gamepad_get_device_count(); _i++) {
		gamepad_set_axis_deadzone(_i, 0.15);
		var _h = gamepad_axis_value(_i, gp_axislh);
		var _v = gamepad_axis_value(_i, gp_axislv);
		if (_h != 0 || _v != 0) {
			_result.axis_h = _h;
			_result.axis_v = _v;
		}
		
		// d-pad overwrites
		_h = 0;
		_v = 0;
		if (gamepad_button_check(_i, gp_padl)) _h -= 1;
		if (gamepad_button_check(_i, gp_padr)) _h += 1;
		if (gamepad_button_check(_i, gp_padu)) _v -= 1;
		if (gamepad_button_check(_i, gp_padd)) _v += 1;
		if (_h != 0 || _v != 0) {
			_result.axis_h = _h;
			_result.axis_v = _v;
		}
	}
	return _result;
}

/**
 * @param {real} _trail_size
 * @param {real} _decay_rate
 */
function PositionTrail(_trail_size = 60, _decay_rate = 1/60) constructor {
	alpha_decay = _decay_rate;
	position_color = c_lime;
	arr = array_create(_trail_size);
	
	last_added_x = 0;
	last_added_y = 0;
	
	for (var _i = 0; _i < array_length(arr); _i++) {
		arr[_i] = {
			pos_x: 0,
			pos_y: 0,
			alpha: 0,
		}
	}
	index = 0;
	
	/**
	 * @param {real} _x
	 * @param {real} _y
	 */
	add = function(_x, _y) {
		if (last_added_x == _x && last_added_y == _y) return;
		last_added_x = _x;
		last_added_y = _y;
		arr[index].pos_x = _x;
		arr[index].pos_y = _y;
		arr[index].alpha = 1;
		index += 1;
		if (index >= array_length(arr)) index = 0;
	};
	
	draw = function() {
		draw_set_color(position_color);
		for (var _i = array_length(arr) -1; _i >= 0; _i--) {
			draw_set_alpha(arr[_i].alpha);
			draw_point(arr[_i].pos_x, arr[_i].pos_y);
			arr[_i].alpha -= alpha_decay;
		}
	};
}
