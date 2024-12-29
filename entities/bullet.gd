extends Area3D

@export var speed: float = 25.0
@export var destroy_at: float = -50

func _process(delta: float) -> void:
	position.z -= speed * delta
	if position.z < destroy_at:
		queue_free()

func _on_area_entered(area: Area3D) -> void:
	if area is EnemyShip:
		area.damage()
	queue_free()
