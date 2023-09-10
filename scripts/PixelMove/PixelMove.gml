// feather disable all

enum PIXEL_MOVE {
	LINE,
	SMOOTH,
	HYBRID,
}

/**
 * Create a new PixelMove instance.
 * 
 * @param {Real} start_position_x The starting x position.
 * @param {Real} start_position_y The starting y position.
 */
function PixelMove(start_position_x, start_position_y) constructor {
	// @ignore
	start_x = floor(start_position_x);
	// @ignore
	start_y = floor(start_position_y);
	// @ignore
	line = new __PixelLine(0, 0);
	
	/*
	True positions allows for checking between the calculated position following the strict
	linear line algorithm, and what the position would have been if position was
	calculated normally.
	*/
	// @ignore
	true_x = start_x;
	// @ignore
	true_y = start_y;
	
	movement_type = PIXEL_MOVE.LINE;
	
	/*
	This is not for calculating x/y position. This is used to track how far this instance
	has travelled along the same angle.
	*/
	// @ignore
	movements_on_angle = 0;
	
	// once movements_on_angle has passed this value position will be derived from line equation instead of true
	// @ignore
	movements_on_angle_to_infer_from_line = 5;
	
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
		var _x = pixel_move_get_x(self);
		var _y = pixel_move_get_y(self);
		start_x = _x;
		start_y = _y;
		line.delta = 0;
		movements_on_angle = movement_type == PIXEL_MOVE.LINE ? movements_on_angle_to_infer_from_line : 0;
	};
	
	/**
	 * Get the integer x position derived from the true position rounded towards start position.
	 *
	 * @ignore
	 */
	get_true_round_to_start_x = function() {
		return __pixelmove_util_round_towards(__pixelmove_util_round_to_correct(true_x), start_x);
	};
	
	/**
	 * Get the integer x position derived from the true position rounded towards start position.
	 *
	 * @ignore
	 */
	get_true_round_to_start_y = function() {
		return __pixelmove_util_round_towards(__pixelmove_util_round_to_correct(true_y), start_y);
	};
	
	/**
	 * Move by the given vector. Angle of 0 corresponds to positive x axis.
	 *
	 * @param {Struct.PixelMove} pixel_move The PixelMove instance to move.
	 * @param {real} angle The angle of the vector in radians.
	 * @param {real} magnitude The magnitude of the vector.
	 */
	move_by_vector = function (_angle, _magnitude) {
		_angle = __pixelmove_util_get_cleaned_angle(_angle);
		var _angle_changed = line.angle != _angle;
		
		var _curr_x = pixel_move_get_x(self);
		var _curr_y = pixel_move_get_y(self);
		
		// reset line data on no movement or angle change
		if ((_magnitude == 0) || _angle_changed) reset_line_to_current();
		
		// reset true data on no movement
		if (_magnitude == 0) {
			true_x = _curr_x;
			true_y = _curr_y;
		}
		
		line.set(_angle, line.delta + _magnitude);
		
		// error correct based on true value
		true_x += __pixelmove_util_get_x_component(_angle, _magnitude);
		true_y += __pixelmove_util_get_y_component(_angle, _magnitude);
		var _error = sqrt(sqr(get_true_round_to_start_x() - pixel_move_get_x(self)) + sqr(get_true_round_to_start_y() - pixel_move_get_y(self)));
		
		// determine if this movement crossed the movements_on_angle threshold, and new error
		var _threshold_cross_before_movements_on_angle_change = get_movements_on_angle_passed_threshold();
		movements_on_angle += 1;
		var _crossed_delta_line_threshold = get_movements_on_angle_passed_threshold() != _threshold_cross_before_movements_on_angle_change;
		var _post_delta_change_error = sqrt(sqr(get_true_round_to_start_x() - pixel_move_get_x(self)) + sqr(get_true_round_to_start_y() - pixel_move_get_y(self)));
		
		// correct line towards error
		if ((!get_movements_on_angle_passed_threshold() && _error >= 1) || (_post_delta_change_error >= 1 && _crossed_delta_line_threshold)) {
			start_x = get_true_round_to_start_x();
			start_y = get_true_round_to_start_y();
			line.delta = 0;
		}
		
		// correct error towards line once passed threshold
		if (get_movements_on_angle_passed_threshold()) {
			true_x = pixel_move_get_x(self);
			true_y = pixel_move_get_y(self);
		}
	};
}

/**
 * Get a copy of the given PixelMove instance.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to copy.
 */
