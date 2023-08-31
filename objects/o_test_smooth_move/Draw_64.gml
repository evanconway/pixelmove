draw_set_color(c_lime);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_tiny);
draw_text(2, 0, $"{smooth_move_get_x(smooth_move)}, {smooth_move_get_y(smooth_move)}");
draw_text(2, 9, $"{smooth_move_get_vector_magnitude_x(smooth_move)}, {smooth_move_get_vector_magnitude_y(smooth_move)}");
