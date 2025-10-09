extends CharacterBody2D

var idleSpeed := 100.0
var chaseSpeed := 200.0
var toFarDist = 30.0

@onready var health: Health = $Health

var target:Node2D = null
var spawnPoint:Vector2

var returning:bool = false

var direction: Vector2
func _ready():
	health.death.connect(_on_death)
	direction = randVec()
	spawnPoint = global_position
	pass

func randVec():
	var vec:Vector2 = Vector2(randf()*2-1,randf()*2-1)
	if(is_zero_approx( vec.length())):
		return Vector2.RIGHT
	return vec.normalized()

	
func _physics_process(_delta: float) -> void:
	
	if(!returning):
		if((global_position-spawnPoint).length()>toFarDist):
			if($ToFarTimer.is_stopped()):
				$ToFarTimer.start()
		if(!target):
			velocity = direction*idleSpeed
		else:
			velocity = ((target.global_position - global_position).normalized())*chaseSpeed 
	else:
		$HitBox/TimeTillHit.stop()
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
	print("ret")
	pass # Replace with function body.


func _on_detect_range_body_entered(body: Node2D) -> void:
	target= body
	pass # Replace with function body.


func _on_detect_range_body_exited(_body: Node2D) -> void:
	
	target =null
	pass # Replace with function body.
func _on_death(_amount, bywho):
	death(_amount, bywho)
func death(_amount:float,_byWho:Node2D):
	queue_free()
	pass


func _on_hit_box_body_entered(body: Node2D) -> void:
	if(body==target):
		$HitBox/TimeTillHit.start()
	pass # Replace with function body.


func _on_hit_box_body_exited(body: Node2D) -> void:
	if(body==target):
		$HitBox/TimeTillHit.stop()
	pass # Replace with function body.
var hit2 :Area2D= null

func _on_time_till_hit_timeout() -> void:
	#$HitBox.set_deferred("monitorable",true)
	hit2 = HitBox.new()
	hit2.collision_mask = $HitBox.collision_mask
	hit2.collision_layer = $HitBox.collision_layer
	var shape = CollisionShape2D.new()
	shape.shape = $HitBox/CollisionShape2D.shape
	hit2.add_child(shape)
	hit2.damage = $HitBox.damage
	add_child(hit2)
	hit2.body_entered.connect(func(_body):
		hit2.queue_free()
		returning=true
		hit2=null
	)
	
	pass # Replace with function body.
