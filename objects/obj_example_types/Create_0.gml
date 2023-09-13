camera_init_basic(room_width, room_height, 7);
//game_set_speed(60, gamespeed_fps);
original_x = x;
original_y = y;
pixel_move = new PixelMove(x, y);
trail = new PositionTrail(200, 0);
trail.add(x, y);


//pixel_move_set_movement_type_smooth(pixel_move);

pixel_move_set_movement_type_hybrid(pixel_move);
pixel_move_set_hybrid_movements_on_angle_to_infer_from_line(pixel_move, 50);
