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
var now_npc: int = 1 # 现在出场的NPC编号
var now_timeline_status = 1 # 1: 剧情刚刚开始（玩家还没坐到过椅子上）  2：玩家已经坐到椅子上了，已经开始工作了 3：玩家已经过关了煎药1 4：过关煎药2
var now_character = "NPC1"
var isinyaolu:bool = false
var isGoinToJianyao: bool = false
var book_scene: PackedScene = preload("uid://dsal210ib2gbj")
var book_instance: bool = false


func _ready():
	GameManager.developer_mode = true
	black_overlay.visible = true
	if not GameManager.isPassC2_1Timeline:
		GameManager.scenedebug = "进入剧情"
		print("来到场景")

		player.add_to_group("player")
		black_overlay.modulate.a = 1.0
	
		Dialogic.signal_event.connect(_on_event_triggered)
		GameManager.Gaming = true
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
	if player_can_move == true:
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
			if book_instance == false:
				book_instance = true
				
			else:
				book_instance = false
			$CanvasLayer/OldBook.visible = book_instance
			$CanvasLayer/TaskShow.visible = not(book_instance)
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
		if Dialogic.current_timeline != null:
			black_overlay.modulate.a = 1.0 - i * 0.01
			await get_tree().create_timer(0.03).timeout
		else:
			black_overlay.modulate.a = 0.0
			break
			
func _on_can_read_book_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.tips = "按 E 键查看信纸"

func _process(_delta):
	if player_can_move and not player_reading and Input.is_key_pressed(KEY_E) and not player_read:
		for body in $CanReadBookArea.get_overlapping_bodies():# 避免在任何地方都能E
			if body.is_in_group("player"):  
				_show_letter()

func _show_letter():
	$Flipbook.play()
	GameManager.task = ""
	GameManager.tips = ""
	$CanReadBookArea.queue_free()
	$Paper.queue_free()
	player_can_move = false
	black_overlay.modulate.a = 0.75
	paper.visible = true
	player_reading = true
	

func _on_can_read_book_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.tips = ""


func _Bamai(TimelineName: String, Correct_Result: String, NPCID:String = "NPC1", NPCSpeed:int = 30) -> void:
	# 开始【把脉】流程
	
	$NPC/Control.面相 = "..."
	$NPC/Control.症状 = "..."
	$NPC/Control.脉搏 = "..."
	$NPC/Control.visible = true
	$NPC.visible = true
	$OpenDoor.play()
	$NPC.play("%s_idle" % NPCID)
	await get_tree().create_timer(1).timeout
	$NPC.play("%s_run_down" % NPCID)
	var npc_target = Vector2(207, 183) # 目标坐标
	var speed = NPCSpeed
	$Step.play()
	while $NPC.global_position.distance_to(npc_target) > 1:
		var direction = (npc_target - $NPC.global_position).normalized()
		$NPC.global_position += direction * speed * get_process_delta_time()
		await get_tree().process_frame
	$Step.stop()
	$NPC.play("%s_idle" % NPCID)
	Dialogic.start(TimelineName)
	print(Dialogic.current_timeline)
	while Dialogic.current_timeline == null:
		await get_tree().create_timer(0.1).timeout
	while Dialogic.current_timeline != null:
		$NPC/Control.面相 = Dialogic.VAR["面相"]
		$NPC/Control.症状 = Dialogic.VAR["症状"]
		$NPC/Control.脉搏 = Dialogic.VAR["脉搏"]
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(1).timeout
	$NPC.play("%s_run_up" % NPCID)
	print(Dialogic.current_timeline)
	npc_target = Vector2(207, 91) # 目标坐标
	$Step.play()
	while $NPC.global_position.distance_to(npc_target) > 1:
		var direction = (npc_target - $NPC.global_position).normalized()
		$NPC.global_position += direction * speed * get_process_delta_time()
		await get_tree().process_frame
	$Step.stop()
	$OpenDoor.play()
	$NPC.visible =false
	
	await get_tree().create_timer(1).timeout
	if Dialogic.VAR["result"] == Correct_Result:
		$CanvasLayer/Control._success()
	else:
		$CanvasLayer/Control._failed()
	GameManager._loseJudge() # 进行一次失败判定



