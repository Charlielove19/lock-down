@tool
extends StaticBody2D
@export var wall_data: WallData:
	set(value):
		wall_data = value
		if is_node_ready():
			apply_wall_data(wall_data)




var health: int


@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D
@export var placement_area: Area2D
@export var placement_area_collision_shape: CollisionShape2D
@export var wall_scale: float

func _ready() -> void:
	if wall_data:
		apply_wall_data(wall_data)
func hit(damage: int):
	health -= damage
	update_damage_visual()
	if health <=0:
		queue_free()
	return wall_data.money_per_hit
func update_damage_visual():
	var health_ratio = float(health)/float(wall_data.max_health)
	sprite.modulate = Color.RED.lerp(Color.GREEN, health_ratio)
	
func apply_wall_data(wall_data_r):
	if wall_data_r == null:
		return
	
	sprite.texture = wall_data.texture
	health = wall_data.max_health
	collision_shape.shape = collision_shape.shape.duplicate()
	collision_shape.shape.size = wall_data.size*wall_scale
	placement_area_collision_shape.shape = placement_area_collision_shape.shape.duplicate()
	placement_area_collision_shape.shape.size = wall_data.size*wall_scale
	sprite.scale = (wall_data.size/sprite.texture.get_size())*wall_scale
