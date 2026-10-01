extends CharacterBody2D

var speed = 250.0
var direction = Vector2(0,1).normalized()
@export var damage:int = 1
@onready var game = get_tree().current_scene

func _physics_process(delta):
	velocity = direction*speed
	var collision = move_and_collide(velocity*delta)
	
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		direction = velocity.normalized()
		
		var collider = collision.get_collider()
		if collider.has_method("hit"):
			var reward = collider.hit(damage)
			game.add_money(reward)