func _on_player_sit_on_chair(body: Node2D) -> void:
	if body.is_in_group("player") and player_read and now_timeline_status == 1:
		now_timeline_status = 2
		# 玩家准备好营业了
		$Step.stop()
		GameManager.task = ""
		GameManager.tips = ""
		player_can_move = false
		sprite.play("idle_up")
		player.position = Vector2(113,155)
		for i in range(20):
			$CanvasLayer/Control.modulate.a = 0.0 + i * 0.05
			await get_tree().create_timer(0.002).timeout
		await get_tree().create_timer(2.35).timeout
		 ##启动把脉对话23
		now_character = "NPC4"
		# Chapter2_1_Jianyao1 流程开启
		player_can_move = false
		$NPC.visible = true
		$NPC/Control.visible = false
		$OpenDoor.play()
		$NPC.play(now_character+"_idle")
		await get_tree().create_timer(1).timeout
		$NPC.play(now_character+"_run_down")
		var npc_target = Vector2(207, 183) # 目标坐标
		var speed = 30.0
		$Step.play()
		while $NPC.global_position.distance_to(npc_target) > 1:
			var direction = (npc_target - $NPC.global_position).normalized()
			$NPC.global_position += direction * speed * get_process_delta_time()
			await get_tree().process_frame
		$Step.stop()
		$NPC.play(now_character+"_idle")
		Dialogic.start("Chapter2_1_JianYao1")
		await Dialogic.timeline_ended
		await get_tree().create_timer(1).timeout
		GameManager.task = "走到药炉旁"
		isGoinToJianyao = true
		player.position = Vector2(90, 155)
		$Player/AnimatedSprite2D.play("idle")
		player_can_move = true
		while now_timeline_status != 3:
			await get_tree().create_timer(0.1).timeout
		await get_tree().create_timer(1).timeout
		
		now_character = "NPC5"
		# Chapter2_1_Jianyao2 流程开启
		now_timeline_status = 2
		player_can_move = false
		$NPC.visible = true
		$NPC/Control.visible = false
		$OpenDoor.play()
		$NPC.play(now_character+"_idle")
		await get_tree().create_timer(1).timeout
		$NPC.play(now_character+"_run_down")
		npc_target = Vector2(207, 183) # 目标坐标
		speed = 30.0
		$Step.play()
		while $NPC.global_position.distance_to(npc_target) > 1:
			var direction = (npc_target - $NPC.global_position).normalized()
			$NPC.global_position += direction * speed * get_process_delta_time()
			await get_tree().process_frame
		$Step.stop()
		$NPC.play(now_character+"_idle")
		Dialogic.start("Chapter2_1_JianYao2")
		await Dialogic.timeline_ended
		await get_tree().create_timer(1).timeout
		GameManager.task = "走到药炉旁"
		isGoinToJianyao = true
		player.position = Vector2(90, 155)
		$Player/AnimatedSprite2D.play("idle")
		player_can_move = true
		while now_timeline_status != 3:
			await get_tree().create_timer(0.1).timeout
		await get_tree().create_timer(1).timeout


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_can_move = false
		$Player/AnimatedSprite2D.play("idle")
		var scene_res = load("uid://7nuo2s3t6q8g")
		var scene_instance = scene_res.instantiate()
		add_child(scene_instance)
		print(scene_instance.finish)
		# 等待场景进入树中、ready 完成
		while scene_instance.finish == false:
			await get_tree().create_timer(0.1).timeout
		print(scene_instance.finish)
		var rating = scene_instance.rating
		scene_instance.queue_free()
		GameManager.task = ""
		GameManager.tips = ""
		for i in range(100):
			black_overlay.modulate.a = 0.0 + i * 0.01
			await get_tree().create_timer(0.01).timeout
		await get_tree().create_timer(0.1).timeout
			
		sprite.play("idle_up")
		
		player.position = Vector2(113,155)
		await get_tree().create_timer(1).timeout
		for i in range(100):
			black_overlay.modulate.a = 1.0 - i * 0.01
			await get_tree().create_timer(0.01).timeout
		
		if rating == "S" or rating == "A":
			Dialogic.start("Chapter2_1_JianYao"+str(now_timeline_status-1)+"_result")
		else:
			Dialogic.start("Chapter2_1_JianYao"+str(now_timeline_status-1)+"_result_badend")
		await Dialogic.timeline_ended
		await get_tree().create_timer(1).timeout
		$NPC.play(now_character+"_run_up")
		print(Dialogic.current_timeline)
		var npc_target = Vector2(207, 91) # 目标坐标
		$Step.play()
		while $NPC.global_position.distance_to(npc_target) > 1:
			var direction = (npc_target - $NPC.global_position).normalized()
			$NPC.global_position += direction * 30 * get_process_delta_time()
			await get_tree().process_frame
		$Step.stop()
		$OpenDoor.play()
		$NPC.visible =false
		now_timeline_status = 3
		# 结算动画
		if rating == "S" or rating == "A":
			$CanvasLayer/Control._success()
		else:
			$CanvasLayer/Control._failed()
		GameManager._loseJudge()
		
