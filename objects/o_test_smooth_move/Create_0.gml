camera_init_basic(160, 90, 10);
smooth_move = new SmoothMove(x, y);
game_set_speed(30, gamespeed_fps);

positions = array_create(100, [smooth_move_get_x(smooth_move), smooth_move_get_y(smooth_move)]);
positions_index = 0;
