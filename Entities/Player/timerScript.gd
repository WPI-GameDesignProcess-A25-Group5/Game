extends Label

var time:float
var stoped = false

func reset():
	time = 0.0
	for i in get_children():
		i.queue_free()
	visible = true
func start():
	stoped = false

func stop():
	stoped = true

func finish():
	for i in get_children():
		if i is Timer:
			return
	stop()
	var timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 0.25
	timer.connect("timeout",func(): visible = not visible)
	add_child(timer)

func _process(delta: float) -> void:
	if(!stoped):
		time += delta
	text = timeToString(time)
	
func timeToString(time1:float):
	var Hours := int(time1 / (60*60))
	var minutes := int(time1 / 60)
	var seconds := int(time1) % 60
	var milliseconds := int((time1 - int(time1)) * 100)
	return "%02d:%02d:%02d.%02d" % [Hours,minutes, seconds, milliseconds]
