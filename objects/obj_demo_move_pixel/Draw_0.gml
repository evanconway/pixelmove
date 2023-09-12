var _hor = 0;
var _vrt = 0;

if (keyboard_check(vk_left)) _hor -= 1;
if (keyboard_check(vk_right)) _hor += 1;
if (keyboard_check(vk_up)) _vrt -= 1;
if (keyboard_check(vk_down)) _vrt += 1;

var _max_vel = 0.707;

var _angle = arctan2(_vrt, _hor);
var _vel = (_hor == 0 && _vrt == 0) ? 0 :_max_vel;

stick = gamepad_get_left_stick_data();
var _stick_mag = sqrt(sqr(stick.axis_h) + sqr(stick.axis_v));
if (_stick_mag > 0.9) _stick_mag = 1;
var _stick_angle = arctan2(stick.axis_v, stick.axis_h);
if (_stick_mag > 0) {
	_angle = __pixelmove_util_get_angle_to_8way(_stick_angle);
	_vel = min(_stick_mag * _max_vel, _max_vel);
}

pixel_move_by_vector(pixel_move, _angle, _vel);

x = pixel_move_get_x(pixel_move);
y = pixel_move_get_y(pixel_move);

draw_self();

trail.add(x, y);
trail.draw();

// draw location
draw_set_color(c_fuchsia);
draw_set_alpha(1);

draw_point(x, y);
