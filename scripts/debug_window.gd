extends CanvasLayer


func _process(delta: float) -> void:
	
	print(typeof(GameManager.developer_mode))
	print(GameManager.developer_mode)
	
	if GameManager.developer_mode:
		$".".visible = true
	else:
		$".".visible = false
	$GameManager.text = """GameManager 全局变量：
developer_mode: %s""" % [GameManager.developer_mode]
	$SceneDebug.text = """场景调试信息 :
%s""" % [GameManager.scenedebug]
