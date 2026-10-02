extends Node
@export var animator:AnimatedSprite2D
@export var reward: int 



func _ready():
	animator.play("Spin")


func _on_body_entered(body: Node2D) -> void:
	get_parent().coins_spawned -=1
	get_tree().current_scene.add_money(reward)
	animator.play("Collect")
	self.queue_free()
