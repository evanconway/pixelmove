if (keyboard_check_pressed(ord("1"))) room_goto(rm_demo_circle_smooth);
if (keyboard_check_pressed(ord("2"))) room_goto(rm_demo_lines_real);
if (keyboard_check_pressed(ord("3"))) room_goto(rm_demo_lines_pixel);
if (keyboard_check_pressed(ord("4"))) room_goto(rm_demo_move_real);
if (keyboard_check_pressed(ord("5"))) room_goto(rm_demo_move_pixel);
if (keyboard_check_pressed(ord("6"))) room_goto(rm_demo_topdown);
if (keyboard_check_pressed(ord("7"))) room_goto(rm_demo_platformer);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_font(fnt_demo_tiny);
draw_text(0, 0, "Press 1-7 to choose a demo.");

draw_set_valign(fa_bottom);
//if (room == rm_demo_circle_smooth) draw_text(0, room_height, "circle");
if (room == rm_demo_lines_real) draw_text(0, room_height, "lines (floored real)");
if (room == rm_demo_lines_pixel) draw_text(0, room_height, "lines (pixel move)");
if (room == rm_demo_move_real) draw_text(0, room_height, "free move (real)");
if (room == rm_demo_move_pixel) draw_text(0, room_height, "free move (pixel move)");
//if (room == rm_demo_topdown) draw_text(0, room_height, "Line Type Movement");
//if (room == rm_demo_platformer) draw_text(0, room_height, "Hybrid Type Movement");
