extends Node3D

@export var speed: float = 5.0
@export var shoot_cooldown: float = 0.3
var shoot_timer: float = 0

@export var bullet: PackedScene

@export var left_bound: float
@export var right_bound: float

func _process(delta: float) -> void:
	var input: float = Input.get_axis("move_left", "move_right")
	position.x += input * delta * speed
	position.x = clampf(position.x, left_bound, right_bound)
	
	if Input.is_action_pressed("shoot") and shoot_timer >= shoot_cooldown:
		shoot_timer = 0
		var bullet_inst: Node3D = bullet.instantiate()
		add_child(bullet_inst)
		bullet_inst.global_position = %BulletSpawner.global_position
	
	shoot_timer += delta
