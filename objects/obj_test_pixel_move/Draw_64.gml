draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_tiny);

var _flawed = abs(pixel_move.get_real_x() - position_x) > 0.0001 || abs(pixel_move.get_real_y() - position_y) > 0.0001;
draw_set_color(_flawed ? c_red : c_lime);
draw_text(0, 0, $"pixel move: ({pixel_move.get_real_x()},{pixel_move.get_real_y()})");
draw_text(0, 9, $"position: ({position_x},{position_y})");
