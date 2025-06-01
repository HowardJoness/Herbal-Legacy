extends Control

func _input(event):
	var sprite = $AnimatedSprite2D
	if event is InputEventKey and event.pressed:
		var frame = sprite.frame
		var max_frame = sprite.sprite_frames.get_frame_count(sprite.animation) - 1

		match event.keycode:
			KEY_LEFT:
				if frame > 0:
					sprite.frame = frame - 1
			KEY_RIGHT:
				if frame < max_frame:
					sprite.frame = frame + 1
			KEY_ESCAPE:
				get_tree().quit()

func _process(delta: float) -> void:
	if $AnimatedSprite2D.frame == 0:
		if "CP1" in GameManager.passedChapter:
			$TickCP1.visible = true
		else:
			$TickCP1.visible = false
		if "CP2" in GameManager.passedChapter:
			$TickCP2.visible = true
		else:
			$TickCP2.visible = false
		if "CP3" in GameManager.passedChapter:
			$TickCP3.visible = true
		else:
			$TickCP3.visible = false
		if "CP4" in GameManager.passedChapter:
			$TickCP4.visible = true
		else:
			$TickCP4.visible = false


func _on_cp_1_pressed() -> void:
	var sprite = $AnimatedSprite2D
	if sprite.frame == 0:
		sprite.frame = 1
