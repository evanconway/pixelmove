/**
 * A line equation that infers y from x, or x from y depending on the angle.
 * @param {real} _angle
 * @param {real} _delta
 */
function SmoothLine(_angle, _delta) constructor {
	// @ignore
	angle = _angle;
	// @ignore
	delta = _delta;
	
	/**
	 * @param {real} _value
	 * @ignore
	 */
	function round_to_thousandths(_value) {
		return floor(_value * 1000 + 0.5) / 1000;
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
	 * @param {real} _angle
	 * @param {real} _delta
	 * @ignore
	 */
	set = function(_angle, _delta) {
		angle = get_cleaned_angle(_angle);
		delta = _delta;
	};
	
	/**
	 * Returns if y is inferred from x, or x is inferred from y.
	 *
	 * @ignore
	 */
	infer_y_from_x = function() {
		return (angle <= 1*pi/4 || angle >= 7*pi/4 || (angle >= 3*pi/4 && angle <= 5*pi/4));
	};
	
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
	 * Get the x magnitude given the current angle and delta.
	 *
	 * @ignore
	 */
	get_magnitude_x = function() {
		return snap_cos(angle) * delta;
	};
	
	/**
	 * Get the y magnitude given the current angle and delta.
	 *
	 * @ignore
	 */
	get_magnitude_y = function() {
		return snap_sin(angle) * delta;
	};
	
	/**
	 * Get the slope to be used to infer an x or y position. The slope changes depending on
	 * whether the x or y magnitude of the 2D vector is greater.
	 *
	 * @ignore
	 */
	slope = function() {
		if (delta == 0) return 0;
		return infer_y_from_x() ? get_magnitude_y() / get_magnitude_x() : get_magnitude_x() / get_magnitude_y();
	}
	
	// @ignore
	get_copy = function() {
		return new SmoothLine(angle, delta);
	};
}
