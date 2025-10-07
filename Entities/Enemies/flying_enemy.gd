extends CharacterBody2D

var idleSpeed := 100.0
var chaseSpeed := 200.0
var toFarDist = 30.0

var target:Node2D = null
var spawnPoint:Vector2

var returning:bool = false

var direction: Vector2
func _ready():
	direction = randVec()
	spawnPoint = global_position
	pass

func randVec():
	var vec:Vector2 = Vector2(randf()*2-1,randf()*2-1)
	if(is_zero_approx( vec.length())):
		return Vector2.RIGHT
	return vec.normalized()

	
func _physics_process(delta: float) -> void:
	
	if(!returning):
		if((global_position-spawnPoint).length()>30):
			if($ToFarTimer.is_stopped()):
				$ToFarTimer.start()
		if(!target):
			velocity = direction*idleSpeed
		else:
			velocity = ((target.position - position).normalized())*chaseSpeed 
	else:
		velocity = ((spawnPoint - global_position).normalized())*idleSpeed
		if((spawnPoint-global_position).length()<toFarDist/2):
			returning = false
	if(velocity.dot(Vector2.RIGHT)>0):
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
		
	move_and_slide()
	
	pass

func onhitPlayer():
	returning = true


func _on_decision_timer_timeout() -> void:
	direction = randVec()
	pass # Replace with function body.


func _on_to_far_timer_timeout() -> void:
	returning = true
	pass # Replace with function body.


func _on_detect_range_body_entered(body: Node2D) -> void:
	target= body
	pass # Replace with function body.


func _on_detect_range_body_exited(body: Node2D) -> void:
	target =null
	pass # Replace with function body.
