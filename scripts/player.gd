extends CharacterBody2D

@export var moveable: bool = true
@export var player_floor: String = "floor_grass" # 玩家脚下踩着的材质类型 floor_grass：草 floor_wood：木
@export var player_scale: float = 1.0
var the_step_audio_speed: float = 1 # 音量速度标准（部分音频文件可能有速度缩放的需求）

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if moveable:
		if Input.is_action_pressed("fast"):
			velocity = direction * 150
			$Step.pitch_scale = the_step_audio_speed * 1.7
			$AnimatedSprite2D.speed_scale = 1.6
		else:
			velocity = direction * 50
			$Step.pitch_scale = the_step_audio_speed * 1.0
			$AnimatedSprite2D.speed_scale = 1.0
		move_and_slide()
		
		if direction != Vector2.ZERO:
			$AnimatedSprite2D.play("run")
			if not $Step.playing:
				
				match player_floor:
					"floor_grass":
						$Step.stream = preload("res://audio/walk_on_the_grass.mp3")
						
						the_step_audio_speed = 2
					"floor_wood":
						$Step.stream = preload("res://audio/walking_on_the_wood.mp3")
						the_step_audio_speed = 1
				$Step.play()
		else:
			$AnimatedSprite2D.play("idle")
			
			$Step.stop()

		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
		elif velocity.x > 0:
			$AnimatedSprite2D.flip_h = false
