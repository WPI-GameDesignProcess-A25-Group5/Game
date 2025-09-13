extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = 600
const MAX_FALL_SPEED=1200

var walldirections := {}

var inFlight := false;
var stuck := false
var lastUpDir  := up_direction
func _physics_process(delta: float) -> void:
	#up_direction = up_direction.rotated(rad_to_deg(10*delta))
	#rotation = atan2(up_direction.y,up_direction.x)
	#var beforeVel = velocity

			
	
	
	if not stuck:
		velocity += get_gravity() * delta 
		if (velocity.y>MAX_FALL_SPEED):
			velocity.y=MAX_FALL_SPEED
		
		
	if is_on_floor() and stuck:
		if(!inFlight):
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
		var direction := Input.get_axis("MoveLeft", "MoveRight")
		if direction:
			if(up_direction.is_equal_approx(Vector2.UP) or up_direction.is_equal_approx(Vector2.DOWN) ):
				velocity.x = direction * SPEED
			if((lastUpDir.is_equal_approx(Vector2.UP) and up_direction.is_equal_approx(Vector2.LEFT)) or
			(lastUpDir.is_equal_approx(Vector2.DOWN) and up_direction.is_equal_approx(Vector2.RIGHT))):
				velocity.y -= direction * SPEED
				
		#print(up_direction)
		inFlight = false;
	
	var collisions := move_and_collide(velocity*delta)
	print(collisions)

	#move_and_slide()


func _on_mouse_vector_sling_shot_fire(dir:Vector2) -> void:
	if(is_on_floor()):
		#print(dir)
		velocity += JUMP_VELOCITY*dir
	
	inFlight = true
	%SlingShotParticles.emitting = false
	pass # Replace with function body.


func _on_mouse_vector_sling_shot_update(dir:Vector2) -> void:
	if(is_on_floor()):
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
	walldirections = {}
	for i in dirs:
		if(dirs[i]!=0):
			walldirections[i]=$BlockInteractionGrid.strToDir[i]
			
	if(walldirections.keys().size()==0):
		up_direction = Vector2.UP
		stuck = false
	elif(walldirections.keys().size()==1):
		lastUpDir=up_direction
		up_direction = walldirections[walldirections.keys()[0]].rotated(PI)
		stuck=true
	else:
		for key in walldirections:
			if walldirections[key] == up_direction.rotated(PI):
				pass

	
		#up_direction = up_direction.rotated(up_direction.angle_to(dirs[0])+PI)
		#up_direction = dirs[0].rotated(PI)
		#inFlight=false
		#$AnimatedSprite2D.rotation = dirs[0].angle_to(Vector2.DOWN)
	pass # Replace with function body.
