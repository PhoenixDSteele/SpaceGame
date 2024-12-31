extends Node

@export var enemy_ship: PackedScene

@export var left_subgroups: Array[Node3D] = []
@export var left_paths: Array[SpawnPath] = []

@export var right_subgroups: Array[Node3D] = []
@export var right_paths: Array[SpawnPath] = []

func _ready() -> void:
	_spawn_subgroup(left_subgroups[0], left_paths[0])
	_spawn_subgroup(right_subgroups[0], right_paths[0])

func _spawn_subgroup(subgroup: Node3D, path: SpawnPath) -> void:
	var i: int = 0
	for mark: Marker3D in subgroup.get_children():
		var enemy_inst: EnemyShip = enemy_ship.instantiate()
		var horizontal_offset: float = fmod(float(i), 2) * 2.0 - 1.0
		var path_delay: float = floorf(float(i) / 2) * 2.0
		enemy_inst.spawn_path = path
		enemy_inst.horizontal_offset = horizontal_offset
		enemy_inst.path_delay = path_delay
		#enemy_inst.entry_offset = Vector3(horizontal_offset, 0, other_offset)
		enemy_inst.group_slot = mark
		enemy_inst.mode = EnemyShip.MoveMode.EntryPath
		get_tree().current_scene.add_child.call_deferred(enemy_inst)
		#path.add_child(enemy_inst)
		i += 1
