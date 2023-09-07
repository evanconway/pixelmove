smooth_move_by_vector(smooth_move, angle, 1);
angle += 0.03;

var _x = smooth_move_get_x(smooth_move);
var _y = smooth_move_get_y(smooth_move);

trail.add(_x, _y);

trail.draw();

// draw location
draw_set_color(trail.position_color);
draw_set_alpha(1);

draw_point(_x, _y);
