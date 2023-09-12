var _lt = keyboard_check(vk_left);
var _rt = keyboard_check(vk_right);

var _vert = 0;
var _horz = 0;

if (_rt) _horz += 1;
if (_lt) _horz -= 1;

var _angle = arctan2(_vert, _horz);

var _max_vel = 1;

var _vel = (_vert != 0 || _horz != 0) ? _max_vel : 0;

stick = gamepad_get_left_stick_data();
var _stick_mag = abs(stick.axis_h);
if (_stick_mag > 0.9) _stick_mag = 1;
var _stick_angle = stick.axis_h >= 0 ? 0 : pi;
if (_stick_mag > 0) {
	_angle = __pixelmove_util_get_angle_to_8way(_stick_angle);
	_vel = min(_stick_mag * _max_vel, _max_vel);
}

var _jump_pressed = gamepad_get_jump() || keyboard_check_pressed(vk_space);

if (place_meeting(x, y - 1, obj_wall) || place_meeting(x, y + 1, obj_wall)) vertical_vel = 0;
vertical_vel += 0.1;
if (place_meeting(x, y + 1, obj_wall) && _jump_pressed) vertical_vel = -3;

var _vel_x = cos(_angle) * _vel;
var _vel_y = (sin(_angle) * _vel) + vertical_vel;

pixel_move_by_magnitudes_against(pixel_move, _vel_x, _vel_y, function(x, y) {
	return place_meeting(x, y, obj_wall);
});

x = pixel_move_get_x(pixel_move);
y = pixel_move_get_y(pixel_move);

draw_self();
