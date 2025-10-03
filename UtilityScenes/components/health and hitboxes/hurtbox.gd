class_name HurtBox
extends Area2D

signal received_damage(damage:int)

@export var health:Health

func _ready() -> void:
	connect("area_entered", _on_area_entered)
	#connect("area_entered", _on_area_entered_heal)

func _on_area_entered(hitbox:Node2D)->void:
	
	if hitbox is HealBox:
		print("healed")
		health.heal(hitbox.get_heal(), hitbox.get_parent())
	
	if hitbox is HitBox:
		print("coool")
		health.hit(hitbox.get_damage(), hitbox.get_parent())
		received_damage.emit(hitbox.damage)

		
		#received_damage.emit(hitbox.damage)
