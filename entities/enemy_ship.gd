class_name EnemyShip
extends Area3D

enum MoveMode {
	EntryPath, JoinGroup, FollowGroup, Attack1, Attack2
}

@export var mode: MoveMode

@export var entry_offset: Vector3
@export var group_slot: Node3D

@export var move_speed: float = 5.0

@export var hitpoints: int = 2

func _process(delta: float) -> void:
	match mode:
		MoveMode.EntryPath:
			position = entry_offset
		MoveMode.JoinGroup:
			if global_position.distance_to(group_slot.global_position) <= 0.05:
			#if global_position.is_equal_approx(group_slot.global_position):
				mode = MoveMode.FollowGroup
				reparent(group_slot)
				position = Vector3.ZERO
				rotation = Vector3.ZERO
				return
			look_at(group_slot.global_position)
			translate_object_local(Vector3.FORWARD * move_speed * delta)
		MoveMode.FollowGroup:
			pass

func damage() -> void:
	hitpoints -= 1
	if hitpoints <= 0:
		queue_free()
