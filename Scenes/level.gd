extends Node

func _ready() -> void:
	PauseScreen.allowPausing = true
	Transition.endTransition()

func _exit_tree() -> void:
	PauseScreen.allowPausing = false
	
	

#func _on_player_dies(_position: Vector2) -> void:
	#$PlayerRespawnTimer.start()
	#pass # Replace with function body.
#
#
#func _on_player_respawn_timer_timeout() -> void:
	#$Player.respawn()
	#pass # Replace with function body.
