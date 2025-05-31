extends Node2D

# 玩家控制状态
var player_can_move := false
var player_read := false
var player_reading := false

# 节点缓存
@onready var player := $Player
@onready var sprite := $Player/AnimatedSprite2D
@onready var step_sound := $Step
@onready var paper := $CanvasLayer/Paperopen
@onready var black_overlay := $ColorRect

var book_scene: PackedScene = preload("uid://dsal210ib2gbj")
var book_instance: Node = null

func _ready():
	black_overlay.visible = true

	if not GameManager.isPassC2_1Timeline:
		GameManager.scenedebug = "进入剧情"
		print("来到场景")

		player.add_to_group("player")
		black_overlay.modulate.a = 1.0

		Dialogic.signal_event.connect(_on_event_triggered)
		Dialogic.start("Chapter2_1_PlayerAwake1")
		await Dialogic.timeline_ended

		GameManager.scenedebug = "时间线闭合"
		player_can_move = true

		await get_tree().create_timer(1).timeout
		GameManager.scenedebug = "发送任务"
		GameManager.task = "阅读桌上的信纸"

func _physics_process(delta: float) -> void:
	if player_can_move:
		_handle_movement()

func _handle_movement():
	var direction := Input.get_vector("left", "right", "up", "down")

	player.velocity = direction * (150 if Input.is_action_pressed("fast") else 50)
	player.move_and_slide()

	# 动画播放与脚步声
	if direction != Vector2.ZERO:
		sprite.play("run")
		if not step_sound.playing:
			step_sound.play()
	else:
		sprite.play("idle")
		step_sound.stop()

	# 左右翻转
	sprite.flip_h = player.velocity.x < 0

func _input(event):
	if (event is InputEventKey or event is InputEventMouseButton) and event.pressed:
		if player_reading:
			_hide_letter()
	if event is InputEventKey and event.pressed and event.keycode == KEY_B:
		if player_read:
			if book_instance == null:
				_show_book()

func _show_book():
	book_instance = book_scene.instantiate()
	get_tree().root.add_child(book_instance)  # 添加到场景树最顶层


func _hide_letter():
	player_reading = false
	player_read = true
	paper.visible = false
	black_overlay.modulate.a = 0.0
	player_can_move = true
	await get_tree().create_timer(1)
	GameManager.task = "坐到椅子上并开始你的工作"
	

func _on_event_triggered(event_name):
	if event_name == "ShowScene":
		GameManager.scenedebug = "黑罩隐藏"
		await _fade_out_black_overlay()

func _fade_out_black_overlay():
	for i in range(100):
		black_overlay.modulate.a = 1.0 - i * 0.01
		await get_tree().create_timer(0.03).timeout

func _on_can_read_book_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.tips = "按 E 键查看信纸"

func _process(_delta):
	if player_can_move and not player_reading and Input.is_key_pressed(KEY_E):
		for body in $CanReadBookArea.get_overlapping_bodies():# 避免在任何地方都能E
			if body.is_in_group("player"):  
				_show_letter()

func _show_letter():
	$Flipbook.play()
	GameManager.task = ""
	GameManager.tips = ""
	$CanReadBookArea.queue_free()
	$House/Paper.queue_free()
	player_can_move = false
	black_overlay.modulate.a = 0.75
	paper.visible = true
	player_reading = true
	

func _on_can_read_book_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.tips = ""
