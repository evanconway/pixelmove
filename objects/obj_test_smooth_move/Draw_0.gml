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

var _angle = arctan2(_vert, _horz)

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
//_angle = 3*pi/4 - 0.3;
//_vel = 0.7;

var _magnitude_x = cos(_angle) * _vel;
var _magnitude_y = sin(_angle) * _vel;

var _true_x = smooth_move.position.true_x;
var _true_y = smooth_move.position.true_y;

var _x = smooth_move_get_x(smooth_move);
var _y = smooth_move_get_y(smooth_move);

var _mod_x = 0;
var _mod_y = 0;

var _min_towards_zero = function(_a, _b) {
	if (min(abs(_a), abs(_b)) == abs(_a)) return _a;
	return _b;
};

if (keyboard_check_pressed(vk_space)) {
	show_debug_message("debug");
}

var _checking = true;
while (_checking) {
	var _moved = false;
	if (_mod_x != _magnitude_x) {
		var _increased_mod_x = sign(_magnitude_x);
		var _new_x_move_pot_x = smooth_move_get_x_if_moved_by_magnitudes(smooth_move, _increased_mod_x, _mod_y);
		var _new_x_move_pot_y = smooth_move_get_y_if_moved_by_magnitudes(smooth_move, _increased_mod_x, _mod_y);
		if (!place_meeting(_new_x_move_pot_x, _new_x_move_pot_y, obj_wall)) {
			_mod_x = _min_towards_zero(_mod_x + sign(_magnitude_x), _magnitude_x);
			_moved = true;
		}
	}
	if (_mod_y != _magnitude_y) {
		var _increased_mod_y = sign(_magnitude_y);
		var _new_y_move_pot_x = smooth_move_get_x_if_moved_by_magnitudes(smooth_move, _mod_x, _increased_mod_y);
		var _new_y_move_pot_y = smooth_move_get_y_if_moved_by_magnitudes(smooth_move, _mod_x, _increased_mod_y);
		if (_mod_y != _increased_mod_y && !place_meeting(_new_y_move_pot_x, _new_y_move_pot_y, obj_wall)) {
			_mod_y = _min_towards_zero(_mod_y + sign(_magnitude_y), _magnitude_y);
			_moved = true;
		}
	}
	_checking = _moved;
}

smooth_move_by_magnitudes(smooth_move, _mod_x, _mod_y);

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
