class_name Player
extends CharacterBody2D

@onready var hit_component: HitComponent = $HitComponent

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
var player_direction: Vector2


func _ready() -> void:
	ToolManager.tool_selected.connect(on_tool_selected)


func on_tool_selected(tool: DataTypes.Tools) -> void:
	print("Player equipped tool: ", tool) 
	current_tool = tool
	hit_component.current_tool = tool


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use_item"):
		use_current_tool()


func use_current_tool() -> void:
	if current_tool == DataTypes.Tools.None:
		return

	hit_component.try_hit()
