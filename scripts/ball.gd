extends CharacterBody2D
@onready var game = get_tree().current_scene

@export var start_speed: float
@onready var speed = start_speed
var direction = Vector2(0,1).normalized()

var difficulty = 0
var speed_increase_rate 
var damage

func _ready():
	difficulty = float(game.difficulty)
	print("difficulty: ", difficulty)
	speed_increase_rate = 1.0 + ((difficulty+1.0)/100.0)
	print("speed_increase_rate: ", speed_increase_rate)
	print("speed: ", speed)
	damage = (difficulty + 2)/2.0
	print("damage: ", damage)

func _physics_process(delta):
	velocity = direction*speed
	var collision = move_and_collide(velocity*delta)
	
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		direction = velocity.normalized()
		speed *= speed_increase_rate
		var collider = collision.get_collider()
		if collider.has_method("hit"):
			var reward = collider.hit(damage)
			game.add_money(reward, collider.position)
