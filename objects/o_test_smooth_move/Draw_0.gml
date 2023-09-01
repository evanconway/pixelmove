var _up = keyboard_check(vk_up);
var _dn = keyboard_check(vk_down);
var _lt = keyboard_check(vk_left);
var _rt = keyboard_check(vk_right);

var _angle = -1;
if (_up && !_rt && !_dn && !_lt) _angle = 0;
if (!_up && _rt && !_dn && !_lt) _angle = pi/2;
if (!_up && !_rt && _dn && !_lt) _angle = pi;
if (!_up && !_rt && !_dn && _lt) _angle = 3*pi/2;

if (_up && _rt && !_dn && !_lt) _angle = pi/4;
if (!_up && _rt && _dn && !_lt) _angle = 3*pi/4;
if (!_up && !_rt && _dn && _lt) _angle = 5*pi/4;
if (_up && !_rt && !_dn && _lt) _angle = 7*pi/4;

//_angle = 7*pi/4;
//_angle = pi/4;

var _vel = _angle >= 0 ? sin(pi/4)/2 : 0;

smooth_move_by_vector(smooth_move, _angle, _vel);

var _x = smooth_move_get_x(smooth_move);
var _y = smooth_move_get_y(smooth_move);

x = _x;
y = _y;

draw_self();

if (keyboard_check_pressed(ord("C"))) {
	positions = create_positions();
}

if (_x != positions[positions_index][0] || _y != positions[positions_index][1]) {
	positions_index += 1;
	if (positions_index >= array_length(positions)) positions_index = 0;
	positions[positions_index] = [_x, _y];
}

draw_set_color(c_lime);
for (var _i = 0; _i < array_length(positions); _i++) {
	draw_point(positions[_i][0], positions[_i][1]);
}
