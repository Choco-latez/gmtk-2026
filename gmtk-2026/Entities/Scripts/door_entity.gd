extends ConnectedEntity

@export var tween_time:float
@export var tween_type:Tween.TransitionType

var tween : Tween

@export var door_open : PackedVector2Array
@export var door_closed : PackedVector2Array
var openness : float = 1.0
var is_open : bool = false

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("debug1"):
		turned_on()
	if Input.is_action_just_pressed("debug2"):
		turned_off()
	
	var arr : PackedVector2Array = []
	for x in 4:
		var vec: Vector2 = Vector2.ZERO
		vec = lerp(door_closed[x],door_open[x],openness)
		arr.append(vec)
	set_points(arr)

func turned_on():
	move_door(true)
func turned_off():
	move_door(false)

func set_points(pointarr:PackedVector2Array):
	%CollisionPolygon2D.polygon = pointarr
	%Polygon2D.polygon = pointarr
	%Line2D.clear_points()
	for point in pointarr:
		var vec: Vector2 = point
		if point.x > 0:
			vec.x -=0.5
		elif point.x < 0:
			vec.x +=0.5
		if point.y > 0:
			vec.y -=0.5
		elif point.y < 0:
			vec.y +=0.5
		%Line2D.add_point(vec)
	
		

func move_door(open):
	if tween:
		tween.kill() # Abort the previous animation.
		
	tween = get_tree().create_tween()
	tween.set_trans(tween_type)
	if open:
		tween.tween_property(self,"openness", 1,tween_time)
	else: 
		tween.tween_property(self,"openness", 0,tween_time)
	is_open = !is_open
