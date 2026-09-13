extends StaticBody2D

@export var max_health: int =3
@export var health: int
@export var money_per_hit: int = 1
@export var cost = 2
@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D

func _ready() -> void:
	health = max_health
func hit(damage: int):
	health -= damage
	update_damage_visual()
	if health <=0:
		queue_free()
	return money_per_hit
func update_damage_visual():
	var health_ratio = float(health)/float(max_health)
	var sprite_index
	sprite.modulate = Color.RED.lerp(Color.GREEN, health_ratio)
