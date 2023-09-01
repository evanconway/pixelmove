draw_set_color(c_lime);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_tiny);
draw_text_ext(2, 0, smooth_move, 0, 10000);
//draw_text(2, 0, $"{smooth_move_get_x(smooth_move)}, {smooth_move_get_y(smooth_move)}");
//draw_text(2, 9, $"{x - prev_x}, {y - prev_y}");

//draw_text(2, 18, $"stick h: {stick.axis_h}");
//draw_text(2, 27, $"stick v: {stick.axis_v}");
//draw_text(2, 36, $"stick angle: {stick_angle}")