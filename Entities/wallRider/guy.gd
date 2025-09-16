extends CharacterBody2D

@export var SPEED = 300

var markerPos:Vector2

func _ready():
	markerPos = $Pivot.position

var stuck = false
var actionable =false
func _physics_process(delta: float) -> void:
	
	#$RayCast2D.target_position = up_direction*20
	#print($WallRider.isOnLeft()," ",$WallRider.isOnRight(), " ", $WallRider.isOnleftCorner(), " ", $WallRider.isOnRightCorner())
		
		
	#if false:
	if not stuck:
		velocity += get_gravity()*delta
	
	if(actionable):
		if($WallRider.isOnleftCorner()):
			print("LC")
			up_direction =  up_direction.rotated(-PI/2)
			global_position -= ($CollisionShape2D.shape.get_rect().size/2).rotated(-up_direction.angle_to(Vector2.UP))
			global_position-=up_direction*SPEED*delta
			#velocity = Vector2.ZERO
			rotate(-PI/2)
		if($WallRider.isOnRightCorner()):
			print("RC")
			up_direction =  up_direction.rotated(PI/2)
			global_position += ($CollisionShape2D.shape.get_rect().size/2).rotated(-up_direction.angle_to(Vector2.UP)-PI/2)
			global_position-=up_direction*SPEED*delta
			#velocity = Vector2.ZERO
			rotate(PI/2)
		if($WallRider.isOnRight()):
			print("RIGHT")
			up_direction =  up_direction.rotated(-PI/2)
			rotate(-PI/2)
		if($WallRider.isOnLeft()):
			print("LEFT")
			up_direction = up_direction.rotated(PI/2)
			rotate(PI/2)
		var direction = Input.get_axis("MoveLeft","MoveRight")
		if(direction):
			velocity = SPEED*up_direction.rotated(direction*PI/2)
		else:
			#pass
			velocity.x = move_toward(velocity.x,0,SPEED)
			velocity.y = move_toward(velocity.y,0,SPEED)
		
	#print(up_direction)
		
	#move_and_slide()
	var collision = move_and_collide(velocity*delta)
	
	if(collision):
		actionable = true
		#velocity -=collision.
	
