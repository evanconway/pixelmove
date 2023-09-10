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
stick_mag = sqrt(sqr(stick.axis_h) + sqr(stick.axis_v));
if (stick_mag > 0.9) stick_mag = 1;
stick_angle = arctan2(stick.axis_v, stick.axis_h);
if (stick_mag > 0) {
	_angle = stick_angle;
	_vel = min(stick_mag * _max_vel, _max_vel);
}

// collision checking
//_angle = 2*pi/4 - 0.1;
//_vel = 2.3;

_angle = __pixelmove_util_get_cleaned_angle(_angle);

var _magnitude_x = __pixelmove_util_get_x_component(_angle, _vel)
var _magnitude_y = __pixelmove_util_get_y_component(_angle, _vel)

var _true_x = smooth_move.true_x;
var _true_y = smooth_move.true_y;

var _x = smooth_move_get_x(smooth_move);
var _y = smooth_move_get_y(smooth_move);

var _min_towards_zero = function(_a, _b) {
	if (min(abs(_a), abs(_b)) == abs(_a)) return _a;
	return _b;
};

var _x_angle = _angle >= 3*pi/2 || _angle <= pi/2 ? 0 : pi;
var _y_angle = _angle >= 0 && _angle <= pi ? pi/2 : 3*pi/2;

var _pot_x_if_moved_by_x_angle = smooth_move_get_x_if_moved_by_vector(smooth_move, _x_angle, _magnitude_x == 0 ? 0 : 1);
var _pot_y_if_moved_by_x_angle = smooth_move_get_y_if_moved_by_vector(smooth_move, _x_angle, _magnitude_x == 0 ? 0 : 1);
var _place_meeting_x_angle = place_meeting(_pot_x_if_moved_by_x_angle, _pot_y_if_moved_by_x_angle, obj_wall);

var _pot_x_if_moved_by_y_angle = smooth_move_get_x_if_moved_by_vector(smooth_move, _y_angle, _magnitude_y == 0 ? 0 : 1);
var _pot_y_if_moved_by_y_angle = smooth_move_get_y_if_moved_by_vector(smooth_move, _y_angle, _magnitude_y == 0 ? 0 : 1);
var _place_meeting_y_angle = place_meeting(_pot_x_if_moved_by_y_angle, _pot_y_if_moved_by_y_angle, obj_wall);

var _pot_x_if_moved_by_original_angle = smooth_move_get_x_if_moved_by_magnitudes(smooth_move, sign(_magnitude_x), sign(_magnitude_y));
var _pot_y_if_moved_by_original_angle = smooth_move_get_y_if_moved_by_magnitudes(smooth_move, sign(_magnitude_x), sign(_magnitude_y));
var _place_meeting_original_angle = place_meeting(_pot_x_if_moved_by_original_angle, _pot_y_if_moved_by_original_angle, obj_wall) || _place_meeting_x_angle || _place_meeting_y_angle;

var _collision_angle = _angle;
var _max_delta = _vel;
if (_place_meeting_original_angle && !_place_meeting_x_angle){
	_collision_angle = _x_angle;
	_max_delta = abs(_magnitude_x);
} else if (_place_meeting_original_angle && !_place_meeting_y_angle) {
	_collision_angle = _y_angle;
	_max_delta = abs(_magnitude_y);
}

var _checking = true;
var _mod_delta = 0;
var _increased_delta = _mod_delta;
while (_checking) {
	var _pot_x = smooth_move_get_x_if_moved_by_vector(smooth_move,_collision_angle, _increased_delta);
	var _pot_y = smooth_move_get_y_if_moved_by_vector(smooth_move, _collision_angle, _increased_delta);
	var _place_meeting = place_meeting(_pot_x, _pot_y, obj_wall);
	_checking = false;
	if (!_place_meeting) {
		_mod_delta = _increased_delta
		if (_mod_delta < _max_delta) _checking = true;
	}
	_increased_delta = min(_max_delta, _mod_delta + 1);
}

smooth_move_by_vector(smooth_move, _collision_angle, _mod_delta);

_x = smooth_move_get_x(smooth_move);
_y = smooth_move_get_y(smooth_move);

x = _x;
y = _y;

draw_self();


if (keyboard_check_pressed(ord("C"))) {
	positions = create_positions();
}

position_add(_x, _y);

array_foreach(ds_map_values_to_array(positions), function(_v) {
	draw_set_color(c_green);
	draw_point(_v[0], _v[1]);
});

with (smooth_move) {
	draw_set_color(c_fuchsia);
	draw_point(_x, _y);
}
