// feather disable all

/**
 * Create a new SmoothMove instance.
 * 
 * @param {Real} start_position_x The starting x position.
 * @param {Real} start_position_y The starting y position.
 */
function SmoothMove(start_position_x, start_position_y) constructor {
	// @ignore
	start_x = floor(start_position_x);
	// @ignore
	start_y = floor(start_position_y);
	line = new SmoothLine(0, 0);
	
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
	
	/*
	Previous and anticipated positions are the actual internal values smooth move did or will have. The user facing
	functions smooth_move_get_x/y_if_moved_by... do not use these. Instead they use our stair step logic to determine
	whether to return the previous actual position, or the current actual position.
	*/
	
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
	 * Reset the start and delta values of this instance.
	 *
	 * @ignore
	 */
	reset = function() {
		var _x = get_x();
		var _y = get_y();
		start_x = _x;
		start_y = _y;
		line.delta = 0;
		delta_on_angle = 0;
	};
	
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
	
	// @ignore
	get_x = function() {
		return get_delta_on_angle_passed_threshold() ? line.get_x(start_x, start_y) : get_round_to_start_x();
	};
	
	// @ignore
	get_y = function() {
		return get_delta_on_angle_passed_threshold() ? line.get_y(start_x, start_y) : get_round_to_start_y();
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
		var _angle_changed = line.angle != _angle;
		
		// reset line data on no movement or angle change
		if ((_magnitude == 0) || _angle_changed) reset();
		
		// reset true data on no movement or too great an angle change
		if ((_magnitude == 0) || get_angle_diff(line.angle, _angle) > pi/2) {
			true_x = get_x();
			true_y = get_y();
		}
		
		line.set(_angle, line.delta + _magnitude);
		
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
			line.delta = 0;
		}
		
		// correct error towards line once passed threshold
		if (get_delta_on_angle_passed_threshold()) {
			true_x = get_x();
			true_y = get_y();
		}
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
	_copy.line = _smooth_move.line.copy();
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
 * Set the threshold for distance travelled before position is derived from line equation.
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
 * Set whether to show or hide stairstep movement based on anticipated changes. Default value
 * for show_stairsteps is false.
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
 * @return {real}
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
 * @return {real}
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
 * @param {real} x The new x position.
 * @param {real} y The new y position.
 */
function smooth_move_set_position(smooth_move, x, y) {
	var _x = floor(x);
	var _y = floor(y);
	with (smooth_move) {
		start_x = _x;
		start_y = _y;
		line.delta = 0;
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
		previous_x = get_x();
		previous_y = get_y();
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
