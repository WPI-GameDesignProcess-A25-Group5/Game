extends AnimatedSprite2D

func _ready() -> void:
	_update_sprite()

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.setRespawn(global_position)
	#if body.is_in_group("player"):
	GlobalScript.checkpoint_pos = $Marker2D.global_position
	if GlobalScript.previous_checkpoint_node:
		GlobalScript.previous_checkpoint_node._update_sprite()
	GlobalScript.previous_checkpoint_node = self
	_update_sprite()

func _update_sprite() -> void:
	if $Marker2D.global_position == GlobalScript.checkpoint_pos:
		play("StartupCheckpoint")
		play("ActiveCheckpoint")
	else:
		play("IdleCheckpoint")
