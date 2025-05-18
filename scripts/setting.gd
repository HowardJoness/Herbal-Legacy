extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Exit.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_pressed() -> void:
	var SettingScene = load("uid://vgyu1plwjec4") 
	var Setting = SettingScene.instantiate()  
	get_tree().current_scene.add_child(Setting) 
