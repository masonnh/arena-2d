extends MobBaseClass

@onready var anim_spr_2d: AnimatedSprite2D = $AnimatedSprite2D

var direction: Vector2 = Vector2.RIGHT


func _ready() -> void:
	init_mob(1, 1, 100)


func _physics_process(delta: float) -> void:
	move(direction)


########################
# Implementation Methods
########################

func _get_anim_spr_node() -> AnimatedSprite2D:
	return anim_spr_2d
