extends Node

@export var speed: float
@export var time_alive:float
@onready var time_alive_counter:= time_alive

@export var text: Label

func set_text(value):
	if value>0:
		text.text = "$" + str(value)
	if value<0:
		text.text = "-$" + str(value)
	else:
		return
	
	

func _process(delta: float) -> void:
	self.position.y -= speed
	if time_alive_counter>0:
		time_alive_counter-= delta
	else:
		self.queue_free()
	
