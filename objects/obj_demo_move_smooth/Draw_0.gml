var _x = smooth_move_get_x(smooth_move);
var _y = smooth_move_get_y(smooth_move);

var _hor = 0;
var _vrt = 0;

if (keyboard_check(vk_left)) _hor -= 1;
if (keyboard_check(vk_right)) _hor += 1;
if (keyboard_check(vk_up)) _vrt -= 1;
if (keyboard_check(vk_down)) _vrt += 1;

if (mouse_check_button(mb_any)) {
	_hor = mouse_x - _x;
	_vrt = mouse_y - _y;
}

var _angle = arctan2(_vrt, _hor);

var _vel = (_hor == 0 && _vrt == 0) ? 0 : 0.707;

smooth_move_by_vector(smooth_move, _angle, _vel);

x = smooth_move_get_x(smooth_move);
y = smooth_move_get_y(smooth_move);

draw_self();

trail.add(x, y);
trail.draw();

// draw location
draw_set_color(trail.position_color);
draw_set_alpha(1);

draw_point(x, y);
