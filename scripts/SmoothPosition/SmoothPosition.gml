// feather ignore all

/**
 * A position tracker that only returns integer positions.
 * 
 * @param {Real} _start_x The starting x position.
 * @param {Real} _start_y The starting y position.
 * @ignore
 */
function __SmoothPosition(_start_x, _start_y) constructor {
	// @ignore
	start_x = floor(_start_x);
	// @ignore
	start_y = floor(_start_y);
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
		var _x = get_x();
		var _y = get_y();
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
	
	/**
	 * @ignore
	 */
	get_x = function() {
		return get_movements_on_angle_passed_threshold() ? line.get_x(start_x, start_y) : get_true_round_to_start_x();
	};
	
	/**
	 * @ignore
	 */
	get_y = function() {
		return get_movements_on_angle_passed_threshold() ? line.get_y(start_x, start_y) : get_true_round_to_start_y();
	};
	
	/**
	 * Move by the given vector. Angle of 0 corresponds to positive x axis
	 *
	 * @param {real} _angle angle of vector in radians
	 * @param {real} _magnitude magnitude of vector
	 * @ignore
	 */
	move_by_vector = function(_angle, _magnitude) {		
		_angle = __smoothmove_util_get_cleaned_angle(_angle);
		var _angle_changed = line.angle != _angle;
		
		// reset line data on no movement or angle change
		if ((_magnitude == 0) || _angle_changed) reset_line_to_current();
		
		
		// reset true data on no movement or too great an angle change
		//if ((_magnitude == 0) || __smoothmove_util_get_angle_diff(line.angle, _angle) >= pi/4) {
		if (_magnitude == 0) {
			true_x = get_x();
			true_y = get_y();
		}
		
		line.set(_angle, line.delta + _magnitude);
		
		// error correct based on true value
		true_x += __smoothmove_util_get_x_component(_angle, _magnitude);
		true_y += __smoothmove_util_get_y_component(_angle, _magnitude);
		var _error = sqrt(sqr(get_true_round_to_start_x() - get_x()) + sqr(get_true_round_to_start_y() - get_y()));
		
		// determine if this movement crossed the movements_on_angle threshold, and new error
		var _threshold_cross_before_movements_on_angle_change = get_movements_on_angle_passed_threshold();
		movements_on_angle += 1;
		var _crossed_delta_line_threshold = get_movements_on_angle_passed_threshold() != _threshold_cross_before_movements_on_angle_change;
		var _post_delta_change_error = sqrt(sqr(get_true_round_to_start_x() - get_x()) + sqr(get_true_round_to_start_y() - get_y()));
		
		// correct line towards error
		if ((!get_movements_on_angle_passed_threshold() && _error >= 1) || (_post_delta_change_error >= 1 && _crossed_delta_line_threshold)) {
			start_x = get_true_round_to_start_x();
			start_y = get_true_round_to_start_y();
			line.delta = 0;
		}
		
		// correct error towards line once passed threshold
		if (get_movements_on_angle_passed_threshold()) {
			true_x = get_x();
			true_y = get_y();
		}
	};
	
	/**
	 * @ignore
	 */
	copy = function() {
		var _copy = new __SmoothPosition(start_x, start_y);
		_copy.start_x = start_x;
		_copy.start_y = start_y;
		_copy.line = line.copy();
		_copy.true_x = true_x;
		_copy.true_y = true_y;
		_copy.movements_on_angle = movements_on_angle;
		_copy.movements_on_angle_to_infer_from_line = movements_on_angle_to_infer_from_line;
		return _copy;
	}
	
	/**
	 * @param {real} _x
	 * @param {real} _y
	 * @ignore
	 */
	set = function(_x, _y) {
		_x = floor(_x);
		_y = floor(_y);
		start_x = _x;
		start_y = _y;
		true_x = start_x;
		true_y = start_y;
		line.delta = 0;
		movements_on_angle = 0;	
	};
}
