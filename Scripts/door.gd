extends MeshInstance3D
signal door_touched

func _ready():
	$Area3D.body_entered.connect(_on_area_3d_body_entered)

func _on_area_3d_body_entered(body: Node3D):
	if body.name == "player" or body.name == "Player" or body is CharacterBody3D:
		Vars.room += 1
		door_touched.emit()
		queue_free()
