/**
 * An object that uses a linear algorithm to derive its position. This
 * ensures that any position changes appear smooth and consistent.
 * 
 * @param {real} _x starting x position
 * @param {real} _y starting y position
 */
function SmoothMove(_x, _y) constructor {
	start_x = _x;
	start_y = _y;
	angle = 0;
	delta = 0;
	
	/*
	This data allows for checking between the calculated position following the strict
	linear line algorithm, and what the position would have been if position was
	calculated normally.
	*/
	error_correction = {
		start_x: start_x,
		start_y: start_y,
		component_x: 0,
		component_y: 0,
	};
	
	// decides if collisions from callback still trigger individual x/y movement
	slide_on_collide = true;
	
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
	 * Returns the given angle in radians rounded roughly towards the cardinal directions
	 * and their intermediates.
	 *
	 * @param {real} _angle
	 */
	function snap_to_cardinals(_angle) {
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
	 * @param {real} _value
	 */
	function round_to_thousandths(_value) {
		var _result = floor(_value * 1000 + 0.5) / 1000;
		return _result;
	}
	
	/**
	 * Given real _a and real _b, returns _a rounded in the direction of _b. It is possible for 
	 * sign(result - _b) to be different from sign(_a - _b) if _a and _b have the same whole
	 * number value.
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
	 */
	infer_y_from_x = function() {
		return (angle <= 1*pi/4 || angle >= 7*pi/4 || (angle >= 3*pi/4 && angle <= 5*pi/4));
	};
	
	/**
	 * Get the x magnitude given the given angle and delta.
	 */
	get_magnitude_x = function() {
		return snap_cos(angle) * delta;
	}
	
	/**
	 * Get the y magnitude given the current angle and delta.
	 */
	get_magnitude_y = function() {
		return snap_sin(angle) * delta;
	};
	
	/**
	 * Get the x component of the given vector.
	 *
	 * @param {real} _angle
	 * @param {real} _delta
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
	 */
	function get_y_component(_angle, _delta) {
		if (_delta == 0 || _angle == 0 || _angle == 4*pi/4) return 0;
		return snap_sin(_angle) * _delta;
	}

	
	/**
	 * Get the slope to be used to infer an x or y position. The slope changes depending on
	 * whether the x or y magnitude of the 2D vector is greater.
	 */
	slope = function() {
		if (delta == 0) return 0;
		var _magnitude_x = get_magnitude_x();
		var _magnitude_y = get_magnitude_y();
		return infer_y_from_x() ? get_magnitude_y() / get_magnitude_x() : get_magnitude_x() / get_magnitude_y();
	}
	
	/**
	 * Resets the start and delta values of this instance.
	 */
	reset = function() {
		var _x = smooth_move_get_x(self);
		var _y = smooth_move_get_y(self);
		start_x = _x;
		start_y = _y;
		delta = 0;
	};
}

/**
 * Sets the slide on collide property of the given SmoothMove instance. When set to false, collisions
 * forbid any movement once detected. When true, SmoothMove will attempt to move along the x and y
 * axis separately.
 *
 * @param {Struct.SmoothMove} _smooth_move
 * @param {bool} _slide_on_collide
 */
function smooth_move_set_slide_on_collide(_smooth_move, _slide_on_collide) {
	_smooth_move.slide_on_collide = _slide_on_collide;
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
			var _change = get_magnitude_x();
			var _x = start_x + _change;
			var _result = round_towards(_x, start_x);
			return _result;
		}
		
		// derive x position from linear line function of y
		var _slope = slope();
		var _y_diff = smooth_move_get_y(self) - start_y;
		var _x = round_to_thousandths(_slope * _y_diff + start_x);
		return round_towards(_x, start_x);
	}
}

/**
 * Get the current y position of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move
 */
function smooth_move_get_y(_smooth_move) {
	with (_smooth_move) {
		if (delta == 0) return start_y;
		if (!infer_y_from_x()) {
			var _change = get_magnitude_y();
			var _y = start_y + _change;
			var _result = round_towards(_y, start_y);
			return _result;
		}
		
		// derive y position from linear line function of x
		var _slope = slope();
		var _x_diff = smooth_move_get_x(self) - start_x;
		var _y = round_to_thousandths(_slope * _x_diff + start_y);
		return round_towards(_y, start_y);
	}
}

/**
 * Sets the position of the given SmoothMove instance.
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
		error_correction.start_x = _x;
		error_correction.start_y = _y;
		error_correction.component_x = 0;
		error_correction.component_y = 0;
	}
}

/**
 * @param {real} _x
 * @param {real} _y
 * @ignore
 */
function smooth_move_default_collide(_x, _y) {
	return false;
}

/**
 * Move the given SmoothMove instance by the given vector. Angle of 0 corresponds to straight along positive x axis
 *
 * @param {Struct.SmoothMove} _smooth_move
 * @param {real} _angle angle of vector in radians
 * @param {real} _delta magnitude of vector
 * @param {function} _collide
 */
