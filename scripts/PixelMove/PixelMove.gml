// feather disable all

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
	angle = 0;
	// @ignore
	delta = 0;
	
	// @ignore
	start_integer_x = start_x;
	// @ignore
	start_integer_y = start_y;
	
	// @ignore
	movement_type = "LINE";
	
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
	static get_movements_on_angle_passed_threshold = function () {
		return movements_on_angle >= movements_on_angle_to_infer_from_line;
	};
	
	
	/**
	 * Returns if y is inferred from x, or x is inferred from y.
	 *
	 * @ignore
	 */
	static infer_y_from_x = function() {
		return (angle <= 1*pi/4 || angle >= 7*pi/4 || (angle >= 3*pi/4 && angle <= 5*pi/4));
	};
	
	/**
	 * Get the slope to be used to infer an x or y position. The slope changes depending on
	 * whether the x or y magnitude of the 2D vector is greater.
	 *
	 * @ignore
	 */
	static slope = function() {
		if (delta == 0) return 0;
		return infer_y_from_x() ? __pixelmove_util_get_y_component(angle, delta) / __pixelmove_util_get_x_component(angle, delta) : __pixelmove_util_get_x_component(angle, delta) / __pixelmove_util_get_y_component(angle, delta);
	}
	
	/**
	 * @param {value} _value
	 * @ignore
	 */
	static round_to_start_integer_x = function(_value) {
		return __pixelmove_util_round_towards(_value, start_integer_x);
	};
	
	/**
	 * @param {value} _value
	 * @ignore
	 */
	static round_to_start_integer_y = function(_value) {
		return __pixelmove_util_round_towards(_value, start_integer_y);
	};
	
	/**
	 * @ignore
	 */
	static get_real_x = function() {
		return start_x + __pixelmove_util_get_x_component(angle, delta);
	};
	
	/**
	 * @ignore
	 */
	static get_real_y = function() {
		return start_y + __pixelmove_util_get_y_component(angle, delta);
	}
	
	/**
	 * @ignore
	 */
	static get_line_x = function() {
		if (delta == 0) return round_to_start_integer_x(start_x);
		if (infer_y_from_x()) {
			var _x = __pixelmove_util_round_to_correct(get_real_x());
			return round_to_start_integer_x(_x);
		}
		
		// derive x position from linear line function of y
		var _y_diff = get_line_y() - start_integer_y;
		var _x = __pixelmove_util_round_to_correct(slope() * _y_diff + start_x);
		return round_to_start_integer_x(_x);
	};
	
	/**
	 * @ignore
	 */
	static get_line_y = function() {
		if (delta == 0) return round_to_start_integer_y(start_y);
		if (!infer_y_from_x()) {
			var _y = __pixelmove_util_round_to_correct(get_real_y());
			return round_to_start_integer_y(_y);
		}
		
		// derive y position from linear line function of x
		var _x_diff = get_line_x() - start_integer_x;
		var _y = __pixelmove_util_round_to_correct(slope() * _x_diff + start_y);
		return round_to_start_integer_y(_y);
	}
	
	/**
	 * Get the integer x position derived from the real position rounded towards last integer position.
	 *
	 * @ignore
	 */
	static get_true_x = function() {
		return round_to_start_integer_x(get_real_x());
	};
	
	/**
	 * Get the integer x position derived from the real position rounded towards last integer position.
	 *
	 * @ignore
	 */
	static get_true_y = function() {
		return round_to_start_integer_y(get_real_y());
	};
	
	/**
	 * Return true if current integer position should be derived from line.
	 *
	 * @ignore
	 */
	static get_derive_position_from_line = function() {
		if (movement_type == "LINE") return true;
		if (movement_type == "HYBRID" && get_movements_on_angle_passed_threshold()) return true;
		return false;
	};
	
	/**
	 * Move by the given vector. Angle of 0 corresponds to positive x axis.
	 *
	 * @param {Struct.PixelMove} pixel_move The PixelMove instance to move.
	 * @param {real} angle The angle of the vector in radians.
	 * @param {real} magnitude The magnitude of the vector.
	 * @ignore
	 */
	static move_by_vector = function (_angle, _magnitude) {
		_angle = __pixelmove_util_get_cleaned_angle(_angle);
		var _prev_real_x = get_real_x();
		var _prev_real_y = get_real_y();
		var _prev_int_x = pixel_move_get_x(self);
		var _prev_int_y = pixel_move_get_y(self);
		var _derive_from_line = get_derive_position_from_line();
		
		if (_angle != angle) {
			start_x = _prev_real_x;
			start_y = _prev_real_y;
			start_integer_x = _prev_int_x;
			start_integer_y = _prev_int_y;
		}
		
		if (_angle != angle || _magnitude == 0) {
			delta = 0;
			movements_on_angle = 0;
		}
		
		if (_magnitude == 0 || (_angle != angle && _derive_from_line)) {
			start_x = _prev_int_x;
			start_y = _prev_int_y;
		}
		
		delta += _magnitude;
		angle = _angle;
		movements_on_angle += 1;
	};
}

