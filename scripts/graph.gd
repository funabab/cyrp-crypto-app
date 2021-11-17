extends Control

export(Texture) var _texture;
export(Color) var _outlineColor;

export(Array, float) var values setget _set_values, _get_values;
export(float) var _lineWidth := 6
export(int, 1, 100) var _steps := 16
export(float, 0, 1) var _tension := 0.5

var _values := []
var _minVal : int
var _maxVal : int

func _set_values(values):
	_minVal = values[0]
	_maxVal = values[0]

	for val in values:
		_minVal = min(_minVal, val)
		_maxVal = max(_maxVal, val)

	_values = values
	pass

func _get_values():
	return _values
	pass

func _ready():
	pass

func _draw():
	if (len(_values) == 0):
		return
	
#	VisualServer.canvas_item_set_clip(get_canvas_item(), true)

	var diffVal = _maxVal - _minVal
	var size := len(_values)

	var pts := []

	# draw straint line graph
#	for i in range(size - 1):
#		draw_line(
#			Vector2(rect_size.x * (i / (size - 1.0)), rect_size.y - rect_size.y * (_values[i] - _minVal) / diffVal),
#			Vector2(rect_size.x * ((i + 1) / (size - 1.0)), rect_size.y - rect_size.y * (_values[i + 1] - _minVal) / diffVal),
#			_outlineColor,
#			_lineWidth,
#			true
#		)

	for i in range(size):
		pts.append(Vector2(rect_size.x * (i / (size - 1.0)), rect_size.y - rect_size.y * (_values[i] - _minVal) / diffVal))
	pts.push_front(pts[0])
	pts.append(pts[len(pts) - 1])

	var outlinePoints = []
	var outlineColors = []
	var outlineUVs = []

	for i in range(1, len(pts) - 2):
		for t in range(0, _steps + 1):
			var t1 = (pts[i + 1] - pts[i - 1]) * _tension
			var t2 = (pts[i + 2] - pts[i]) * _tension

			var st = t / float(_steps)
			var c1 = 2 * st * st * st - 3 * st * st + 1
			var c2 = (-2 * st * st * st) + 3 * st * st
			var c3 = st * st * st - 2 * st * st + st
			var c4 =  st * st * st - st * st

			var point = Vector2(
				c1 * pts[i].x + c2 * pts[i + 1].x + c3 * t1.x + c4 * t2.x,
				c1 * pts[i].y + c2 * pts[i + 1].y + c3 * t1.y + c4 * t2.y
			)


			outlinePoints.append(point)
			outlineColors.append(Color.white)
			outlineUVs.append(Vector2(point.x / rect_size.x, point.y / rect_size.y))



	var points := [
		Vector2(0, rect_size.y - rect_size.y * (_values[0] - _minVal) / diffVal),
	]
	var colors := [ Color.white ]
	var uvs := [ Vector2(1, 0) ]

	points.append_array(outlinePoints)
	colors.append_array(outlineColors)
	uvs.append_array(outlineUVs)

	colors.append_array([Color.white, Color.white, Color.white])
	points.append_array(
		[
			Vector2(rect_size.x, 0),
			Vector2(rect_size.x, rect_size.y),
			Vector2(0, rect_size.y)
		]
	)

	uvs.append_array(
		[
			Vector2(1, 1),
			Vector2(0, 1),
			Vector2(0, 0)
		]
	)
	

	# draw graph
	draw_polygon(points, colors, uvs, _texture, null, true)
	# draw graph outline
	draw_polyline(outlinePoints, _outlineColor, _lineWidth, true)
	# draw graph outline tip
	var tipRadius = 10
	draw_circle(Vector2(rect_size.x, (_minVal / diffVal) * rect_size.y), tipRadius, _outlineColor)

	# draw graph points
#	for pt in outlinePoints:
#		draw_arc(pt, 10, 0, PI * 2, 20, _outlineColor)

	pass
