@tool
extends VBoxContainer

var data = []

var personCreditNode := preload("res://Credits/Sections/Developers/person_credit.tscn")

func _ready() -> void:
	$Tile.text = "Credits"
	var colms = $ColumnCredits
	for person in data:
		var personCredit = personCreditNode.instantiate()
		personCredit.personName=person["Name"]
		personCredit.Roles=person["Jobs"]
		colms.add_child(personCredit)
		#colms.add_child(HSeparator.new())
	pass
