extends Node2D

@onready var savePoint = $SavePoint
signal respawned (prevPos:Vector2, newPos:Vector2)

func setRespawnPoint(pos:Vector2):
	savePoint.global_position = pos
	
func respawn(thing:Node2D):
	var temp = thing.global_position
	thing.global_position = savePoint.global_position
	respawned.emit(temp,thing.global_position)
