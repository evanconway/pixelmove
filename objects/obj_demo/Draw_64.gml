if (keyboard_check_pressed(ord("1"))) room_goto(rm_demo_circle_smooth);
if (keyboard_check_pressed(ord("2"))) room_goto(rm_demo_diagonals_real);
if (keyboard_check_pressed(ord("3"))) room_goto(rm_demo_diagonals_pixel);
if (keyboard_check_pressed(ord("4"))) room_goto(rm_demo_move_real);
if (keyboard_check_pressed(ord("5"))) room_goto(rm_demo_move_pixel);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_font(fnt_demo_tiny);
draw_text(0, 0, "Press 1-5 to choose a demo.");

draw_set_valign(fa_bottom);
if (room == rm_demo_circle_smooth) draw_text(0, room_height, "circle");
if (room == rm_demo_diagonals_real) draw_text(0, room_height, "diagonals (real)");
if (room == rm_demo_diagonals_pixel) draw_text(0, room_height, "diagonals (pixel move)");
if (room == rm_demo_move_real) draw_text(0, room_height, "free move (real)");
if (room == rm_demo_move_pixel) draw_text(0, room_height, "free move (pixel move)");
