extends Node2D

@onready var Player:CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.scenedebug = "..."
	var position: String = "a"
	print("来到场景")
	Player.add_to_group("player")
	
	$ColorRect.modulate.a = 1
	GameManager.GameBegin()
	Dialogic.start("Character1_1_FindGrandFather")
	await Dialogic.timeline_ended
	await get_tree().create_timer(1).timeout
	$RainBGM.play()
	# 淡出到50%透明度，过程更慢一些～
	for i in range(26):  # 从 0 到 50，共 51 步（每步降低 0.01）
		$ColorRect.modulate.a = 1.0 - i * 0.01
		await get_tree().create_timer(0.03).timeout  # 每帧等待时间变长，让动画更慢
	await get_tree().create_timer(1).timeout
	GameManager.task = "找到爷爷"
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# 当有东西进入了房间时
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		await get_tree().create_timer(1).timeout
		$CanvasLayer.visible = false
		$OpenDoor.play()
		SceneManager.fade_out()
		$ColorRect.modulate.a = 1
		GameManager.Gaming = false
		SceneManager.change_scene("uid://g0x1c5b5amcg")
		
