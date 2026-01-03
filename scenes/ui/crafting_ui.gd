extends CanvasLayer

@onready var crafting_panel: Panel = $CraftingPanel
@onready var recipe_list: VBoxContainer = $CraftingPanel/MarginContainer/VBoxContainer/HBoxContainer/RecipeListScroll/RecipeList
@onready var recipe_detail: Panel = $CraftingPanel/MarginContainer/VBoxContainer/HBoxContainer/RecipeDetail
@onready var result_icon: TextureRect = $CraftingPanel/MarginContainer/VBoxContainer/HBoxContainer/RecipeDetail/VBoxContainer/ResultPanel/MarginContainer/ResultIcon
@onready var result_name: Label = $CraftingPanel/MarginContainer/VBoxContainer/HBoxContainer/RecipeDetail/VBoxContainer/ResultPanel/ResultName
@onready var result_description: Label = $CraftingPanel/MarginContainer/VBoxContainer/HBoxContainer/RecipeDetail/VBoxContainer/Description
@onready var ingredients_list: VBoxContainer = $CraftingPanel/MarginContainer/VBoxContainer/HBoxContainer/RecipeDetail/VBoxContainer/IngredientsScroll/IngredientsList
@onready var craft_button: Button = $CraftingPanel/MarginContainer/VBoxContainer/HBoxContainer/RecipeDetail/VBoxContainer/CraftButton
@onready var station_label: Label = $CraftingPanel/MarginContainer/VBoxContainer/HBoxContainer/RecipeDetail/VBoxContainer/StationLabel
@onready var category_tabs: HBoxContainer = $CraftingPanel/MarginContainer/VBoxContainer/CategoryTabs

# Preload button scenes
var recipe_button_scene := preload("res://scenes/ui/crafting_recipe_button.tscn")
var ingredient_display_scene := preload("res://scenes/ui/crafting_ingredient_display.tscn")

var current_category := "all"
var current_station := ""  # Can be set to "workbench", "forge", etc.
var selected_recipe_id := ""


func _ready():
	crafting_panel.visible = false
	
	# Connect signals
	CraftingManager.recipe_crafted.connect(_on_recipe_crafted)
	CraftingManager.crafting_failed.connect(_on_crafting_failed)
	InventoryManager.inventory_changed.connect(_on_inventory_changed)
	craft_button.pressed.connect(_on_craft_button_pressed)
	
	# Setup category tabs
	_setup_category_tabs()
	
	# Initial recipe list
	refresh_recipe_list()


func _unhandled_input(event):
	if event.is_action_pressed("crafting_toggle"):
		toggle_crafting_panel()


func toggle_crafting_panel():
	crafting_panel.visible = !crafting_panel.visible
	if crafting_panel.visible:
		refresh_recipe_list()


func set_crafting_station(station: String):
	"""Set the current crafting station (e.g., 'workbench', 'forge', or '' for anywhere)."""
	current_station = station
	refresh_recipe_list()


func _setup_category_tabs():
	"""Create category filter tabs."""
	var categories := ["all", "tools", "weapons", "armor", "consumables", "resources"]
	
	for category in categories:
		var button := Button.new()
		button.text = category.capitalize()
		button.toggle_mode = true
		button.button_group = ButtonGroup.new() if category == "all" else category_tabs.get_child(0).button_group
		button.pressed.connect(_on_category_selected.bind(category))
		category_tabs.add_child(button)
		
		# Select "all" by default
		if category == "all":
			button.button_pressed = true


func _on_category_selected(category: String):
	current_category = category
	refresh_recipe_list()


func refresh_recipe_list():
	"""Refresh the list of available recipes."""
	# Clear existing buttons
	for child in recipe_list.get_children():
		child.queue_free()
	
	# Get recipes to display
	var recipes_to_show := []
	
	if current_category == "all":
		recipes_to_show = CraftingManager.get_all_recipes().keys()
	else:
		recipes_to_show = CraftingManager.get_recipes_by_category(current_category)
	
	# Filter by station if we're at one
	if current_station != "":
		var filtered := []
		for recipe_id in recipes_to_show:
			var recipe = CraftingManager.get_recipe(recipe_id)
			var required_station = recipe.get("required_station", null)
			if required_station == null or required_station == current_station:
				filtered.append(recipe_id)
		recipes_to_show = filtered
	
	# Create buttons for each recipe
	for recipe_id in recipes_to_show:
		var recipe_info = CraftingManager.get_recipe_info(recipe_id)
		var button := recipe_button_scene.instantiate()
		recipe_list.add_child(button)
		
		# Setup button
		button.setup_recipe(recipe_info)
		button.pressed.connect(_on_recipe_selected.bind(recipe_id))
		
		# Auto-select first recipe
		if selected_recipe_id.is_empty():
			selected_recipe_id = recipe_id
			show_recipe_details(recipe_id)


func _on_recipe_selected(recipe_id: String):
	selected_recipe_id = recipe_id
	show_recipe_details(recipe_id)


func show_recipe_details(recipe_id: String):
	"""Display detailed information about a recipe."""
	var recipe_info = CraftingManager.get_recipe_info(recipe_id)
	
	if recipe_info.is_empty():
		return
	
	# Set result icon and name
	result_icon.texture = recipe_info.get("result_icon")
	result_name.text = recipe_info.get("result_display_name", "")
	var amount = recipe_info.get("result_amount", 1)
	if amount > 1:
		result_name.text += " x" + str(amount)
	
	# Set description
	result_description.text = recipe_info.get("result_description", "")
	
	# Set station requirement
	var required_station = recipe_info.get("required_station", null)
	if required_station:
		station_label.text = "Requires: " + required_station.capitalize()
		station_label.visible = true
	else:
		station_label.text = "Craft anywhere"
		station_label.visible = true
	
	# Clear and populate ingredients list
	for child in ingredients_list.get_children():
		child.queue_free()
	
	var ingredients = recipe_info.get("ingredients", [])
	for ingredient in ingredients:
		var display := ingredient_display_scene.instantiate()
		ingredients_list.add_child(display)
		
		var item_name = ingredient.get("item", "")
		var required = ingredient.get("amount", 0)
		var has = InventoryManager.get_item_count(item_name)
		
		display.setup_ingredient(item_name, required, has)
	
	# Update craft button
	var can_craft = recipe_info.get("can_craft", false)
	craft_button.disabled = !can_craft
	craft_button.text = "Craft" if can_craft else "Insufficient Materials"


func _on_craft_button_pressed():
	if selected_recipe_id.is_empty():
		return
	
	CraftingManager.craft_item(selected_recipe_id, current_station)


func _on_recipe_crafted(recipe_id: String, result_item: String, result_amount: int):
	print("Crafted: ", result_amount, "x ", DataTypes.get_display_name(result_item))
	refresh_recipe_list()
	if selected_recipe_id == recipe_id:
		show_recipe_details(recipe_id)


func _on_crafting_failed(reason: String):
	print("Crafting failed: ", reason)


func _on_inventory_changed():
	# Refresh the current recipe details
	if not selected_recipe_id.is_empty():
		show_recipe_details(selected_recipe_id)
	
	# Update all recipe buttons to show craftable status
	for child in recipe_list.get_children():
		if child.has_method("update_craftable_status"):
			child.update_craftable_status()
