/**
* Given real _a and real _b, returns _a rounded in the direction of _b. It is possible for 
* sign(result - _b) to be different from sign(_a - _b) if _a and _b have the same whole
* number value.
*
* @ignore
*/
function round_towards(_a, _b) {
	var _result = (_a - _b) >= 0 ? floor(_a) : ceil(_a);
	return _result == 0 ? 0 : _result; // prevents -0
}

/**
* Rounding function to account for gamemaker's imperfect real tracking
*
* @param {real} _value
* @ignore
*/
function round_to_correct(_value) {
	return floor(_value * 100000 + 0.5) / 100000;
}

/**
* Round given value to 0 if it's already close. This is mostly to deal
* with sin and cos not returning a perfect 0 on certain values.
*
* @param {real} _value
* @ignore
*/
function snap_to_zero(_value) {
	return abs(_value) < 0.001 ? 0 : _value;
};
	
/**
* Wrapper function around sin that snaps the result to 0 if it's within 0.001 of 0.
*
* @param {real} _angle angle in radians
* @ignore
*/
function snap_sin(_angle) {
	return snap_to_zero(sin(_angle));
}
	
/**
* Wrapper function around cos that snaps the result to 0 if it's within 0.001 of 0.
*
* @param {real} _angle angle in radians
* @ignore
*/
function snap_cos(_angle) {
	return snap_to_zero(cos(_angle));
}

/**
* Return the given angle in radians transformed to the equivalent position and rounded
* roughly towards the cardinal directions and their intermediates.
*
* @param {real} _angle
* @ignore
*/
function get_cleaned_angle(_angle) {
	if (_angle < 0) _angle = _angle % (-2*pi) + 2*pi;
	if (_angle >= 2*pi) _angle %= 2*pi;
	if (round_to_correct(_angle) == round_to_correct(0*pi/4)) _angle = 0*pi/4;
	if (round_to_correct(_angle) == round_to_correct(1*pi/4)) _angle = 1*pi/4;
	if (round_to_correct(_angle) == round_to_correct(2*pi/4)) _angle = 2*pi/4;
	if (round_to_correct(_angle) == round_to_correct(3*pi/4)) _angle = 3*pi/4;
	if (round_to_correct(_angle) == round_to_correct(4*pi/4)) _angle = 4*pi/4;
	if (round_to_correct(_angle) == round_to_correct(5*pi/4)) _angle = 5*pi/4;
	if (round_to_correct(_angle) == round_to_correct(6*pi/4)) _angle = 6*pi/4;
	if (round_to_correct(_angle) == round_to_correct(7*pi/4)) _angle = 7*pi/4;
	return _angle;
}

/**
* Get the difference in radians between 2 angles. Favors the shortest distance.
* For example using 7*pi/4 and 1*pi/4 will return a difference of 2*pi/4.
* 
* @param {real} _a angle a in radians
* @param {real} _b angle b in radians
* @ignore
*/
function get_angle_diff(_a, _b) {
	_a = get_cleaned_angle(_a);
	_b = get_cleaned_angle(_b);
	var _diff1 = abs(_a - _b);
	var _diff2 = 2*pi - _diff1;
	return min(_diff1, _diff2);
}

/**
	* Get the x component of the given vector.
	*
	* @param {real} _angle
	* @param {real} _delta
	* @ignore
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
	* @ignore
	*/
function get_y_component(_angle, _delta) {
	if (_delta == 0 || _angle == 0 || _angle == 4*pi/4) return 0;
	return snap_sin(_angle) * _delta;
}
