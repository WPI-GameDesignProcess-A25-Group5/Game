extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = 600
const MAX_FALL_SPEED=1200

@export var MAX_HEALTH := 3
var health:int



var walldirections := {}

var keepMoveDir = false
var chirality = 1

var stuck := false

var lastUpDir  := up_direction

var movingDir = 0

signal damaged (amount:int)
signal dies (position:Vector2)

func _ready() -> void:
	health = MAX_HEALTH

func _physics_process(delta: float) -> void:
	#var beforeVel = velocity
	if not stuck:
		velocity += get_gravity() * delta 
		if (velocity.y>MAX_FALL_SPEED):
			velocity.y=MAX_FALL_SPEED
		 
		#
	if stuck:
		var direction := Input.get_axis("MoveLeft", "MoveRight")
		movingDir = direction
		var directionCorrection :Vector2
		if(!direction):
			keepMoveDir = false
		else:
			keepMoveDir = true
		if(!keepMoveDir)	:
			if(lastUpDir.y<=0):
				chirality = 1
			else:
				chirality = -1		
		directionCorrection = up_direction.rotated(chirality* PI/2)
			#
		if direction:
			velocity = direction * SPEED *directionCorrection
		else:
			velocity.x = move_toward(velocity.x,0,SPEED)
			velocity.y = move_toward(velocity.y,0,SPEED)
			
		if(checkUnstick):
			var movementTest = -up_direction*velocity.length() + get_gravity().rotated(get_gravity().angle_to(-up_direction))
			if(!test_move(self.transform,movementTest*delta)): # try rotating around block, if can,Do it
				stuck = false
			else:
				velocity = movementTest
			checkUnstick = false
			pass
	#
	var collisions := move_and_collide(velocity*delta)
	if(collisions):
		var collider = collisions.get_collider()
		if(collider is BaseBlock):
			lastUpDir = up_direction
			up_direction = collisions.get_normal()
			$AnimatedSprite2D.rotation = -up_direction.angle_to(Vector2.UP)
			if(collisions.get_angle(velocity.normalized())>PI/2+PI/8):
				stuck = true
				#
			#else:
				#var componentInUpDir = up_direction.dot(velocity)*up_direction.normalized()
				#if(componentInUpDir.length()>20):
					#velocity = velocity-componentInUpDir*(1+.5) #bounce 1+coef of restitution
				#else:
					#stuck = true
					#velocity = velocity-componentInUpDir

		
		
	#move_and_collide(velocity*delta)
	
	#


var checkUnstick = false
func _on_block_interaction_grid_changed_most_occupied(dirs: bool,body:Node2D) -> void:
	checkUnstick= !dirs
