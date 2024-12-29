class_name EntryCarriage
extends PathFollow3D

@export var speed: float = 2.0
var running: bool = true

func _process(delta: float) -> void:
	if running:
		progress += speed * delta
		
		if progress_ratio >= 1.0:
			for child: EnemyShip in get_children():
				child.mode = child.MoveMode.JoinGroup
				child.reparent(get_tree().current_scene)
			
			progress_ratio = 0
			running = false
