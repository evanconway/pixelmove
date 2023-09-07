// feather disable all

/**
 * Position tracker that smoothes out changes.
 * 
 * @param {Real} start_position_x The starting x position.
 * @param {Real} start_position_y The starting y position.
 */
function SmoothMove(start_position_x, start_position_y) constructor {
	// @ignore
	start_x = start_position_x;
	// @ignore
	start_y = start_position_y;
	// @ignore
	angle = 0;
	// @ignore
	delta = 0;
	
	/*
	True positions allows for checking between the calculated position following the strict
	linear line algorithm, and what the position would have been if position was
	calculated normally.
	*/
	
	// @ignore
	true_x = start_x;
	// @ignore
	true_y = start_y;
	
	/*
	This is not for calculating x/y position. This is used to track how far this instance
	has travelled along the same angle.
	*/
	// @ignore
	delta_on_angle = 0;
	
	// once delta_on_angle has passed this value position will be derived from line equation instead of error
	// @ignore
	delta_on_angle_threshold = 7.1;
	
	// last known position following stairstep rules
	// @ignore
	previous_x = start_x;
	// @ignore
	previous_y = start_y;
	
	// the next position if moved along the same vector
	// @ignore
	anticipated_x = start_x;
	// @ignore
	anticipated_y = start_y;
	
	// if false, anticipated next vector movement will be used to determine and hide stairstep pixels
	// @ignore
	show_stairsteps = false;
	
	// @ignore
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
	 * @ignore
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
	 * @ignore
	 */
	function snap_to_zero(_value) {
		return abs(_value) < 0.001 ? 0 : _value;
	};
	
	/**
	 * Wrapper function around sin that snaps the result to 0 if it's within 0.001 of 0.
	 *
	 * @param {real} _angle angle in radians
	 * @ignore
	 */
	function snap_sin(_angle) {
		return snap_to_zero(sin(_angle));
	}
	
	/**
	 * Wrapper function around cos that snaps the result to 0 if it's within 0.001 of 0.
	 *
	 * @param {real} _angle angle in radians
	 * @ignore
	 */
	function snap_cos(_angle) {
		return snap_to_zero(cos(_angle));
	}
	
	/**
	 * @param {real} _value
	 * @ignore
	 */
	function round_to_thousandths(_value) {
		return floor(_value * 1000 + 0.5) / 1000;
	}
	
	/**
	 * Rounding function to account for gamemaker's imperfect real tracking
	 *
	 * @param {real} _value
	 * @ignore
	 */
	function round_to_correct(_value) {
		return floor(_value * 100000 + 0.5) / 100000;
	}
	
	/**
	 * Return the given angle in radians transformed to the equivalent position and rounded
	 * roughly towards the cardinal directions and their intermediates.
	 *
	 * @param {real} _angle
	 * @ignore
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
	 * @ignore
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
	 * @ignore
	 */
	infer_y_from_x = function() {
		return (angle <= 1*pi/4 || angle >= 7*pi/4 || (angle >= 3*pi/4 && angle <= 5*pi/4));
	};
	
	/**
	 * Get the x magnitude given the given angle and delta.
	 *
	 * @ignore
	 */
	get_magnitude_x = function() {
		return snap_cos(angle) * delta;
	}
	
	/**
	 * Get the y magnitude given the current angle and delta.
	 *
	 * @ignore
	 */
	get_magnitude_y = function() {
		return snap_sin(angle) * delta;
	};
	
	/**
	 * Get the x component of the given vector.
	 *
	 * @param {real} _angle
	 * @param {real} _delta
	 * @ignore
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
	 * @ignore
	 */
	function get_y_component(_angle, _delta) {
		if (_delta == 0 || _angle == 0 || _angle == 4*pi/4) return 0;
		return snap_sin(_angle) * _delta;
	}
	
	/**
	 * Get the slope to be used to infer an x or y position. The slope changes depending on
	 * whether the x or y magnitude of the 2D vector is greater.
	 *
	 * @ignore
	 */
	slope = function() {
		if (delta == 0) return 0;
		return infer_y_from_x() ? get_magnitude_y() / get_magnitude_x() : get_magnitude_x() / get_magnitude_y();
	}
	
	/**
	 * Reset the start and delta values of this instance.
	 *
	 * @ignore
	 */
	reset = function() {
		var _x = get_x();
		var _y = get_y();
		start_x = _x;
		start_y = _y;
		delta = 0;
		delta_on_angle = 0;
		previous_x = _x;
		previous_y = _y;
		anticipated_x = _x;
		anticipated_y = _y;
	};
	
	/**
	 * Get the integer x position derived from the line equation.
	 *
	 * @ignore
	 */
	get_derived_x = function() {
		if (delta == 0) return start_x;
		if (infer_y_from_x()) {
			var _x = round_to_correct(start_x + get_magnitude_x());
			return round_towards(_x, start_x);
		}
		
		// derive x position from linear line function of y
		var _y_diff = get_y() - start_y;
		var _x = round_to_thousandths(slope() * _y_diff + start_x);
		return round_towards(_x, start_x);
	}
	
	/**
	 * Get the integer y position derived from the line equation.
	 *
	 * @ignore
	 */
	get_derived_y = function() {
		if (delta == 0) return start_y;
		if (!infer_y_from_x()) {
			var _y = round_to_correct(start_y + get_magnitude_y());
			return round_towards(_y, start_y);
		}
		
		// derive y position from linear line function of x
		var _x_diff = get_x() - start_x;
		var _y = round_to_thousandths(slope() * _x_diff + start_y);
		return round_towards(_y, start_y);
	}
	
	/**
	 * Get the integer x position derived from the true position.
	 *
	 * @ignore
	 */
	get_round_to_start_x = function() {
		return round_towards(round_to_correct(true_x), start_x);
	};
	
	/**
	 * Get the integer y position derived from the true position.
	 *
	 * @ignore
	 */
	get_round_to_start_y = function() {
		return round_towards(round_to_correct(true_y), start_y);
	};
	
	/**
	 * Return boolean indicating if current position will likely be 
	 * a stair step based on anticipated position.
	 *
	 * @ignore
	 */
	get_is_stair_step = function() {
		if (show_stairsteps) return false;
		var _dist_to_prev = sqrt(sqr(get_x() - previous_x) + sqr(get_y() - previous_y));
		var _dist_to_ant = sqrt(sqr(get_x() - anticipated_x) + sqr(get_y() - anticipated_y));
		var _dist_prev_to_ant = sqrt(sqr(previous_x - anticipated_x) + sqr(previous_y - anticipated_y));
		return (_dist_to_prev == 1) && (_dist_to_ant == 1) && (_dist_prev_to_ant == sqrt(2));
	}
	
	/**
	 * Move by the given vector. Angle of 0 corresponds to positive x axis
	 *
	 * @param {real} _angle angle of vector in radians
	 * @param {real} _magnitude magnitude of vector
	 * @ignore
	 */
	move_by_vector = function(_angle, _magnitude) {		
		_angle = get_cleaned_angle(_angle);
		var _angle_changed = angle != _angle;
		
		// reset line data on no movement or angle change
		if ((_magnitude == 0) || _angle_changed) reset();
		
		// reset true data on no movement or too great an angle change
		if ((_magnitude == 0) || get_angle_diff(angle, _angle) >= pi/4) {
			true_x = get_x();
			true_y = get_y();
			previous_x = get_x();
			previous_y = get_y();
		}
		
		if (!get_is_stair_step()) {
			previous_x = get_x();
			previous_y = get_y();
		}
		
		angle = _angle;
		delta += _magnitude;
		
		// error correct based on true value
		true_x += get_x_component(_angle, _magnitude);
		true_y += get_y_component(_angle, _magnitude);
		var _error = sqrt(sqr(get_round_to_start_x() - get_x()) + sqr(get_round_to_start_y() - get_y()));
		
		// determine if this movement crossed the delta_on_angle threshold, and new error
		var _threshold_cross_before_delta_on_angle_change = get_delta_on_angle_passed_threshold();
		delta_on_angle += _magnitude;
		var _crossed_delta_line_threshold = get_delta_on_angle_passed_threshold() != _threshold_cross_before_delta_on_angle_change;
		var _post_delta_change_error = sqrt(sqr(get_round_to_start_x() - get_x()) + sqr(get_round_to_start_y() - get_y()));
		
		// correct line towards error
		if ((!get_delta_on_angle_passed_threshold() && _error >= 1) || (_post_delta_change_error >= 1 && _crossed_delta_line_threshold)) {
			start_x = get_round_to_start_x();
			start_y = get_round_to_start_y();
			delta = 0;
		}
		
		// correct error towards line once passed threshold
		if (get_delta_on_angle_passed_threshold()) {
			true_x = get_x();
			true_y = get_y();
		}
		
		anticipated_x = get_x();
		anticipated_y = get_y();
	};
	
	// @ignore
	get_x = function() {
		return get_delta_on_angle_passed_threshold() ? get_derived_x() : get_round_to_start_x();
	};
	
	// @ignore
	get_y = function() {
		return get_delta_on_angle_passed_threshold() ? get_derived_y() : get_round_to_start_y();
	};
	
	// @ignore
	get_x_if_moved_by_vector = function(_angle, _magnitude) {
		var _copy = smooth_move_get_copy(self);
		_copy.move_by_vector(_angle, _magnitude);
		return _copy.get_x();
	};
	
	// @ignore
	get_y_if_moved_by_vector = function(_angle, _magnitude) {
		var _copy = smooth_move_get_copy(self);
		_copy.move_by_vector(_angle, _magnitude);
		return _copy.get_y();
	};
}

