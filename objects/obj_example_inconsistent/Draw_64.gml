draw_set_font(fnt_tiny);
draw_text(0, 0, $"real x: {x}");
draw_text(0, 9, $"real y: {y}");

var _clean_x = floor(x * 10000 + 0.5)/10000;
var _clean_y = floor(y * 10000 + 0.5)/10000;

draw_text(0, 18, $"drawn x: {floor(_clean_x + 0.4)}");
draw_text(0, 27, $"drawn y: {floor(_clean_y + 0.4)}");
