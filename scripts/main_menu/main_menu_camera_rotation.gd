extends Node3D

var rotation_speed : float = 5

@onready var cam_root: Node3D = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cam_root.rotation_degrees.x -= rotation_speed * delta
