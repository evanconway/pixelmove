/**
 * SmoothMove uses a linear algorithm to derive its position. This
 * ensures that any position changes appear smooth and consistent.
 * 
 * @param {Real} _x starting x position
 * @param {Real} _y starting y position
 */
function SmoothMove(_x, _y) constructor {
	// @notignore
	start_x = _x;
	// @notignore
	start_y = _y;
	// @notignore
	angle = 0;
	// @notignore
	delta = 0;
	
	// the next 2 positions to occur if moved along the same vector
	anticipated_x = start_x;
	anticipated_y = start_y;
	anticipated_x2 = start_x;
	anticipated_y2 = start_y;
	
	/*
	This data allows for checking between the calculated position following the strict
	linear line algorithm, and what the position would have been if position was
	calculated normally.
	*/
	
	// @notignore
	true_x = start_x;
	// @notignore
	true_y = start_y;
	
	/*
	This is not for calculating x/y position. This is used to track how far this instance
	has travelled along the same angle.
	*/
	delta_on_angle = 0;
	
	// once delta_on_angle has passed this value position will be derived from line equation instead of error
	delta_on_angle_threshold = 7.1;
	
	get_delta_on_angle_passed_threshold = function () {
		return delta_on_angle >= delta_on_angle_threshold;
	};
	
	/**
	 * Get the difference in radians between 2 angles. Both angles must be between 0
	 * and 2*pi radians. Favors the shortest distance. For example using 7*pi/4 and
	 * 1*pi/4 will return a difference of 2*pi/4.
	 * 
	 * @param {real} _a angle a in radians
	 * @param {real} _b angle b in radians
	 * @notignore
	 */
	function get_angle_diff(_a, _b) {
		var _diff1 = abs(_a - _b);
		var _diff2 = 2*pi - _diff1;
		return min(_diff1, _diff2);
	}
	
	/**
	 * Round given value to 0 if it's already close. This is mostly to deal
	 * with sin and cos not returning a perfect 0 on certain values.
	 *
	 * @param {real} _value
	 * @notignore
	 */
	function snap_to_zero(_value) {
		return abs(_value) < 0.001 ? 0 : _value;
	};
	
	/**
	 * Wrapper function around sin that snaps the result to 0 if it's within 0.001 of 0.
	 *
	 * @param {real} _angle angle in radians
	 * @notignore
	 */
	function snap_sin(_angle) {
		return snap_to_zero(sin(_angle));
	}
	
	/**
	 * Wrapper function around cos that snaps the result to 0 if it's within 0.001 of 0.
	 *
	 * @param {real} _angle angle in radians
	 * @notignore
	 */
	function snap_cos(_angle) {
		return snap_to_zero(cos(_angle));
	}
	
	/**
	 * @param {real} _value
	 * @notignore
	 */
	function round_to_thousandths(_value) {
		var _result = floor(_value * 1000 + 0.5) / 1000;
		return _result;
	}
	
	/**
	 * Rounding function to account for gamemaker's imperfect real tracking
	 *
	 * @param {real} _value
	 * @notignore
	 */
	function round_to_correct(_value) {
		var _result = floor(_value * 100000 + 0.5) / 100000;
		return _result;
	}
	
	/**
	 * Return the given angle in radians transformed to the equivalent position and rounded
	 * roughly towards the cardinal directions and their intermediates.
	 *
	 * @param {real} _angle
	 * @notignore
	 */
	function get_cleaned_angle(_angle) {
		if (_angle < 0) _angle = _angle % (-2*pi) + 2*pi;
		if (_angle >= 2*pi) _angle %= 2*pi;
		if (round_to_thousandths(_angle) == round_to_thousandths(0*pi/4)) _angle = 0*pi/4;
		if (round_to_thousandths(_angle) == round_to_thousandths(1*pi/4)) _angle = 1*pi/4;
		if (round_to_thousandths(_angle) == round_to_thousandths(2*pi/4)) _angle = 2*pi/4;
		if (round_to_thousandths(_angle) == round_to_thousandths(3*pi/4)) _angle = 3*pi/4;
		if (round_to_thousandths(_angle) == round_to_thousandths(4*pi/4)) _angle = 4*pi/4;
		if (round_to_thousandths(_angle) == round_to_thousandths(5*pi/4)) _angle = 5*pi/4;
		if (round_to_thousandths(_angle) == round_to_thousandths(6*pi/4)) _angle = 6*pi/4;
		if (round_to_thousandths(_angle) == round_to_thousandths(7*pi/4)) _angle = 7*pi/4;
		return _angle;
	}
	
	/**
	 * Given real _a and real _b, returns _a rounded in the direction of _b. It is possible for 
	 * sign(result - _b) to be different from sign(_a - _b) if _a and _b have the same whole
	 * number value.
	 *
	 * @notignore
	 */
	function round_towards(_a, _b) {
		var _result = (_a - _b) >= 0 ? floor(_a) : ceil(_a);
		return _result == 0 ? 0 : _result; // prevents -0
	}
	
	/**
	 * SmoothMove works by inferring x and y positions based off the 2D vector it's moved by.
	 * This function returns true if the x magnitude of the vector is greater than the y
	 * magnitude, indicating that the y position should be inferred from the x position.
	 * Returns false if the reverse is true.
	 *
	 * @notignore
	 */
	infer_y_from_x = function() {
		return (angle <= 1*pi/4 || angle >= 7*pi/4 || (angle >= 3*pi/4 && angle <= 5*pi/4));
	};
	
	/**
	 * Get the x magnitude given the given angle and delta.
	 *
	 * @notignore
	 */
	get_magnitude_x = function() {
		return snap_cos(angle) * delta;
	}
	
	/**
	 * Get the y magnitude given the current angle and delta.
	 *
	 * @notignore
	 */
	get_magnitude_y = function() {
		return snap_sin(angle) * delta;
	};
	
	/**
	 * Get the x component of the given vector.
	 *
	 * @param {real} _angle
	 * @param {real} _delta
	 * @notignore
	 */
	function get_x_component(_angle, _delta) {
		if (_delta == 0 || _angle == 2*pi/4 || _angle == 6*pi/4) return 0;
		return snap_cos(_angle) * _delta;
	}
	
	/**
	 * Get the y component of the given vector.
	 *
	 * @param {real} _angle
	 * @param {real} _delta
	 * @notignore
	 */
	function get_y_component(_angle, _delta) {
		if (_delta == 0 || _angle == 0 || _angle == 4*pi/4) return 0;
		return snap_sin(_angle) * _delta;
	}
	
	/**
	 * Get the slope to be used to infer an x or y position. The slope changes depending on
	 * whether the x or y magnitude of the 2D vector is greater.
	 *
	 * @notignore
	 */
	slope = function() {
		if (delta == 0) return 0;
		var _result = infer_y_from_x() ? get_magnitude_y() / get_magnitude_x() : get_magnitude_x() / get_magnitude_y();
		return _result;
	}
	
	/**
	 * Reset the start and delta values of this instance.
	 *
	 * @notignore
	 */
	reset = function() {
		var _x = smooth_move_get_x(self);
		var _y = smooth_move_get_y(self);
		start_x = _x;
		start_y = _y;
		delta = 0;
		delta_on_angle = 0;
	};
	
	/**
	 * Get the integer x position derived from the line equation.
	 *
	 * @notignore
	 */
	get_derived_x = function() {
		if (delta == 0) return start_x;
		if (infer_y_from_x()) {
			var _change = get_magnitude_x();
			var _x = round_to_correct(start_x + _change);
			var _result = round_towards(_x, start_x);
			return _result;
		}
		
		// derive x position from linear line function of y
		var _slope = slope();
		var _y_diff = smooth_move_get_y(self) - start_y;
		var _x = round_to_thousandths(_slope * _y_diff + start_x);
		return round_towards(_x, start_x);
	}
	
	/**
	 * Get the integer y position derived from the line equation.
	 *
	 * @notignore
	 */
	get_derived_y = function() {
		if (delta == 0) return start_y;
		if (!infer_y_from_x()) {
			var _change = get_magnitude_y();
			var _y = round_to_correct(start_y + _change);
			var _result = round_towards(_y, start_y);
			return _result;
		}
		
		// derive y position from linear line function of x
		var _slope = slope();
		var _x_diff = smooth_move_get_x(self) - start_x;
		var _y = round_to_thousandths(_slope * _x_diff + start_y);
		return round_towards(_y, start_y);
	}
	
	/**
	 * Get the integer x position derived from the error position.
	 */
	get_round_to_start_x = function() {
		return round_towards(round_to_correct(true_x), start_x);
	};
	
	/**
	 * Get the integer y position derived from the error position.
	 */
	get_round_to_start_y = function() {
		return round_towards(round_to_correct(true_y), start_y);
	};
	
	/**
	 * Move by the given vector. Angle of 0 corresponds to positive x axis
	 *
	 * @param {real} _angle angle of vector in radians
	 * @param {real} _magnitude magnitude of vector
	 */
	move_by_vector = function(_angle, _magnitude) {
		_angle = get_cleaned_angle(_angle);
		var _angle_changed = angle != _angle;
		
		// reset line data on no movement or angle change
		if ((_magnitude == 0) || _angle_changed) reset();
		
		// reset error data on no movement or too great an angle change
		if ((_magnitude == 0) || get_angle_diff(angle, _angle) >= pi/4) {
			true_x = smooth_move_get_x(self);
			true_y = smooth_move_get_y(self);
		}
		
		angle = _angle;
		delta += _magnitude;
		
		// error correct based on true value
		true_x += get_x_component(_angle, _magnitude);
		true_y += get_y_component(_angle, _magnitude);
		var _error = sqrt(sqr(get_round_to_start_x() - smooth_move_get_x(self)) + sqr(get_round_to_start_y() - smooth_move_get_y(self)));
		
		// determine if this movement crossed the delta_on_angle threshold, and new error
		var _threshold_cross_before_delta_on_angle_change = get_delta_on_angle_passed_threshold();
		delta_on_angle += _magnitude;
		var _crossed_delta_line_threshold = get_delta_on_angle_passed_threshold() != _threshold_cross_before_delta_on_angle_change;
		var _post_delta_change_error = sqrt(sqr(get_round_to_start_x() - smooth_move_get_x(self)) + sqr(get_round_to_start_y() - smooth_move_get_y(self)));
		
		// correct line towards error
		if ((!get_delta_on_angle_passed_threshold() && _error >= 1) || (_post_delta_change_error >= 1 && _crossed_delta_line_threshold)) {
			start_x = get_round_to_start_x();
			start_y = get_round_to_start_y();
			delta = 0;
		}
		
		// correct error towards line once passed threshold
		if (get_delta_on_angle_passed_threshold()) {
			true_x = smooth_move_get_x(self);
			true_y = smooth_move_get_y(self);
		}
	};
}

