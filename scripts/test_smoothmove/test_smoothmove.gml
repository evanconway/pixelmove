/**
 * Assert function for testing real numbers in this package.
 *
 * @param {real} _value
 * @param {real} _expected
 * feather ignore once all
 */
function test_smooth_move_assert_real(_value, _expected, _msg = "Smooth move test fail!") {
	if (!is_real(_value)) show_error(_msg + $"\n Value {_value} is not a real.", true);
	if (!is_real(_expected)) show_error(_msg + $"\n Expected {_expected} is not a real.", true);
	if (is_nan(_value)) show_error(_msg + $"\n Value {_value} is not a real.", true);
	if (is_nan(_expected)) show_error(_msg + $"\n Expected {_expected} is not a real.", true);
	if (_value != _expected) show_error(_msg + $"\n Expected {_expected} got {_value}.", true);
}

function __test_smoothmove_cardinals() {
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
}

function __test_smoothmove_perfect_diagonals() {
	// @param {real} _mag
	var _test_perfect_diagonals = function(_mag) {
		var _func = function(_mag_x, _mag_y) {
			var _sm = new SmoothMove(0, 0);
			for (var _i = 0; _i < 1000; _i++) {
				var _check_x = smooth_move_get_x(_sm);
				var _check_y = smooth_move_get_y(_sm);
				smooth_move_by_magnitudes(_sm, _mag_x, _mag_y);
				var _x_after_move = smooth_move_get_x(_sm);
				var _y_after_move = smooth_move_get_y(_sm);
				var _divider = 1 / abs(_mag_x);
				if ((_i + 1) % _divider == 0) {
					test_smooth_move_assert_real(_x_after_move, _check_x + sign(_mag_x), $"Smooth diagonal test {_mag_x} x fail!");
					test_smooth_move_assert_real(_y_after_move, _check_y + sign(_mag_y), $"Smooth diagonal test {_mag_y} y fail!");
				} else {
					test_smooth_move_assert_real(_x_after_move, _check_x, $"Smooth diagonal test {_mag_x} x fail!");
					test_smooth_move_assert_real(_y_after_move, _check_y, $"Smooth diagonal test {_mag_y} y fail!");
				}
			}
		};
		_func(_mag, _mag);
		_func(_mag, _mag * -1);
		_func(_mag * -1, _mag);
		_func(_mag * -1, _mag * -1);
	};
	
	_test_perfect_diagonals(1/10);
	_test_perfect_diagonals(1/9);
	_test_perfect_diagonals(1/8);
	_test_perfect_diagonals(1/7);
	_test_perfect_diagonals(1/6);
	_test_perfect_diagonals(1/5);
	_test_perfect_diagonals(1/4);
	_test_perfect_diagonals(1/3);
	_test_perfect_diagonals(1/2);
	_test_perfect_diagonals(1);
}

function __test_smoothmove_pixel_gaps() {
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
}

function __test_smoothmove_positions() {
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
	for (var _i = 0; _i < 1000; _i++) {
		var _mag_x = random_range(-1000, 1000);
		var _mag_y = random_range(-1000, 1000);
		var _pot_x = smooth_move_get_x_if_moved_by_magnitudes(_potential, _mag_x, _mag_y);
		var _pot_y = smooth_move_get_y_if_moved_by_magnitudes(_potential, _mag_x, _mag_y);
		smooth_move_by_magnitudes(_potential, _mag_x, _mag_y);
		test_smooth_move_assert_real(_pot_x, smooth_move_get_x(_potential), "Smooth move potential position x fail!");
		test_smooth_move_assert_real(_pot_y, smooth_move_get_y(_potential), "Smooth move potential position y fail!");
	}
	
	// potential positions (with vectors)
	smooth_move_set_position(_potential, 0, 0);
	var _angle_test = 0;
	var _vel_test = 0;
	for (var _i = 0; _i < 1000; _i++) {
		_angle_test += random_range(-0.05, 0.05);
		_vel_test = random_range(0.2, 2);
		var _pot_x = smooth_move_get_x_if_moved_by_vector(_potential, _angle_test, _vel_test);
		var _pot_y = smooth_move_get_y_if_moved_by_vector(_potential, _angle_test, _vel_test);
		smooth_move_by_vector(_potential, _angle_test, _vel_test);
		test_smooth_move_assert_real(_pot_x, smooth_move_get_x(_potential), "Smooth move potential position x fail!");
		test_smooth_move_assert_real(_pot_y, smooth_move_get_y(_potential), "Smooth move potential position y fail!");
	}
}

function __test_smoothmove_stairsteps() {
	// stairsteps
	// moving along the same line, stairsteps should never occur (more than 1 y for an x when inferring y from x)
	
	var _real_x = 0;
	var _real_y = 0;
	
	var _sm = new SmoothMove(0, 0);
	var _positions = ds_map_create();
	for (var _i = 0; _i < 100; _i++) {
		ds_map_clear(_positions);
		smooth_move_set_position(_sm, 0, 0);
		var _stair_x = smooth_move_get_x(_sm);
		var _stair_y = smooth_move_get_y(_sm);
		ds_map_set(_positions, _stair_x, _stair_y);
		// start with random offset
		smooth_move_by_vector(_sm, random_range(0.001, pi/4), random_range(0.001, 1));
		_stair_x = smooth_move_get_x(_sm);
		_stair_y = smooth_move_get_y(_sm);
		ds_map_set(_positions, _stair_x, _stair_y);
		// choose line and move along it
		var _angle = random_range(0.001, pi/4);
		var _vel = random_range(0.05, 1);
		for (var _k = 0; _k < 100; _k++) {
			smooth_move_by_vector(_sm, _angle, _vel);
			_stair_x = smooth_move_get_x(_sm);
			_stair_y = smooth_move_get_y(_sm);
			_real_x = _sm.get_vector_x();
			_real_y = _sm.get_vector_y();
			if (ds_map_exists(_positions, _stair_x) && ds_map_find_value(_positions, _stair_x) != _stair_y) {
				show_error($"Smooth move stair step test fail on line {_i}. Y of {ds_map_find_value(_positions, _stair_x)} and {_stair_y} for x: {_stair_x}.", true);
			}
			ds_map_set(_positions, _stair_x, _stair_y);
		}
	}	
}

function __test_smoothmove_misc() {
	// angle diff
	var _angles = new SmoothMove(0, 0);
	test_smooth_move_assert_real(_angles.get_angle_diff(7*pi/4, 1*pi/4), 2*pi/4, "Smooth move angle check fail!");
	test_smooth_move_assert_real(_angles.get_angle_diff(7*pi/4, 0*pi/4), 1*pi/4, "Smooth move angle check fail!");
	test_smooth_move_assert_real(_angles.get_angle_diff(6*pi/4, 1*pi/4), 3*pi/4, "Smooth move angle check fail!");
	test_smooth_move_assert_real(_angles.get_angle_diff(1*pi/4, 2*pi/4), 1*pi/4, "Smooth move angle check fail!");
}

// @ignore
function __test_smoothmove(){
	__test_smoothmove_cardinals();
	__test_smoothmove_perfect_diagonals();
	__test_smoothmove_pixel_gaps();
	__test_smoothmove_positions();
	//__test_smoothmove_stairsteps();
	__test_smoothmove_misc();
}

if (true) __test_smoothmove();
