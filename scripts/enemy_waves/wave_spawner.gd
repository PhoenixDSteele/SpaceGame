extends Node

signal new_wave(wave_number: int)

enum WaveState {
	Spawn,
	Attack
}

var state: WaveState = WaveState.Spawn

var wave_counter: int = 0

@export var enemy_ship: PackedScene

@export var formation_order: Array[Formation] = []

@export var left_paths: Array[SpawnPath] = []
@export var right_paths: Array[SpawnPath] = []

var timer: float = 3.0

var next_formation_idx: int = 0
var can_spawn_next_formation: bool = true

func _ready() -> void:
	_start_next_wave(2.0)

func _process(delta: float) -> void:
	timer -= delta
	
	match state:
		WaveState.Spawn:
			if timer <= 0 and can_spawn_next_formation:
				var spawn_path_idx: int = randi_range(0, left_paths.size() - 1)
				
				var left_path: SpawnPath = left_paths[spawn_path_idx]
				left_path.progress = 0
				left_path.moving = true
				var right_path: SpawnPath = right_paths[spawn_path_idx]
				right_path.progress = 0
				right_path.moving = true
				
				var formation: Formation = formation_order[next_formation_idx]
				formation.spawn_complete.connect(func():
					if next_formation_idx >= formation_order.size():
						print("switching to attack")
						state = WaveState.Attack
						timer = 3.0
					
					can_spawn_next_formation = true
					timer = 3.0
				, CONNECT_ONE_SHOT)
				
				_spawn_formation(formation, left_path, right_path)
				can_spawn_next_formation = false
				next_formation_idx += 1
		WaveState.Attack:
			pass

func _spawn_formation(formation: Formation, left_path: SpawnPath, right_path: SpawnPath) -> void:
	print("spawning formation %s" % formation.name)
	for enemy_pos: EnemyPosition in formation.get_children():
		var enemy_inst: EnemyShip = enemy_ship.instantiate()
		enemy_inst.horizontal_offset = signf(enemy_pos.position.x) * 0.75
		enemy_inst.path_delay = float(enemy_pos.formation_row) * 1.75
		enemy_inst.spawn_path = left_path if enemy_pos.side == 0 else right_path
		enemy_inst.group_slot = enemy_pos
		enemy_inst.mode = EnemyShip.MoveMode.EntryPath
		
		formation.attach_enemy(enemy_inst)
		get_tree().current_scene.add_child.call_deferred(enemy_inst)

func _on_formation_eliminated() -> void:
	var any_formation_alive: bool = false
	for formation: Formation in get_children():
		if formation.connected_enemies.size() > 0:
			any_formation_alive = true
	
	if not any_formation_alive:
		_start_next_wave(1.5)

func _start_next_wave(delay: float) -> void:
	print("starting new wave!")
	wave_counter += 1
	new_wave.emit(wave_counter)
	next_formation_idx = 0
	can_spawn_next_formation = true
	timer = delay
	
	state = WaveState.Spawn
	
	for formation: Formation in get_children():
		formation.clear()