/**
 * Get a copy of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move
 */
function smooth_move_get_copy(_smooth_move) {
	var _copy = new SmoothMove(0, 0);
	_copy.start_x = _smooth_move.start_x;
	_copy.start_y = _smooth_move.start_y;
	_copy.angle = _smooth_move.angle;
	_copy.delta = _smooth_move.delta;
	_copy.delta_on_angle = _smooth_move.delta_on_angle;
	_copy.true_x = _smooth_move.true_x;
	_copy.true_y = _smooth_move.true_y;
	return _copy;
}

/**
 * 
 *
 * @param {Struct.SmoothMove} _smooth_move
 * @param {real} _threshold
 */
function smooth_move_set_delta_line_threshold(_smooth_move, _threshold) {
	_smooth_move.delta_on_angle_threshold = _threshold;
}

/**
 * Get the current x position of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move
 */
function smooth_move_get_x(_smooth_move) {
	with (_smooth_move) {
		var _result = get_delta_on_angle_passed_threshold() ? get_derived_x() : get_round_to_start_x();
		return _result;
	}
}

/**
 * Get the current y position of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move
 */
function smooth_move_get_y(_smooth_move) {
	with (_smooth_move) {
		var _result = get_delta_on_angle_passed_threshold() ? get_derived_y() : get_round_to_start_y();
		return _result;
	}
}

