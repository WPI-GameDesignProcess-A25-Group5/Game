extends CharacterBody2D

const SPEED = 100
const JUMP_VELOCITY = 600
const MAX_FALL_SPEED=1200

var keepMoveDir = false
var chirality = 1
var direction =-1
var launched := false;
var stuck := false

var launchVel := Vector2.ZERO
var lastUpDir  := up_direction

func _ready():
	EventBus.player_launched.connect(change_direction)

func _physics_process(delta: float) -> void:
	#var beforeVel = velocity
	if not stuck:
		velocity += get_gravity() * delta 
		if (velocity.y>MAX_FALL_SPEED):
			velocity.y=MAX_FALL_SPEED
		 
		
	if stuck:
		if(!launched): # to not slow down velocity if just launched
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
		
		
		var directionCorrection :Vector2
		if(!direction or launched):
			keepMoveDir = false
		else:
			keepMoveDir = true
			
		if(!keepMoveDir)	:
			if(lastUpDir.y<=0):
				chirality = 1
			else:
				chirality = -1
		directionCorrection = up_direction.rotated(chirality* PI/2)
		velocity = direction * SPEED *directionCorrection
		if(checkUnstick):
			#var movementTest = velocity-up_direction*velocity.length() -velocity
			var movementTest = -up_direction*velocity.length() +  get_gravity().rotated(get_gravity().angle_to(-up_direction))
			if(launched):
				stuck = false
				
			elif(!test_move(self.transform,movementTest*delta)): # try rotating around block, if can,Do it
				#print("untsick")
				stuck = false
			else:
				velocity = movementTest
				#velocity +=
				#pass
			checkUnstick = false
			pass
		velocity += launchVel
		launchVel = Vector2.ZERO		
		launched = false;
	
	var collisions := move_and_collide(velocity*delta)
	if(collisions):
		lastUpDir = up_direction
		up_direction = collisions.get_normal()
		$AnimatedSprite2D.rotation = -up_direction.angle_to(Vector2.UP)
		if(collisions.get_angle(velocity.normalized())>PI/2+PI/8):
			stuck = true
			
		else:
			var componentInUpDir = up_direction.dot(velocity)*up_direction.normalized()
			if(componentInUpDir.length()>20):
				velocity = velocity-componentInUpDir*(1+.5) #bounce 1+coef of restitution
			else:
				stuck = true
				velocity = velocity-componentInUpDir
	#

func change_direction(_change:Vector2):
	direction=direction*-1

var checkUnstick = false
func _on_block_interaction_grid_changed_most_occupied(dirs: bool) -> void:
	checkUnstick= !dirs