/**
 * Get a copy of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} smooth_move The SmoothMove instance to copy.
 */
function smooth_move_get_copy(smooth_move) {
	var _smooth_move = smooth_move
	var _copy = new SmoothMove(0, 0);	
	_copy.start_x = _smooth_move.start_x;
	_copy.start_y = _smooth_move.start_y;
	_copy.angle = _smooth_move.angle;
	_copy.delta = _smooth_move.delta;
	_copy.delta_on_angle = _smooth_move.delta_on_angle;
	_copy.true_x = _smooth_move.true_x;
	_copy.true_y = _smooth_move.true_y;
	_copy.previous_x = _smooth_move.previous_x;
	_copy.previous_y = _smooth_move.previous_y;
	_copy.anticipated_x = _smooth_move.anticipated_x;
	_copy.anticipated_y = _smooth_move.anticipated_y;
	_copy.show_stairsteps = _smooth_move.show_stairsteps;
	return _copy;
}

/**
 * Set the threshold for distance travelled before line equation is used to derive position.
 *
 * @param {Struct.SmoothMove} smooth_move The SmoothMove instance to set the threshold for.
 * @param {real} threshold The new delta threshold.
 */
function smooth_move_set_delta_line_threshold(smooth_move, threshold) {
	var _smooth_move = smooth_move;
	var _threshold = threshold;
	_smooth_move.delta_on_angle_threshold = _threshold;
}

