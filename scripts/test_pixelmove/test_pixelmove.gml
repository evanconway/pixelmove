/**
 * Assert function for testing real numbers in this package.
 *
 * @param {real} _value
 * @param {real} _expected
 * @ignore
 */
function __test_pixel_move_assert_real(_value, _expected, _msg = "Pixel move test fail!") {
	if (!is_real(_value)) show_error(_msg + $"\n Value {_value} is not a real.", true);
	if (!is_real(_expected)) show_error(_msg + $"\n Expected {_expected} is not a real.", true);
	if (is_nan(_value)) show_error(_msg + $"\n Value {_value} is not a real.", true);
	if (is_nan(_expected)) show_error(_msg + $"\n Expected {_expected} is not a real.", true);
	if (_value != _expected) show_error(_msg + $"\n Expected {_expected} got {_value}.", true);
}

/**
 * @param {string} _test_name
 * @ignore
 */
function __test_pixel_move_show_test_message(_test_name) {
	show_debug_message("Pixel move testing " + _test_name + "...");
}

/**
 * Confirm component function is consistent with itself.
 *
 * @ignore
 */
function __test_pixelmove_components() {
	__test_pixel_move_show_test_message("Component Function");
	
	for (var _i = 0 ; _i < 1000; _i++) {
		var _angle = random(2*pi);
		var _vel = 1;
		var _delta = 0;
		var _check_x = 0;
		var _check_y = 0
		for (var _k = 0; _k < 100; _k ++) {
			_delta += 1;
			_check_x += __pixelmove_util_get_x_component(_angle, _vel);
			_check_y += __pixelmove_util_get_y_component(_angle, _vel);
		}
		
		var _component_x = __pixelmove_util_get_x_component(_angle, _delta);
		var _component_y = __pixelmove_util_get_y_component(_angle, _delta);
		
		__test_pixel_move_assert_real(_check_x, _component_x, "Pixel move compoment x fail!");
		__test_pixel_move_assert_real(_check_y, _component_y, "Pixel move compoment x fail!");
	}
	
	show_debug_message("test complete");
}

/**
 * Check that real tracking from line data is close enough to tracking by changing reals.
 *
 * @ignore
 */
function __test_pixelmove_real_stays_true() {
	__test_pixel_move_show_test_message("Real Position");
	
	var _pm = new PixelMove(0, 0);
	pixel_move_set_movement_type_smooth(_pm);
	var _position_x = 0;
	var _position_y = 0;
	for (var _i = 0; _i < 10000; _i++) {	
		var _angle = random(2*pi);
		var _vel = random_range(0.01, 1);
		var _frames = irandom(20);
		for (var _f = 0; _f < _frames; _f++) {
			pixel_move_by_vector(_pm, _angle, _vel);
			_position_x += __pixelmove_util_get_x_component(_angle, _vel);
			_position_y += __pixelmove_util_get_y_component(_angle, _vel);
			var _real_x = _pm.get_real_x();
			var _real_y = _pm.get_real_y();
			__test_pixel_move_assert_real(_position_x, _real_x, $"Pixel move real position x fail movement {_i} frame {_f}. Expected {_position_x} got {_real_x}");
			__test_pixel_move_assert_real(_position_y, _real_y, $"Pixel move real position y fail movement {_i} frame {_f}. Expected {_position_y} got {_real_y}");
		}
	}
	show_debug_message("test complete");
}

/**
 * @param {bool} _show_stairsteps
 * @ignore
 */
