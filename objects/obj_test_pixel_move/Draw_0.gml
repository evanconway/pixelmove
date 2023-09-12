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

//_angle = angle;
//_vel = 1;
//angle +=  random_range(-0.03, 0.03);

//_angle = __pixelmove_util_get_cleaned_angle(angle);

var _x = pixel_move_get_x(pixel_move);
var _y = pixel_move_get_y(pixel_move);

if (_vel == 0) {
	position_x = pixel_move_get_x(pixel_move);
	position_y = pixel_move_get_y(pixel_move);
}

var _potential_position_x = position_x + __pixelmove_util_get_x_component(_angle, _vel);
var _potential_position_y = position_y + __pixelmove_util_get_y_component(_angle, _vel);

var _potential_pixel_position = pixel_move_get_real_position_if_moved_by_vector(pixel_move, _angle, _vel);

var _flawed = abs(_potential_pixel_position.x - _potential_position_x) > 0.0001 || abs(_potential_pixel_position.y - _potential_position_y) > 0.0001;

if (_flawed) {
	show_debug_message("show time");
}

pixel_move_by_vector(pixel_move, _angle, _vel);

position_x += __pixelmove_util_get_x_component(_angle, _vel);
position_y += __pixelmove_util_get_y_component(_angle, _vel);

/*
pixel_move_by_vector_against(pixel_move, _angle, _vel, function(x, y) {
	return place_meeting(x, y, obj_wall);
});
*/

_x = pixel_move_get_x(pixel_move);
_y = pixel_move_get_y(pixel_move);

x = _x;
y = _y;

draw_self();


if (keyboard_check_pressed(ord("C"))) {
	positions = create_positions();
}

position_add(x, y);

array_foreach(ds_map_values_to_array(positions), function(_v) {
	draw_set_color(c_green);
	draw_point(_v[0], _v[1]);
});


if (place_meeting(x, y, obj_wall)) draw_set_color(c_red);
else draw_set_color(c_yellow);
draw_point(x, y);
