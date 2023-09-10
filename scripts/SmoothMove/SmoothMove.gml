// feather disable all

/**
 * Create a new SmoothMove instance.
 * 
 * @param {Real} start_position_x The starting x position.
 * @param {Real} start_position_y The starting y position.
 */
function SmoothMove(start_position_x, start_position_y) constructor {
	// @ignore
	position = new __SmoothPosition(start_position_x, start_position_y);
	
	
}

/**
 * Get a copy of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} smooth_move The SmoothMove instance to copy.
 */
function smooth_move_get_copy(smooth_move) {
	var _smooth_move = smooth_move
	var _copy = new SmoothMove(0, 0);	
	_copy.position = _smooth_move.position.copy();
	return _copy;
}

/**
 * Set the number of movements at same angle before position is derived from line equation.
 *
 * @param {Struct.SmoothMove} smooth_move The SmoothMove instance to set the threshold for.
 * @param {real} threshold The new delta threshold.
 */
function smooth_move_set_movements_on_angle_to_infer_from_line(smooth_move, threshold) {
	var _smooth_move = smooth_move;
	var _threshold = threshold;
	_smooth_move.position.movements_on_angle_to_infer_from_line = _threshold;
}

/**
 * Get the current x position.
 *
 * @param {Struct.SmoothMove} smooth_move The SmoothMove instance to get the x position of.
 * @return {real}
 */
function smooth_move_get_x(smooth_move) {
	with (smooth_move) {
		return position.get_x();
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
		return position.get_y();
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
		position.set(_x, _y);
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
		position.move_by_vector(angle, magnitude);
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