function __test_pixelmove_cardinals() {
	__test_pixel_move_show_test_message("Cardinal Directions");
	var _move_count = 1000;
	
	// north
	var _n = new PixelMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		pixel_move_by_vector(_n, 6*pi/4, 1);
	}
	__test_pixel_move_assert_real(pixel_move_get_x(_n), 0, "Pixel move north test 1 x fail!");
	__test_pixel_move_assert_real(pixel_move_get_y(_n), -1000, "Pixel move north test 1 y fail!");
	pixel_move_by_vector(_n, 0, 0);
	__test_pixel_move_assert_real(pixel_move_get_x(_n), 0, "Pixel move north test 2 x fail!");
	__test_pixel_move_assert_real(pixel_move_get_y(_n), -1000, "Pixel move north test 2 y fail!");
	
	// south
	var _s = new PixelMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		pixel_move_by_vector(_s, 2*pi/4, 1);
	}
	__test_pixel_move_assert_real(pixel_move_get_x(_s), 0, "Pixel move south test 1 x fail!");
	__test_pixel_move_assert_real(pixel_move_get_y(_s), 1000, "Pixel move south test 1 y fail!");
	pixel_move_by_vector(_s, 0, 0);
	__test_pixel_move_assert_real(pixel_move_get_x(_s), 0, "Pixel move south test 2 x fail!");
	__test_pixel_move_assert_real(pixel_move_get_y(_s), 1000, "Pixel move south test 2 y fail!");
	
	// east
	var _e = new PixelMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		pixel_move_by_vector(_e, 0*pi/4, 1);
	}
	__test_pixel_move_assert_real(pixel_move_get_x(_e), 1000, "Pixel move east test 1 x fail!");
	__test_pixel_move_assert_real(pixel_move_get_y(_e), 0, "Pixel move east test 1 y fail!");
	pixel_move_by_vector(_e, 0, 0);
	__test_pixel_move_assert_real(pixel_move_get_x(_e), 1000, "Pixel move east test 2 x fail!");
	__test_pixel_move_assert_real(pixel_move_get_y(_e), 0, "Pixel move east test 2 y fail!");
	
	// west
	var _w = new PixelMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		pixel_move_by_vector(_w, 4*pi/4, 1);
	}
	__test_pixel_move_assert_real(pixel_move_get_x(_w), -1000, "Pixel move west test 1 x fail!");
	__test_pixel_move_assert_real(pixel_move_get_y(_w), 0, "Pixel move west test 1 y fail!");
	pixel_move_by_vector(_w, 0, 0);
	__test_pixel_move_assert_real(pixel_move_get_x(_w), -1000, "Pixel move west test 2 x fail!");
	__test_pixel_move_assert_real(pixel_move_get_y(_w), 0, "Pixel move west test 2 y fail!");
	
	// north east
	var _ne = new PixelMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		pixel_move_by_vector(_ne, 7*pi/4, 1);
	}
	__test_pixel_move_assert_real(pixel_move_get_x(_ne), 707, "Pixel move north east test 1 x fail!");
	__test_pixel_move_assert_real(pixel_move_get_y(_ne), -707, "Pixel move north east test 1 y fail!");
	pixel_move_by_vector(_ne, 0, 0);
	__test_pixel_move_assert_real(pixel_move_get_x(_ne), 707, "Pixel move north east test 2 x fail!");
	__test_pixel_move_assert_real(pixel_move_get_y(_ne), -707, "Pixel move north east test 2 y fail!");
	
	// north west
	var _nw = new PixelMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		pixel_move_by_vector(_nw, 5*pi/4, 1);
	}
	__test_pixel_move_assert_real(pixel_move_get_x(_nw), -707, "Pixel move north west test 1 x fail!");
	__test_pixel_move_assert_real(pixel_move_get_y(_nw), -707, "Pixel move north west test 1 y fail!");
	pixel_move_by_vector(_nw, 0, 0);
	__test_pixel_move_assert_real(pixel_move_get_x(_nw), -707, "Pixel move north west test 2 x fail!");
	__test_pixel_move_assert_real(pixel_move_get_y(_nw), -707, "Pixel move north west test 2 y fail!");
	
	// south east
	var _se = new PixelMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		pixel_move_by_vector(_se, 1*pi/4, 1);
	}
	__test_pixel_move_assert_real(pixel_move_get_x(_se), 707, "Pixel move south east test 1 x fail!");
	__test_pixel_move_assert_real(pixel_move_get_y(_se), 707, "Pixel move south east test 1 y fail!");
	pixel_move_by_vector(_se, 0, 0);
	__test_pixel_move_assert_real(pixel_move_get_x(_se), 707, "Pixel move south east test 2 x fail!");
	__test_pixel_move_assert_real(pixel_move_get_y(_se), 707, "Pixel move south east test 2 y fail!");
	
	// south west
	var _sw = new PixelMove(0, 0);
	for (var _i = 0; _i < _move_count; _i++) {
		pixel_move_by_vector(_sw, 3*pi/4, 1);
	}
	__test_pixel_move_assert_real(pixel_move_get_x(_sw), -707, "Pixel move south west test 1 x fail!");
	__test_pixel_move_assert_real(pixel_move_get_y(_sw), 707, "Pixel move south west test 1 y fail!");
	pixel_move_by_vector(_sw, 0, 0);
	__test_pixel_move_assert_real(pixel_move_get_x(_sw), -707, "Pixel move south west test 2 x fail!");
	__test_pixel_move_assert_real(pixel_move_get_y(_sw), 707, "Pixel move south west test 2 y fail!");
	
	show_debug_message("test complete");
}

/**
 * @param {bool} _show_stairsteps
 * @ignore
 */
