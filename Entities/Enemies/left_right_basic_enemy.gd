extends Node2D

const SPEED=60
@onready var floor_detect_left: RayCast2D = $floor_detect_left
@onready var floor_detect_right: RayCast2D = $floor_detect_right

@onready var left_collision: RayCast2D = $left_collision
@onready var right_collision: RayCast2D = $right_collision
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction=1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if right_collision.is_colliding() or not floor_detect_right.is_colliding():
		if direction==1:
			direction=-1
			animated_sprite.flip_h=true
		
	if left_collision.is_colliding() or not floor_detect_left.is_colliding():
		if direction==-1:
			direction=1
			animated_sprite.flip_h=false
	position.x+=direction*SPEED*delta
	
