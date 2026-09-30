extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	_handle_movement()
	move_and_slide() # move and slide handles delta, no need to account for it in velocity calcs


func _handle_movement() -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	
	if direction == Vector2.ZERO:
		velocity = Vector2.ZERO
	else:
		velocity = direction * SPEED
