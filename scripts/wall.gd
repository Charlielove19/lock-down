extends StaticBody2D
@export var wall_data: WallData

var health: int


@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D
@export var placement_area: Area2D

func _ready() -> void:
	health = wall_data.max_health
func hit(damage: int):
	health -= damage
	update_damage_visual()
	if health <=0:
		queue_free()
	return wall_data.money_per_hit
func update_damage_visual():
	var health_ratio = float(health)/float(wall_data.max_health)
	sprite.modulate = Color.RED.lerp(Color.GREEN, health_ratio)
