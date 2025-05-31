extends Control

func _start_button_fadeout():
	for i in range(10):
		$Button.modulate.a = 1.0 - i * 0.1 
		$Label.modulate.a = 1.0 - i * 0.1 
		$Label2.modulate.a = 1.0 - i * 0.1 
		$AnimatedSprite2D.modulate.a = 1.0 - i * 0.1 
		await get_tree().create_timer(0.01).timeout
	$Button.modulate.a = 0
	$Label.modulate.a = 0
	$Label2.modulate.a =0
	$AnimatedSprite2D.modulate.a = 0
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


func _start_button_fadein():
	for i in range(10):
		$AnimatedSprite2D.modulate.a = 0.0 + i * 0.1
		await get_tree().create_timer(0.01).timeout
func _background_fadein():
	var texture_rect = $TextureRect
	if texture_rect.material and texture_rect.material is ShaderMaterial:
		var shader_material = texture_rect.material as ShaderMaterial
		var i = 0.0
		while i <= 2.64:
			shader_material.set_shader_parameter("lod", i)
			await get_tree().create_timer(0.0008).timeout
			i += 0.2

var is_in_UI:bool = false

func _success() -> void:
	if not(is_in_UI):
		is_in_UI = true
		if GameManager.Reputation < 10:
			GameManager.Reputation += 1
		$Label.text = "成功的诊断"
		$Label2.text = "声望 +1"
		$Label.add_theme_color_override("font_color", Color(0, 1, 0))  # RGB 绿色
		$Label2.add_theme_color_override("font_color", Color(0, 1, 0))  # RGB 绿色
		$AnimatedSprite2D.frame = 1
		$Button.visible = false
		_start_button_fadein()
		_background_fadein()
		$AnimationPlayer.play("Show")
		await get_tree().create_timer(0.1).timeout
		$Button.visible = true
		for i in range(10):
			$Button.modulate.a = 0.0 + i * 0.1
			await get_tree().create_timer(0.01).timeout
		$Button.grab_focus()

func _failed() -> void:
	if not(is_in_UI):
		if GameManager.Reputation > 0:
			GameManager.Reputation -= 2
		is_in_UI = true
		$Label.text = "失败的诊断"
		$Label2.text = "声望 -2"
		$Label.add_theme_color_override("font_color", Color(1, 0, 0))  # RGB 红色
		$Label2.add_theme_color_override("font_color", Color(1, 0, 0))  # RGB 红色
		$AnimatedSprite2D.frame = 0
		$Button.visible = false
		_start_button_fadein()
		_background_fadein()
		$AnimationPlayer.play("Show")
		await get_tree().create_timer(0.1).timeout
		$Button.visible = true
		for i in range(10):
			$Button.modulate.a = 0.0 + i * 0.1
			await get_tree().create_timer(0.01).timeout
		$Button.grab_focus()

func _ready() -> void:
	$AnimatedSprite2D.modulate.a = 0
	
	
	

func _process(delta: float) -> void:
	$ProgressBar.value = GameManager.Reputation
	
	# # 在玩家第一次启用声望值的时候显示教程
	#if GameManager.Reputation_Enable:
		#$ProgressBar.visible = true
		#if GameManager.Reputation_show == false:
			#GameManager.Reputation_show == true
			#$ColorRect.visible = true


func _on_button_pressed() -> void:
	_start_button_fadeout()
	_background_fadeout()
	is_in_UI = false
