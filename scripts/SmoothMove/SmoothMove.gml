/**
 * @param {real} _x starting x position
 * @param {real} _y starting y position
 */
function SmoothMove(_x, _y) constructor {
	vector_angle = 0;
	vector_magnitude = 0;
	vector_magnitude_multiplier = 1;
	
	start_x = floor(_x);
	start_y = floor(_y);
	
	get_magnitudes_from_vector = function() {		
		var _result = { pos_x: start_x, pos_y: start_y };
		if (vector_magnitude == 0) return _result;
		
		var _x_magnitude = sin(vector_angle);
		var _y_magnitude = cos(vector_angle);
		
		var _tolerance = 0.001; // fixes bug where cos/sin do not return perfect 0
		_x_magnitude = abs(_x_magnitude) < _tolerance ? 0 : _x_magnitude;
		_y_magnitude = abs(_y_magnitude) < _tolerance ? 0 : _y_magnitude;
		
		_x_magnitude *= vector_magnitude_multiplier;
		_y_magnitude *= vector_magnitude_multiplier;
		
		_result.pos_x += _x_magnitude > 0 ? floor(_x_magnitude) : ceil(_x_magnitude);
		_result.pos_y -= _y_magnitude > 0 ? floor(_y_magnitude) : ceil(_y_magnitude);
		
		return _result;
	}
}

/**
 * Get the current x position of the given smooth move object.
 * @param {Struct.SmoothMove} _smooth_move
 */
function smooth_move_get_x(_smooth_move) {
	return _smooth_move.get_magnitudes_from_vector().pos_x;
}

/**
 * Get the current y position of the given smooth move object.
 * @param {Struct.SmoothMove} _smooth_move
 */
function smooth_move_get_y(_smooth_move) {
	return _smooth_move.get_magnitudes_from_vector().pos_y;
}

/**
 * @param {Struct.SmoothMove} _smooth_move
 * @param {real} _angle angle of vector in radians
 * @param {real} _magnitude magnitude of vector
 */
function smooth_move_vector(_smooth_move, _angle, _magnitude) {
	with (_smooth_move) {
		if (vector_angle != _angle || vector_magnitude != _magnitude) {
			start_x = smooth_move_get_x(self);
			start_y = smooth_move_get_y(self);
			vector_angle = _angle;
			while (vector_angle < 0) vector_angle += 2*pi;
			vector_magnitude = _magnitude;
			vector_magnitude_multiplier = 0;
		}
		vector_magnitude_multiplier++;
	}
}
