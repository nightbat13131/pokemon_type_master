class_name LevelSelect extends Control

@export var level_holder : Node2D

static var _instance : LevelSelect

func _ready() -> void:
	_instance = self

static func activate() -> void:
	if _instance:
		_instance._activate()

func _activate() -> void:
	assert(level_holder != null)
	if level_holder:
		for each in level_holder.get_children():
			if each is MasterMind:
				each.queue_free()
	show()

static func deactivate() -> void:
	if _instance:
		_instance._deactivate()

func _deactivate() -> void:
	hide()

static func request_level(scene: PackedScene) -> void:
	var holder = scene.instantiate()
	assert(holder is MasterMind)
	if holder is MasterMind:
		if _instance:
			deactivate()
			_instance._request_level(holder)

func _request_level(level: MasterMind) -> void:
	level_holder.add_child(level)
