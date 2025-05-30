extends Node2D
func _physics_process(delta: float) -> void:
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
