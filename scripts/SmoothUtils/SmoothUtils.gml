// feather ignore all

/**
* Given real _a and real _b, returns _a rounded in the direction of _b. It is possible for 
* sign(result - _b) to be different from sign(_a - _b) if _a and _b have the same whole
* number value.
*
* @ignore
*/
function __smoothmove_util_round_towards(_a, _b) {
	var _result = (_a - _b) >= 0 ? floor(_a) : ceil(_a);
	return _result == 0 ? 0 : _result; // prevents -0
}

/**
* Rounding function to account for gamemaker's imperfect real tracking
*
* @param {real} _value
* @ignore
*/
function __smoothmove_util_round_to_correct(_value) {
	return floor(_value * 100000 + 0.5) / 100000;
}


/**
* Round given value to 0 if it's already close. This is mostly to deal
* with sin and cos not returning a perfect 0 on certain values.
*
* @param {real} _value
* @ignore
*/
function __smoothmove_util_snap_to_zero(_value) {
	return abs(_value) < 0.001 ? 0 : _value;
};
	
/**
* Wrapper function around sin that snaps the result to 0 if it's within 0.001 of 0.
*
* @param {real} _angle angle in radians
* @ignore
*/
function __smoothmove_util_snap_sin(_angle) {
	return __smoothmove_util_snap_to_zero(sin(_angle));
}
	
/**
* Wrapper function around cos that snaps the result to 0 if it's within 0.001 of 0.
*
* @param {real} _angle angle in radians
* @ignore
*/
function __smoothmove_util_snap_cos(_angle) {
	return __smoothmove_util_snap_to_zero(cos(_angle));
}

/**
 * Returns an angle between 0 and 2pi that is coterminal with the given angle.
 *
 * @param {real} angle
 */
function get_normal_coterminal(angle) {
	return ((angle % (2*pi)) + (2*pi)) % (2*pi);
}

/**
* Return the given angle in radians transformed to the equivalent position and rounded
* roughly towards the cardinal directions and their intermediates.
*
* @param {real} _angle
* @ignore
*/
function __smoothmove_util_get_cleaned_angle(_angle) {
	_angle = get_normal_coterminal(_angle);
	
	var round_to_thousandths = function(_value) {
		return floor(_value * 1000 + 0.5) / 1000;
	};
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
* Get the difference in radians between 2 angles. Favors the shortest distance.
* For example using 7*pi/4 and 1*pi/4 will return a difference of 2*pi/4.
* 
* @param {real} _a angle a in radians
* @param {real} _b angle b in radians
* @ignore
*/
function __smoothmove_util_get_angle_diff(_a, _b) {
	_a = __smoothmove_util_get_cleaned_angle(_a);
	_b = __smoothmove_util_get_cleaned_angle(_b);
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
function __smoothmove_util_get_x_component(_angle, _delta) {
	_angle = __smoothmove_util_get_cleaned_angle(_angle);
	if (_delta == 0 || _angle == 2*pi/4 || _angle == 6*pi/4) return 0;
	return __smoothmove_util_snap_cos(_angle) * _delta;
}
	
/**
	* Get the y component of the given vector.
	*
	* @param {real} _angle
	* @param {real} _delta
	* @ignore
	*/
function __smoothmove_util_get_y_component(_angle, _delta) {
	_angle = __smoothmove_util_get_cleaned_angle(_angle);
	if (_delta == 0 || _angle == 0 || _angle == 4*pi/4) return 0;
	return __smoothmove_util_snap_sin(_angle) * _delta;
}