function pixel_move_get_copy(pixel_move) {
	var _copy = new PixelMove(0, 0);	
	with (pixel_move) {
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
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to set the threshold for.
 * @param {real} threshold The new delta threshold.
 */
function pixel_move_set_movements_on_angle_to_infer_from_line(pixel_move, threshold) {
	pixel_move.movements_on_angle_to_infer_from_line = max(1, floor(abs(threshold)));
}

/**
 * Set the movement type to line. Movement will be mathematically perfect lines.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to set the movement type for.
 */
function pixel_move_set_movement_type_line(pixel_move) {
	pixel_move.movement_type = PIXEL_MOVE.LINE;
}

/**
 * Set the movement type to smooth. Movement will be more responsive and fluid.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to set the movement type for.
 */
function pixel_move_set_movement_type_smooth(pixel_move) {
	pixel_move.movement_type = PIXEL_MOVE.SMOOTH;
}

/**
 * Set the movement type to hybrid. Movement will be responsive and fluid but change to mathematically perfect lines after repeated movements on the same angle.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to set the movement type for.
 */
function pixel_move_set_movement_type_hybrid(pixel_move) {
	if (pixel_move.movement_type != PIXEL_MOVE.HYBRID) pixel_move.movements_on_angle = 0;
	pixel_move.movement_type = PIXEL_MOVE.HYBRID;
}

/**
 * Get the current x position.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to get the x position of.
 * @return {real}
 */
function pixel_move_get_x(pixel_move) {
	with (pixel_move) {
		return get_movements_on_angle_passed_threshold() ? line.get_x(start_x, start_y) : get_true_round_to_start_x();
	}
}

/**
 * Get the current y position.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to get the y position of.
 * @return {real}
 */
function pixel_move_get_y(pixel_move) {
	with (pixel_move) {
		return get_movements_on_angle_passed_threshold() ? line.get_y(start_x, start_y) : get_true_round_to_start_y();
	}
}

/**
 * Set the x,y position. 
 *
 * @param {Struct.PixelMove} _pixel_move The PixelMove instance to set the x and y position of.
 * @param {real} x The new x position.
 * @param {real} y The new y position.
 */
function pixel_move_set_position(pixel_move, x, y) {
	x = floor(x);
	y = floor(y);
	with (pixel_move) {
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
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to move.
 * @param {real} angle The angle of the vector in radians.
 * @param {real} magnitude The magnitude of the vector.
 */
function pixel_move_by_vector(pixel_move, angle, magnitude) {
	if (pixel_move.movement_type == PIXEL_MOVE.SMOOTH) pixel_move.movements_on_angle = -2;
	pixel_move.move_by_vector(angle, magnitude);
}

/**
 * Move by the given x and y magnitudes.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to move.
 * @param {real} magnitude_x The x magnitude.
 * @param {real} magnitude_y The y magnitude.
 */
function pixel_move_by_magnitudes(pixel_move, magnitude_x, magnitude_y) {
	with (pixel_move) {
		var _angle = arctan2(magnitude_y, magnitude_x);
		var _m = sqrt(sqr(magnitude_x) + sqr(magnitude_y));
		pixel_move_by_vector(self, _angle, _m);
	}
}

/**
 * Get the x position after movement by the given vector. Does not mutate the given
 * PixelMove instance.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to get the potential x position of.
 * @param {real} angle The angle in radians of the vector.
 * @param {real} magnitude The magnitude of the vector.
 */
function pixel_move_get_x_if_moved_by_vector(pixel_move, angle, magnitude) {
	var _copy = pixel_move_get_copy(pixel_move);
	pixel_move_by_vector(_copy, angle, magnitude);
	return pixel_move_get_x(_copy);
}

/**
 * Get the y position after movement by the given vector. Does not mutate the given
 * PixelMove instance.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to get the potential y position of.
 * @param {real} angle The angle in radians of the vector.
 * @param {real} magnitude The magnitude of the vector.
 */
function pixel_move_get_y_if_moved_by_vector(pixel_move, angle, magnitude) {
	var _copy = pixel_move_get_copy(pixel_move);
	pixel_move_by_vector(_copy, angle, magnitude);
	return pixel_move_get_y(_copy);
}

/**
 * Get the x position after movement by the given x and y magnitudes. Does not mutate the given
 * PixelMove instance.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to get the potential x position of.
 * @param {real} magnitude_x The x magnitude.
 * @param {real} magnitude_y The y magnitude.
 */
function pixel_move_get_x_if_moved_by_magnitudes(pixel_move, magnitude_x, magnitude_y) {
	var _copy = pixel_move_get_copy(pixel_move);
	var _angle = arctan2(magnitude_y, magnitude_x);
	var _m = sqrt(sqr(magnitude_x) + sqr(magnitude_y));
	return pixel_move_get_x_if_moved_by_vector(_copy, _angle, _m);
}

/**
 * Get the y position after movement by the given x and y magnitudes. Does not mutate the given
 * PixelMove instance.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to get the potential y position of.
 * @param {real} magnitude_x The x magnitude.
 * @param {real} magnitude_y The y magnitude.
 */
function pixel_move_get_y_if_moved_by_magnitudes(pixel_move, magnitude_x, magnitude_y) {
	var _copy = pixel_move_get_copy(pixel_move);
	var _angle = arctan2(magnitude_y, magnitude_x);
	var _m = sqrt(sqr(magnitude_x) + sqr(magnitude_y));
	return pixel_move_get_y_if_moved_by_vector(_copy, _angle, _m);
}
