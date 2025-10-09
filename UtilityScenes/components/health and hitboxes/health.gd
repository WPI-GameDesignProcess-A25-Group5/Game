class_name Health
extends Node

@export var MAX_HEALTH:float=3
var health := MAX_HEALTH

signal death (amount:float, bywho:Node2D )
signal damaged(amount:float,currenthealth:float,bywho:Node2D)
signal healed (amount:float,currenthealth,byWhat:Node2D)
signal reset_ ()


func _ready() -> void:
	reset()
"res://Assets/Sprites/UI Sprites/health_full_1-Sheet.png"
func hit(amount:float, bywho:Node2D):
	health -= amount
	if(health>0):
		damaged.emit(amount,health, bywho)
	else:
		death.emit(amount,bywho)

func heal(amount, byWhat):
	health += amount
	if health>MAX_HEALTH:
		health=MAX_HEALTH
	healed.emit(amount,health, byWhat)
	
func reset():
	health = MAX_HEALTH
	reset_.emit()
	
