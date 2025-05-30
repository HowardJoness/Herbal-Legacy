extends Control


func _process(delta: float) -> void:
	if GameManager.Reputation_Enable:
		$ProgressBar.visible = true
		if GameManager.Reputation_show == false:
			GameManager.Reputation_show == true
			$ColorRect.visible = true
