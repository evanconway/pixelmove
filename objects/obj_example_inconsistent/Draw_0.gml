if (!keyboard_check(vk_anykey)) {
	x = original_x;
	y = original_y;
	draw_self();
	exit;
}

if (keyboard_check(vk_left)) x -= 0.1;
if (keyboard_check(vk_right)) x += 0.1;
if (keyboard_check(vk_up)) y -= 0.1;
if (keyboard_check(vk_down)) y += 0.1;

draw_self();
