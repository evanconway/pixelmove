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
stick_angle = arctan2(stick.axis_v, stick.axis_h);
if (stick_mag > 0) {
	_angle = stick_angle;
	_vel = min(stick_mag * _max_vel, _max_vel);
}

//_angle = 7*pi/4 - 0.3;
//_vel = 1;

// collision checking
/*
var _magnitude_x = cos(_angle) * _vel;
var _magnitude_y = sin(_angle) * _vel;

var _target_x = smooth_move_get_x_if_moved_by_magnitudes(smooth_move, _magnitude_x, _magnitude_y);
var _target_y = smooth_move_get_y_if_moved_by_magnitudes(smooth_move, _magnitude_x, _magnitude_y);

var _curr_x = smooth_move_get_x(smooth_move);
var _curr_y = smooth_move_get_y(smooth_move);

var _target_diff_x = _target_x - _curr_x;
var _target_diff_y = _target_y - _curr_y;

var _mod_x = 0;
var _mod_y = 0;

var _checking = (_mod_x != _target_diff_x) || (_mod_y != _target_diff_y);
while (_checking) {
	var _moved = false;
	var _new_x_move_pot_x = smooth_move_get_x_if_moved_by_magnitudes(smooth_move, _mod_x + sign(_magnitude_x), _mod_y);
	var _new_x_move_pot_y = smooth_move_get_y_if_moved_by_magnitudes(smooth_move, _mod_x + sign(_magnitude_x), _mod_y);
	if (_mod_x != _target_diff_x && !place_meeting(_new_x_move_pot_x, _new_x_move_pot_y, obj_wall)) {
		_mod_x += sign(_magnitude_x);
		_moved = true;
	}
	var _new_y_move_pot_x = smooth_move_get_x_if_moved_by_magnitudes(smooth_move, _mod_x, _mod_y + sign(_magnitude_y));
	var _new_y_move_pot_y = smooth_move_get_y_if_moved_by_magnitudes(smooth_move, _mod_x, _mod_y + sign(_magnitude_y));
	if (_mod_y != _target_diff_y && !place_meeting(_new_y_move_pot_x, _new_y_move_pot_y, obj_wall)) {
		_mod_y += sign(_magnitude_y);
		_moved = true;
	}
	_checking = _moved;
}

var _final_mag_x = _mod_x == _target_diff_x ? _magnitude_x : _mod_x;
var _final_mag_y = _mod_y == _target_diff_y ? _magnitude_y : _mod_y;

//smooth_move_by_magnitudes(smooth_move, _final_mag_x, _final_mag_y);
*/

//_vel = 1
//_angle = 6*pi/4;

//smooth_move_by_vector(smooth_move, _angle, _vel);

if (keyboard_check_pressed(vk_space)) {
	var _check_x = smooth_move.anticipated_x;
	var _check_y = smooth_move.anticipated_y;
	smooth_move_by_vector(smooth_move, angle, 1);
	angle += 0.02;
	if (_check_x != smooth_move_get_x(smooth_move) || _check_y != smooth_move_get_y(smooth_move)) {
		show_debug_message("anticipated position was incorrect");
	}
}

var _x = smooth_move_get_x(smooth_move);
var _y = smooth_move_get_y(smooth_move);

x = _x;
y = _y;

draw_self();


if (keyboard_check_pressed(ord("C"))) {
	positions = create_positions();
}

position_add();

array_foreach(ds_map_values_to_array(positions), function(_v) {
	draw_set_color(_v[2]);
	draw_point(_v[0], _v[1]);
});

with (smooth_move) {
	draw_set_color(c_white);
	draw_point(anticipated_x2, anticipated_y2);
	draw_set_color(c_yellow);
	draw_point(anticipated_x, anticipated_y);
	//draw_set_color(c_red);
	//draw_point(start_x, start_y);
	draw_set_color(c_fuchsia);
	draw_point(smooth_move_get_x(self), smooth_move_get_y(self));
}
