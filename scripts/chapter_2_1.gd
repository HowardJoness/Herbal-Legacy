extends Node2D

var Player_Can_Move:bool = false

func _physics_process(delta: float) -> void:
	if Player_Can_Move:
		# 处理玩家移动
		var direction = Input.get_vector("left", "right", "up", "down") # Y轴顺序改了！
		if Input.is_action_pressed("fast"):
			$Player.velocity = direction * 150
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

func _ready():
	$ColorRect.visible = true
	if GameManager.isPassC2_1Timeline == false:
		GameManager.scenedebug = "..."
		var position: String = "a"
		
		print("来到场景")
		$Player.add_to_group("player")
		$ColorRect.modulate.a = 1
		Dialogic.signal_event.connect(_on_event_triggered)
		Dialogic.start("Chapter2_1_PlayerAwake1")
		await Dialogic.timeline_ended
		GameManager.scenedebug = "时间线闭合"
		Player_Can_Move = true
		await get_tree().create_timer(1).timeout
		GameManager.scenedebug = "发送任务"
		GameManager.task = "阅读桌上的信纸"

func _on_event_triggered(event_name):
	if event_name == "ShowScene":
		GameManager.scenedebug = "黑罩隐藏"
		for i in range(100):  # 从 0 到 50，共 51 步（每步降低 0.01）
			$ColorRect.modulate.a = 1.0 - i * 0.01
			await get_tree().create_timer(0.03).timeout  # 每帧等待时间变长，让动画更慢

func _on_can_read_book_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.tips = "按 E 键查看信纸"
		


func _on_can_read_book_area_body_exited(body: Node2D) -> void:
	GameManager.tips = ""
