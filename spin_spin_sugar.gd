extends Node3D

@onready var meshes : Array[MeshInstance3D] = [
	find_child("Tetrahedron")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(p_delta: float) -> void:
	for m in meshes:
		m.rotate_y(p_delta * 0.75)
