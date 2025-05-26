extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("任务显示场景被加载")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.task != "":
		$NinePatchRect.visible = false
		$Task.text = "任务：" + GameManager.task
	else:
		$NinePatchRect.visible = false
		$Task.text = ""
	
	$Tips.text = GameManager.tips
