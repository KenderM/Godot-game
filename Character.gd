extends AnimatedSprite

var speed : = 400.0
var path : = []

var thread = Thread.new()

onready var Map = get_parent().get_parent().get_child(0).get_child(0)
onready var Nav = get_parent().get_parent().get_child(0)

var mutex = Mutex.new()

func _ready() -> void:
	randomize()

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return


func _process(delta: float) -> void:
	if path.size() != 0:
		var move_distance : = speed * delta
		move_along_path(move_distance)
	else:
		set_process(false)
		newPath()


func move_along_path(distance : float) -> void:
	var last_point : = global_position
	for index in range(path.size()):
		var distance_to_next = last_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			global_position = last_point.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif distance < 0.0:
			global_position = path[0]
			newPath()
			break

		distance -= distance_to_next
		last_point = path[0]
		path.remove(0)


func newPath():
	
	if (thread.is_active()):
		# Already working
		return


	thread.start(self, "_on_newPath", get_instance_id())


	
func _on_newPath(id):
	
	print("THREAD FUNC!")
	var newPosition = Vector2(randi()%200, randi()%200)
	print("Tposition!")
	var tile_center_pos = Map.map_to_world(newPosition)
	print("map!")
	var newPath = Nav.get_simple_path(global_position,tile_center_pos) #navigation2D node in tree

	print("newpath!")

	#get_parent().get_child(2).points = newPath
	#newPath.remove(0)
	call_deferred("_on_newPath_done")
	return newPath
	

func _on_newPath_done():
	# Wait for the thread to complete, get the returned value
	var minionPath = thread.wait_to_finish()
	path = minionPath
	set_process(true)

func truePath():
	
	var newPosition = Vector2(randi()%200, randi()%200)
	var tile_center_pos = Map.map_to_world(newPosition)
	var newPath = Nav.get_simple_path(global_position,tile_center_pos)
	path = newPath
	set_process(true)
