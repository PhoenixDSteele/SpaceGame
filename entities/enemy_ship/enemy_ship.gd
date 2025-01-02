class_name EnemyShip
extends Area3D

signal dead(enemy: EnemyShip)
signal state_changed(old_state: MoveMode, new_state: MoveMode)

enum MoveMode {
	EntryPath, JoinGroup, FollowGroup, Attack1, Attack2
}

var mode: MoveMode:
	set(v):
		var old_mode: MoveMode = mode
		mode = v
		if old_mode != mode and mode != MoveMode.EntryPath:
			state_changed.emit(old_mode, mode)

var spawn_path: SpawnPath
var horizontal_offset: float
var path_delay: float
var group_slot: EnemyPosition

@export var move_speed: float = 5.0

@export var hitpoints: int = 2

func _ready() -> void:
	position = Vector3(0, 0, 10000)

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
		dead.emit(self)
		queue_free()
