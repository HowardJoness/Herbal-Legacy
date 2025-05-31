extends Control


@export var 面相: String = "..."
@export var 症状: String = "..."
@export var 脉搏: String = "..."
@export var showLabel:Label

func _process(delta: float) -> void:
	showLabel.text = " 面相：" + 面相 + " \n 症状：" + 症状 + " \n 脉搏：" + 脉搏 + " "
