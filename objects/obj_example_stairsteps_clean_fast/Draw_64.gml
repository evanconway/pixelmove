draw_set_font(fnt_tiny);
draw_text(0, 0, $"real x: {pixel_move.get_real_x()}");
draw_text(0, 9, $"real y: {pixel_move.get_real_y()}");
draw_text(0, 18, $"drawn x: {floor(x)}");
draw_text(0, 27, $"drawn y: {floor(y)}");
