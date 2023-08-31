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
}
