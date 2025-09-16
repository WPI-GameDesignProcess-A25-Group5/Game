extends StaticBody2D


signal stickTo(dir:Vector2, body:BaseBlock)
signal unstickFrom(body:BaseBlock)



func _on_body_entered(body: Node2D) -> void:
	if(body is BaseBlock):
		if(body.stickable):
			var dir = global_position - body.global_position
			stickTo.emit(dir,body)
	pass # Replace with function body.
	
	


func _on_body_exited(body: Node2D) -> void:
	unstickFrom.emit(body)
	pass # Replace with function body.

var velCheck:Vector2=Vector2.ZERO

func set_CheckVel(vel:Vector2):
	velCheck = vel
	
var current:BaseBlock=null
var colliding = false

func _physics_process(delta: float) -> void:
	var collisions = move_and_collide(velCheck*delta,true)
	#print(collisions)
	if(collisions and collisions.get_collider() is BaseBlock):
		var body = collisions.get_collider()
		if(body.stickable):
			current = body
			#collisions.get_
			var dir = collisions.get_normal()
			stickTo.emit(dir,body)
			colliding = true
	else:
		colliding = false
		print("nah")
			#print(dir)
	if(current):
		$RayCast2D.target_position =current.global_position - $RayCast2D.global_position
		var normal = $RayCast2D.get_collision_normal()
		var tangent = Vector2(-normal.y, normal.x) # perpendicular
		
