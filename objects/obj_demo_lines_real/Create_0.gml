start_x = room_width / 2;
start_y = room_height / 2;

angle = 7*pi/4;
angle_mod = 0;
draw_state = 0;
draw_time = 0;

position_x = start_x;
position_y = start_y;

trail = new PositionTrail(100, 1/100);
