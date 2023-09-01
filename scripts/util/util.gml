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
	}
	return _result;
}
