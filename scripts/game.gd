extends Node2D

@export var money_label: Label
@export var money = 4

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



func _ready():
	update_money_display()
	for wall_data in wall_datas:
		var button = wall_button_scene.instantiate()
		button.wall_data = wall_data
		button.text = wall_data.wall_name
		wall_menu.add_child(button)
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
func add_money(amount):
	money+=amount
	update_money_display()
func update_money_display():
	money_label.text = "Money: " + str(money)
func pickup_wall(wall_data):
	wall_preview = wall_scene.instantiate()
	wall_preview.wall_data = wall_data
	
	if money < wall_preview.wall_data.cost:
		wall_preview.queue_free()
		wall_preview = null
		print("Cant Afford")
		return
	add_child(wall_preview)
	
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
	if wall_preview == null:
		return
	if cant_drop:
		wall_preview.queue_free()
		dragging_wall = false
		return

	money -= wall_preview.wall_data.cost
	update_money_display()
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
	await placed_wall_rotation_tween.finished
	placed_wall.sprite.modulate.a = 1
	placed_wall.collision_shape.disabled = false
	
