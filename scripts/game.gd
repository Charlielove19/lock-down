extends Node2D

@export var money_label: Label
@export var money = 4

@export var wall_scene: PackedScene
@export var wall_button: Button
var wall_preview
var dragging_wall:= false

func _ready():
	update_money_display()
func _process(_delta):
	if dragging_wall and wall_preview:
		wall_preview.global_position = get_global_mouse_position()
func _input(event):
	if event.is_action_pressed("rotate_left") and dragging_wall:
		print("rotate_left")
		wall_preview.rotation_degrees -= 15
	if event.is_action_pressed("rotate_right") and dragging_wall:
		print("rotate_right")
		wall_preview.rotation_degrees += 15	

func add_money(amount):
	money+=amount
	update_money_display()
func update_money_display():
	money_label.text = "Money: " + str(money)

func pickup_wall():
	wall_preview = wall_scene.instantiate()
	wall_preview.sprite.modulate.a = 0.5
	if money<=wall_preview.cost:
		wall_preview.queue_free()
		wall_preview = null
		return
	add_child(wall_preview)
	wall_preview.collision_shape.disabled = true
	dragging_wall = true
func drop_wall():
	if wall_button.get_global_rect().has_point(get_viewport().get_mouse_position()):
		wall_preview.queue_free()
	else:
		money -= wall_preview.cost
		update_money_display()
	wall_preview.sprite.modulate.a = 1
	wall_preview.collision_shape.disabled = false
	wall_preview = null
	dragging_wall = false
func _on_wall_button_button_down() -> void:
	pickup_wall()
func _on_wall_button_button_up() -> void:
	drop_wall()
