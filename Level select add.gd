func _load_level() -> void:
	GlobalScript.checkpoint_pos = Vector2 (-999, -999)
	GlobalScript.previous_checkpoint_node = null
	get_tree().change_scene_to_file("res://game.tsn")
