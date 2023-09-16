extends Node2D

enum Direction {
	UP,
	LEFT,
	RIGHT,
	DOWN
}
var direction = Direction.UP
var score = 0
var prev_position
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func change_direction():
	pass

func _input(event):
	if event.is_action_pressed("ui_up"):
		direction = Direction.UP
	if event.is_action_pressed("ui_left"):
		direction = Direction.LEFT
	if event.is_action_pressed("ui_right"):
		direction = Direction.RIGHT
	if event.is_action_pressed("ui_down"):
		direction = Direction.DOWN
			
		
