extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = 600
const MAX_FALL_SPEED=1200

@export var MAX_HEALTH := 3




var walldirections := {}

var keepMoveDir = false
var chirality = 1

var launched := false;
var stuck := false
var dead := false
var grounded = false

var launchVel := Vector2.ZERO
var lastUpDir  := up_direction
@onready var timer: Timer = $Timer



@onready var animTree = $AnimatedSprite2D/AnimationTree

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#Engine.time_scale=.3
	
	
	%Health.MAX_HEALTH = MAX_HEALTH
	$Respawning.setRespawnPoint(self.global_position)
	var health = %Health
	health.damaged.connect(_on_damaged)
	health.death.connect(_on_death)
	health.healed.connect(_on_healed)

func _on_damaged(amount, _current_health, bywho):
	hit(amount,bywho)
	
func _on_death(_amount, bywho):
	print("Died from", bywho.name)
	Engine.time_scale=0.5
	death(_amount, bywho)


func _on_timer_timeout() -> void:
	Engine.time_scale=1
	respawn()
	
	#get_tree().reload_current_scene()

func _on_healed(amount, _current_health, by_what):
	print("Healed", amount, "by", by_what.name)

var colpoint = null
func _physics_process(delta: float) -> void:
	#stuck = true
	var tryRot = false

	if($RayCast2D.is_colliding()):
		grounded = true
	else:
		grounded = false
		stuck = false
		pass
		
	var coll = get_last_slide_collision()
	if(coll):
		colpoint = coll.get_position()
		
		if(isStickBlock(coll)):
			stuck = true
		else:
			stuck =false
		
		if(stuck):
			up_direction = coll.get_normal()
			rotation = -up_direction.angle_to(Vector2.UP)
		else:
			pass
	elif(colpoint):
		if(stuck):
			tryRot = true
			pass
		else:
			pass
		
	
	
	
	if not grounded:
		velocity += get_gravity() * delta 
		if (velocity.y>MAX_FALL_SPEED):
			velocity.y=MAX_FALL_SPEED
		 
	if grounded or stuck:
		var direction = Input.get_axis("MoveLeft","MoveRight")
		if(direction):
			if(tryRot):
				var rad = 14.5
				var deg = SPEED/rad *direction
				var point = colpoint
				var temp = global_position
				velocity = (rotAround(global_position,point,deg)-temp)/delta
				rotate(deg)
				up_direction = Vector2.UP.rotated(rotation)
				print(velocity.length())
			else:
				velocity = SPEED * direction * up_direction.rotated(PI/2)
		else:
			velocity = velocity.move_toward(Vector2.ZERO,SPEED)
		pass
		
	$RayCast2D2.global_position = global_position
	$RayCast2D2.target_position = velocity
	move_and_slide()
		
	#
func rotAround(vec:Vector2, point:Vector2, deg:float):
	var diff := point-vec
	diff=diff.rotated(deg)
	point = point +diff
	
	return point

func hit(amount:float,byWho:Node2D):
	pass
	
func respawn():
	%Health.reset()
	dead=false
	velocity = Vector2.ZERO
	$EnvironmentCollision.set_deferred("disabled",false)
	$HurtBox.set_deferred("monitorable",true)
	$HurtBox.set_deferred("monitoring",true)
	$Respawning.respawn(self)
	
func death(amount:float,byWho:Node2D):
	#velocity = (position - byWho.position)*amount*20
	$EnvironmentCollision.set_deferred("disabled",true)
	$HurtBox.set_deferred("monitorable",false)
	$HurtBox.set_deferred("monitoring",false)
	stuck=false
	checkUnstick = true
	dead = true
	launched = true
	timer.start()


func _on_mouse_vector_sling_shot_fire(dir:Vector2) -> void:
	%SlingShotParticles.emitting = false
	if(dir.is_equal_approx(Vector2.ZERO)):
		return
	if(grounded):
		launchVel = JUMP_VELOCITY*dir
		#stuck = false
		#checkUnstick = true
		launched = true
	EventBus.emit_signal("player_launched", dir)
	pass # Replace with function body.

func isStickBlock(col:KinematicCollision2D):
	if(!col):
		return false
	
	var collider = col.get_collider()
	if(collider is BaseBlock or collider is StaticBody2D or collider is TileMapLayer):
		#print("YOO")
		if(collider is BaseBlock):
			return collider.stickable
		if(collider is TileMapLayer):
			var sticky = false
			var loc = collider.local_to_map(collider.to_local(col.get_position()+(-col.get_normal())))
			var td = collider.get_cell_tile_data(loc)
			if(td):
				sticky = td.get_custom_data("Stickable")
			
			return sticky
	
	
	return true


func _on_mouse_vector_sling_shot_update(dir:Vector2) -> void:
	if(grounded): # set particle params to show jump
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


func _on_enemy_collision_body_entered(body: Node2D) -> void:
	%Health.hit(1,body)
	pass # Replace with function body.
#
