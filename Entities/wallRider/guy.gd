extends CharacterBody2D


@export var SPEED:=300.0
@export var MAX_FALL_SPEED :=1200.0


var stickList :Array[BaseBlock]= []

func _on_wall_rider_stick_to(dir: Vector2, body: BaseBlock) -> void:
	#stickList.push_back(body)
	#print("In, ",dir)
	up_direction = dir
	
	pass # Replace with function body.


func _on_wall_rider_unstick_from(body: BaseBlock) -> void:
	stickList.erase(body)
	#print("Gone, ",stickList)
	
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	$Sprite2D.rotation = -up_direction.angle_to(Vector2.UP)
	
	if(not is_on_floor()):
		velocity += get_gravity().rotated(get_gravity().angle_to(-up_direction))*delta
		if(velocity.dot(-up_direction)>MAX_FALL_SPEED):
			velocity -= velocity.project(up_direction)+up_direction*MAX_FALL_SPEED
	
	else:	
		var direction = Input.get_axis("MoveLeft","MoveRight")
		if(direction):
			var movedir = up_direction.rotated(direction*PI/2)
			velocity += SPEED*movedir
			var indir = velocity.project(movedir)
			velocity -= indir - movedir*SPEED
		else:
			velocity.x = move_toward(velocity.x,0,SPEED)
			velocity.y = move_toward(velocity.y,0,SPEED)
	$WallRider.set_CheckVel(velocity)
	#print(velocity)
	#move_and_collide(velocity*delta)
	move_and_slide()
	
	pass
	
