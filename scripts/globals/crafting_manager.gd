extends Node

# ============================================
# CRAFTING SYSTEM
# ============================================

signal recipe_crafted(recipe_id: String, result_item: String, result_amount: int)
signal crafting_failed(reason: String)

# Recipe structure:
# {
#   "recipe_id": {
#     "result": "item_name",
#     "amount": 1,
#     "ingredients": [
#       {"item": "item_name", "amount": 2},
#       {"item": "item_name", "amount": 1}
#     ],
#     "category": "tools", # Optional for filtering
#     "required_station": "workbench" # Optional, null = craft anywhere
#   }
# }

const RECIPES := {
	# ===== TOOLS =====
	"craft_axewood": {
		"result": "axewood",
		"amount": 1,
		"ingredients": [
			{"item": "log", "amount": 5},
			{"item": "fiber", "amount": 3}
		],
		"category": "tools",
		"required_station": null
	},
	"craft_axestone": {
		"result": "axestone",
		"amount": 1,
		"ingredients": [
			{"item": "log", "amount": 3},
			{"item": "stone", "amount": 5},
			{"item": "fiber", "amount": 5}
		],
		"category": "tools",
		"required_station": "workbench"
	},
	"craft_axeiron": {
		"result": "axeiron",
		"amount": 1,
		"ingredients": [
			{"item": "log", "amount": 2},
			{"item": "ironbar", "amount": 3},
			{"item": "fiber", "amount": 3}
		],
		"category": "tools",
		"required_station": "forge"
	},
	"craft_hoestone": {
		"result": "hoestone",
		"amount": 1,
		"ingredients": [
			{"item": "log", "amount": 4},
			{"item": "stone", "amount": 3}
		],
		"category": "tools",
		"required_station": null
	},
	"craft_wateringcan": {
		"result": "wateringcan",
		"amount": 1,
		"ingredients": [
			{"item": "ironbar", "amount": 2},
			{"item": "log", "amount": 1}
		],
		"category": "tools",
		"required_station": "workbench"
	},
	"craft_pickaxe": {
		"result": "pickaxe",
		"amount": 1,
		"ingredients": [
			{"item": "log", "amount": 3},
			{"item": "stone", "amount": 5}
		],
		"category": "tools",
		"required_station": "workbench"
	},
	"craft_fishingrod": {
		"result": "fishingrod",
		"amount": 1,
		"ingredients": [
			{"item": "log", "amount": 3},
			{"item": "fiber", "amount": 8}
		],
		"category": "tools",
		"required_station": null
	},
	"craft_sickle": {
		"result": "sickle",
		"amount": 1,
		"ingredients": [
			{"item": "log", "amount": 2},
			{"item": "ironbar", "amount": 1}
		],
		"category": "tools",
		"required_station": "workbench"
	},
	
	# ===== WEAPONS =====
	"craft_woodensword": {
		"result": "woodensword",
		"amount": 1,
		"ingredients": [
			{"item": "log", "amount": 6},
			{"item": "fiber", "amount": 2}
		],
		"category": "weapons",
		"required_station": null
	},
	"craft_stonesword": {
		"result": "stonesword",
		"amount": 1,
		"ingredients": [
			{"item": "log", "amount": 4},
			{"item": "stone", "amount": 8}
		],
		"category": "weapons",
		"required_station": "workbench"
	},
	"craft_ironsword": {
		"result": "ironsword",
		"amount": 1,
		"ingredients": [
			{"item": "log", "amount": 2},
			{"item": "ironbar", "amount": 5}
		],
		"category": "weapons",
		"required_station": "forge"
	},
	"craft_woodenbow": {
		"result": "woodenbow",
		"amount": 1,
		"ingredients": [
			{"item": "log", "amount": 4},
			{"item": "fiber", "amount": 10}
		],
		"category": "weapons",
		"required_station": "workbench"
	},
	"craft_dagger": {
		"result": "dagger",
		"amount": 1,
		"ingredients": [
			{"item": "ironbar", "amount": 2},
			{"item": "leather", "amount": 1}
		],
		"category": "weapons",
		"required_station": "forge"
	},
	"craft_spear": {
		"result": "spear",
		"amount": 1,
		"ingredients": [
			{"item": "log", "amount": 5},
			{"item": "stone", "amount": 3}
		],
		"category": "weapons",
		"required_station": null
	},
	
	# ===== ARMOR =====
	"craft_leatherhelmet": {
		"result": "leatherhelmet",
		"amount": 1,
		"ingredients": [
			{"item": "leather", "amount": 5}
		],
		"category": "armor",
		"required_station": "workbench"
	},
	"craft_leatherchest": {
		"result": "leatherchest",
		"amount": 1,
		"ingredients": [
			{"item": "leather", "amount": 8}
		],
		"category": "armor",
		"required_station": "workbench"
	},
	"craft_leatherlegs": {
		"result": "leatherlegs",
		"amount": 1,
		"ingredients": [
			{"item": "leather", "amount": 6}
		],
		"category": "armor",
		"required_station": "workbench"
	},
	"craft_leatherboots": {
		"result": "leatherboots",
		"amount": 1,
		"ingredients": [
			{"item": "leather", "amount": 4}
		],
		"category": "armor",
		"required_station": "workbench"
	},
	"craft_ironhelmet": {
		"result": "ironhelmet",
		"amount": 1,
		"ingredients": [
			{"item": "ironbar", "amount": 5}
		],
		"category": "armor",
		"required_station": "forge"
	},
	"craft_ironchest": {
		"result": "ironchest",
		"amount": 1,
		"ingredients": [
			{"item": "ironbar", "amount": 8}
		],
		"category": "armor",
		"required_station": "forge"
	},
	
	# ===== CONSUMABLES =====
	"craft_healthpotion": {
		"result": "healthpotion",
		"amount": 1,
		"ingredients": [
			{"item": "fiber", "amount": 5},
			{"item": "tomato", "amount": 2}
		],
		"category": "consumables",
		"required_station": null
	},
	"craft_bread": {
		"result": "bread",
		"amount": 2,
		"ingredients": [
			{"item": "corn", "amount": 3}
		],
		"category": "consumables",
		"required_station": null
	},
	"craft_cookedmeat": {
		"result": "cookedmeat",
		"amount": 1,
		"ingredients": [
			{"item": "egg", "amount": 2}
		],
		"category": "consumables",
		"required_station": null
	},
	
	# ===== RESOURCES =====
	"smelt_ironbar": {
		"result": "ironbar",
		"amount": 1,
		"ingredients": [
			{"item": "ironore", "amount": 2}
		],
		"category": "resources",
		"required_station": "forge"
	},
}


