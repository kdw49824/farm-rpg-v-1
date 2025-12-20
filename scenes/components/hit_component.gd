class_name HitComponent
extends Area2D

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
@export var hit_damage: int = 1


func try_hit() -> void:
	match current_tool:
		DataTypes.Tools.AxeWood:
			_axe_hit()
		DataTypes.Tools.TillGround:
			_till_hit()
		DataTypes.Tools.WaterCrops:
			_water_hit()
		DataTypes.Tools.PlantCorn:
			_plant_hit("corn")
		DataTypes.Tools.PlantTomato:
			_plant_hit("tomato")
		DataTypes.Tools.None:
			pass


func _axe_hit() -> void:
	for body in get_overlapping_bodies():
		if body.has_method("chop"):
			body.chop(hit_damage)


func _till_hit() -> void:
	for body in get_overlapping_bodies():
		if body.has_method("till"):
			body.till()


func _water_hit() -> void:
	for body in get_overlapping_bodies():
		if body.has_method("water"):
			body.water()


func _plant_hit(crop_name: String) -> void:
	for body in get_overlapping_bodies():
		if body.has_method("plant"):
			body.plant(crop_name)
