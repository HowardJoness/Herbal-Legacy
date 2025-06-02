extends CanvasLayer


@onready var Logo: Sprite2D = $YaoluLogo
@onready var title: Label = $Title
@onready var step: Label = $Step
@onready var buttons: Control = $Control
@onready var ShaguoButton: TextureButton = $Control/Shaguo
@onready var BuxiugangguoButton: TextureButton = $Control/Buxiugangguo
@onready var fire_slider_bg := $FireSlider/TextureRect
@onready var fire_slider_handle := $FireSlider/TextureButton


var finish = false

var fire_value := 0.5  # 取值 0.0 ~ 1.0，代表火候大小

var onFiring:bool = false

func _start_button_fadeout():
	for i in range(10):
		Logo.modulate.a = 1.0 - i * 0.1
		title.modulate.a = 1.0 - i * 0.1
		step.modulate.a = 1.0 - i * 0.1
		buttons.modulate.a = 1.0 - i * 0.1
		Logo.modulate.a = 1.0 - i * 0.1
		$FireSlider.modulate.a = 1.0 - i * 0.1
		$Label.modulate.a = 1.0 - i * 0.1
		$Label2.modulate.a = 1.0 - i * 0.1
		$YaoluBag.modulate.a = 1.0 - i * 0.1
		$Label3.modulate.a = 1.0 - i * 0.1
		$Button.modulate.a = 1.0 - i * 0.1
		await get_tree().create_timer(0.01).timeout
	Logo.modulate.a = 0
	title.modulate.a = 0
	step.modulate.a = 0
	buttons.modulate.a = 0
	Logo.modulate.a = 0
	$FireSlider.modulate.a = 0
	$Label.modulate.a = 0
	$Label2.modulate.a = 0
	$YaoluBag.modulate.a = 0
	$Label3.modulate.a = 0
	$Button.modulate.a = 0
	$AnimationPlayer.play("RESET")
	$Button.visible = false
	
func _background_fadeout():
	var texture_rect = $TextureRect
	if texture_rect.material and texture_rect.material is ShaderMaterial:
		var shader_material = texture_rect.material as ShaderMaterial
		var i = 2.65
		while i >= 0:
			shader_material.set_shader_parameter("lod", i)
			await get_tree().create_timer(0.0008).timeout
			i -= 0.2


var guo:String = "" # 玩家选择的锅底

func _initialize() -> void:
	guo = ""
	var texture_rect = $TextureRect
	if texture_rect.material and texture_rect.material is ShaderMaterial:
		var shader_material = texture_rect.material as ShaderMaterial
		shader_material.set_shader_parameter("lod", 0)
	Logo.modulate.a = 0
	Logo.visible = false
	step.modulate.a = 0
	step.visible = false
	step.text = "步骤 1 / 2"
	title.visible = false
	buttons.visible = false
	$Button.visible = false
	$AnimationPlayer.play("RESET")
	ShaguoButton.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	BuxiugangguoButton.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	
func _ready() -> void:
	_initialize()
	await get_tree().create_timer(1).timeout
	_playJian()
	

# 背景模糊
func _background_fadein() -> void:
	var texture_rect = $TextureRect
	if texture_rect.material and texture_rect.material is ShaderMaterial:
		var shader_material = texture_rect.material as ShaderMaterial
		var i = 0.0
		while i <= 2.64:
			shader_material.set_shader_parameter("lod", i)
			await get_tree().create_timer(0.0008).timeout
			i += 0.2

# Logo & Step 逐渐出现
func _logostep_fadein() -> void:
	Logo.visible = true
	step.visible = true
	
	for i in range(10):
		Logo.modulate.a = 0.0 + i * 0.1 
		step.modulate.a = 0.0 + i * 0.1 
		await get_tree().create_timer(0.01).timeout


func _Step1() -> void:
	title.visible = true
	buttons.visible = true
	_background_fadein()
	_logostep_fadein()
	$AnimationPlayer.play("Step1")

func _Step2() -> void:
	title.text = "准备开火"
	step.text = "步骤 2 / 2"
	title.visible = true
	$AnimationPlayer.play("Step2")

func _playJian() -> float:
	_initialize()
	title.text = "请选择您的药炉"
	_Step1()
	await get_tree().create_timer(1).timeout
	while guo == "":
		await get_tree().create_timer(0.1).timeout
	$AnimationPlayer.play("Step1_done")
	buttons.visible = false
	await get_tree().create_timer(0.4).timeout
	title.text = "准备开火"
	$AnimationPlayer.play("Step2")
	fire_slider_handle.connect("gui_input", _on_fire_slider_handle_input)
	_update_fire_slider_ui()
	while onFiring == false:
		await get_tree().create_timer(0.1).timeout
	$Timer.start(30)
	title.text = "煎药中... (" + str(int($Timer.time_left)) + "s)"
	onFiring= true # 开始烤火
	_updateFireUI()
	return 1


