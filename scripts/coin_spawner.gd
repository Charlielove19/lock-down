extends Node

@export var coin:PackedScene
@export var area:CollisionShape2D
@onready var coins_spawned:= int(0)

func _ready():
	print("coin_spawner_instantiated")

func _process(delta):
	if coins_spawned<1:
		spawn_coin()
func create_position_in_area():
	var rect = area.shape.get_rect()
	var x = randf_range(0, rect.size.x)
	var y = randf_range(0, rect.size.y)
	var position = Vector2(x,y)
	return position
func spawn_coin():
	print("coins spawned:", coins_spawned)
	coins_spawned += 1
	var random_position = create_position_in_area()
	print("random position is: ", random_position)
	var instantiated_coin = coin.instantiate()
	instantiated_coin.position = random_position
	add_child(instantiated_coin)
