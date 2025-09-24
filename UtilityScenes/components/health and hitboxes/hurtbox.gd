class_name HurtBox
extends Area2D

signal received_damage(damage:int)

@export var health:Health

func _ready() -> void:
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox:HitBox)->void:
	if hitbox!=null:
		print("coool")
		health.hit(hitbox.get_damage(), hitbox.get_parent())
		received_damage.emit(hitbox.damage)
