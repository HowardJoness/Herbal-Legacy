extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.scenedebug = "..."
	await get_tree().create_timer(3).timeout
	SceneManager.change_scene("uid://crcwk8xvr47cs")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
