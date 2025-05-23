extends Node2D
var grandpa_is_alive = true
var nottalking = true
var PlotAlreadyPlayed: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	GameManager.scenedebug = "..."
	$RainBGM.play()
	$Player.add_to_group("player")
	$Button.modulate.a = 1
	$Button.visible = false
	$Cover.visible = false
	GameManager.task = "与爷爷对话"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if PlotAlreadyPlayed:
		if Input.is_key_pressed(KEY_B):
			GameManager.scenedebug = "玩家按下了按键B"



func _physics_process(delta: float) -> void:
	
	# 处理玩家移动
	var direction = Input.get_vector("left", "right", "up", "down") # Y轴顺序改了！
	if nottalking:
		
		if Input.is_action_pressed("fast"):
			$Player.velocity = direction * 100
			$Player.move_and_slide()
		else:
			$Player.velocity = direction * 50
			$Player.move_and_slide()
		if direction[0] != 0 or direction[1] != 0:
			$Player/AnimatedSprite2D.play("run")
			if not($Step.playing):
				$Step.play()
		else:
			$Player/AnimatedSprite2D.play("idle")
			$Step.stop()
		if $Player.velocity.x < 0:
			$Player/AnimatedSprite2D.flip_h = true  # 朝左
		elif $Player.velocity.x > 0:
			$Player/AnimatedSprite2D.flip_h = false # 朝右


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
	nottalking = false
	GameManager.tips = ""
	GameManager.task = ""
	$Grandpa/AnimatedSprite2D.stop()
	$Grandpa/AnimatedSprite2D.frame = 0
	Dialogic.start("Character1_2_TalkWithGrandFather")
	Dialogic.timeline_ended.connect(_on_dialogue_finished)
	Dialogic.signal_event.connect(_on_event_triggered)
	
	
func _on_dialogue_finished():
	nottalking = true
	grandpa_is_alive = false
	$Grandpa.queue_free()
	await get_tree().create_timer(1).timeout
	GameManager.scenedebug = "剧情结束"
	GameManager.task = "打开爷爷给予你的书本"
	GameManager.tips = "按 B 键打开书本"
	"""
	屏幕逐渐变模糊代码：
	
	var texture_rect = $CanvasLayer/TextureRect
	if texture_rect.material and texture_rect.material is ShaderMaterial:
		var shader_material = texture_rect.material as ShaderMaterial
		var i = 0.0
		while i <= 2.64:
			shader_material.set_shader_parameter("lod", i)
			await get_tree().create_timer(0.008).timeout
			i += 0.2
	"""
		
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
