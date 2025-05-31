extends Control


func _ready() -> void:
	await get_tree().create_timer(3).timeout
	SceneManager.change_scene("uid://dvqufn63yw7m8")
