extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = 600
const MAX_FALL_SPEED=1200





var walldirections := {}

var keepMoveDir = false
var chirality = 1

var launched := false;
var stuck := false

var launchVel := Vector2.ZERO
var lastUpDir  := up_direction
@onready var timer: Timer = $Timer



@onready var animTree = $AnimatedSprite2D/AnimationTree

func _ready() -> void:
	var health = $Health
	health.damaged.connect(_on_damaged)
	health.death.connect(_on_death)
	health.healed.connect(_on_healed)

func _on_damaged(amount, current_health, bywho):
	print("Took ", amount, " damage from ", bywho.name)
	
func _on_death(amount, bywho):
	print("Died from", bywho.name)
	Engine.time_scale=0.5
	self.get_node("CollisionShape2D").queue_free()
	self.get_node("HurtBox").queue_free()
	stuck=false
	checkUnstick = true
	launched = true
	timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale=1
	get_tree().reload_current_scene()

func _on_healed(amount, current_health, by_what):
	print("Healed", amount, "by", by_what.name)

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
		var direction := Input.get_axis("MoveLeft", "MoveRight")
		animTree.set("parameters/BlendSpace1D/blend_position",direction*chirality)
		#print(direction)
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
				
		#print(chirality, "l ", lastUpDir)
		directionCorrection = up_direction.rotated(chirality* PI/2)
			
		if direction:
			velocity = direction * SPEED *directionCorrection 
		if(checkUnstick):
			#var movementTest = velocity-up_direction*velocity.length() -velocity
			var movementTest = -up_direction*velocity.length() + get_gravity().rotated(get_gravity().angle_to(-up_direction))
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
	#$RayCast2D.target_position = velocity
	if(collisions):
		var collider = collisions.get_collider()
		#print(collider)
		if(collider is BaseBlock or collider is StaticBody2D):
			#print("popo")
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


func _on_mouse_vector_sling_shot_fire(dir:Vector2) -> void:
	%SlingShotParticles.emitting = false
	if(dir.is_equal_approx(Vector2.ZERO)):
		return
	if(stuck):
		launchVel = JUMP_VELOCITY*dir
		#stuck = false
		checkUnstick = true
		launched = true
	EventBus.emit_signal("player_launched", dir)
	pass # Replace with function body.


func _on_mouse_vector_sling_shot_update(dir:Vector2) -> void:
	if(stuck): # set particle params to show jump
		%SlingShotParticles.emitting = true
		%SlingShotParticles.process_material.set("direction",dir)
		%SlingShotParticles.process_material.set("gravity",get_gravity())
		var speed = JUMP_VELOCITY*dir.length()
		%SlingShotParticles.process_material.set("initial_velocity_max",speed)
		%SlingShotParticles.process_material.set("initial_velocity_min",speed)
	pass 


var checkUnstick = false
func _on_block_interaction_grid_changed_most_occupied(dirs: bool) -> void:
	checkUnstick= !dirs
