extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var position: String = "a"
	
	print("来到场景")
	$CharacterBody2D.add_to_group("player")
	$ColorRect.modulate.a = 1
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


func _physics_process(delta: float) -> void:
	# 处理玩家移动
	var direction = Input.get_vector("left", "right", "up", "down") # Y轴顺序改了！
	if Input.is_action_pressed("fast"):
		$CharacterBody2D.velocity = direction * 150
		$CharacterBody2D.move_and_slide()
	else:
		$CharacterBody2D.velocity = direction * 50
		$CharacterBody2D.move_and_slide()
	if direction[0] != 0 or direction[1] != 0:
		$CharacterBody2D/AnimatedSprite2D.play("run")
		if not($Step.playing):
			$Step.play()
	else:
		$CharacterBody2D/AnimatedSprite2D.play("idle")
		$Step.stop()
	if $CharacterBody2D.velocity.x < 0:
		$CharacterBody2D/AnimatedSprite2D.flip_h = true  # 朝左
	elif $CharacterBody2D.velocity.x > 0:
		$CharacterBody2D/AnimatedSprite2D.flip_h = false # 朝右

# 当有东西进入了房间时
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		await get_tree().create_timer(1).timeout
		$CanvasLayer.visible = false
		$OpenDoor.play()
		SceneManager.fade_out()
		$ColorRect.modulate.a = 1
		
		SceneManager.change_scene("uid://g0x1c5b5amcg")
		