func _on_shaguo_pressed() -> void:
	guo = "shaguo"
	print("1")
var record_time: Array = []
var fire_log: Array = []
func _updateFireUI() -> void:
	fire_log.clear()  # 每次开始时清空上一次的记录
	var counter := 0
	
	while onFiring:
		if onFiring:
			$GUO/Fire.play()
			title.text = "煎药中... (" + str(int($Timer.time_left)) + "s)"
			# 获取当前火力值，范围为 0.0 - 1.0
			var Fire = (fire_slider_handle.position.x - 309.0) / (760.0 - 309.0)
			Fire = clamp(Fire, 0.0, 1.0)  # 防止越界

			# 动画播放速度控制（可选）
			if Fire < 0.3:
				$GUO/Fire.speed_scale = 1
			elif Fire < 0.6:
				$GUO/Fire.speed_scale = 2
			else:
				$GUO/Fire.speed_scale = 4

			# 记录火力
			if not(int($Timer.time_left) in record_time):
				fire_log.append(Fire)
				counter += 1
				record_time.append(int($Timer.time_left))

		await get_tree().create_timer(0.1).timeout

	$GUO/Fire.stop()

func _on_buxiugangguo_pressed() -> void:
	guo = "buxiugangguo"

func _on_fire_slider_handle_input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		onFiring= true # 开始烤火
		var global_mouse = get_viewport().get_mouse_position()
		var x = clamp(global_mouse.x, 309.0, 760.0)

		var local_mouse = fire_slider_handle.get_parent().get_global_transform_with_canvas().affine_inverse() * Vector2(x, global_mouse.y)
		fire_slider_handle.position.x = local_mouse.x
		var total_range = 760-309
		var thefire = (x - 309.0) / total_range
		print(thefire)

func _update_fire_slider_ui():
	var percent = fire_value
	var track_width = fire_slider_bg.size.x
	var handle_half_width = fire_slider_handle.size.x / 2
	fire_slider_handle.position.x = percent * track_width - handle_half_width



func _on_timer_timeout() -> void:
	print(1)
	onFiring = false
	print(fire_log)
	print(record_time)
	var total_error = 0.0
	var total_score = 0.0
	var ideal_fire_curve = [
	0.8, 0.85, 0.9, 0.95, 1.0, 0.9, 0.85, 0.8, 0.7, 0.6,  # 前10秒
	0.5, 0.45, 0.4, 0.4, 0.35, 0.35, 0.3, 0.3, 0.35, 0.4,  # 中段
	0.45, 0.4, 0.35, 0.3, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.5   # 后段
]

	for i in range(30):
		var player_fire = fire_log[i]
		var ideal_fire = ideal_fire_curve[i]
		var weight = 0.0
		if i < 10:
			weight = 0.4
		else:
			weight = 1.0

		var diff = abs(player_fire - ideal_fire) * weight
		total_error += diff
		total_score += (1.0 - diff) * weight
	$Timer.queue_free()
	print(total_error)
	print(total_score)

	# 初始化评级变量
	var rating := ""
	var idiom := ""
	var comment := ""

	# 根据误差自动判定评级与成语
	if total_error < 2.0:
		rating = "S"
		idiom = "炉火纯青"
		comment = "火候精准无误，药汤药效极佳。"
	elif total_error < 4.0:
		rating = "A"
		idiom = "得心应手"
		comment = "整体火候掌握得不错，操作稳定，药效基本发挥出来。"
	elif total_error < 6.0:
		rating = "B"
		idiom = "差强人意"
		comment = "火候略有偏差，药效打了一些折扣。"
	else:
		rating = "C"
		idiom = "谬以千里"
		comment = "火候严重偏差，药效基本流失，建议重新煎药。"

	# 生成最终文本
	var result_text := "总误差：%.3f\n" % total_error
	result_text += "加权得分：%.1f / 30\n" % total_score
	result_text += "评级：%s（%s）\n" % [rating, idiom]

	# 输出到控制台或 UI
	print(result_text)
	$Label2.text = result_text
	$Label3.text = comment
	$Button.visible = true
	$AnimationPlayer.play("Finish")
	


func _on_button_pressed() -> void:
	_background_fadeout()
	_start_button_fadeout()
	finish = true
