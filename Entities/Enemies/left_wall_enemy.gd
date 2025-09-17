extends Node2D
@onready var collision_detect_down: RayCast2D = $collision_detect_down
@onready var collision_detect_up: RayCast2D = $collision_detect_up
@onready var wall_detect_up: RayCast2D = $wall_detect_up
@onready var wall_detect_down: RayCast2D = $wall_detect_down
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED=60


var direction=1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if collision_detect_up.is_colliding() or not wall_detect_up.is_colliding():
		if direction==-1:
			direction=1
			animated_sprite_2d.flip_h=true
		
	if collision_detect_down.is_colliding() or not wall_detect_down.is_colliding():
		if direction==1:
			direction=-1
			animated_sprite_2d.flip_h=false
	position.y+=direction*SPEED*delta
	