/**
 * Set whether or not to hide stairstep movement based on
 * anticipated changes. Default is false.
 *
 * @param {Struct.SmoothMove} _smooth_move The SmoothMove instance to set show stairsteps for.
 * @param {bool} new_show_stairsteps True to show stairsteps, false to hide.
 */
function smooth_move_show_stairsteps(smooth_move, new_show_stairsteps) {
	var _smooth_move = smooth_move;
	var _bool = new_show_stairsteps;
	_smooth_move.show_stairsteps = _bool;
}

/**
 * Get the current x position.
 *
 * @param {Struct.SmoothMove} smooth_move The SmoothMove instance to get the x position of.
 */
function smooth_move_get_x(smooth_move) {
	with (smooth_move) {
		return get_is_stair_step() ? previous_x : get_x();
	}
}

/**
 * Get the current y position.
 *
 * @param {Struct.SmoothMove} smooth_move The SmoothMove instance to get the y position of.
 */
function smooth_move_get_y(smooth_move) {
	with (smooth_move) {
		return get_is_stair_step() ? previous_y : get_y();
	}
}

/**
 * Set the x,y position.
 *
 * @param {Struct.SmoothMove} _smooth_move The SmoothMove instance to set the x and y position of.
 * @param {real} x x position
 * @param {real} y y position
 */
