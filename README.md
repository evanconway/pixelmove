# PixelMove

A GameMaker package to quickly setup pixel perfect movement in low resolution environments.

### The Problem
When moving elements around in very low resolution environments, there is a frustrating stairstep effect that happens when moving at non-integer values on certain diagonals.

![Stairstep Example](https://github.com/AceOfHeart5/pixelmove/blob/main/example%20gifs/pixelmove_stairsteps.gif)

By default, GameMaker floors non-integer x and y values when drawing them, as seen in the above gif. Unfortunately no matter how a position is rounded there will always be inconsistent stairstep style changes on a diagonal:

| Rounding       | Position   |  Result   |
| ----------- | ----------- | -----------|
| floor, floor | 0.5, -0.5 | 0, -1 |
| floor, ceil | 0.5, 0.5 | 0, 1 |
| ceil, ceil | 0.5, -0.5 | 1, 0 |

The effect in motion is jagged and messy looking.

![Stairstep Fast Example](https://github.com/AceOfHeart5/pixelmove/blob/main/example%20gifs/pixelmove_stairsteps_fast.gif)

In order for pixel-by-pixel motion with non-integer changes to look consistent, the result of any position adjustments has to have consistent change regardless of the direction.

That is what PixelMove does.

```
// create event
pixel_move = new PixelMove(0, 0);

// step event
pixel_move_by_vector(pixel_move, pi/4, 1);

// or...
pixel_move_by_magnitudes(pixel_move, 0.5, -0.5);

// draw event
x = pixel_move_get_x(pixel_move);
y = pixel_move_get_y(pixel_move);
```

PixelMove maintains its position internally and yeilds consistent integer positions regardless of the vector changes applied to it.

![Fixed Example](https://github.com/AceOfHeart5/pixelmove/blob/main/example%20gifs/pixelmove_fixed_movement.gif)

The result is pixel-by-pixel movement that is smoother and much more consistent.

![Fixed Fast Example](https://github.com/AceOfHeart5/pixelmove/blob/main/example%20gifs/pixelmove_fixed_movement_fast.gif)

Check out the [demo at itch.io](https://gla55world.itch.io/pixelmove-demo) for more examples.

# Functions
`PixelMove`
 
Create a new **PixelMove** instance.

_Full function name:_  `PixelMove(start_position_x, start_position_y)`
 
_Returns:_  `Struct.PixelMove`

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| start_position_x | Real | The starting x position. |
| start_position_y | Real | The starting y position. |
---

`pixel_move_set_movement_type_line`

Set the movement type to line. Movement will be mathematically perfect lines.

_Full function name:_  `pixel_move_set_movement_type_line(pixel_move)`

_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| pixel_move | Struct.PixelMove | The PixelMove instance to set the movement type for. |
---

`pixel_move_set_movement_type_smooth`

Set the movement type to smooth. Movement will be responsive and fluid. This is most similar to drawing the real position rounded.

_Full function name:_  `pixel_move_set_movement_type_smooth(pixel_move)`

_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| pixel_move | Struct.PixelMove | The PixelMove instance to set the movement type for. |
---

Set the movement type to hybrid. Movement will be responsive and fluid but change to mathematically perfect lines after repeated movements on the same angle.

_Full function name:_  `pixel_move_set_movement_type_hybrid(pixel_move)`

_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| pixel_move | Struct.PixelMove | The PixelMove instance to set the movement type for. |
---

`pixel_move_set_hybrid_movements_on_angle_to_infer_from_line`

Set the number of movements at same angle before position is derived from line equation when using hybrid type movement.

_Full function name:_  `pixel_move_set_delta_line_threshold(pixel_move, threshold)`

_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| pixel_move | Struct.PixelMove | The PixelMove instance to set the threshold for. |
| threshold | Real | The new delta threshold. |
---

`pixel_move_get_x`

Get the current x position.

_Full function name:_  `pixel_move_get_x(pixel_move)`

_Returns:_  `Real`

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| pixel_move | Struct.PixelMove | The PixelMove instance to get the x position of. |
---

`pixel_move_get_y`

Get the current y position.

_Full function name:_  `pixel_move_get_y(pixel_move)`

_Returns:_  `Real`

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| pixel_move | Struct.PixelMove | The PixelMove instance to get the y position of. |
---

`pixel_move_set_position`

Set the x,y position.

_Full function name:_  `pixel_move_set_position(pixel_move, x, y)`

_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| pixel_move | Struct.PixelMove | The PixelMove instance to set the x and y position of. |
| x | Real | The new x position. |
| y | Real | The new y position. |
---

`pixel_move_by_vector`

Move by the given vector. Angle of 0 corresponds to positive x axis.

_Full function name:_  `pixel_move_by_vector(pixel_move, angle, magnitude)`

_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| pixel_move | Struct.PixelMove | The PixelMove instance to move. |
| angle | Real | The angle of the vector in radians. |
| magnitude | Real | The magnitude of the vector. |
---

`pixel_move_by_magnitudes`

Move by the given x and y magnitudes.

_Full function name:_  `pixel_move_by_magnitudes(pixel_move, magnitude_x, magnitude_y)`

_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| pixel_move | Struct.PixelMove | The PixelMove instance to move. |
| magnitude_x | Real | The x magnitude. |
| magnitude_y | Real | The y magnitude. |
---

`pixel_move_get_position_if_moved_by_vector`

Get the position after movement by the given vector. Does not mutate the given PixelMove instance.

_Full function name:_  `pixel_move_get_position_if_moved_by_vector(pixel_move, angle, magnitude)`

_Returns:_  `{ x: Real, y: Real}`

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| pixel_move | Struct.PixelMove | The PixelMove instance to get the potential position of. |
| angle | Real | The angle in radians of the vector. |
| magnitude | Real | The magnitude of the vector. |
---

`pixel_move_get_position_if_moved_by_magnitudes`

Get the position after movement by the given x and y magnitudes. Does not mutate the given PixelMove instance.

_Full function name:_  `pixel_move_get_position_if_moved_by_magnitudes(pixel_move, magnitude_x, magnitude_y)`

_Returns:_  `{ x: Real, y: Real}`

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| pixel_move | Struct.PixelMove | The PixelMove instance to get the potential position of. |
| magnitude_x | Real | The x magnitude. |
| magnitude_x | Real | The y magnitude. |
---

`pixel_move_by_vector_against`

Move by the given vector. Angle of 0 corresponds to positive x axis. Movement on x and/or y axis will stop once against callback returns true.

_Full function name:_  `pixel_move_by_vector_against(pixel_move, angle, magnitude, against)`

_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| pixel_move | Struct.PixelMove | The PixelMove instance to move. |
| angle | Real | The angle in radians of the vector. |
| magnitude | Real | The magnitude of the vector. |
| against | Function | Callback function defined as: (x: Real, y: Real) returns Bool. Movement along axis will stop if this function returns true for a given position. |
---

`pixel_move_by_magnitudes_against`

Move by the given x and y magnitudes. Movement on x and/or y axis will stop once against callback returns true.

_Full function name:_  `pixel_move_by_magnitudes_against(pixel_move, magnitude_x, magnitude_y, against)`

_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| pixel_move | Struct.PixelMove | The PixelMove instance to move. |
| magnitude_x | Real | The x magnitude. |
| magnitude_y | Real | The y magnitude. |
| against | Function | Callback function defined as: (x: Real, y: Real) returns Bool. Movement along axis will stop if this function returns true for a given position. |
---

`pixel_move_get_position_if_moved_by_vector_against`

Get the position after movement by the given vector using the against callback. Does not mutate the given PixelMove instance.

_Full function name:_  `pixel_move_get_position_if_moved_by_vector_against(pixel_move, angle, magnitude, against)`

_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| pixel_move | Struct.PixelMove | The PixelMove instance to get the potential position of. |
| angle | Real | The angle in radians of the vector. |
| magnitude | Real | The magnitude of the vector. |
| against | Function | Callback function defined as: (x: Real, y: Real) returns Bool. Movement along axis will stop if this function returns true for a given position. |
---

`pixel_move_get_position_if_moved_by_magnitudes_against`

Get the position after movement by the given x and y magnitudes using the against callback. Does not mutate the given PixelMove instance.

_Full function name:_  `pixel_move_get_position_if_moved_by_magnitudes_against(pixel_move, angle, magnitude, against)`

_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| pixel_move | Struct.PixelMove | The PixelMove instance to get the potential position of. |
| magnitude_x | Real | The x magnitude. |
| magnitude_y | Real | The y magnitude. |
| against | Function | Callback function defined as: (x: Real, y: Real) returns Bool. Movement along axis will stop if this function returns true for a given position. |
---
