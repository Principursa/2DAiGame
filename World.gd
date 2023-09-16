extends TileMap

@onready var environ_pixel = load("res://environ_pixel.tscn")
var height = 100
var width = 100
var base_position = Vector2(0,0)
var arr = []
# Called when the node enters the scene tree for the first time.
func _ready():
	var y_pos = base_position.y
	for x in range(width):
		var x_pos = base_position.x
		for y in range(height):
			var pos: Vector2 = Vector2(x_pos,y_pos)
			var env_pixel = environ_pixel.instantiate()
			add_child(env_pixel)
			env_pixel.set_position(pos)
			x_pos += 1	
		x_pos = base_position.x
		y_pos += 1
			



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
