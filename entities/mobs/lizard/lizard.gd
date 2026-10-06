extends MobBaseClass

@onready var anim_spr_2d: AnimatedSprite2D = $AnimatedSprite2D as AnimatedSprite2D
@onready var hurt_box: Area2D = $HurtBox as Area2D
@onready var hit_box: Area2D = $HitBox as Area2D
@onready var player = get_node("/root/Main/Player") as Player

var direction: Vector2 = Vector2.UP

# Lizard state
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0


func _ready() -> void:
	init_mob(2, 1, 100)


func _physics_process(delta: float) -> void:
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		move_and_slide()
		return
	
	direction = global_position.direction_to(player.global_position)
	move(direction)


########################
# Implementation Methods
########################

func _get_anim_spr_node() -> AnimatedSprite2D:
	return anim_spr_2d


func _get_hurtbox_node() -> Area2D:
	return hurt_box


func _get_hitbox_node() -> Area2D:
	return hit_box


func _on_hurt_box_area_entered(area: Area2D) -> void:
	var parent
	if area.get_parent().name == "Player":
		parent = area.get_parent() as Player
		if area.name == "HitBox":
			knockback = -direction * 350
			knockback_timer = 0.25
