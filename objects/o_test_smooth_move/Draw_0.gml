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

var _vel = _angle >= 0 ? 1 : 0;

smooth_move_vector(smooth_move, _angle, _vel);

x = smooth_move_get_x(smooth_move);
y = smooth_move_get_y(smooth_move);

draw_self();
draw_set_color(c_fuchsia);
//draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
draw_set_color(c_red);
draw_point(bbox_left, bbox_top);
draw_point(bbox_left, bbox_bottom - 1);
draw_point(bbox_right - 1, bbox_top);
draw_point(bbox_right - 1, bbox_bottom - 1);
