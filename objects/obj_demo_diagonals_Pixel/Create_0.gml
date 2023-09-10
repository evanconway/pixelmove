start_x = room_width / 2;
start_y = room_height / 2;

diagonal_angle_state = 0;
diagonal_draw_time = 0;

pixel_move = new PixelMove(start_x, start_y) ;

trail = new PositionTrail(300, 1/300);
