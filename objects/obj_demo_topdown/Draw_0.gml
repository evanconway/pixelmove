var _up = keyboard_check(vk_up);
var _dn = keyboard_check(vk_down);
var _lt = keyboard_check(vk_left);
var _rt = keyboard_check(vk_right);

var _vert = 0;
var _horz = 0;

if (_up) _vert -= 1;
if (_dn) _vert += 1;
if (_rt) _horz += 1;
if (_lt) _horz -= 1;

var _angle = arctan2(_vert, _horz);

var _max_vel = 1;

var _vel = (_vert != 0 || _horz != 0) ? _max_vel : 0;

stick = gamepad_get_left_stick_data();
var _stick_mag = sqrt(sqr(stick.axis_h) + sqr(stick.axis_v));
if (_stick_mag > 0.9) _stick_mag = 1;
var _stick_angle = arctan2(stick.axis_v, stick.axis_h);
if (_stick_mag > 0) {
	_angle = __pixelmove_util_get_angle_to_8way(_stick_angle);
	_vel = min(_stick_mag * _max_vel, _max_vel);
}

pixel_move_by_vector_against(pixel_move, _angle, _vel, function(x, y) {
	return place_meeting(x, y, obj_wall);
});

x = pixel_move_get_x(pixel_move);
y = pixel_move_get_y(pixel_move);

draw_self();
