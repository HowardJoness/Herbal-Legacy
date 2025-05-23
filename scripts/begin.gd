extends Control

var BGMplayed = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.developer_mode = false
	$StartButton.grab_focus()
	GameManager.scenedebug = "..."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if BGMplayed == true:
		if not($AudioStreamPlayer.playing):
			$AudioStreamPlayer.play()
	else:
		$AudioStreamPlayer.play()
		BGMplayed = true
			

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_setting_button_pressed() -> void:
	var SettingScene = load("uid://co3kutwp0y3bs") 
	var Setting = SettingScene.instantiate()  
	get_tree().current_scene.add_child(Setting) 


func _on_start_button_pressed() -> void:
	print("切换场景")
	SceneManager.change_scene("uid://dx8af5gtxvonq", {
	"pattern": "scribbles",
	"pattern_leave": "fade"
})
