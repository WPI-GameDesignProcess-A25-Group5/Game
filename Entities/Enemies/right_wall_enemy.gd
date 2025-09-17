extends Node2D

@onready var collision_detect_up: RayCast2D = $"collision detect up"
@onready var collision_detect_down: RayCast2D = $"collision detect down"
@onready var down_wall_detect: RayCast2D = $"down wall detect"
@onready var up_wall_detect: RayCast2D = $"up wall detect"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const SPEED=60

var direction=1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if collision_detect_up.is_colliding() or not up_wall_detect.is_colliding():
		if direction==-1:
			direction=1
			animated_sprite_2d.flip_h=true
		
	if collision_detect_down.is_colliding() or not down_wall_detect.is_colliding():
		if direction==1:
			direction=-1
			animated_sprite_2d.flip_h=false
	position.y+=direction*SPEED*delta
