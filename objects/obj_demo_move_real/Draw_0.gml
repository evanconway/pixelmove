var _hor = 0;
var _vrt = 0;

if (keyboard_check(vk_left)) _hor -= 1;
if (keyboard_check(vk_right)) _hor += 1;
if (keyboard_check(vk_up)) _vrt -= 1;
if (keyboard_check(vk_down)) _vrt += 1;

if (mouse_check_button(mb_any)) {
	_hor = mouse_x - x;
	_vrt = mouse_y - y;
}

var _angle = arctan2(_vrt, _hor);
var _vel = (_hor == 0 && _vrt == 0) ? 0 : 0.707;

x += cos(_angle) * _vel;
y += sin(_angle) * _vel;

draw_self();

trail.add(x, y);
trail.draw();

// draw location
draw_set_color(c_fuchsia);
draw_set_alpha(1);

draw_point(x, y);
