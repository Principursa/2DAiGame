extends TileMap

@onready var environ_pixel = load("res://environ_pixel.tscn")
@onready var player_pixel_pre = load("res://player_pixel.tscn")
@onready var enemy_pixel_pre = load("res://enemy_pixel.tscn")
@onready var tick = get_node("../Tick")
@onready var player_score_label = get_node("../Control").get_node("%P_Score")
@onready var enemy_score_label = get_node("../Control").get_node("%E_Score")
@onready var reward_label = get_node("../Control").get_node("%Reward")
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
var player_score: int
var enemy_score: int
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
			environ_grid[pos].get_node("Pixelenviron").modulate = Color(.5,.5,.9)
			x_pos += 1
		x_pos = base_position.x
		y_pos += 1
	spawn_entities()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
			


func get_player_direction():
	return player_pix.direction		
func get_enemy_direction():
	return enemy_pix.direction
func change_gridstate(position,entity):
	if grid[position] == GridState.ABSENT:
		if entity == Entity.PLAYER:
			grid[position] = GridState.PLAYER
			environ_grid[position].get_node("Pixelenviron").modulate = Color(1,250,1)
		else: 
			grid[position] = GridState.ENEMY
			environ_grid[position].get_node("Pixelenviron").modulate = Color(250,1,1)
		
	
	
	
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
	enemy_pix.init(self)
	
	
func failure_check():
	if player_pix.position.y == height:
		enemy_pix.inc_reward()
		restart(Entity.ENEMY)
	if player_pix.position.y ==  0:
		enemy_pix.inc_reward()
		restart(Entity.ENEMY)
	if player_pix.position.x == 0:
		enemy_pix.inc_reward()
		restart(Entity.ENEMY)
	if player_pix.position.x == width:
		enemy_pix.inc_reward()
		restart(Entity.ENEMY)
	if enemy_pix.position.y == height:
		restart(Entity.PLAYER)
		enemy_pix.dec_reward()
	if enemy_pix.position.y ==  0:
		restart(Entity.PLAYER)
		enemy_pix.dec_reward()
	if enemy_pix.position.x == 0:
		restart(Entity.PLAYER)
		enemy_pix.dec_reward()
	if enemy_pix.position.x == width:
		restart(Entity.PLAYER)
		enemy_pix.dec_reward()
	if grid[player_pix.position] != GridState.ABSENT:

		enemy_pix.inc_reward()
		restart(Entity.ENEMY)
	if grid[enemy_pix.position] != GridState.ABSENT:

		restart(Entity.PLAYER)
		enemy_pix.dec_reward()
	reward_label.text = "Reward:" + str(enemy_pix.reward)
		

func restart(entity: Entity):
	if entity == Entity.PLAYER:
		player_score += 1 
		player_score_label.update_score(player_score)

	if entity == Entity.ENEMY:
		enemy_score += 1 
		enemy_score_label.update_score(enemy_score) 

	clear_grid()
	var halfway_h = height / 2 
	var halfway_w = height / 2 
	var player_pos = Vector2(halfway_h -1, halfway_w)
	var enemy_pos = Vector2(halfway_h + 1, halfway_w)
	enemy_pix.set_position(enemy_pos)
	player_pix.set_position(player_pos)
	enemy_pix.direction = enemy_pix.Direction.UP
	player_pix.direction = player_pix.Direction.UP
	
	
func clear_grid():
	var y_pos = base_position.y
	for x in range(width):
		var x_pos = base_position.x
		for y in range(height):
			var pos = Vector2(x_pos, y_pos)
			grid[pos] = GridState.ABSENT
			environ_grid[pos].get_node("Pixelenviron").modulate = Color(.5,.5,.9)
			x_pos += 1 
		x_pos = base_position.x
		y_pos += 1 
			

func _on_tick_timeout():
	failure_check()
	player_pix.prev_position = player_pix.position
	enemy_pix.prev_position = enemy_pix.position
	player_movement()
	enemy_movement()
		

func player_movement():
	var player_direction = get_player_direction()
	if player_direction == player_pix.Direction.UP:
		player_pix.position.y += -1
		change_gridstate(player_pix.prev_position, Entity.PLAYER)
	if player_direction == player_pix.Direction.DOWN:
		player_pix.position.y += 1
		change_gridstate(player_pix.prev_position, Entity.PLAYER)

	if player_direction == player_pix.Direction.LEFT:
		player_pix.position.x += -1
		change_gridstate(player_pix.prev_position, Entity.PLAYER)

	if player_direction == player_pix.Direction.RIGHT:
		player_pix.position.x += 1	
		change_gridstate(player_pix.prev_position, Entity.PLAYER)
		

func enemy_movement():
	var enemy_direction = get_enemy_direction()
	
	if enemy_direction == enemy_pix.Direction.UP:
		enemy_pix.position.y += -1
		change_gridstate(enemy_pix.prev_position, Entity.ENEMY)
	if enemy_direction == enemy_pix.Direction.DOWN:
		enemy_pix.position.y += 1
		change_gridstate(enemy_pix.prev_position, Entity.ENEMY)
	if enemy_direction == enemy_pix.Direction.LEFT:
		enemy_pix.position.x += -1
		change_gridstate(enemy_pix.prev_position, Entity.ENEMY)
	if enemy_direction == enemy_pix.Direction.RIGHT:
		enemy_pix.position.x += -1
		change_gridstate(enemy_pix.prev_position, Entity.ENEMY)
