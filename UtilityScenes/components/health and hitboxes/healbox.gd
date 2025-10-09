class_name HealBox
extends Area2D
#deals damage to entity
@export var heal: int=1 : set=set_heal, get=get_heal
func set_heal(value:int):
	heal=value
func get_heal():
	return heal
