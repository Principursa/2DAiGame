class_name AIEnemy
extends AIController2D
enum Direction {
	UP,
	LEFT,
	RIGHT,
	DOWN
}
var direction: Direction = Direction.UP
var prev_position
var MAX_STEPS = 20000
@onready var step_label = get_node("../../Control").get_node("%Steps")
@onready var player_ref = get_node("../Playerpixel")
# Called when the node enters the scene tree for the first time.
func _ready():
	n_steps = 0
	heuristic= "model"
	needs_reset= true
	reward = 0.0
	done = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	inc_steps()
	if n_steps >= MAX_STEPS:
		done = true
		needs_reset = true

	if needs_reset:
		needs_reset = false
		reset()
		return

	pass

func inc_reward():
	reward += 10

func dec_reward():
	reward -= 10
func get_action_space():
	return {
		"direction" : {
			"size": 4,
			"action_type": "discrete"
		}
		
	}
func set_action(action):
	direction = action["direction"] == 0
func get_obs():
	var enemy_pos = global_position
	var player_pos = player_ref.global_position
	
	var obs = [enemy_pos.x,enemy_pos.y,player_pos.x,player_pos.y]
	
	return {"obs": obs}

func get_reward() -> float:
	return reward
func get_done():
	return done
func set_done_false():
	done = false
func reset():
	needs_reset = false
	n_steps = 0
func inc_steps():
	n_steps +=1
	step_label.text = "Steps:" + str(n_steps)
