var _stick = gamepad_get_left_stick_data();

smooth_move_by_vector(smooth_move, angle, 0.5);

x = smooth_move_get_x(smooth_move);
y = smooth_move_get_y(smooth_move);

angle += 0.01;
