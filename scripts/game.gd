extends Node2D
@export var interactables: Node2D
#State Variables
var game_over_flag: bool
#coin variables
@export var coin_spawner:PackedScene
#difficulty variables
enum Difficulty{
	EASY,
	NORMAL,
	HARD,
	IMPOSSIBLE
}
@export var difficulty: Difficulty
@export var start_scenes: Array[PackedScene]

#money variables
@export var money_label: Label
@export var start_money: int
var money = 4
@export var money_particle_scene: PackedScene

#wall variables
@export var wall_scene: PackedScene
@export var wall_button_scene: PackedScene
@export var wall_datas: Array[WallData]
@export var wall_menu: VBoxContainer
var wall_preview
var dragging_wall:= false


# variables that concern placing wall inputs
var diagonal_grace_time:= 0.095
var last_input_direction: Vector2
var diagonal_grace:= 0.0
var cant_drop: bool


#UI
@export var game_UI: Control
@export var main_menu:Panel
@export var game_over_menu:Panel
@export var ball_scene: PackedScene

func start_game():
	money = start_money
	game_over_flag = false
	main_menu.visible = false
	game_over_menu.visible = false
	game_UI.visible = true
	
	var instantiated_coin_spawner = coin_spawner.instantiate()
	interactables.add_child(instantiated_coin_spawner)
	
	var start_scene = start_scenes[difficulty]
	var start_env = start_scene.instantiate()
	interactables.add_child(start_env)
	
	var ball = ball_scene.instantiate()
	ball.position = get_viewport_rect().get_center()
	interactables.add_child(ball)
	
	
func game_over():
	game_over_menu.visible = true
	game_over_flag = true
	clear_game()
func clear_game():
	game_UI.visible = false
	for child in interactables.get_children():
		child.queue_free()
func _ready():
	main_menu.visible = true
	game_over_menu.visible = false
	game_UI.visible = false
	update_money_display()
	create_wall_menu()
func _process(_delta):
	if dragging_wall and wall_preview:
		update_wall_direction(_delta)
		wall_preview.global_position = get_global_mouse_position()
		cant_drop = wall_preview.placement_area.has_overlapping_bodies()
		if cant_drop:
			wall_preview.sprite.modulate = Color.RED
		else:
			wall_preview.sprite.modulate = Color.GREEN
		wall_preview.sprite.modulate.a = 0.5
func spawn_money_particle(position_r:Vector2, value):
	var money_particle = money_particle_scene.instantiate()
	money_particle.set_text(value)
	money_particle.position = position_r
	game_UI.add_child(money_particle)
func add_money(amount, position_r:Vector2):
	if position_r == null:
		pass
	else:
		spawn_money_particle(position_r, amount)
	money+=amount
	update_money_display()
func update_money_display():
	money_label.text = "Money: " + str(money)
func pickup_wall(wall_data):
	if game_over_flag:
		return
	if money < wall_data.cost:
		print("Cant Afford")
		return
	
	wall_preview = wall_scene.instantiate()
	wall_preview.wall_data = wall_data
	interactables.add_child(wall_preview)
	
	wall_preview.collision_shape.disabled = true
	dragging_wall = true
func update_wall_direction(delta):
	var input_direction = Input.get_vector(
			"input_left",
			"input_right",
			"input_up",
			"input_down"
		)
	# checks if the input is diagonal and adds a small amount of grace to allow for letting go of both keys at once
	var is_diagonal = input_direction.x != 0 and input_direction.y != 0
	if is_diagonal:
		last_input_direction = input_direction
		diagonal_grace = diagonal_grace_time
	elif diagonal_grace > 0: 
		diagonal_grace -= delta
	elif input_direction != Vector2.ZERO:
		last_input_direction = input_direction
		
	
	
	wall_preview.rotation = lerp_angle(
		wall_preview.rotation,
		last_input_direction.angle() + deg_to_rad(90),
		25*delta
	)
func drop_wall():
	if game_over_flag:
		return
	if wall_preview == null:
		return
	if cant_drop:
		wall_preview.queue_free()
		dragging_wall = false
		return
	# create a new reference to wall instance so it isnt controlled by inputs anymore
	var placed_wall = wall_preview
	wall_preview = null
	dragging_wall = false
	# recalc and tween the angle of the placed wall as to avoid full 360 deg rotations after placement
	var target_rotation = last_input_direction.angle() + deg_to_rad(90)
	var rotation_diff = wrapf(target_rotation - placed_wall.rotation,-PI,PI)
	var adjusted_rotation_for_wrapping = placed_wall.rotation + rotation_diff
	var placed_wall_rotation_tween = create_tween()
	placed_wall_rotation_tween.tween_property(
		placed_wall,
		"rotation",
		adjusted_rotation_for_wrapping,
		0.08
	)
	#check if ball is in placed wall
	if placed_wall.placement_area.has_overlapping_bodies():
		placed_wall.queue_free()
		return
	add_money(-placed_wall.wall_data.cost, placed_wall.position) 
	await placed_wall_rotation_tween.finished
	placed_wall.sprite.modulate.a = 1
	placed_wall.collision_shape.disabled = false

func create_wall_menu():
	for wall_data in wall_datas:
		var button = wall_button_scene.instantiate()
		button.wall_data = wall_data
		button.text = wall_data.wall_name
		wall_menu.add_child(button)

func _on_boundaries_body_entered(_body: Node2D) -> void:
	game_over()



func _on_start_game_pressed() -> void:
	start_game()
func _on_restart_game_pressed() -> void:
	start_game()