/**
 * Set the movement type to line. Movement will be mathematically perfect lines.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to set the movement type for.
 */
function pixel_move_set_movement_type_line(pixel_move) {
	pixel_move.movement_type = "LINE";
}

/**
 * Set the movement type to smooth. Movement will be responsive and fluid. This is most similar to drawing the real position rounded.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to set the movement type for.
 */
function pixel_move_set_movement_type_smooth(pixel_move) {
	pixel_move.movement_type = "SMOOTH";
}

/**
 * Set the movement type to hybrid. Movement will be responsive and fluid but change to mathematically perfect lines after repeated movements on the same angle.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to set the movement type for.
 */
function pixel_move_set_movement_type_hybrid(pixel_move) {
	pixel_move.movement_type = "HYBRID";
}

/**
 * Set the number of movements at same angle before position is derived from line equation when using hybrid type movement.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to set movements to infer from line threshold for.
 * @param {real} threshold The new number of movements to infer from line.
 */
function pixel_move_set_hybrid_movements_on_angle_to_infer_from_line(pixel_move, threshold) {
	pixel_move.movements_on_angle_to_infer_from_line = max(0, floor(abs(threshold)));
}

/**
 * Get the current x position.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to get the x position of.
 * @return {real}
 */
function pixel_move_get_x(pixel_move) {
	with (pixel_move) {
		if (movement_type == "LINE") return get_line_x();
		if (movement_type == "SMOOTH") return get_true_x();
		// must be hybrid
		return get_movements_on_angle_passed_threshold() ? get_line_x() : get_true_x();
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
		if (movement_type == "LINE") return get_line_y();
		if (movement_type == "SMOOTH") return get_true_y();
		// must be hybrid
		return get_movements_on_angle_passed_threshold() ? get_line_y() : get_true_y();
	}
}

/**
 * Set the x,y position. 
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to set the x and y position of.
 * @param {real} x The new x position.
 * @param {real} y The new y position.
 */
