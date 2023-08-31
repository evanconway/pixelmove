/**
 * An object that uses a linear algorithm to derive its position. This
 * ensures that any position changes appear smooth and consistent.
 * 
 * @param {real} _x starting x position
 * @param {real} _y starting y position
 */
function SmoothMove(_x, _y) constructor {
	vector = {
		angle: 0,
		magnitude: 0,
	};
	movements = 1; // number of times instance has moved by vector
	
	start_x = floor(_x + 0.5);
	start_y = floor(_y + 0.5);
	
	/**
	 * Rounds given value to 0 if within tolerance range. This is mostly to deal
	 * with sin and cos not returning a perfect 0 on certain values.
	 *
	 * @param {real} _value
	 */
	function tolerance(_value) {
		return abs(_value) < 0.001 ? 0 : _value;
	};
}

/**
 * Get the x magnitude of the vector of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move
 */
function smooth_move_get_vector_magnitude_x(_smooth_move) {
		var _x_magnitude = _smooth_move.tolerance(sin(_smooth_move.vector.angle));
		return _x_magnitude * _smooth_move.vector.magnitude;
}

/**
 * Get the y magnitude of the vector of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move
 */
function smooth_move_get_vector_magnitude_y(_smooth_move) {
		var _y_magnitude = _smooth_move.tolerance(cos(_smooth_move.vector.angle));
		return _y_magnitude * _smooth_move.vector.magnitude;
}

/**
 * Get the current x position of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move
 */
function smooth_move_get_x(_smooth_move) {
	var _x_magnitude = smooth_move_get_vector_magnitude_x(_smooth_move) * _smooth_move.movements;
	return _smooth_move.start_x + (_x_magnitude > 0 ? floor(_x_magnitude) : ceil(_x_magnitude));
}

/**
 * Get the current y position of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move
 */
function smooth_move_get_y(_smooth_move) {
		var _y_magnitude = smooth_move_get_vector_magnitude_y(_smooth_move) * _smooth_move.movements;
	return _smooth_move.start_y - (_y_magnitude > 0 ? floor(_y_magnitude) : ceil(_y_magnitude));
}

/**
 * Increments the given SmoothMove instance along its current vector.
 *
 * @param {Struct.SmoothMove} _smooth_move 
 */
function smooth_move_advance(_smooth_move) {
	_smooth_move.movements += 1;
}

/**
 * Set the vector of the given SmoothMove instance.
 *
 * @param {Struct.SmoothMove} _smooth_move 
 * @param {real} _angle new vector angle in radians
 * @param {real} _magnitude new vector magnitude
 */
function smooth_move_set_vector(_smooth_move, _angle, _magnitude) {
	while (_angle < 0) _angle += 2*pi;
	with (_smooth_move) {
		if (_angle == vector.angle && _magnitude == vector.magnitude) return;
		start_x = smooth_move_get_x(self);
		start_y = smooth_move_get_y(self);
		vector.angle = _angle;
		vector.magnitude = _magnitude;
		movements = 0;
	}
}

/**
 * @param {Struct.SmoothMove} _smooth_move
 * @param {real} _angle angle of vector in radians
 * @param {real} _magnitude magnitude of vector
 */
function smooth_move_by_vector(_smooth_move, _angle, _magnitude) {
	smooth_move_set_vector(_smooth_move, _angle, _magnitude);
	smooth_move_advance(_smooth_move);
}
