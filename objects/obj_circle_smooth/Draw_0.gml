pixel_move_by_vector(pixel_move, angle, 1);
angle += 0.03;

var _x = pixel_move_get_x(pixel_move);
var _y = pixel_move_get_y(pixel_move);

trail.add(_x, _y);

trail.draw();

// draw location
draw_set_color(trail.position_color);
draw_set_alpha(1);

draw_point(_x, _y);
