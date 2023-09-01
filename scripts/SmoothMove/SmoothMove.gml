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
	vector_angle = 0;
	vector_magnitude = 0;
	movements = 0; // number of times instance has moved by vector
	
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
	 * Returns the give value rounded whichever direction is closest to 0.
	 */
	function round_to_zero(_value) {
		return _value > 0 ? floor(_value) : ceil(_value);
	}
	
	function round_to_thousandths(_value) {
		var _result = floor(_value * 1000 + 0.5) / 1000;
		return _result;
	}
	
	/**
	 * Get the real x position of this SmoothMove derived from movements and vector magnitude.
	 */
	get_x_from_movements = function() {
		var _x_magnitude = smooth_move_get_vector_magnitude_x(self);
		return round_to_zero(start_x + _x_magnitude * movements);
	};
	
	/**
	 * Get the real y position of this SmoothMove derived from movements and vector magnitude.
	 */
	get_y_from_movements = function() {
		var _y_magnitude = smooth_move_get_vector_magnitude_y(self);
		return round_to_zero(start_y + _y_magnitude * movements);
	}
}

/**
 * Get the x magnitude of the vector of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move
 */
function smooth_move_get_vector_magnitude_x(_smooth_move) {
	with (_smooth_move) {
		var _unit_magnitude = snap_sin(vector_angle);
		return round_to_thousandths(_unit_magnitude * vector_magnitude);
	}
}

/**
 * Get the y magnitude of the vector of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move
 */
function smooth_move_get_vector_magnitude_y(_smooth_move) {
	with (_smooth_move) {
		var _unit_magnitude = snap_cos(vector_angle) * -1;
		return round_to_thousandths(_unit_magnitude * vector_magnitude);
	}
}

/**
 * Get the current x position of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move
 */
function smooth_move_get_x(_smooth_move) {
	with (_smooth_move) {
		if (vector_magnitude == 0) return start_x;
		var _rise = smooth_move_get_vector_magnitude_y(self);
		var _run = smooth_move_get_vector_magnitude_x(self);
		if (abs(_run) >= abs(_rise)) return get_x_from_movements();
		
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
		if (vector_magnitude == 0) return start_y;
		var _rise = smooth_move_get_vector_magnitude_y(self);
		var _run = smooth_move_get_vector_magnitude_x(self);
		if (abs(_run) < abs(_rise)) return get_y_from_movements();
		
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
	_smooth_move.movements += 1;
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
		if (_angle == vector_angle && _magnitude == vector_magnitude) return;
		start_x = smooth_move_get_x(self);
		start_y = smooth_move_get_y(self);
		vector_angle = _angle;
		vector_magnitude = _magnitude;
		movements = 0;
	}
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
