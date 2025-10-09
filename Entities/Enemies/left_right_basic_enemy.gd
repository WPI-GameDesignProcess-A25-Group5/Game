extends Node2D

const SPEED=60
@onready var floor_detect_left: RayCast2D = $floor_detect_left
@onready var floor_detect_right: RayCast2D = $floor_detect_right
@onready var health: Health = $Health
@onready var left_collision: RayCast2D = $left_collision
@onready var right_collision: RayCast2D = $right_collision
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D2

var direction=1
func _ready():
	health.death.connect(_on_death)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(not floor_detect_left.is_colliding() and not floor_detect_right.is_colliding()):
		global_position += SPEED*delta*Vector2.DOWN.rotated(rotation)
	
	if right_collision.is_colliding() or not floor_detect_right.is_colliding():
		if direction==1:
			direction=-1
			animated_sprite.flip_h=true
		
	if left_collision.is_colliding() or not floor_detect_left.is_colliding():
		if direction==-1:
			direction=1
			animated_sprite.flip_h=false
	global_position+=direction*SPEED*delta*Vector2.RIGHT.rotated(rotation)
	
func _on_death(_amount, bywho):
	print("Died from", bywho.name)
	death(_amount, bywho)
	
func death(amount:float,byWho:Node2D):
	#velocity = (position - byWho.position)*amount*20

	queue_free()
