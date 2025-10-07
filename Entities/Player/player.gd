extends CharacterBody2D


const SPEED = 200.0
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
var dashing = false

var launchVel := Vector2.ZERO
var lastUpDir  := up_direction
@onready var timer: Timer = $Timer



@onready var animTree = $AnimatedSprite2D/AnimationTree

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$DashTimer.connect("timeout",func():
		dashing=false
		velocity = -up_direction*10	
		stuck =true
		grounded = true
	)
	
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

var lastDir = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	if not grounded:
		velocity += get_gravity() * delta 
		if (velocity.y>MAX_FALL_SPEED):
			velocity.y=MAX_FALL_SPEED
	
	if(dashing):
		dash()
		 
	if grounded:
		if(!launched): # to not slow down velocity if just launched
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
		var direction :=0
		if(!dead):
			direction = Input.get_axis("MoveLeft", "MoveRight")
			animTree.set("parameters/BlendSpace1D/blend_position",direction*chirality)
			
		var directionCorrection :Vector2
		if(!direction or launched ):
			keepMoveDir = false
		else:
			keepMoveDir = true
			
		if(!keepMoveDir)	:
			if(lastUpDir.y<=0):
				chirality = 1
			else:
				chirality = -1
		directionCorrection = up_direction.rotated(chirality* PI/2)
		#print(lastDir)
		
		if direction:
			lastDir = directionCorrection*direction
			velocity = direction * SPEED *directionCorrection
		if(Input.is_action_just_pressed("Dash") and not dashing):
			startDash()
			
			
		if(checkUnstick or launched): #leaving bloc/tile or launching
			#var movementTest = velocity-up_direction*velocity.length() -velocity
			var movementTest = -up_direction*velocity.length() + get_gravity().rotated(get_gravity().angle_to(-up_direction))
			var col:KinematicCollision2D= move_and_collide(movementTest*delta,true)
			if(launched): # if because launched
				# print("launch")
				grounded = false
				
			elif(!isStickBlock(col)): # try rotating around block, if can,Do it
				#print("untsick")
				stuck = false
				grounded = false
				#velocity +=velocity
			else:
				#print("rotate")
				velocity = movementTest + directionCorrection*20
				grounded = true
				
			if(not grounded):
				# print("ungrounf")
				#grounded = false
				stuck = false
				#velocity +=
				#pass
			checkUnstick = false
			pass
		velocity += launchVel 
		launchVel = Vector2.ZERO		
		launched = false;

	
	var collisions := move_and_collide(velocity*delta)
	
	if(collisions):
		var isStick = isStickBlock(collisions)
		if(dashing):
			prematureEndDash()
		if(isStick):
			up_direction = collisions.get_normal()
			lastUpDir = up_direction
			$AnimatedSprite2D.rotation = -up_direction.angle_to(Vector2.UP)
			if(collisions.get_angle(velocity.normalized())>PI/2+PI/8):
				# print("stick--1")
				stuck = true
				grounded = true
				
			else:
				var componentInUpDir = up_direction.dot(velocity)*up_direction.normalized()
				if(componentInUpDir.length()>20):
					# print("unstickstick--1Bounces")
					stuck = false
					grounded = false
					velocity = velocity-componentInUpDir*(1+.5) #bounce 1+coef of restitution
				else:
					# print("stick--1splat")
					stuck = true
					grounded = true
					velocity = velocity-componentInUpDir
		else:
			var temp = lastUpDir
			up_direction = collisions.get_normal()
			lastUpDir = up_direction
			$AnimatedSprite2D.rotation = -up_direction.angle_to(Vector2.UP)
			var componentInUpDir = up_direction.dot(velocity)*up_direction.normalized()
			if(componentInUpDir.length()>10):
				velocity = velocity-componentInUpDir*(1+.5)
			# print("nonstickunstick")
			stuck = false
			if(grounded):
				lastUpDir = temp
				up_direction = temp
				$AnimatedSprite2D.rotation = -up_direction.angle_to(Vector2.UP)
				#grounded = false
				pass
			if(up_direction.dot(Vector2.UP)>0.7):
				# print("nonstickunstick-ground")
				
				grounded = true
		
	#

func startDash():
	dashing = true
	dash()
	$DashTimer.start()
	pass
func dash():
	
	launched = true
	grounded = false
	stuck = false
	velocity = lastDir *500
	pass
func prematureEndDash():
	$DashTimer.stop()
	dashing = false
	print("STOP")

func hit(amount:float,byWho:Node2D):
	hitJump(byWho,5)
	pass
	
func respawn():
	%Health.reset()
	dead=false
	velocity = Vector2.ZERO
	launchVel = Vector2.ZERO
	$EnvironmentCollision.set_deferred("disabled",false)
	$HurtBox.set_deferred("monitorable",true)
	$HurtBox.set_deferred("monitoring",true)
	$Respawning.respawn(self)
	#tween.tween_callback()
	
func death(amount:float,byWho:Node2D):
	#velocity = (position - byWho.position)*amount*20
	$EnvironmentCollision.set_deferred("disabled",true)
	$HurtBox.set_deferred("monitorable",false)
	$HurtBox.set_deferred("monitoring",false)
	stuck=false
	checkUnstick = true
	dead = true
	launched = true
	hitJump(byWho,20)
	#_physics_process(1/Engine.physics_ticks_per_second)
	#launchVel = (global_position - byWho.global_position).normalized()*100 + up_direction*200
	timer.start()

func hitJump(byWho, strength:float):
	grounded = false
	stuck = false
	launched = true
	velocity = Vector2.ZERO
	velocity = (global_position - byWho.global_position).normalized()*100 + up_direction*200
	#launchVel = (global_position - byWho.global_position).normalized()*100 + up_direction*200
	var tween1 = get_tree().create_tween()
	tween1.tween_property($Camera2D, "rotation", deg_to_rad(sign((global_position-byWho.global_position).angle_to(up_direction))*strength), .01)
	tween1.set_ease(Tween.EASE_OUT)
	tween1.set_trans(Tween.TRANS_ELASTIC)
	var tween2 =tween1.chain()
	tween2.tween_property($Camera2D, "rotation", 0, .2)
	tween2.set_ease(Tween.EASE_OUT)
	tween2.set_trans(Tween.TRANS_ELASTIC)
	#print(up_direction)

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
			var sticky = true
			var loc = collider.local_to_map(collider.to_local(col.get_position()+(-col.get_normal()*3)))
			var td = collider.get_cell_tile_data(loc)
			if(td):
				sticky = td.get_custom_data("Stickable")
				#if(!sticky):
					#print("td")
			
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


func _on_hurt_box_incivible(t: bool) -> void:
	if(t):
		$AnimatedSprite2D/AnimationPlayer.play("cantBeHit")
		pass
	else:
		$AnimatedSprite2D/AnimationPlayer.play("RESET")
		pass
	pass # Replace with function body.
	
func stopSpeedrunTimer():
	$CanvasLayer2/Label.finish()

func startSpeedrunTimer():
	$CanvasLayer2/Label.reset()
	$CanvasLayer2/Label.start()
	
