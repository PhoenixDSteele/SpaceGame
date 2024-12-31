class_name SpawnPath
extends Path3D

@export var speed: float = 8.0
var progress: float = 0.0
var moving: bool = true

func _process(delta: float) -> void:
	if moving:
		progress += delta * speed
		if progress > curve.get_baked_length() + 8:
			progress = 0
			moving = false
