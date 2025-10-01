extends Node2D
@onready var left_most: AnimatedSprite2D = $left_most
@onready var right_most: AnimatedSprite2D = $right_most
@onready var middle: AnimatedSprite2D = $middle


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var health = %Health
	left_most.play("Full") 
	right_most.play("Full")
	middle.play("Full")# Replace with function body.
	health.damaged.connect(_on_damaged)
	health.death.connect(_on_death)
	health.healed.connect(_on_healed)
	health.reset_.connect(_on_reset)
	

func _on_damaged(amount, _current_health, bywho):
	if _current_health==3:
		left_most.play("Full") 
		right_most.play("Full")
		middle.play("Full")
	elif _current_health==2:
		left_most.play("Full") 
		right_most.play("Empty")
		middle.play("Full")
	elif _current_health==1:
		left_most.play("Full") 
		right_most.play("Empty")
		middle.play("Empty")
		
func _on_healed(amount, _current_health, by_what):
	if _current_health==3:
		left_most.play("Full") 
		right_most.play("Full")
		middle.play("Full")
	elif _current_health==2:
		left_most.play("Full") 
		right_most.play("Empty")
		middle.play("Full")
	elif _current_health==1:
		left_most.play("Full") 
		right_most.play("Empty")
		middle.play("Empty")
		
func _on_death(_amount, bywho):
		left_most.play("Empty") 
		right_most.play("Empty")
		middle.play("Empty")
		
func _on_reset():
	left_most.play("Full") 
	right_most.play("Full")
	middle.play("Full")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(get_parent().get_parent().health)
	
	pass
