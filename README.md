# SmoothMove

A GameMaker package to make moving in clean, pixel perfect lines easier.


# Functions
`SmoothMove`
 
Create a new **SmoothMove** instance.

_Full function name:_  `SmoothMove(start_position_x, start_position_y)`
 
_Returns:_  `Struct.SmoothMove`

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| start_position_x | Real | The starting x position. |
| start_position_y | Real | The starting y position. |
---

`smooth_move_get_copy`
 
Get a copy of the given SmoothMove instance.

_Full function name:_  `smooth_move_get_copy(smooth_move)`

_Returns:_  `Struct.SmoothMove`

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| smooth_move | Struct.SmoothMove | The SmoothMove instance to copy. |
---

`smooth_move_set_delta_line_threshold`

Set the threshold for distance travelled before position is derived from line equation.

_Full function name:_  `smooth_move_set_delta_line_threshold(smooth_move, threshold)`

_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| smooth_move | Struct.SmoothMove | The SmoothMove instance to set the threshold for. |
| threshold | Real | The new delta threshold. |
---

`smooth_move_show_stairsteps`

Set whether to show or hide stairstep movement based on anticipated changes. Default value for show_stairsteps is false.

_Full function name:_  `smooth_move_show_stairsteps(smooth_move, new_show_stairsteps)`

_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| smooth_move | Struct.SmoothMove | The SmoothMove instance to set show stairsteps for. |
| new_show_stairsteps | Bool | True to show stairsteps, false to hide. |
---

`smooth_move_get_x`

Get the current x position.

_Full function name:_  `smooth_move_get_x(smooth_move)`

_Returns:_  `Real`

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| smooth_move | Struct.SmoothMove | The SmoothMove instance to get the x position of. |
---

`smooth_move_get_y`

Get the current y position.

_Full function name:_  `smooth_move_get_y(smooth_move)`

_Returns:_  `Real`

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| smooth_move | Struct.SmoothMove | The SmoothMove instance to get the y position of. |
---

`smooth_move_set_position`

Set the x,y position.

_Full function name:_  `smooth_move_set_position(smooth_move, x, y)`

_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| smooth_move | Struct.SmoothMove | The SmoothMove instance to set the x and y position of. |
| x | Real | The new x position. |
| y | Real | The new y position. |
---

`smooth_move_by_vector`

Move by the given vector. Angle of 0 corresponds to positive x axis.

_Full function name:_  `smooth_move_by_vector(smooth_move, angle, magnitude)`

_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| smooth_move | Struct.SmoothMove | The SmoothMove instance to move. |
| angle | Real | The angle of the vector in radians. |
| magnitude | Real | The magnitude of the vector. |
---

`smooth_move_by_magnitudes`

Move by the given x and y magnitudes.

_Full function name:_  `smooth_move_by_magnitudes(smooth_move, magnitude_x, magnitude_y)`

_Returns:_  NA(`undefined`)

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| smooth_move | Struct.SmoothMove | The SmoothMove instance to move. |
| magnitude_x | Real | The x magnitude. |
| magnitude_y | Real | The y magnitude. |
---

`smooth_move_get_x_if_moved_by_vector`

Get the x position after movement by the given vector. Does not mutate the given SmoothMove instance.

_Full function name:_  `smooth_move_get_x_if_moved_by_vector(smooth_move, angle, magnitude)`

_Returns:_  `Real`

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| smooth_move | Struct.SmoothMove | The SmoothMove instance to get the potential x position of. |
| angle | Real | The angle in radians of the vector. |
| magnitude | Real | The magnitude of the vector. |
---

`smooth_move_get_y_if_moved_by_vector`

Get the x position after movement by the given vector. Does not mutate the given SmoothMove instance.

_Full function name:_  `smooth_move_get_y_if_moved_by_vector(smooth_move, angle, magnitude)`

_Returns:_  `Real`

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| smooth_move | Struct.SmoothMove | The SmoothMove instance to get the potential y position of. |
| angle | Real | The angle in radians of the vector. |
| magnitude | Real | The magnitude of the vector. |
---

`smooth_move_get_x_if_moved_by_magnitudes`

Get the x position after movement by the given x and y magnitudes. Does not mutate the given SmoothMove instance.

_Full function name:_  `smooth_move_get_x_if_moved_by_magnitudes(smooth_move, magnitude_x, magnitude_y)`

_Returns:_  `Real`

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| smooth_move | Struct.SmoothMove | The SmoothMove instance to get the potential x position of. |
| magnitude_x | Real | The x magnitude. |
| magnitude_x | Real | The y magnitude. |
---

`smooth_move_get_y_if_moved_by_magnitudes`

Get the x position after movement by the given x and y magnitudes. Does not mutate the given SmoothMove instance.

_Full function name:_  `smooth_move_get_y_if_moved_by_magnitudes(smooth_move, magnitude_x, magnitude_y)`

_Returns:_  `Real`

| Name        | DataType    |  Purpose   |
| ----------- | ----------- | -----------|
| smooth_move | Struct.SmoothMove | The SmoothMove instance to get the potential y position of. |
| magnitude_x | Real | The x magnitude. |
| magnitude_x | Real | The y magnitude. |
---
