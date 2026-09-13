extends StaticBody2D

@export var health = 3
@export var money_per_hit = 1
@export var cost = 2

func hit(damage: int):
	health -= damage
	if health <=0:
		queue_free()
	return money_per_hit
