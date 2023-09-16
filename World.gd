extends TileMap

@onready var environ_pixel = load("res://environ_pixel.tscn")
@onready var player_pixel_pre = load("res://player_pixel.tscn")
@onready var enemy_pixel_pre = load("res://enemy_pixel.tscn")
@onready var tick = get_node("../Tick")
var height = 100
var width = 100
var base_position = Vector2(0,0)
var grid = {}
var environ_grid = {}
enum GridState {
	ABSENT,
	PLAYER,
	ENEMY
}

enum Entity {
	PLAYER,
	ENEMY
}
var player_pix
var enemy_pix
# Called when the node enters the scene tree for the first time.
func _ready():
	var y_pos = base_position.y
	for x in range(width):
		var x_pos = base_position.x
		for y in range(height):
			var pos: Vector2 = Vector2(x_pos,y_pos)
			grid[pos] = GridState.ABSENT
			var env_pixel = environ_pixel.instantiate()
			add_child(env_pixel)
			env_pixel.set_position(pos)
			environ_grid[pos] = env_pixel
			x_pos += 1	
		x_pos = base_position.x
		y_pos += 1
	spawn_entities()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
			


func get_player_direction():
	return player_pix.direction		

func change_gridstate(position,entity):
	if grid[position] == GridState.ABSENT:
		if entity == Entity.PLAYER:
			grid[position] = GridState.PLAYER
			environ_grid[position].get_node("Pixelenviron").modulate = Color(1,250,1)
		else: grid[position] = GridState.ENEMY
	
	
	
func spawn_entities():
	var halfway_h = height / 2 
	var halfway_w = height / 2 
	var player_pos = Vector2(halfway_h -1, halfway_w)
	var enemy_pos = Vector2(halfway_h + 1, halfway_w)
	player_pix = player_pixel_pre.instantiate()
	enemy_pix = enemy_pixel_pre.instantiate()
	add_child(player_pix)
	player_pix.set_position(player_pos)
	add_child(enemy_pix)
	enemy_pix.set_position(enemy_pos)
	
	
func failure_check():
	if grid[player_pix.position] != GridState.ABSENT:
		restart(Entity.ENEMY)
		

func restart(entity: Entity):
	enemy_pix.queue_free()
	player_pix.queue_free()
	if entity == Entity.PLAYER:
		player_pix.score += 1

	if entity == Entity.ENEMY:
		enemy_pix.score += 1 

	clear_grid()
	spawn_entities()
	
func clear_grid():
	var y_pos = base_position.y
	for x in range(width):
		var x_pos = base_position.x
		for y in range(height):
			var pos = Vector2(x_pos, y_pos)
			grid[pos] = GridState.ABSENT
			environ_grid[pos].get_node("Pixelenviron").modulate = Color("#0d1e42")
			x_pos += 1 
		x_pos = base_position.x
		y_pos += 1 
			

func _on_tick_timeout():
	var direction = get_player_direction()
	failure_check()
	player_pix.prev_position = player_pix.position
	if direction == player_pix.Direction.UP:
		player_pix.position.y += -1
		change_gridstate(player_pix.prev_position, Entity.PLAYER)
	if direction == player_pix.Direction.DOWN:
		player_pix.position.y += 1
		change_gridstate(player_pix.prev_position, Entity.PLAYER)

	if direction == player_pix.Direction.LEFT:
		player_pix.position.x += -1
		change_gridstate(player_pix.prev_position, Entity.PLAYER)

	if direction == player_pix.Direction.RIGHT:
		player_pix.position.x += 1	
		change_gridstate(player_pix.prev_position, Entity.PLAYER)
		
