class_name Player
extends CharacterBody2D

# Nodes
@onready var anim_spr: AnimatedSprite2D = $AnimatedSprite2D as AnimatedSprite2D
@onready var hit_box: Area2D = $HitBox as Area2D
@onready var hurt_box: Area2D = $HurtBox as Area2D
@onready var hit_box_collision: CollisionShape2D = $HitBox/CollisionShape2D


# Player Data
const SPEED = 300.0
var attack_power: int = 1
var direction: Vector2 = Vector2.DOWN

# Player State
var attacking := false


func _physics_process(delta: float) -> void:
	if attacking:
		return
	
	if Input.is_action_pressed("attack"):
		_attack()
	
	_handle_movement()
	_handle_animation()
	move_and_slide() # move and slide handles delta, no need to account for it in velocity calcs


## Handles player attacking state
func _attack() -> void:
	attacking = true
	hit_box_collision.disabled = false


## Reads player input and updates velocity to move player
func _handle_movement() -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	
	if direction == Vector2.ZERO:
		velocity = Vector2.ZERO
	else:
		velocity = direction * SPEED


## Automatically plays animation based on player movement and state
func _handle_animation() -> void:
	# Get the previous direction str
	var prev_dir_str: String = anim_spr.animation.get_slice("_", anim_spr.animation.get_slice_count("_") - 1)
	
	# Determine the prefix
	var prefix: String = "idle_"
	if velocity != Vector2.ZERO:
		prefix = "walk_"
	
	if attacking:
		prefix = "attack_"
		anim_spr.play(prefix + prev_dir_str)
	
	# Handle return to idle
	if prefix == "idle_":
		anim_spr.play(prefix + prev_dir_str)
	
	# Determine the direction
	if direction.x > 0:
		anim_spr.play(prefix + "right")
		_move_hitbox(Vector2(30.0, 0.0), 90.0)
	elif direction.x < 0:
		anim_spr.play(prefix + "left")
		_move_hitbox(Vector2(-30.0, 0.0), 90.0)
	elif direction.y > 0:
		anim_spr.play(prefix + "down")
		_move_hitbox(Vector2(0.0, 30.0), 0.0)
	elif direction.y < 0:
		anim_spr.play(prefix + "up")
		_move_hitbox(Vector2(0.0, -30.0), 0.0)


func _move_hitbox(position: Vector2, rotation_degrees: float) -> void:
	hit_box.position = position
	hit_box.rotation_degrees = rotation_degrees

##########
# Signals
##########

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim_spr.animation.begins_with("attack"):
		attacking = false
		hit_box_collision.disabled = true
		_handle_animation()
