extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var stick_detect_right: RayCast2D = $StickDetectRight
@onready var stick_detect_left: RayCast2D = $StickDetectLeft
@onready var stick_detect_up: RayCast2D = $StickDetectUp
@onready var stick_detect_down: RayCast2D = $StickDetectDown

var stuck_ceiling=false
var stuck_wall=false
var in_air=false
func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if not is_on_floor() and not stuck_ceiling and not stuck_wall:
		velocity += get_gravity() * delta
		in_air=true
	
	if stick_detect_up.is_colliding() :
		stuck_ceiling=true
		in_air=false
	else:
		stuck_ceiling=false
	if stick_detect_left.is_colliding() or stick_detect_right.is_colliding():
		
		
		if (stick_detect_left.is_colliding() or stick_detect_right.is_colliding())  and in_air==true and not Input.is_action_just_pressed("ui_accept"):
			velocity.y=0
			stuck_wall=true
			in_air=false
		
	else:
		stuck_wall=false
		
	# Handle jump from ground
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	#handle unstick from ceiling
	if Input.is_action_just_pressed("ui_accept") and stuck_ceiling:
		stuck_ceiling=false
	#wall jumping
	if Input.is_action_just_pressed("ui_accept") and stuck_wall:
		stuck_wall=false
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_horizontal := Input.get_axis("ui_left", "ui_right")
	if direction_horizontal and stuck_ceiling:
		velocity.x = direction_horizontal * SPEED/4
	elif direction_horizontal:
		velocity.x = direction_horizontal * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	#up-down movement on walls
	var direction_vertical := Input.get_axis("ui_up", "ui_down")
	if direction_vertical and stuck_wall:
		velocity.y=direction_vertical*SPEED/4
	elif stuck_wall:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()
