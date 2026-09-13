extends CharacterBody2D

var speed = 250.0
var direction = Vector2(1,1).normalized()
@export var damage = 1

func _physics_process(delta):
	velocity = direction*speed
	
	var collision = move_and_collide(velocity*delta)
	
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		direction = velocity.normalized()
		
		var collider = collision.get_collider()
		if collider.has_method("hit"):
			var reward = collider.hit(damage)
			get_parent().add_money(reward)
			
			
			
