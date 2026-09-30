extends CharacterBody2D

@onready var anim_spr: AnimatedSprite2D = $AnimatedSprite2D as AnimatedSprite2D

const SPEED = 300.0

var direction: Vector2 = Vector2.DOWN
var previous_direction: Vector2

func _physics_process(delta: float) -> void:
	_handle_movement()
	_handle_animation()
	move_and_slide() # move and slide handles delta, no need to account for it in velocity calcs


## Reads player input and updates velocity to move player
func _handle_movement() -> void:
	previous_direction = direction
	direction = Input.get_vector("left", "right", "up", "down")
	
	if direction == Vector2.ZERO:
		velocity = Vector2.ZERO
	else:
		velocity = direction * SPEED


## Automatically plays animation based on player movement
func _handle_animation() -> void:
	# Determine the prefix
	var prefix: String = "idle_"
	if velocity != Vector2.ZERO:
		prefix = "walk_"
	
	# Determine the direction
	if previous_direction.x > 0:
		anim_spr.play(prefix + "right")
	elif previous_direction.x < 0:
		anim_spr.play(prefix + "left")
	elif previous_direction.y > 0:
		anim_spr.play(prefix + "down")
	elif previous_direction.y < 0:
		anim_spr.play(prefix + "up")