function __test_pixelmove_perfect_diagonals() {
	__test_pixel_move_show_test_message("Perfect Diagonals");
	
	// @param {real} _mag
	var _test_perfect_diagonals = function(_mag) {
		var _func = function(_mag_x, _mag_y) {
			var _sm = new PixelMove(0, 0);
			pixel_move_set_movement_type_line(_sm);
			for (var _i = 0; _i < 1000; _i++) {
				var _check_x = pixel_move_get_x(_sm);
				var _check_y = pixel_move_get_y(_sm);
				pixel_move_by_magnitudes(_sm, _mag_x, _mag_y);
				var _x_after_move = pixel_move_get_x(_sm);
				var _y_after_move = pixel_move_get_y(_sm);
				var _divider = 1 / abs(_mag_x);
				if ((_i + 1) % _divider == 0) {
					__test_pixel_move_assert_real(_x_after_move, _check_x + sign(_mag_x), $"Pixel diagonal test {_mag_x} x fail!");
					__test_pixel_move_assert_real(_y_after_move, _check_y + sign(_mag_y), $"Pixel diagonal test {_mag_y} y fail!");
				} else {
					__test_pixel_move_assert_real(_x_after_move, _check_x, $"Pixel diagonal test {_mag_x} x fail!");
					__test_pixel_move_assert_real(_y_after_move, _check_y, $"Pixel diagonal test {_mag_y} y fail!");
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
	show_debug_message("test complete");
}

/**
 * @ignore
 */
function __test_pixelmove_pixel_gaps() {
	__test_pixel_move_show_test_message("No Pixel Gaps");
	// pixel gaps and error correction
	var _random = new PixelMove(0, 0);
	pixel_move_set_movement_type_smooth(_random);
	
	// there should never be a gap while showing stair steps and vector magnitude is 1
	show_debug_message("move by random angle changes");
	var _angle = 0;
	var _last_x = pixel_move_get_x(_random);
	var _last_y = pixel_move_get_y(_random);
	for (var _i = 0; _i < 50000; _i++) {
		var _frames = irandom_range(1, 20);
		_angle += random_range(-pi/8, pi/8);
		for (var _f = 0; _f < _frames; _f++) {
			pixel_move_by_vector(_random, _angle, 1);
			var _curr_x = pixel_move_get_x(_random);
			var _curr_y = pixel_move_get_y(_random);
			if (point_distance(_last_x, _last_y, _curr_x, _curr_y) > sqrt(2)) {
				show_error($"Pixel move random movement failed move {_i} frame {_f}. Delta greater than sqrt(2) from ({_last_x}, {_last_y})  to ({_curr_x}, {_curr_y})", true);
			}
			_last_x = _curr_x;
			_last_y = _curr_y;
		}
	}
	
	show_debug_message("move by random cardinal or intermediate");
	pixel_move_set_movement_type_line(_random);
	pixel_move_set_position(_random, 0, 0);
	var _angle_options = [0*pi/4, 1*pi/4, 2*pi/4, 3*pi/4, 4*pi/4, 5*pi/4, 6*pi/4, 7*pi/4];
	_angle = 0;
	_last_x = pixel_move_get_x(_random);
	_last_y = pixel_move_get_y(_random);
	for (var _i = 0; _i < 50000; _i++) {
		var _frames = random_range(1, 15);
		_angle = _angle_options[irandom_range(0, 7)];
		for (var _f = 0; _f < _frames; _f++) {
			pixel_move_by_vector(_random, _angle, 1);
			var _curr_x = pixel_move_get_x(_random);
			var _curr_y = pixel_move_get_y(_random);
			if (point_distance(_last_x, _last_y, _curr_x, _curr_y) > sqrt(2)) {
				show_error($"Pixel move random cardinal/intermediate movement failed move {_i} frame {_f}. Delta greater than sqrt(2) from ({_last_x}, {_last_y})  to ({_curr_x}, {_curr_y})", true);
			}
			_last_x = _curr_x;
			_last_y = _curr_y;
		}
	}
	
	show_debug_message("test complete");
}

/**
 * @param {bool} _show_stairsteps
 * @ignore
 */
function __test_pixelmove_positions() {
	__test_pixel_move_show_test_message("Set and Potential Position");
	
	// set position
	var _set_pos = new PixelMove(0, 0);
	for (var _i = 0; _i < 1000; _i++) {
		var _x = irandom_range(-10000, 10000);
		var _y = irandom_range(-10000, 10000);
		pixel_move_set_position(_set_pos, _x, _y);
		__test_pixel_move_assert_real(pixel_move_get_x(_set_pos), _x, "Pixel move set position x fail.");
		__test_pixel_move_assert_real(pixel_move_get_y(_set_pos), _y, "Pixel move set position y fail.");
	}
	
	// potential positions
	var _potential = new PixelMove(0, 0);
	pixel_move_set_position(_potential, 0, 0);
	var _angle_test = 0;
	var _vel_test = 0;
	var _pot_pos = { x: 0, y: 0 };
	var _against_callback = function() {
		return false;
	};
	for (var _i = 0; _i < 4000; _i++) {
		_angle_test += random_range(-0.05, 0.05);
		_vel_test = random_range(0.2, 2);
		var _mag_x = __pixelmove_util_get_x_component(_angle_test, _vel_test);
		var _mag_y = __pixelmove_util_get_x_component(_angle_test, _vel_test);
		var _move_type = irandom_range(0, 2);
		if (_move_type == 0) pixel_move_set_movement_type_line(_potential);
		if (_move_type == 1) pixel_move_set_movement_type_smooth(_potential);
		if (_move_type == 2) pixel_move_set_movement_type_hybrid(_potential);
		var _move_equation = irandom_range(0, 3);
		if (_move_equation == 0) {
			_pot_pos = pixel_move_get_position_if_moved_by_vector(_potential, _angle_test, _vel_test);
			pixel_move_by_vector(_potential, _angle_test, _vel_test);
		} else if (_move_equation == 1) {
			_pot_pos = pixel_move_get_position_if_moved_by_magnitudes(_potential, _mag_x, _mag_y);
			pixel_move_by_magnitudes(_potential, _mag_x, _mag_y);
		} else if (_move_equation == 2) {
			_pot_pos = pixel_move_get_position_if_moved_by_vector_against(_potential, _angle_test, _vel_test, _against_callback);
			pixel_move_by_vector_against(_potential, _angle_test, _vel_test, _against_callback);
		} else if (_move_equation == 3) {
			_pot_pos = pixel_move_get_position_if_moved_by_magnitudes_against(_potential, _mag_x, _mag_y, _against_callback);
			pixel_move_by_magnitudes_against(_potential, _mag_x, _mag_y, _against_callback);
		}
		__test_pixel_move_assert_real(_pot_pos.x, pixel_move_get_x(_potential), $"Pixel move potential position x failed attempt {_i}");
		__test_pixel_move_assert_real(_pot_pos.y, pixel_move_get_y(_potential), $"Pixel move potential position y failed attempt {_i}.");
	}
	show_debug_message("test complete");
}

/**
 * @param {bool} _show_stairsteps
 * @ignore
 */
function __test_pixelmove_stairsteps() {
	__test_pixel_move_show_test_message("No Stairsteps On Lines");
	
	// stairsteps
	// moving along the same line, stairsteps should never occur (more than 1 y for an x when inferring y from x)
	
	var _sm = new PixelMove(0, 0);
	pixel_move_set_hybrid_movements_on_angle_to_infer_from_line(_sm, 0);
	var _positions = ds_map_create();
	for (var _i = 0; _i < 100; _i++) {
		
		// setup starting position
		ds_map_clear(_positions);
		pixel_move_set_position(_sm, 0, 0);
		var _stair_x = pixel_move_get_x(_sm);
		var _stair_y = pixel_move_get_y(_sm);
		ds_map_set(_positions, _stair_x, _stair_y);

		// choose line and move along it
		var _angle = random_range(0.001, pi/4);
		var _vel = random_range(0.05, 1);
		for (var _k = 0; _k < 100; _k++) {
			pixel_move_by_vector(_sm, _angle, _vel);
			_stair_x = pixel_move_get_x(_sm);
			_stair_y = pixel_move_get_y(_sm);
			if (ds_map_exists(_positions, _stair_x) && ds_map_find_value(_positions, _stair_x) != _stair_y) {
				show_error($"Pixel move stair step test fail on line {_i}. Y of {ds_map_find_value(_positions, _stair_x)} and {_stair_y} for x: {_stair_x}.", true);
			}
		}
	}
	
	show_debug_message("test complete");
}

/**
 * @ignore
 */
function __test_pixelmove_stairsteps_on_cardinalintermediates() {
	show_debug_message("No Stairsteps On Cardinal Intermediates");
	
	var _sm = new PixelMove(0, 0);
	var _angle_options = [1*pi/4, 3*pi/4, 5*pi/4, 7*pi/4];
	var _angle = 0;
	var _vel = 0;
	var _prev2_x = pixel_move_get_x(_sm);
	var _prev2_y = pixel_move_get_y(_sm);
	var _prev1_x = pixel_move_get_x(_sm);
	var _prev1_y = pixel_move_get_y(_sm);
	var _curr_x = pixel_move_get_x(_sm);
	var _curr_y = pixel_move_get_y(_sm);
	
	for (var _i = 0; _i < 1000; _i++) {
		var _frames = random_range(2, 15);
		_angle = _angle_options[irandom_range(0, 3)];
		_vel = random_range(0.1, 1);
		for (var _f = 0; _f < _frames; _f++) {
			_prev2_x = _prev1_x;
			_prev2_y = _prev1_y;
			_prev1_x = _curr_x;
			_prev1_y = _curr_y;
			pixel_move_by_vector(_sm, _angle, _vel);
			_curr_x = pixel_move_get_x(_sm);
			_curr_y = pixel_move_get_y(_sm);
			var _dist12 = sqrt(sqr(_prev2_x - _prev1_x) + sqr(_prev2_y - _prev1_y));
			var _dist23 = sqrt(sqr(_prev1_x - _curr_x) + sqr(_prev1_y - _curr_y));
			var _dist13 = sqrt(sqr(_prev2_x - _curr_x) + sqr(_prev2_y - _curr_y));
			if (_dist12 == 1 && _dist23 == 1 && _dist13 == sqrt(2)) {
				show_error($"Pixel move random cardinal/intermediate movement failed movement {_i}. Stair step at ({_prev2_x}, {_prev2_y})-({_prev1_x}, {_prev1_y})-({_curr_x}, {_curr_y})", true);
			}
		}
	}
}

/**
 * @ignore
 */
function __test_pixelmove_misc() {
	show_debug_message("Miscellaneous");
	
	// angle diff
	__test_pixel_move_assert_real(__pixelmove_util_get_angle_diff(7*pi/4, 1*pi/4), 2*pi/4, "Pixel move angle check fail!");
	__test_pixel_move_assert_real(__pixelmove_util_get_angle_diff(7*pi/4, 0*pi/4), 1*pi/4, "Pixel move angle check fail!");
	__test_pixel_move_assert_real(__pixelmove_util_get_angle_diff(6*pi/4, 1*pi/4), 3*pi/4, "Pixel move angle check fail!");
	__test_pixel_move_assert_real(__pixelmove_util_get_angle_diff(1*pi/4, 2*pi/4), 1*pi/4, "Pixel move angle check fail!");
	show_debug_message("test complete");
}

/**
 * Ensures that when moving by vectors that should only result in one direction changes along an axis,
 * the calculated value on that axis never jumps back.
 *
 * @param {bool} _show_stairsteps
 * @ignore
 */
function __test_pixelmove_always_increase() {
	__test_pixel_move_show_test_message("No Stairsteps On Lines");
	
	var _sm = new PixelMove(0, 0);
	pixel_move_set_movement_type_smooth(_sm);
	var _x = pixel_move_get_x(_sm);
	var _y = pixel_move_get_y(_sm);

	// test x axis increase
	var _vel = 0.13;

	/**
	 * @param {real} _old
	 * @param {real} _new
	 */
	var _assert_only_increased = function(_old, _new) {
		if (_new < _old) show_error($"Pixel move test only increase x fail. X when from {_old} to {_new}.", true);
	}

	for (var _i = 0; _i < 20; _i++) {
		pixel_move_by_vector(_sm, 0, _vel);
		_assert_only_increased(_x, pixel_move_get_x(_sm));
		_x = pixel_move_get_x(_sm);
		_y = pixel_move_get_y(_sm);
	}

	var _angle = 0;
	for (var _i = 0; _i < 60; _i++) {
		pixel_move_by_vector(_sm, _angle, _vel);
		_assert_only_increased(_x, pixel_move_get_x(_sm));
		_x = pixel_move_get_x(_sm);
		_y = pixel_move_get_y(_sm);
		_angle += 0.02
	}

	for (var _i = 0; _i < 1000; _i++) {
		pixel_move_by_vector(_sm, _angle, _vel);
		_assert_only_increased(_x, pixel_move_get_x(_sm));
		_x = pixel_move_get_x(_sm);
		_y = pixel_move_get_y(_sm);
	}
	show_debug_message("test complete");
}

/**
 * @ignore
 */
function __test_pixelmove() {
	__test_pixelmove_components();
	__test_pixelmove_real_stays_true();
	__test_pixelmove_cardinals();
	__test_pixelmove_perfect_diagonals();
	__test_pixelmove_pixel_gaps();
	__test_pixelmove_positions();
	__test_pixelmove_stairsteps();
	__test_pixelmove_always_increase();
	__test_pixelmove_stairsteps_on_cardinalintermediates();
	__test_pixelmove_misc();
}

if (true) __test_pixelmove();
