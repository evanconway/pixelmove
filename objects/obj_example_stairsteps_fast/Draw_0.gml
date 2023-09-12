if (!keyboard_check(vk_space)){
	draw_self();
	exit;
}

x += 0.5;
y -= 0.5;

draw_self();

if (x > 90 || y < 10) {
	x = original_x;
	y = original_y;
}