function pixel_move_set_position(pixel_move, x, y) {
	x = floor(x);
	y = floor(y);
	with (pixel_move) {
		start_x = x;
		start_y = y;
		start_integer_x = x;
		start_integer_y = y;
		delta = 0;
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
 * Get the position after movement by the given vector. Does not mutate the given PixelMove instance.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to get the potential position of.
 * @param {real} angle The angle in radians of the vector.
 * @param {real} magnitude The magnitude of the vector.
 */
function pixel_move_get_position_if_moved_by_vector(pixel_move, angle, magnitude) {
	var _pre_move_start_x = pixel_move.start_x;
	var _pre_move_start_y = pixel_move.start_y;
	var _pre_move_start_integer_x = pixel_move.start_integer_x;
	var _pre_move_start_integer_y = pixel_move.start_integer_y;
	var _pre_move_angle = pixel_move.angle;
	var _pre_move_delta = pixel_move.delta;
	var _pre_move_movements_on_angle = pixel_move.movements_on_angle;
	
	pixel_move_by_vector(pixel_move, angle, magnitude);
	var _result = { x: pixel_move_get_x(pixel_move), y: pixel_move_get_y(pixel_move) };
	
	pixel_move.start_x = _pre_move_start_x;
	pixel_move.start_y = _pre_move_start_y;
	pixel_move.start_integer_x = _pre_move_start_integer_x;
	pixel_move.start_integer_y = _pre_move_start_integer_y;
	pixel_move.angle = _pre_move_angle;
	pixel_move.delta = _pre_move_delta;
	pixel_move.movements_on_angle = _pre_move_movements_on_angle;
	
	return _result;
}

/**
 * Get the position after movement by the given x and y magnitudes. Does not mutate the given PixelMove instance.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to get the potential position of.
 * @param {real} magnitude_x The x magnitude.
 * @param {real} magnitude_y The y magnitude.
 */
function pixel_move_get_position_if_moved_by_magnitudes(pixel_move, magnitude_x, magnitude_y) {
	var _angle = arctan2(magnitude_y, magnitude_x);
	var _m = sqrt(sqr(magnitude_x) + sqr(magnitude_y));
	return pixel_move_get_position_if_moved_by_vector(pixel_move, _angle, _m);
}

/**
 * Move by the given vector. Angle of 0 corresponds to positive x axis. Movement on x and/or y axis will stop once
 * against callback returns true.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to move.
 * @param {real} angle The angle of the vector in radians.
 * @param {real} magnitude The magnitude of the vector.
 * @param {function} against Callback function defined as: (x: Real, y: Real) returns Bool. Movement along axis will stop if this function returns true for a given position.
 */
function pixel_move_by_vector_against(pixel_move, angle, magnitude, against) {
	angle = __pixelmove_util_get_cleaned_angle(angle);

	var _magnitude_x = __pixelmove_util_get_x_component(angle, magnitude);
	var _magnitude_y = __pixelmove_util_get_y_component(angle, magnitude);

	var _x_angle = angle >= 3*pi/2 || angle <= pi/2 ? 0 : pi;
	var _y_angle = angle >= 0 && angle <= pi ? pi/2 : 3*pi/2;

	var _pot_pos_if_move_by_x_angle = pixel_move_get_position_if_moved_by_vector(pixel_move, _x_angle, _magnitude_x == 0 ? 0 : 1);
	var _place_meeting_x_angle = against(_pot_pos_if_move_by_x_angle.x, _pot_pos_if_move_by_x_angle.y);

	var _pot_pos_if_move_by_y_angle = pixel_move_get_position_if_moved_by_vector(pixel_move, _y_angle, _magnitude_y == 0 ? 0 : 1);
	var _place_meeting_y_angle = against(_pot_pos_if_move_by_y_angle.x, _pot_pos_if_move_by_y_angle.y);

	var _pot_pos_if_move_by_original_angle = pixel_move_get_position_if_moved_by_magnitudes(pixel_move, sign(_magnitude_x), sign(_magnitude_y));
	var _place_meeting_original_angle = against(_pot_pos_if_move_by_original_angle.x, _pot_pos_if_move_by_original_angle.y) || _place_meeting_x_angle || _place_meeting_y_angle;

	var _collision_angle = angle;
	var _max_delta = magnitude;
	if (_place_meeting_original_angle && !_place_meeting_x_angle){
		_collision_angle = _x_angle;
		_max_delta = abs(_magnitude_x);
	} else if (_place_meeting_original_angle && !_place_meeting_y_angle) {
		_collision_angle = _y_angle;
		_max_delta = abs(_magnitude_y);
	}

	var _checking = !_place_meeting_x_angle || !_place_meeting_y_angle || !_place_meeting_original_angle;
	var _mod_delta = 0;
	var _increased_delta = min(_max_delta, _mod_delta + 1);
	while (_checking) {
		var _pos = pixel_move_get_position_if_moved_by_vector(pixel_move,_collision_angle, _increased_delta);
		var _place_meeting = against(_pos.x, _pos.y);
		_checking = false;
		if (!_place_meeting) {
			_mod_delta = _increased_delta
			if (_mod_delta < _max_delta) _checking = true;
		}
		_increased_delta = min(_max_delta, _mod_delta + 1);
	}
	
	pixel_move_by_vector(pixel_move, _collision_angle, _mod_delta);
}

/**
 * Move by the given x and y magnitudes. Movement on x and/or y axis will stop once
 * against callback returns true.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to move.
 * @param {real} magnitude_x The x magnitude.
 * @param {real} magnitude_y The y magnitude.
 * @param {function} against Callback function defined as: (x: Real, y: Real) returns Bool. Movement along axis will stop if this function returns true for a given position.
 */
function pixel_move_by_magnitudes_against(pixel_move, magnitude_x, magnitude_y, against) {
	var _angle = arctan2(magnitude_y, magnitude_x);
	var _m = sqrt(sqr(magnitude_x) + sqr(magnitude_y));
	pixel_move_by_vector_against(pixel_move, _angle, _m, against);
}

/**
 * Get the position after movement by the given vector using the against callback. Does not mutate the given PixelMove instance.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to get the potential position of.
 * @param {real} angle The angle in radians of the vector.
 * @param {real} magnitude The magnitude of the vector.
 * @param {function} against Callback function defined as: (x: Real, y: Real) returns Bool. Movement along axis will stop if this function returns true for a given position.
 */
function pixel_move_get_position_if_moved_by_vector_against(pixel_move, angle, magnitude, against) {
	var _pre_move_start_x = pixel_move.start_x;
	var _pre_move_start_y = pixel_move.start_y;
	var _pre_move_start_integer_x = pixel_move.start_integer_x;
	var _pre_move_start_integer_y = pixel_move.start_integer_y;
	var _pre_move_angle = pixel_move.angle;
	var _pre_move_delta = pixel_move.delta;
	var _pre_move_movements_on_angle = pixel_move.movements_on_angle;
	
	pixel_move_by_vector_against(pixel_move, angle, magnitude, against);
	var _result = { x: pixel_move_get_x(pixel_move), y: pixel_move_get_y(pixel_move) };
	
	pixel_move.start_x = _pre_move_start_x;
	pixel_move.start_y = _pre_move_start_y;
	pixel_move.start_integer_x = _pre_move_start_integer_x;
	pixel_move.start_integer_y = _pre_move_start_integer_y;
	pixel_move.angle = _pre_move_angle;
	pixel_move.delta = _pre_move_delta;
	pixel_move.movements_on_angle = _pre_move_movements_on_angle;
	
	return _result;
}

/**
 * Get the position after movement by the given x and y magnitudes using the against callback. Does not mutate the given PixelMove instance.
 *
 * @param {Struct.PixelMove} pixel_move The PixelMove instance to get the potential position of.
 * @param {real} magnitude_x The x magnitude.
 * @param {real} magnitude_y The y magnitude.
 * @param {function} against Callback function defined as: (x: Real, y: Real) returns Bool. Movement along axis will stop if this function returns true for a given position.
 */
function pixel_move_get_position_if_moved_by_magnitudes_against(pixel_move, magnitude_x, magnitude_y, against) {
	var _angle = arctan2(magnitude_y, magnitude_x);
	var _m = sqrt(sqr(magnitude_x) + sqr(magnitude_y));
	return pixel_move_get_position_if_moved_by_vector_against(pixel_move, _angle, _m, against);
}
