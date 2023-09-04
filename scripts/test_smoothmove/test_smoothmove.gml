// @ignore
function __test_smoothmove(){
	/**
	 * Assert function for testing real numbers in this package.
	 *
	 * @param {real} _value
	 * @param {real} _expected
	 * feather ignore once all
	 */
	var test_smooth_move_assert_real = function(_value, _expected, _msg = "Smooth move test fail!") {
		if (!is_real(_value)) show_error(_msg + $"\n Value {_value} is not a real.", true);
		if (!is_real(_expected)) show_error(_msg + $"\n Expected {_expected} is not a real.", true);
		if (is_nan(_value)) show_error(_msg + $"\n Value {_value} is not a real.", true);
		if (is_nan(_expected)) show_error(_msg + $"\n Expected {_expected} is not a real.", true);
		if (_value != _expected) show_error(_msg + $"\n Expected {_expected} got {_value}.", true);
	}
	
	var _move_count = 1000;
	
	// north
	var _n = new SmoothMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		smooth_move_by_vector(_n, 0, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_n), 0, "Smooth move north test x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_n), -1000, "Smooth move north test y fail!");
	
	// south
	var _s = new SmoothMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		smooth_move_by_vector(_s, pi, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_s), 0, "Smooth move south test x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_s), 1000, "Smooth move south test y fail!");
	
	// east
	var _e = new SmoothMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		smooth_move_by_vector(_e, 3*pi/2, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_e), -1000, "Smooth move east test x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_e), 0, "Smooth move east test y fail!");
	
	// west
	var _w = new SmoothMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		smooth_move_by_vector(_w, pi/2, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_w), 1000, "Smooth move west test x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_w), 0, "Smooth move west test y fail!");
	
	// north east
	var _ne = new SmoothMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		smooth_move_by_vector(_ne, 7*pi/4, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_ne), -707, "Smooth move north east test x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_ne), -707, "Smooth move north east test y fail!");
	
	// north west
	var _nw = new SmoothMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		smooth_move_by_vector(_nw, pi/4, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_nw), 707, "Smooth move north west test x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_nw), -707, "Smooth move north west test y fail!");
	
	// south east
	var _se = new SmoothMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		smooth_move_by_vector(_se, 5*pi/4, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_se), -707, "Smooth move south east test x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_se), 707, "Smooth move south east test y fail!");
	
	// south west
	var _sw = new SmoothMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		smooth_move_by_vector(_sw, 3*pi/4, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_sw), 707, "Smooth move south west test x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_sw), 707, "Smooth move south west test y fail!");
	
	
	// conserve distance travelled when changing vectors
	var _dist_travelled_same = new SmoothMove(0, 0);
	smooth_move_set_xy_magnitudes(_dist_travelled_same, -0.7, 0.3);
	smooth_move_advance(_dist_travelled_same);
	smooth_move_advance(_dist_travelled_same);
	smooth_move_advance(_dist_travelled_same);
	smooth_move_advance(_dist_travelled_same);
	smooth_move_advance(_dist_travelled_same);
	test_smooth_move_assert_real(smooth_move_get_x(_dist_travelled_same), -3, "Smooth move distance travelled test 1 x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_dist_travelled_same), 1, "Smooth move distance travelled test 1 y fail!");
	smooth_move_set_xy_magnitudes(_dist_travelled_same, -0.02,0.1);
	smooth_move_advance(_dist_travelled_same);
	smooth_move_advance(_dist_travelled_same);
	smooth_move_advance(_dist_travelled_same);
	smooth_move_advance(_dist_travelled_same);
	smooth_move_advance(_dist_travelled_same);
	test_smooth_move_assert_real(smooth_move_get_x(_dist_travelled_same), -3, "Smooth move distance travelled test 2 x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_dist_travelled_same), 2, "Smooth move distance travelled test 2 y fail!");
	smooth_move_by_magnitudes(_dist_travelled_same, -0.1, -0.3);
	smooth_move_by_magnitudes(_dist_travelled_same, -0.1, -0.3);
	smooth_move_by_magnitudes(_dist_travelled_same, -0.1, -0.3);
	smooth_move_by_magnitudes(_dist_travelled_same, -0.1, -0.3);
	test_smooth_move_assert_real(smooth_move_get_x(_dist_travelled_same), -3, "Smooth move distance travelled test 3 x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_dist_travelled_same), 1, "Smooth move distance travelled test 3 y fail!");
}

//__test_smoothmove();