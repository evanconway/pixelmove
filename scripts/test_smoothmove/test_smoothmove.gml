/**
 * Basic assert function for testing real numbers in this library.
 *
 * @param {real} _value
 * @param {real} _expected
 */
function test_smooth_move_assert_real(_value, _expected, _msg = "Smooth move test fail!") {
	if (_value != _expected) show_error($"{_msg}\n Expected {_expected} got {_value}.", true);
}

function test_smoothmove(){	
	// north
	var _n = new SmoothMove(0, 0);
	for (var _i = 0; _i < 10; _i++) {
		smooth_move_by_vector(_n, 0, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_n), 0, "Smooth move north text x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_n), -10, "Smooth move north text y fail!");
	
	// south
	var _s = new SmoothMove(0, 0);
	for (var _i = 0; _i < 10; _i++) {
		smooth_move_by_vector(_s, pi, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_s), 0, "Smooth move south text x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_s), 10, "Smooth move south text y fail!");
	
	// east
	var _e = new SmoothMove(0, 0);
	for (var _i = 0; _i < 10; _i++) {
		smooth_move_by_vector(_e, 3*pi/2, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_e), -10, "Smooth move east text x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_e), 0, "Smooth move east text y fail!");
	
	// west
	var _w = new SmoothMove(0, 0);
	for (var _i = 0; _i < 10; _i++) {
		smooth_move_by_vector(_w, pi/2, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_w), 10, "Smooth move west text x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_w), 0, "Smooth move west text y fail!");
}

test_smoothmove();