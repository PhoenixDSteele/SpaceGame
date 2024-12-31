class_name EnemyShip
extends Area3D

enum MoveMode {
	EntryPath, JoinGroup, FollowGroup, Attack1, Attack2
}

var mode: MoveMode

var spawn_path: SpawnPath
var horizontal_offset: float
var path_delay: float
var group_slot: Node3D

@export var move_speed: float = 5.0

@export var hitpoints: int = 2

func _process(delta: float) -> void:
	match mode:
		MoveMode.EntryPath:
			var my_progress: float = clampf(spawn_path.progress - path_delay, 0.0, spawn_path.curve.get_baked_length())
			if my_progress == spawn_path.curve.get_baked_length():
				mode = MoveMode.JoinGroup
				return
			var path_transform: Transform3D = spawn_path.curve.sample_baked_with_rotation(my_progress)
			path_transform = path_transform.translated_local(Vector3(horizontal_offset, 0.0, 0.0))
			transform = path_transform
		MoveMode.JoinGroup:
			if global_position.distance_to(group_slot.global_position) <= 0.05:
				mode = MoveMode.FollowGroup
				reparent(group_slot)
				position = Vector3.ZERO
				rotation = Vector3.ZERO
				return
			look_at(group_slot.global_position)
			translate_object_local(Vector3.FORWARD * move_speed * delta)

func damage() -> void:
	hitpoints -= 1
	if hitpoints <= 0:
		queue_free()
