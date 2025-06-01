extends CanvasLayer

"""
你好awa
这里是 Herbal Legacy 的 GameManager部分~，用来播放一些bgm以及对游戏进行一些调控啦~
"""

var task: String = "" # 任务名称
var tips: String = "" # 提示名称
var scenedebug: String = "..." # 场景调试信息
var developer_mode = true # 开发者模式
var Reputation_Enable:bool = true # 启用声望值
var Reputation_show:bool = true # 已显示声望值用法
var Reputation: int = 10 # 声望值
var passedChapter:Array = [] # 已经过关的章节


# 特殊全局变量
var isPassC2_1Timeline:bool = false # 是否过关 Chapter2_1 的剧情介绍

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("[GameManager] GM模块被成功加载。")
	# 默认隐藏计时器
	total_time_label.visible = false
	gaming_time_label.visible = false

	
@onready var total_time_label: Label = $TotalTime
@onready var gaming_time_label: Label = $GamingTime
@onready var bgm_player: AudioStreamPlayer2D = $M500003sBjkR0ssd3r

var isSpeedrunMode := false  # ← 速通模式开关
var total_seconds := 0.0
var gaming_seconds := 0.0
var Gaming := true
var game_started := false
var speedRunBGM:bool = true


func _loseJudge():
	# 游戏运行时进行一次失败判定
	if Reputation <= 0:
		# 声望值小于等于0
		SceneManager.change_scene("uid://bge82j1r1x7ne")


func GameBegin():
	if not isSpeedrunMode:
		print("[GameManager] 游戏以正常模式启动")
		return

	print("[GameManager] 游戏以速通模式启动")
	game_started = true
	Gaming = true
	total_seconds = 0.0
	gaming_seconds = 0.0

	# 显示计时器
	total_time_label.visible = true
	gaming_time_label.visible = true

	# 播放BGM
	if speedRunBGM:
		bgm_player.play()




func _process(delta: float) -> void:
	if not game_started or not isSpeedrunMode:
		return

	total_seconds += delta
	if Gaming:
		gaming_seconds += delta
	
	total_time_label.text = format_time(total_seconds)
	gaming_time_label.text = format_time(gaming_seconds)


func format_time(time: float) -> String:
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	var milliseconds = int((time - int(time)) * 1000)
	return "%02d:%02d.%03d" % [minutes, seconds, milliseconds]
