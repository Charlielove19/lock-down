extends Node
@export var animator:AnimatedSprite2D
@export var reward: int 
@onready var game = get_tree().current_scene
var position_rec


func _ready():
	animator.play("Spin")
	position_rec = self.position


func _on_body_entered(_body: Node2D) -> void:
	get_parent().coins_spawned -=1
	game.add_money(reward, position_rec)
	animator.play("Collect")
	
	
	self.queue_free()
