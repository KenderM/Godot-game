extends TileMap

enum TILES {uoop, Floor, Costa, Costa2, Costa3, Water}


var isleSize = Vector2(200,200)

export (float,0.0,100.0) var precentatge_floors

var neighbor = [Vector2(1,0),Vector2(1,1),Vector2(0,1),
				Vector2(-1,0),Vector2(-1,-1),Vector2(0,-1),
				Vector2(1,-1),Vector2(-1,1)]
				
onready var HumanScene = load("res://Human.tscn")

var Humans = []

func _ready():
	randomize()
	makeIsle()


func _process(delta): 
	if Input.is_action_just_pressed("ui_accept"):
			makeIsle()
			smooth_map()
	if Input.is_action_just_pressed("ui_down"):
		smooth_map()
	
	
func makeIsle():
			
	for x in range(0,isleSize.x):
		for y in range(0,isleSize.y):
		
			if x == 0 or x == isleSize.x-1 or x == 1 or x == isleSize.x-2 :
				set_cell(x,y, TILES.Water)
			elif y == 0 or y == isleSize.y -1 or y == 1 or y == isleSize.y -2:
				set_cell(x,y, TILES.Water)
				
			else:
				var num = rand_range(0.0,100.0)
				if num < precentatge_floors :
					set_cell(x,y, TILES.Floor)
				else:
					set_cell(x,y, TILES.Water)
	
	smooth_map()
	waterEffect()

	for n in range(0,15):
		
		var gootPosition = false
		
		while !gootPosition:

			var position = Vector2(randi()%int(isleSize.x), randi()%int(isleSize.y))
			var cell = get_cellv(position)
			if cell != 0:
				var Human = HumanScene.instance()
				var tile_center_pos = map_to_world(position) + cell_size / 2
				Human.global_position = tile_center_pos
				Humans.append(Human)
				
				get_parent().get_parent().call_deferred("add_child", Humans[n])
				gootPosition = true
	
func smooth_map():
	for t in 5:
		for x in range(1,isleSize.x -1):
			for y in range(1,isleSize.y -1):
				var number_of_neighbour_walls = 0
				for direction in neighbor:
					var currentTile = Vector2(x,y) + direction
					if get_cell(currentTile.x, currentTile.y) == TILES.Water:
						number_of_neighbour_walls += 1
				if number_of_neighbour_walls > 4:
					set_cell(x,y,TILES.Water)
				elif number_of_neighbour_walls < 4:
						set_cell(x,y,TILES.Floor)

func waterEffect():
	
	var lastTile = TILES.Floor
	for value in [TILES.Costa, TILES.Costa2, TILES.Costa3, TILES.Water]:
		for x in isleSize.x:
			for y in isleSize.y:
				if get_cell(x,y) == TILES.Water:
					
					for direction in neighbor:
						var currentTile = Vector2(x,y) + direction
						if get_cell(currentTile.x, currentTile.y) == lastTile:
							set_cell(x,y,value)
							break
		lastTile = value
				
				
				
				
				
				
