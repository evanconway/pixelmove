start_x = room_width / 2;
start_y = room_height / 2;

angle = 7*pi/4;
angle_mod = 0;
draw_state = 0;
draw_time = 0;

pixel_move = new PixelMove(start_x, start_y);

trail = new PositionTrail(100, 1/100);
