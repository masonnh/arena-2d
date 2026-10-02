extends MobBaseClass

@onready var anim_spr_2d: AnimatedSprite2D = $AnimatedSprite2D as AnimatedSprite2D
@onready var hurt_box: Area2D = $HurtBox as Area2D

var direction: Vector2 = Vector2.UP


func _ready() -> void:
	init_mob(1, 1, 100)


func _physics_process(delta: float) -> void:
	move(direction)


########################
# Implementation Methods
########################

func _get_anim_spr_node() -> AnimatedSprite2D:
	return anim_spr_2d


func _get_hurtbox_node() -> Area2D:
	return hurt_box
