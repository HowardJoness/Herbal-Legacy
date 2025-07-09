extends Node2D
var grandpa_is_alive = true
var PlotAlreadyPlayed: bool = false
var FinishAnimation:bool = false
@onready var Player: CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.Gaming = true
	$CanvasLayer/White.visible = false
	GameManager.scenedebug = "..."
	Player.moveable = true
	Player.add_to_group("player")
	$Button.modulate.a = 1
	$Button.visible = false
	$Cover.visible = false
	GameManager.task = "与爷爷对话"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if PlotAlreadyPlayed:
		if Input.is_key_pressed(KEY_B):
			GameManager.scenedebug = "玩家按下了按键B"
			PlotAlreadyPlayed = false
			GameManager.scenedebug = "出书动画开始播放"
			GameManager.task = ""
			GameManager.tips = ""
			$CanvasLayer/BookseekPlayer.play("bookseek")
		else:
			GameManager.scenedebug = "s"
	if not($RainBGM.playing) and not(FinishAnimation):
		$RainBGM.play()



func _on_grand_pa_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.scenedebug = "玩家触发爷爷碰撞箱"
		$Button.modulate.a = 0
		$Button.visible = true
		$Button.grab_focus()
		GameManager.tips = "按 E 键与爷爷对话"
		


func _on_grand_pa_body_exited(body: Node2D) -> void:
	GameManager.scenedebug = "玩家离开爷爷碰撞箱"
	$Button.modulate.a = 0
	GameManager.tips = ""


func _on_button_pressed() -> void:
	
	$Button.visible = false
	$Button.disabled = true
	Player.moveable = false
	GameManager.tips = ""
	GameManager.task = ""
	$Grandpa/AnimatedSprite2D.stop()
	$Grandpa/AnimatedSprite2D.frame = 0
	Dialogic.start("Character1_2_TalkWithGrandFather")
	Dialogic.timeline_ended.connect(_on_dialogue_finished)
	Dialogic.signal_event.connect(_on_event_triggered)
	
	
func _on_dialogue_finished():
	Player.moveable = true
	grandpa_is_alive = false
	$Grandpa.queue_free()
	await get_tree().create_timer(1).timeout
	GameManager.scenedebug = "剧情结束"
	GameManager.task = "打开爷爷给予你的书本"
	GameManager.tips = "按 B 键打开书本"
	PlotAlreadyPlayed = true
		
func _on_event_triggered(event_name):
	if event_name == "Showbook":
		$Cover.visible = true
		$AnimationPlayer.play("bookseek")
	elif event_name == "die":
		GameManager.scenedebug = "爷爷趋势"
		for i in range(100, 0, -1):
			if grandpa_is_alive == true:
				$Grandpa/AnimatedSprite2D.modulate.a = i * 0.01
				await get_tree().create_timer(0.008).timeout


func _OnBookseekPlayed(anim_name: StringName) -> void:
	# 播放出书动画
	$BookSlide.play()
	GameManager.scenedebug = "执行伪对焦"
	var texture_rect = $CanvasLayer/TextureRect
	if texture_rect.material and texture_rect.material is ShaderMaterial:
		var shader_material = texture_rect.material as ShaderMaterial
		var i = 0.0
		while i <= 2.64:
			shader_material.set_shader_parameter("lod", i)
			await get_tree().create_timer(0.008).timeout
			i += 0.2
	GameManager.scenedebug = "伪对焦完毕 等待时间<3.01"
#	
	while $CanvasLayer/BookseekPlayer.current_animation_position < 3.01:
		## 新增功能: 检查动画播放时间
		if $CanvasLayer/BookseekPlayer.current_animation_position >= 2.9 and $CanvasLayer/BookseekPlayer.current_animation_position < 3.0:
			$BookOpen.play()
			FinishAnimation = true
			$RainBGM.stop()
		await get_tree().create_timer(0.1).timeout
		GameManager.scenedebug = str($CanvasLayer/BookseekPlayer.current_animation_position)
	
	GameManager.scenedebug = "超时"
	$CanvasLayer/White.visible = true
	for i in range(0, 100, 5):
		$CanvasLayer/White.modulate.a = i * 0.01
		await get_tree().create_timer(0.0002).timeout
	await get_tree().create_timer(1.4).timeout
	$CanvasLayer/Black.visible = true
	for i in range(0, 100, 5):
		$CanvasLayer/Black.modulate.a = i * 0.01
		await get_tree().create_timer(0.0002).timeout
	await get_tree().create_timer(1).timeout
	GameManager.Gaming = false
	SceneManager.change_scene("uid://vsvc6wy7tl7w")
