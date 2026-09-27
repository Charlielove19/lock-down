extends StaticBody2D
@export var wall_data: WallData

var health: int


@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D
@export var placement_area: Area2D
@export var placement_area_collision_shape: CollisionShape2D
@export var wall_scale: float

func _ready() -> void:
	health = wall_data.max_health
	collision_shape.shape = collision_shape.shape.duplicate()
	collision_shape.shape.size = wall_data.size*wall_scale
	placement_area_collision_shape.shape = placement_area_collision_shape.shape.duplicate()
	placement_area_collision_shape.shape.size = wall_data.size*wall_scale
	sprite.scale = (wall_data.size/sprite.texture.get_size())*wall_scale
func hit(damage: int):
	health -= damage
	update_damage_visual()
	if health <=0:
		queue_free()
	return wall_data.money_per_hit
func update_damage_visual():
	var health_ratio = float(health)/float(wall_data.max_health)
	sprite.modulate = Color.RED.lerp(Color.GREEN, health_ratio)
