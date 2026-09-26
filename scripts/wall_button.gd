extends Button

var wall_data:WallData
@onready var game = get_tree().current_scene
	
func _on_button_down() -> void:
	game.pickup_wall(wall_data)
	
func _on_button_up() -> void:
	game.drop_wall()
