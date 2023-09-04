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
	angle = 0;
	delta = 0;
	
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
	 * SmoothMove works by inferring x and y positions based off the 2D vector it's moved by.
	 * This function returns true if the x magnitude of the vector is greater than the y
	 * magnitude, indicating that the y position should be inferred from the x position.
	 * Returns false if the reverse is true.
	 *
	 */
	infer_y_from_x = function() {
		return (angle <= 1*pi/4 || angle >= 7*pi/4 || (angle >= 3*pi/4 && angle <= 5*pi/4));
	};
	
	/**
	 * Get the slope to be used to infer an x or y position. The slope changes depending on
	 * whether the x or y magnitude of the 2D vector is greater.
	 */
	slope = function() {
		return infer_y_from_x() ? get_magnitude_y() / get_magnitude_x() : get_magnitude_x() / get_magnitude_y();
	}
	
	get_magnitude_x = function() {
		var _cos_value = snap_cos(angle);
		var _result = _cos_value * delta;
		return _result;
	}
	
	get_magnitude_y = function() {
		var _sin_value = snap_sin(angle);
		var _result = _sin_value * delta
		return _result;
	};
}

/**
 * Get the current x position of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move
 */
function smooth_move_get_x(_smooth_move) {
	with (_smooth_move) {
		if (delta == 0) return start_x;
		if (infer_y_from_x()) {
			var _change = round_to_zero(get_magnitude_x());
			var _result = start_x + _change;
			return _result;
		}
		
		// derive x position from linear line function of y
		var _slope = slope();
		var _y_diff = smooth_move_get_y(self) - start_y;
		var _x = round_to_zero(_slope * _y_diff) + start_x;
		return _x;
	}
}

/**
 * Get the current y position of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move
 */
function smooth_move_get_y(_smooth_move) {
	with(_smooth_move) {
		if (delta == 0) return start_y;
		if (!infer_y_from_x()) {
			var _change = round_to_zero(get_magnitude_y());
			var _result = start_y + _change;
			return _result;
		}
		
		// derive y position from linear line function of x
		var _slope = slope();
		var _x_diff = smooth_move_get_x(self) - start_x;
		var _y = round_to_zero(_slope * _x_diff) + start_y;
		return _y;
	}
}

/**
 * Increments the given SmoothMove instance along its current vector.
 *
 * @param {Struct.SmoothMove} _smooth_move 
 */
function smooth_move_advance(_smooth_move, _magnitude) {
	with (_smooth_move) {
		delta = _magnitude == 0 ? 0 : delta + _magnitude;
	}
}



/**
 * Set the vector of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move 
 * @param {real} _angle new vector angle in radians
 */
function smooth_move_set_angle(_smooth_move, _angle) {
	with (_smooth_move) {
		while (_angle < 0) _angle += (2 * pi);
		angle = _angle
	}
}

/**
 * @param {Struct.SmoothMove} _smooth_move
 * @param {real} _magnitude_x
 * @param {real} _magnitude_y
 */
function smooth_move_by_magnitudes(_smooth_move, _magnitude_x, _magnitude_y) {
	with (_smooth_move) {
		// angle of 0 corresponds to straight along positive x axis
		
		if (_magnitude_x == 0) return _magnitude_y >= 0 ? pi/2 : 3*pi/2;
	
		var _angle = arctan2(_magnitude_y, _magnitude_x);
	
		smooth_move_set_angle(_smooth_move, _angle);
		smooth_move_advance(_smooth_move, sqrt(sqr(_magnitude_x) + sqr(_magnitude_y)));
	
	}
}

/**
 * @param {Struct.SmoothMove} _smooth_move
 * @param {real} _angle angle of vector in radians
 * @param {real} _magnitude magnitude of vector
 */
function smooth_move_by_vector(_smooth_move, _angle, _magnitude) {
	smooth_move_set_angle(_smooth_move, _angle);
	smooth_move_advance(_smooth_move, _magnitude);
}

