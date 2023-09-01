camera_init_basic(160, 90, 10);
smooth_move = new SmoothMove(x, y);
//game_set_speed(3, gamespeed_fps);

create_positions = function() {
	return array_create(1000, [smooth_move_get_x(smooth_move), smooth_move_get_y(smooth_move)]);
};

positions = create_positions();
positions_index = 0;
