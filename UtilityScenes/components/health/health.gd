extends Node2D

@export var MAX_HEALTH:float=3
var health := MAX_HEALTH

signal death (amount:float, bywho:Node2D )
signal damaged(amount:float,currenthealth:float,bywho:Node2D)
signal healed (amount:float,currenthealth,byWhat:Node2D)


func hit(amount:float, bywho:Node2D):
	health -= amount
	if(health>0):
		damaged.emit(amount,health, bywho)
	else:
		death.emit(amount,bywho)

func heal(amount, byWhat):
	health += amount
	healed.emit(amount,health, byWhat)
	