/**
 * Set the position of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move
 * @param {real} _x
 * @param {real} _y
 */
function smooth_move_set_position(_smooth_move, _x, _y) {
	_x = floor(_x);
	_y = floor(_y);
	with (_smooth_move) {
		start_x = _x;
		start_y = _y;
		delta = 0;
		delta_on_angle = 0;
		true_x = _x;
		true_y = _y;
	}
}

/**
 * Move the given SmoothMove instance by the given vector. Angle of 0 corresponds to positive x axis
 *
 * @param {Struct.SmoothMove} _smooth_move
 * @param {real} _angle angle of vector in radians
 * @param {real} _magnitude magnitude of vector
 */
function smooth_move_by_vector(_smooth_move, _angle, _magnitude) {
	with (_smooth_move) {
		move_by_vector(_angle, _magnitude);
		
		anticipated_x = smooth_move_get_x_if_moved_by_vector(self, _angle, _magnitude);
		anticipated_y = smooth_move_get_y_if_moved_by_vector(self, _angle, _magnitude);
		
		anticipated_x2 = smooth_move_get_x_if_moved_by_vector(self, _angle, _magnitude * 2);
		anticipated_y2 = smooth_move_get_y_if_moved_by_vector(self, _angle, _magnitude * 2);
	}
}

