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
	
	/*
	Previous and anticipated positions are the actual internal values smooth move did or will have. The user facing
	functions smooth_move_get_x/y_if_moved_by... do not use these. Instead they use our stair step logic to determine
	whether to return the previous actual position, or the current actual position.
	*/
	
	// last known position following stairstep rules
	
	// @ignore
	previous_x = position.get_x();
	
	// @ignore
	previous_y = position.get_y();
	
	// the next position if moved along the same vector
	
	// @ignore
	anticipated_x = position.get_x();
	
	// @ignore
	anticipated_y = position.get_y();
	
	// if false, anticipated next vector movement will be used to determine and hide stairstep pixels
	// @ignore
	show_stairsteps = false;
	
	previous_vectors = [];
	previous_vectors_cap = 1;
	previous_vectors_index = 0;
	
	/**
	 * @param {real} _angle
	 * @param {real} _magnitude
	 */
	add_previous_vector = function(_angle, _magnitude) {
		if (array_length(previous_vectors) < previous_vectors_cap) {
			previous_vectors_index = array_length(previous_vectors);
			array_push(previous_vectors, { angle: _angle, magnitude: _magnitude });
			return;
		}
		previous_vectors_index = (previous_vectors_index + 1) % array_length(previous_vectors);
		previous_vectors[previous_vectors_index].angle = _angle;
		previous_vectors[previous_vectors_index].magnitude = _magnitude;
	};
	
	get_anticipated_vector = function() {
		var _len = array_length(previous_vectors);
		if (_len == 0) return { angle: 0, magnitude: 0 };
		if (_len == 1) return previous_vectors[0]
		var _first_point = previous_vectors[(previous_vectors_index + 1) % _len];
		var _last_point = previous_vectors[previous_vectors_index];
		var _slope_for_angles = (_last_point.angle - _first_point.angle) / _len;
		var _slope_for_magnitudes = (_last_point.magnitude - _first_point.magnitude) / _len;
		var _best_angle = _first_point.angle + _slope_for_angles * (_len + 1);
		var _best_magnitude = _first_point.magnitude + _slope_for_magnitudes * (_len + 1);
		return {
			angle: _best_angle,
			magnitude: _best_magnitude,
		};
	};
	
	/**
	 * Return boolean indicating if current position will likely be 
	 * a stair step based on anticipated position.
	 *
	 * @ignore
	 */
	get_is_stair_step = function() {
		if (show_stairsteps) return false;
		var _dist_to_prev = sqrt(sqr(position.get_x() - previous_x) + sqr(position.get_y() - previous_y));
		var _dist_to_ant = sqrt(sqr(position.get_x() - anticipated_x) + sqr(position.get_y() - anticipated_y));
		var _dist_prev_to_ant = sqrt(sqr(previous_x - anticipated_x) + sqr(previous_y - anticipated_y));
		return (_dist_to_prev == 1) && (_dist_to_ant == 1) && (_dist_prev_to_ant == sqrt(2));
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
	_copy.position = _smooth_move.position.copy();
	_copy.previous_x = _smooth_move.previous_x;
	_copy.previous_y = _smooth_move.previous_y;
	_copy.anticipated_x = _smooth_move.anticipated_x;
	_copy.anticipated_y = _smooth_move.anticipated_y;
	_copy.show_stairsteps = _smooth_move.show_stairsteps;
	
	_copy.previous_vectors_cap = _smooth_move.previous_vectors_cap;
	_copy.previous_vectors_index = _smooth_move.previous_vectors_index;
	var _sm_arr = _smooth_move.previous_vectors;
	_copy.previous_vectors = array_create(array_length(_sm_arr));
	for (var _i = 0; _i < array_length(_sm_arr); _i++) {
		_copy.previous_vectors[_i] = {
			angle: _sm_arr[_i].angle,
			magnitude: _sm_arr[_i].magnitude,
		};
	}
	
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
	_smooth_move.position.delta_on_angle_threshold = _threshold;
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
		return get_is_stair_step() ? previous_x : position.get_x();
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
		return get_is_stair_step() ? previous_y : position.get_y();
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
		if (magnitude == 0) previous_vectors = [];
		else add_previous_vector(angle, magnitude);
		
		previous_x = smooth_move_get_x(self);
		previous_y = smooth_move_get_y(self);
		
		position.move_by_vector(angle, magnitude);
		
		var _copy = position.copy();
		var _anticipated_vector = get_anticipated_vector();
		_copy.move_by_vector(_anticipated_vector.angle, _anticipated_vector.magnitude);
		anticipated_x = _copy.get_x();
		anticipated_y = _copy.get_y();
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
