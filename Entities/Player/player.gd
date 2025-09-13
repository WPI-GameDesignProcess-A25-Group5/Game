extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = 600
const MAX_FALL_SPEED=1200

var walldirections := {}

var launched := false;
var stuck := false
var lastUpDir  := up_direction
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
		if direction:
			velocity = direction * SPEED *up_direction.rotated(PI/2)
				
		#print(up_direction)
		launched = false;
	
	var collisions := move_and_collide(velocity*delta)
	if(collisions):
		lastUpDir = up_direction
		up_direction = collisions.get_normal()
		$AnimatedSprite2D.rotation = -up_direction.angle_to(Vector2.UP)
		#print(collisions.get_angle(velocity.normalized()))
		if(collisions.get_angle(velocity.normalized())>PI/2+PI/8):
			#print("U")
			stuck = true
		else:
			var componentInUpDir = up_direction.dot(velocity)*up_direction.normalized()
			if(componentInUpDir.length()>20):
				velocity = velocity-componentInUpDir*(1+.5) #bounce 1+coef of restitution
			else:
				stuck = true
				velocity = velocity-componentInUpDir
	#else:
		#stuck = false
		
	print("stuck: ",stuck," launced: ",launched)
	#else:
		#up_direction = Vector2.UP
		#$AnimatedSprite2D.rotation = up_direction.angle_to(Vector2.UP)
	#


func _on_mouse_vector_sling_shot_fire(dir:Vector2) -> void:
	if(stuck):
		#print(dir)
		velocity += JUMP_VELOCITY*dir
		stuck = false
	
		launched = true
	%SlingShotParticles.emitting = false
	pass # Replace with function body.


func _on_mouse_vector_sling_shot_update(dir:Vector2) -> void:
	if(stuck):
		%SlingShotParticles.emitting = true
		%SlingShotParticles.process_material.set("direction",dir)
		%SlingShotParticles.process_material.set("gravity",get_gravity())
		var speed = JUMP_VELOCITY*dir.length()
		%SlingShotParticles.process_material.set("initial_velocity_max",speed)
		%SlingShotParticles.process_material.set("initial_velocity_min",speed)
	pass # Replace with function body.



func _on_block_interaction_grid_changed_most_occupied(dirs: Dictionary) -> void:
	#if(dirs):
	#print("VOTE: ",dirs)
	#walldirections = {}
	#for i in dirs:
		#if(dirs[i]!=0):
			#walldirections[i]=$BlockInteractionGrid.strToDir[i]
			#
	#if(walldirections.keys().size()==0):
		#up_direction = Vector2.UP
		#stuck = false
	#elif(walldirections.keys().size()==1):
		#lastUpDir=up_direction
		#up_direction = walldirections[walldirections.keys()[0]].rotated(PI)
		#stuck=true
	#else:
		#for key in walldirections:
			#if walldirections[key] == up_direction.rotated(PI):
				#pass

	
		#up_direction = up_direction.rotated(up_direction.angle_to(dirs[0])+PI)
		#up_direction = dirs[0].rotated(PI)
		#launched=false
		#$AnimatedSprite2D.rotation = dirs[0].angle_to(Vector2.DOWN)
	pass # Replace with function body.
