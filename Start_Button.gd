extends Button
@onready var tile_map = get_node("../../../../TileMap")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_pressed():
	tile_map.gamestate = tile_map.GameStates.Ongoing
	tile_map.spawn_entities()
	hide()