function smooth_move_set_position(smooth_move, x, y) {
	var _x = floor(x);
	var _y = floor(y);
	with (smooth_move) {
		start_x = _x;
		start_y = _y;
		delta = 0;
		delta_on_angle = 0;
		true_x = _x;
		true_y = _y;
		previous_x = _x;
		previous_y = _y;
		anticipated_x = _x;
		anticipated_y = _y;
	}
}

/**
 * Move by the given vector. Angle of 0 corresponds to positive x axis.
 *
 * @param {Struct.SmoothMove} smooth_move The SmoothMove instance to move.
 * @param {real} angle The angle of the vector in radians.
 * @param {real} magnitude The magnitude of the vector.
 */
function smooth_move_by_vector(smooth_move, angle, magnitude) {
	with (smooth_move) {
		move_by_vector(angle, magnitude);
		anticipated_x = get_x_if_moved_by_vector(angle, magnitude);
		anticipated_y = get_y_if_moved_by_vector(angle, magnitude);
	}
}

/**
 * Move by the given x and y magnitudes.
 *
 * @param {Struct.SmoothMove} smooth_move The SmoothMove instance to move.
 * @param {real} magnitude_x The x magnitude.
 * @param {real} magnitude_y The y magnitude.
 */
function smooth_move_by_magnitudes(smooth_move, magnitude_x, magnitude_y) {
	with (smooth_move) {
		var _angle = arctan2(magnitude_y, magnitude_x);
		var _m = sqrt(sqr(magnitude_x) + sqr(magnitude_y));
		smooth_move_by_vector(self, _angle, _m);
	}
}

/**
 * Get the x position after movement by the given vector. Does not mutate the given
 * SmoothMove instance.
 *
 * @param {Struct.SmoothMove} smooth_move The SmoothMove instance to get the potential x position of.
 * @param {real} angle The angle in radians of the vector.
 * @param {real} magnitude The magnitude of the vector.
 */
function smooth_move_get_x_if_moved_by_vector(smooth_move, angle, magnitude) {
	var _copy = smooth_move_get_copy(smooth_move);
	smooth_move_by_vector(_copy, angle, magnitude);
	return smooth_move_get_x(_copy);
}

/**
 * Get the y position after movement by the given vector. Does not mutate the given
 * SmoothMove instance.
 *
 * @param {Struct.SmoothMove} smooth_move The SmoothMove instance to get the potential y position of.
 * @param {real} angle The angle in radians of the vector.
 * @param {real} magnitude The magnitude of the vector.
 */
function smooth_move_get_y_if_moved_by_vector(smooth_move, angle, magnitude) {
	var _copy = smooth_move_get_copy(smooth_move);
	smooth_move_by_vector(_copy, angle, magnitude);
	return smooth_move_get_y(_copy);
}

/**
 * Get the x position after movement by the given x and y magnitudes. Does not mutate the given
 * SmoothMove instance.
 *
 * @param {Struct.SmoothMove} smooth_move The SmoothMove instance to get the potential x position of.
 * @param {real} magnitude_x The x magnitude.
 * @param {real} magnitude_y The y magnitude.
 */
function smooth_move_get_x_if_moved_by_magnitudes(smooth_move, magnitude_x, magnitude_y) {
	var _copy = smooth_move_get_copy(smooth_move);
	var _angle = arctan2(magnitude_y, magnitude_x);
	var _m = sqrt(sqr(magnitude_x) + sqr(magnitude_y));
	return smooth_move_get_x_if_moved_by_vector(_copy, _angle, _m);
}

/**
 * Get the y position after movement by the given x and y magnitudes. Does not mutate the given
 * SmoothMove instance.
 *
 * @param {Struct.SmoothMove} smooth_move The SmoothMove instance to get the potential y position of.
 * @param {real} magnitude_x The x magnitude.
 * @param {real} magnitude_y The y magnitude.
 */
function smooth_move_get_y_if_moved_by_magnitudes(smooth_move, magnitude_x, magnitude_y) {
	var _copy = smooth_move_get_copy(smooth_move);
	var _angle = arctan2(magnitude_y, magnitude_x);
	var _m = sqrt(sqr(magnitude_x) + sqr(magnitude_y));
	return smooth_move_get_y_if_moved_by_vector(_copy, _angle, _m);
}
