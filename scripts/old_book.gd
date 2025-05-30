extends Control

func _input(event):
	if event is InputEventKey and event.pressed:
		var sprite = $AnimatedSprite2D
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
