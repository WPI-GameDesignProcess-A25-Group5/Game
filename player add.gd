func _ready() -> void:
	add_to_group("player")
	
	if GlobalScript.checkpoint_pos != Vector2 (-999,-999):
		global_position = GlobalScript.checkpoint_pos
