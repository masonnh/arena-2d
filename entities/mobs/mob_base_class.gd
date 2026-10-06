class_name MobBaseClass
extends CharacterBody2D

# Mob stats
var health: int = 1
var attack_power: int = 1
var speed: int = 100

# Mob state
var attacking: bool = false

## Called when a mob instance is created to initialize values
func init_mob(health_init: int = 1, attack_power_init: int = 1, speed_init: int = 200) -> void:
	health = health_init
	attack_power = attack_power_init
	speed = speed_init
	
	var hurtbox = _get_hurtbox_node()
	if hurtbox:
		hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	
	var hitbox = _get_hitbox_node()
	if hitbox:
		hitbox.area_entered.connect(_on_hitbox_area_entered)


#################
# Handle Damage
#################

## Subtracts mob health by damage_amt
func take_damage(damage_amt: int) -> void:
	health -= damage_amt
	if health <= 0:
		_die()


## Removes mob from scene
func _die() -> void:
	queue_free()


#################
# Handle Movement
#################

## Takes direction and moves the mob according to speed
func move(direction: Vector2) -> void:
	velocity = direction * speed
	_handle_animation(direction)
	move_and_slide()


## Automatically plays animation based on mob movement and state
func _handle_animation(direction: Vector2) -> void:
	var anim_spr = _get_anim_spr_node()
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
	var strong_x = abs(direction.x) > abs(direction.y)
	if direction.x > 0 and strong_x:
		anim_spr.play(prefix + "right")
	elif direction.x < 0 and strong_x:
		anim_spr.play(prefix + "left")
	elif direction.y > 0:
		anim_spr.play(prefix + "down")
	elif direction.y < 0:
		anim_spr.play(prefix + "up")


############
# Signals
############

func _on_hurtbox_area_entered(area: Area2D) -> void:
	var parent
	if area.get_parent().name == "Player":
		parent = area.get_parent() as Player
		if area.name == "HitBox":
			take_damage(parent.attack_power)


func _on_hitbox_area_entered(area: Area2D) -> void:
	var parent
	if area.get_parent().name == "Player":
		parent = area.get_parent() as Player
		if area.name == "HurtBox":
			parent.take_damage(attack_power)

##################
# Abstract Methods
##################

## Gets the AnimatedSprite2D node of a mob implementation
func _get_anim_spr_node():
	pass

## Gets the HurtBox node of a mob implementation
func _get_hurtbox_node():
	pass

## Gets the HitBox node of a mob implementation
func _get_hitbox_node():
	pass
