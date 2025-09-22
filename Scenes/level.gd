extends Node



func _on_player_dies(position: Vector2) -> void:
	$PlayerRespawnTimer.start()
	pass # Replace with function body.


func _on_player_respawn_timer_timeout() -> void:
	$Player.respawn()
	pass # Replace with function body.