function smooth_move_by_vector(_smooth_move, _angle, _delta, _collide = smooth_move_default_collide) {
	with (_smooth_move) {
		var _pre_move_x = smooth_move_get_x(self);
		var _pre_move_y = smooth_move_get_y(self);
		if (_angle < 0) _angle = _angle % (-2*pi) + 2*pi;
		if (_angle >= 2*pi) _angle %= 2*pi;
		_angle = snap_to_cardinals(_angle);
		
		if ((_delta == 0) || (abs(angle - _angle) >= pi/4)) {
			error_correction.component_x = 0;
			error_correction.component_y = 0;
			error_correction.start_x = smooth_move_get_x(self);
			error_correction.start_y = smooth_move_get_y(self);
		}
		var _angle_changed = angle != _angle;
		if ((_delta == 0) || _angle_changed) reset();
		
		angle = _angle;
		delta += _delta;
		
		error_correction.component_x += get_x_component(_angle, _delta);
		error_correction.component_y += get_y_component(_angle, _delta);
		
		var _calculated_x = smooth_move_get_x(self);
		var _calculated_y = smooth_move_get_y(self);
		
		var _error_x = round_towards(error_correction.start_x + error_correction.component_x, error_correction.start_x);
		var _error_y = round_towards(error_correction.start_y + error_correction.component_y, error_correction.start_y);
		
		var _error = sqrt(sqr(_error_x - _calculated_x) + sqr(_error_y - _calculated_y));
		
		var _error_slope = 0;
		with (error_correction) if (component_x != 0 || component_y != 0) {
			_error_slope = component_x > component_y ? component_y / component_x : component_x / component_y;
		}
		
		var _same_equation = (slope() == _error_slope) && (start_x == error_correction.start_x) && (start_y == error_correction.start_y);
		
		if ((_error >= 1) && (_angle_changed || !_same_equation)) {
			/*
			If the error distance is greater than sqrt(2) (adjacent pixels), we'll set the smooth move position
			to a pixel in between it's calculated position and the error position.
			*/
			if (_error > sqrt(2)) {
				start_x = round_towards((_error_x - _calculated_x) / 2 + _calculated_x, start_x);
				start_y = round_towards((_error_y - _calculated_y) / 2 + _calculated_y, start_y);
			} else if (_error_x != _calculated_x && _error_y != _calculated_y) {
				error_correction.start_x = _error_x;
				error_correction.start_y = _error_y;
				error_correction.component_x = 0;
				error_correction.component_y = 0;
				start_x = _error_x;
				start_y = _error_y;
			} else {
				start_x = _error_x;
				start_y = _error_y;
			}
			delta = 0;
		}
		
		var _final_x = smooth_move_get_x(self);
		var _final_y = smooth_move_get_y(self);
		
		// final position has been calculated, now check for collisions
		var _mod_x = sign(_final_x - _pre_move_x);
		var _mod_y = sign(_final_y - _pre_move_y);
		
		var _check_x = _pre_move_x;
		var _check_y = _pre_move_y;
		var _colliding = true;
		
		while (_colliding) {
			var _collision = _collide(_check_x + _mod_x, _check_y + _mod_y);
			if (!_collision) {
				_check_x = _check_x == _final_x ? _final_x : _check_x + _mod_x;
				_check_y = _check_y == _final_y ? _final_y : _check_y + _mod_y;
			}
			if (_collision && !slide_on_collide) { 
				_colliding = false;
				start_x = _check_x;
				start_y = _check_y;
				delta = 0;
				error_correction.start_x = _pre_move_x;
				error_correction.start_y = _pre_move_y;
				error_correction.component_x = _check_x - _pre_move_x;
				error_correction.component_y = _check_y - _pre_move_y;
			}
			if (_collision && slide_on_collide) {
				var _moved = false;
				if (!_collide(_check_x + _mod_x, _check_y)) {
					_check_x += _mod_x;
					_moved = true;
				}
				if (!_collide(_check_x, _check_y + _mod_y)) {
					_check_y += _mod_y;
					_moved = true;
				}
				if (_check_x == _final_x || _check_y == _final_y || !_moved) {
					_colliding = false;
					start_x = _check_x;
					start_y = _check_y;
					delta = 0;
					/*
					Error vector is only way we have of tracking how far instance should have moved.
					Only change values if final was not reached.
					*/
					if (_check_x != _final_x) error_correction.start_x = _pre_move_x;
					if (_check_y != _final_y) error_correction.start_y = _pre_move_y;
					if (_check_x != _final_x) error_correction.component_x = _check_x - _pre_move_x;
					if (_check_y != _final_y) error_correction.component_y = _check_y - _pre_move_y;
				}
			}
			if (_check_x == _final_x && _check_y == _final_y) {
				_colliding = false;
			}
		}
		
		return {
			change_x: _check_x - _pre_move_x,
			change_y: _check_y - _pre_move_y,
		};
	}
}

/**
 * Move the given SmoothMove instance by the vector formed by the given x and y magnitudes.
 *
 * @param {Struct.SmoothMove} _smooth_move
 * @param {real} _magnitude_x
 * @param {real} _magnitude_y
 */
function smooth_move_by_magnitudes(_smooth_move, _magnitude_x, _magnitude_y) {
	with (_smooth_move) {
		var _angle = arctan2(_magnitude_y, _magnitude_x);
		var _delta = sqrt(sqr(_magnitude_x) + sqr(_magnitude_y));
		smooth_move_by_vector(_smooth_move, _angle, _delta);
	}
}