/**
 * Move the given SmoothMove instance by the given x and y magnitudes.
 *
 * @param {Struct.SmoothMove} _smooth_move
 * @param {real} _magnitude_x
 * @param {real} _magnitude_y
 */
function smooth_move_by_magnitudes(_smooth_move, _magnitude_x, _magnitude_y) {
	with (_smooth_move) {
		var _angle = arctan2(_magnitude_y, _magnitude_x);
		var _m = sqrt(sqr(_magnitude_x) + sqr(_magnitude_y));
		smooth_move_by_vector(_smooth_move, _angle, _m);
	}
}

/**
 * Get the x position of the given SmoothMove instance if it was moved by the given vector.
 *
 * @param {Struct.SmoothMove} _smooth_move
 * @param {real} _angle angle in radians of the vector
 * @param {real} _magnitude magnitude of the vector
 */
function smooth_move_get_x_if_moved_by_vector(_smooth_move, _angle, _magnitude) {
	var _copy = smooth_move_get_copy(_smooth_move);
	_copy.move_by_vector(_angle, _magnitude);
	return smooth_move_get_x(_copy);
}

/**
 * Get the y position of the given SmoothMove instance if it was moved by the given vector.
 *
 * @param {Struct.SmoothMove} _smooth_move
 * @param {real} _angle angle in radians of the vector
 * @param {real} _magnitude magnitude of the vector
 */
function smooth_move_get_y_if_moved_by_vector(_smooth_move, _angle, _magnitude) {
	var _copy = smooth_move_get_copy(_smooth_move);
	_copy.move_by_vector(_angle, _magnitude);
	return smooth_move_get_y(_copy);
}

/**
 * Get the x position of the given SmoothMove instance if it was moved by the given x and y magnitudes.
 *
 * @param {Struct.SmoothMove} _smooth_move
 * @param {real} _magnitude_x
 * @param {real} _magnitude_y
 */
function smooth_move_get_x_if_moved_by_magnitudes(_smooth_move, _magnitude_x, _magnitude_y) {
	var _copy = smooth_move_get_copy(_smooth_move);
	var _angle = arctan2(_magnitude_y, _magnitude_x);
	var _m = sqrt(sqr(_magnitude_x) + sqr(_magnitude_y));
	_copy.move_by_vector(_angle, _m);
	return smooth_move_get_x(_copy);
}

/**
 * Get the y position of the given SmoothMove instance if it was moved by the given x and y magnitudes.
 *
 * @param {Struct.SmoothMove} _smooth_move
 * @param {real} _magnitude_x
 * @param {real} _magnitude_y
 */
function smooth_move_get_y_if_moved_by_magnitudes(_smooth_move, _magnitude_x, _magnitude_y) {
	var _copy = smooth_move_get_copy(_smooth_move);
	var _angle = arctan2(_magnitude_y, _magnitude_x);
	var _m = sqrt(sqr(_magnitude_x) + sqr(_magnitude_y));
	_copy.move_by_vector(_angle, _m);
	return smooth_move_get_y(_copy);
}