# ============================================
# CRAFTING FUNCTIONS
# ============================================

func get_all_recipes() -> Dictionary:
	"""Get all recipes."""
	return RECIPES


func get_recipe(recipe_id: String) -> Dictionary:
	"""Get a specific recipe by ID."""
	return RECIPES.get(recipe_id, {})


func get_recipes_by_category(category: String) -> Array:
	"""Get all recipes in a category."""
	var filtered := []
	for recipe_id in RECIPES.keys():
		var recipe = RECIPES[recipe_id]
		if recipe.get("category", "") == category:
			filtered.append(recipe_id)
	return filtered


func get_craftable_recipes(at_station: String = "") -> Array:
	"""Get all recipes that can currently be crafted.
	at_station: Optional station name. Empty string = anywhere."""
	var craftable := []
	
	for recipe_id in RECIPES.keys():
		if can_craft(recipe_id, at_station):
			craftable.append(recipe_id)
	
	return craftable


func can_craft(recipe_id: String, at_station: String = "") -> bool:
	"""Check if a recipe can be crafted with current inventory.
	at_station: Optional station name. Empty string = anywhere."""
	var recipe = get_recipe(recipe_id)
	
	if recipe.is_empty():
		return false
	
	# Check if we're at the required station
	var required_station = recipe.get("required_station", null)
	if required_station != null and required_station != at_station:
		return false
	
	# Check if we have all ingredients
	var ingredients = recipe.get("ingredients", [])
	for ingredient in ingredients:
		var item_name = ingredient.get("item", "")
		var required_amount = ingredient.get("amount", 0)
		var has_amount = InventoryManager.get_item_count(item_name)
		
		if has_amount < required_amount:
			return false
	
	return true


func craft_item(recipe_id: String, at_station: String = "") -> bool:
	"""Attempt to craft an item. Returns true if successful."""
	var recipe = get_recipe(recipe_id)
	
	if recipe.is_empty():
		crafting_failed.emit("Recipe not found")
		return false
	
	# Check if we can craft
	if not can_craft(recipe_id, at_station):
		var required_station = recipe.get("required_station", null)
		if required_station != null and required_station != at_station:
			crafting_failed.emit("Requires " + required_station)
		else:
			crafting_failed.emit("Not enough materials")
		return false
	
	# Remove ingredients from inventory
	var ingredients = recipe.get("ingredients", [])
	for ingredient in ingredients:
		var item_name = ingredient.get("item", "")
		var amount = ingredient.get("amount", 0)
		InventoryManager.remove_item(item_name, amount)
	
	# Add result to inventory
	var result_item = recipe.get("result", "")
	var result_amount = recipe.get("amount", 1)
	InventoryManager.add_item(result_item, result_amount)
	
	# Emit success signal
	recipe_crafted.emit(recipe_id, result_item, result_amount)
	
	return true


func get_recipe_info(recipe_id: String) -> Dictionary:
	"""Get formatted recipe information for UI display."""
	var recipe = get_recipe(recipe_id)
	
	if recipe.is_empty():
		return {}
	
	var result_item = recipe.get("result", "")
	
	return {
		"recipe_id": recipe_id,
		"result_item": result_item,
		"result_amount": recipe.get("amount", 1),
		"result_display_name": DataTypes.get_display_name(result_item),
		"result_icon": DataTypes.get_icon(result_item),
		"result_description": DataTypes.get_description(result_item),
		"ingredients": recipe.get("ingredients", []),
		"category": recipe.get("category", ""),
		"required_station": recipe.get("required_station", null),
		"can_craft": can_craft(recipe_id)
	}


func get_missing_ingredients(recipe_id: String) -> Array:
	"""Get list of missing ingredients for a recipe."""
	var recipe = get_recipe(recipe_id)
	var missing := []
	
	if recipe.is_empty():
		return missing
	
	var ingredients = recipe.get("ingredients", [])
	for ingredient in ingredients:
		var item_name = ingredient.get("item", "")
		var required = ingredient.get("amount", 0)
		var has = InventoryManager.get_item_count(item_name)
		
		if has < required:
			missing.append({
				"item": item_name,
				"required": required,
				"has": has,
				"missing": required - has
			})
	
	return missing
