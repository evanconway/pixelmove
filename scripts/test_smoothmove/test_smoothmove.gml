// @ignore
global.gap_fixes = 0;

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
		smooth_move_by_vector(_n, 6*pi/4, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_n), 0, "Smooth move north test 1 x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_n), -1000, "Smooth move north test 1 y fail!");
	smooth_move_by_vector(_n, 0, 0);
	test_smooth_move_assert_real(smooth_move_get_x(_n), 0, "Smooth move north test 2 x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_n), -1000, "Smooth move north test 2 y fail!");
	
	// south
	var _s = new SmoothMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		smooth_move_by_vector(_s, 2*pi/4, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_s), 0, "Smooth move south test 1 x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_s), 1000, "Smooth move south test 1 y fail!");
	smooth_move_by_vector(_s, 0, 0);
	test_smooth_move_assert_real(smooth_move_get_x(_s), 0, "Smooth move south test 2 x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_s), 1000, "Smooth move south test 2 y fail!");
	
	// east
	var _e = new SmoothMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		smooth_move_by_vector(_e, 0*pi/4, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_e), 1000, "Smooth move east test 1 x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_e), 0, "Smooth move east test 1 y fail!");
	smooth_move_by_vector(_e, 0, 0);
	test_smooth_move_assert_real(smooth_move_get_x(_e), 1000, "Smooth move east test 2 x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_e), 0, "Smooth move east test 2 y fail!");
	
	// west
	var _w = new SmoothMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		smooth_move_by_vector(_w, 4*pi/4, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_w), -1000, "Smooth move west test 1 x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_w), 0, "Smooth move west test 1 y fail!");
	smooth_move_by_vector(_w, 0, 0);
	test_smooth_move_assert_real(smooth_move_get_x(_w), -1000, "Smooth move west test 2 x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_w), 0, "Smooth move west test 2 y fail!");
	
	// north east
	var _ne = new SmoothMove(0, 0);
	var _count = 0;
	for (var _i = 0; _i < _move_count; _i++) {
		smooth_move_by_vector(_ne, 7*pi/4, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_ne), 707, "Smooth move north east test 1 x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_ne), -707, "Smooth move north east test 1 y fail!");
	smooth_move_by_vector(_ne, 0, 0);
	test_smooth_move_assert_real(smooth_move_get_x(_ne), 707, "Smooth move north east test 2 x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_ne), -707, "Smooth move north east test 2 y fail!");
	
	// north west
	var _nw = new SmoothMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		smooth_move_by_vector(_nw, 5*pi/4, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_nw), -707, "Smooth move north west test 1 x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_nw), -707, "Smooth move north west test 1 y fail!");
	smooth_move_by_vector(_nw, 0, 0);
	test_smooth_move_assert_real(smooth_move_get_x(_nw), -707, "Smooth move north west test 2 x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_nw), -707, "Smooth move north west test 2 y fail!");
	
	// south east
	var _se = new SmoothMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		smooth_move_by_vector(_se, 1*pi/4, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_se), 707, "Smooth move south east test 1 x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_se), 707, "Smooth move south east test 1 y fail!");
	smooth_move_by_vector(_se, 0, 0);
	test_smooth_move_assert_real(smooth_move_get_x(_se), 707, "Smooth move south east test 2 x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_se), 707, "Smooth move south east test 2 y fail!");
	
	// south west
	var _sw = new SmoothMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		smooth_move_by_vector(_sw, 3*pi/4, 1);
	}
	test_smooth_move_assert_real(smooth_move_get_x(_sw), -707, "Smooth move south west test 1 x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_sw), 707, "Smooth move south west test 1 y fail!");
	smooth_move_by_vector(_sw, 0, 0);
	test_smooth_move_assert_real(smooth_move_get_x(_sw), -707, "Smooth move south west test 2 x fail!");
	test_smooth_move_assert_real(smooth_move_get_y(_sw), 707, "Smooth move south west test 2 y fail!");
	
	// pixel gaps and error correction
	var _random = new SmoothMove(0, 0);
	var _angle = 0;
	var _positions = array_create(0);
	array_push(_positions, [smooth_move_get_x(_random), smooth_move_get_y(_random)]);
	for (var _i = 0; _i < 1000; _i++) {
		var _frames = random_range(1, 20);
		_angle += random(pi/4);
		for (var _f = 0; _f < _frames; _f++) {
			smooth_move_by_vector(_random, _angle, 1);
			array_push(_positions, [smooth_move_get_x(_random), smooth_move_get_y(_random)]);
		}
	}
	
	for (var _i = 1; _i < array_length(_positions); _i++) {
		var _x1 = _positions[_i -1][0];
		var _x2 = _positions[_i][0]
		var _y1 = _positions[_i - 1][1];
		var _y2 = _positions[_i][1];
		var _dist = sqrt(sqr(_x1 - _x2) + sqr(_y1 - _y2));
		if (_dist > sqrt(2)) {
			show_error($"Smooth move random movement fail! Delta greater than 1 from ({_x1}, {_y1})  to ({_x2}, {_y2})", true);
		}
	}
	
	// set position
	var _set_pos = new SmoothMove(0, 0);
	for (var _i = 0; _i < 1000; _i++) {
		var _x = irandom_range(-10000, 10000);
		var _y = irandom_range(-10000, 10000);
		smooth_move_set_position(_set_pos, _x, _y);
		test_smooth_move_assert_real(smooth_move_get_x(_set_pos), _x, "Smooth move set position x fail!");
		test_smooth_move_assert_real(smooth_move_get_y(_set_pos), _y, "Smooth move set position y fail!");
	}
	
	// potential positions
	var _potential = new SmoothMove(0, 0);
	for (var _i = 0; _i < 10000; _i++) {
		var _mag_x = random_range(-1000, 1000);
		var _mag_y = random_range(-1000, 1000);
		var _pot_x = smooth_move_get_x_if_moved_by_magnitudes(_potential, _mag_x, _mag_y);
		var _pot_y = smooth_move_get_y_if_moved_by_magnitudes(_potential, _mag_x, _mag_y);
		smooth_move_by_magnitudes(_potential, _mag_x, _mag_y);
		test_smooth_move_assert_real(_pot_x, smooth_move_get_x(_potential), "Smooth move potential position x fail!");
		test_smooth_move_assert_real(_pot_y, smooth_move_get_y(_potential), "Smooth move potential position y fail!");
	}
}

__test_smoothmove();
