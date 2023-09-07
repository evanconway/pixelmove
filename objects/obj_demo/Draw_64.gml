if (keyboard_check_pressed(ord("1"))) room_goto(rm_demo_circle);
if (keyboard_check_pressed(ord("2"))) room_goto(rm_demo_move);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_font(fnt_demo_tiny);
draw_text(0, 0, "Press 1 or 2 to choose a demo.");

draw_set_valign(fa_bottom);
if (room == rm_demo_circle) draw_text(0, room_height, "circle");
if (room == rm_demo_move) draw_text(0, room_height, "mouse or arrow keys to move");
