extends Node

var selected_tool: DataTypes.Tools = DataTypes.Tools.None
var selected_slot_index: int = -1

signal tool_selected(tool: DataTypes.Tools, slot_index: int)
signal enable_tool(tool: DataTypes.Tools)

func select_tool(tool: DataTypes.Tools, slot_index: int) -> void:
	selected_tool = tool
	selected_slot_index = slot_index
	tool_selected.emit(tool, slot_index)
	
func enable_tool_button(tool: DataTypes.Tools) -> void:
	enable_tool.emit(tool)
