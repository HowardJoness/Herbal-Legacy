extends Node2D

"""
你好awa
这里是 Herbal Legacy 的 GameManager部分~，用来播放一些bgm以及对游戏进行一些调控啦~
"""

var task: String = "" # 任务名称
var tips: String = "" # 提示名称
var scenedebug: String = "..." # 场景调试信息
var developer_mode = true # 开发者模式

# 特殊全局变量
var isPassC2_1Timeline:bool = false # 是否过关 Chapter2_1 的剧情介绍

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("[GameManager] GM模块被成功加载。")

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
