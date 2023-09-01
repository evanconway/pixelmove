/**
 * An object that uses a linear algorithm to derive its position. This
 * ensures that any position changes appear smooth and consistent.
 * 
 * @param {real} _x starting x position
 * @param {real} _y starting y position
 */
function SmoothMove(_x, _y) constructor {
	start_x = floor(_x + 0.5);
	start_y = floor(_y + 0.5);
	magnitude_x = 0;
	magnitude_y = 0;
	distance_x = 0;
	distance_y = 0;
	
	/**
	 * Rounds given value to 0 if it's already close. This is mostly to deal
	 * with sin and cos not returning a perfect 0 on certain values.
	 *
	 * @param {real} _value
	 */
	function snap_to_zero(_value) {
		return abs(_value) < 0.001 ? 0 : _value;
	};
	
	/**
	 * Wrapper function around sin that snaps the result to 0 if it's within 0.001 of 0.
	 *
	 * @param {real} _angle angle in radians
	 */
	function snap_sin(_angle) {
		return snap_to_zero(sin(_angle));
	}
	
	/**
	 * Wrapper function around cos that snaps the result to 0 if it's within 0.001 of 0.
	 *
	 * @param {real} _angle angle in radians
	 */
	function snap_cos(_angle) {
		return snap_to_zero(cos(_angle));
	}
	
	/**
	 * @param {real} _value
	 */
	function round_to_thousandths(_value) {
		var _result = floor(_value * 1000 + 0.5) / 1000;
		return _result;
	}
	
	/**
	 * Returns the give value rounded whichever direction is closest to 0.
	 */
	function round_to_zero(_value) {
		if (_value == 0) return 0;
		_value = round_to_thousandths(_value);
		return _value > 0 ? floor(_value) : ceil(_value);
	}
	
	/**
	 * Get the magnitude of the vector resulting from the x and y magnitudes.
	 */
	get_vector_magnitude = function() {
		return round_to_thousandths(sqrt(sqr(magnitude_x) + sqr(magnitude_y)));
	}
	
	// feather ignore once all
	toString = function() {
		return $"start_x: {start_x}\n start_y: {start_y}\n magnitude_x: {magnitude_x}\n magnitude_y: {magnitude_y}\n distance_x: {distance_x}\n distance_y: {distance_y}\n x: {smooth_move_get_x(self)}\n y: {smooth_move_get_y(self)}";
	}
}

/**
 * Get the x magnitude of the vector of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move
 */
function smooth_move_get_vector_magnitude_x(_smooth_move) {
	return _smooth_move.magnitude_x;
}

/**
 * Get the y magnitude of the vector of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move
 */
function smooth_move_get_vector_magnitude_y(_smooth_move) {
	return _smooth_move.magnitude_y;
}

/**
 * Get the current x position of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move
 */
function smooth_move_get_x(_smooth_move) {
	with (_smooth_move) {
		if (get_vector_magnitude() == 0) return start_x;
		var _rise = smooth_move_get_vector_magnitude_y(self);
		var _run = smooth_move_get_vector_magnitude_x(self);
		if (abs(_run) >= abs(_rise)) {
			var _change = round_to_zero(distance_x)
			var _result = start_x + _change;
			return _result;
		}
		
		// derive x position from linear line function of y
		var _slope = _run/_rise;
		var _y_diff = smooth_move_get_y(self) - start_y;
		var _x = (_slope * _y_diff) + start_x;
		return round_to_zero(_x);
	}
}

/**
 * Get the current y position of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move
 */
function smooth_move_get_y(_smooth_move) {
	with(_smooth_move) {
		if (get_vector_magnitude() == 0) return start_y;
		var _rise = smooth_move_get_vector_magnitude_y(self);
		var _run = smooth_move_get_vector_magnitude_x(self);
		if (abs(_run) < abs(_rise)) {
			var _change = round_to_zero(distance_y)
			var _result = start_y + _change;
			return _result;
		}
		
		// derive y position from linear line function of x
		var _slope = _rise/_run;
		var _x_diff = smooth_move_get_x(self) - start_x;
		var _y = (_slope * _x_diff) + start_y;
		return round_to_zero(_y);
	}
}

/**
 * Increments the given SmoothMove instance along its current vector.
 *
 * @param {Struct.SmoothMove} _smooth_move 
 */
function smooth_move_advance(_smooth_move) {
	with (_smooth_move) {
		distance_x += magnitude_x;
		distance_y += magnitude_y;
	}
}

/**
 * Sets the x and y magnitudes of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move
 * @param {real} _magnitude_x
 * @param {real} _magnitude_y
 */
function smooth_move_set_xy_magnitudes(_smooth_move, _magnitude_x, _magnitude_y) {
	with (_smooth_move) {
		if (_magnitude_x == magnitude_x && _magnitude_y == magnitude_y) return;
		var _x = smooth_move_get_x(self);
		var _y = smooth_move_get_y(self);
		start_x = _x;
		start_y = _y;
		distance_x -= round_to_zero(distance_x);
		distance_y -= round_to_zero(distance_y);
		magnitude_x = _magnitude_x;
		magnitude_y = _magnitude_y;
	}
}

/**
 * Set the vector of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move 
 * @param {real} _angle new vector angle in radians
 * @param {real} _magnitude new vector magnitude
 */
function smooth_move_set_vector(_smooth_move, _angle, _magnitude) {
	while (_angle < 0) _angle += 2*pi;	
	with (_smooth_move) {
		var _magnitude_x = snap_sin(_angle) * _magnitude;
		var _magnitude_y = snap_cos(_angle) * _magnitude * -1;
		smooth_move_set_xy_magnitudes(self, _magnitude_x, _magnitude_y);
	}
}

/**
 * @param {Struct.SmoothMove} _smooth_move
 * @param {real} _magnitude_x
 * @param {real} _magnitude_y
 */
function smooth_move_by_magnitudes(_smooth_move, _magnitude_x, _magnitude_y) {
	smooth_move_set_xy_magnitudes(_smooth_move, _magnitude_x, _magnitude_y);
	smooth_move_advance(_smooth_move);
}

/**
 * @param {Struct.SmoothMove} _smooth_move
 * @param {real} _angle angle of vector in radians
 * @param {real} _magnitude magnitude of vector
 */
function smooth_move_by_vector(_smooth_move, _angle, _magnitude) {
	smooth_move_set_vector(_smooth_move, _angle, _magnitude);
	smooth_move_advance(_smooth_move);
}
