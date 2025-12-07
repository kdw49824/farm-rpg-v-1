extends GridContainer

@export var slot_scene: PackedScene
@export var slot_count := 20

func _ready():
	for i in slot_count:
		var slot = slot_scene.instantiate()
		add_child(slot)

	print("Slots created:", get_child_count())
