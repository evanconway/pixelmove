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
	window_center();
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
 * @param {Struct.SmoothMove} _smooth_move
 * @ignore
 */
function smooth_move_tostring(_smooth_move) {
	with (_smooth_move) {
		return $"start_x: {start_x}\n start_y: {start_y}\n angle: {angle}\n  delta: {delta}\n x: {smooth_move_get_x(self)}\n y: {smooth_move_get_y(self)}";
	}
}
