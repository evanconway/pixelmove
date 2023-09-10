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
	// @ignore
	line = new __SmoothLine(0, 0);
	
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
	movements_on_angle = 0;
	
	// once movements_on_angle has passed this value position will be derived from line equation instead of true
	// @ignore
	movements_on_angle_to_infer_from_line = 0;
	
	/**
	 * @ignore
	 */
	get_movements_on_angle_passed_threshold = function () {
		return movements_on_angle >= movements_on_angle_to_infer_from_line;
	};
	
	/**
	 * Reset result of line equation to current position. Does not change angle.
	 *
	 * @ignore
	 */
	reset_line_to_current = function() {
		var _x = smooth_move_get_x(self);
		var _y = smooth_move_get_y(self);
		start_x = _x;
		start_y = _y;
		line.delta = 0;
		movements_on_angle = 0;
	};
	
	/**
	 * Get the integer x position derived from the true position rounded towards start position.
	 *
	 * @ignore
	 */
	get_true_round_to_start_x = function() {
		return __smoothmove_util_round_towards(__smoothmove_util_round_to_correct(true_x), start_x);
	};
	
	/**
	 * Get the integer x position derived from the true position rounded towards start position.
	 *
	 * @ignore
	 */
	get_true_round_to_start_y = function() {
		return __smoothmove_util_round_towards(__smoothmove_util_round_to_correct(true_y), start_y);
	};
}

/**
 * Get a copy of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} smooth_move The SmoothMove instance to copy.
 */
function smooth_move_get_copy(smooth_move) {
	var _copy = new SmoothMove(0, 0);	
	with (smooth_move) {
		_copy.start_x = start_x;
		_copy.start_y = start_y;
		_copy.line = line.copy();
		_copy.true_x = true_x;
		_copy.true_y = true_y;
		_copy.movements_on_angle = movements_on_angle;
		_copy.movements_on_angle_to_infer_from_line = movements_on_angle_to_infer_from_line;
	}
	return _copy;
}

/**
 * Set the number of movements at same angle before position is derived from line equation.
 *
 * @param {Struct.SmoothMove} smooth_move The SmoothMove instance to set the threshold for.
 * @param {real} threshold The new delta threshold.
 */
function smooth_move_set_movements_on_angle_to_infer_from_line(smooth_move, threshold) {
	smooth_move.movements_on_angle_to_infer_from_line = threshold;
}

/**
 * Get the current x position.
 *
 * @param {Struct.SmoothMove} smooth_move The SmoothMove instance to get the x position of.
 * @return {real}
 */
function smooth_move_get_x(smooth_move) {
	with (smooth_move) {
		return get_movements_on_angle_passed_threshold() ? line.get_x(start_x, start_y) : get_true_round_to_start_x();
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
		return get_movements_on_angle_passed_threshold() ? line.get_y(start_x, start_y) : get_true_round_to_start_y();
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
	x = floor(x);
	y = floor(y);
	with (smooth_move) {
		start_x = x;
		start_y = y;
		true_x = start_x;
		true_y = start_y;
		line.delta = 0;
		movements_on_angle = 0;	
	}
}

/**
 * Move by the given vector. Angle of 0 corresponds to positive x axis.
 *
 * @param {Struct.SmoothMove} smooth_move The SmoothMove instance to move.
 * @param {real,undefined} angle The angle of the vector in radians.
 * @param {real} magnitude The magnitude of the vector.
 */
function smooth_move_by_vector(smooth_move, angle, magnitude) {
	with (smooth_move) {
		angle = __smoothmove_util_get_cleaned_angle(angle);
		var _angle_changed = line.angle != angle;
		
		var _curr_x = smooth_move_get_x(self);
		var _curr_y = smooth_move_get_y(self);
		
		// reset line data on no movement or angle change
		if ((magnitude == 0) || _angle_changed) reset_line_to_current();
		
		// reset true data on no movement
		if (magnitude == 0) {
			true_x = _curr_x;
			true_y = _curr_y;
		}
		
		line.set(angle, line.delta + magnitude);
		
		// error correct based on true value
		true_x += __smoothmove_util_get_x_component(angle, magnitude);
		true_y += __smoothmove_util_get_y_component(angle, magnitude);
		var _error = sqrt(sqr(get_true_round_to_start_x() - smooth_move_get_x(self)) + sqr(get_true_round_to_start_y() - smooth_move_get_y(self)));
		
		// determine if this movement crossed the movements_on_angle threshold, and new error
		var _threshold_cross_before_movements_on_angle_change = get_movements_on_angle_passed_threshold();
		movements_on_angle += 1;
		var _crossed_delta_line_threshold = get_movements_on_angle_passed_threshold() != _threshold_cross_before_movements_on_angle_change;
		var _post_delta_change_error = sqrt(sqr(get_true_round_to_start_x() - smooth_move_get_x(self)) + sqr(get_true_round_to_start_y() - smooth_move_get_y(self)));
		
		// correct line towards error
		if ((!get_movements_on_angle_passed_threshold() && _error >= 1) || (_post_delta_change_error >= 1 && _crossed_delta_line_threshold)) {
			start_x = get_true_round_to_start_x();
			start_y = get_true_round_to_start_y();
			line.delta = 0;
		}
		
		// correct error towards line once passed threshold
		if (get_movements_on_angle_passed_threshold()) {
			true_x = smooth_move_get_x(self);
			true_y = smooth_move_get_y(self);
		}
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
