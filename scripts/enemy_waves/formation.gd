class_name Formation
extends Node3D

signal formation_eliminated()
signal spawn_complete()

var connected_enemies: Array[EnemyShip] = []
var enemies_on_path: int = 0

func attach_enemy(enemy: EnemyShip) -> void:
	connected_enemies.push_back(enemy)
	enemy.dead.connect(_enemy_killed)
	enemy.state_changed.connect(_enemy_state_change)
	enemies_on_path += 1

func _enemy_killed(enemy: EnemyShip) -> void:
	var enemy_idx: int = connected_enemies.find(enemy)
	if enemy_idx > -1:
		connected_enemies.remove_at(enemy_idx)
		
		if enemy.mode == EnemyShip.MoveMode.EntryPath:
			enemies_on_path -= 1
		
		if connected_enemies.size() == 0:
			formation_eliminated.emit()

func _enemy_state_change(old_state: EnemyShip.MoveMode, new_state: EnemyShip.MoveMode) -> void:
	if new_state == EnemyShip.MoveMode.JoinGroup and old_state == EnemyShip.MoveMode.EntryPath:
		enemies_on_path -= 1
		if enemies_on_path == 0:
			spawn_complete.emit()

func clear() -> void:
	for enemy: EnemyShip in connected_enemies:
		enemy.queue_free()
	connected_enemies.clear()
	enemies_on_path = 0
