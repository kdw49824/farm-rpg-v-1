class_name DataTypes

# ============================================
# ENUMS
# ============================================

enum Tools {
	None,
	AxeWood,
	AxeStone,
	AxeIron,
	TillGround,
	WaterCrops,
	PlantCorn,
	PlantTomato,
	Pickaxe,
	FishingRod,
	Sickle
}

enum Weapons {
	None,
	WoodenSword,
	StoneSword,
	IronSword,
	WoodenBow,
	Dagger,
	Spear
}

enum ArmorSlot {
	None,
	Head,
	Chest,
	Legs,
	Feet,
	Hands
}

enum GrowthStates {
	Seed,
	Germination,
	Vegetative,
	Reproduction,
	Maturity,
	Harvesting
}

enum ItemCategory {
	TOOL,
	WEAPON,
	ARMOR,
	CONSUMABLE,
	RESOURCE,
	SEED,
	CROP,
	EQUIPMENT,
	QUEST,
	MISC
}

enum ItemRarity {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY
}

enum DamageType {
	PHYSICAL,
	FIRE,
	ICE,
	LIGHTNING,
	POISON
}

# ============================================
# ITEM DATABASE
# ============================================

const ITEM_DATABASE := {
	# ===== TOOLS =====
	"axewood": {
		"display_name": "Wooden Axe",
		"category": ItemCategory.TOOL,
		"tool_type": Tools.AxeWood,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/axewood_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": true,
		"max_durability": 8,
		"description": "A basic wooden axe for chopping trees."
	},
	"axestone": {
		"display_name": "Stone Axe",
		"category": ItemCategory.TOOL,
		"tool_type": Tools.AxeStone,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/axestone_icon.tres",
		"rarity": ItemRarity.UNCOMMON,
		"has_durability": true,
		"max_durability": 200,
		"description": "A sturdy stone axe. Lasts longer than wood."
	},
	"axeiron": {
		"display_name": "Iron Axe",
		"category": ItemCategory.TOOL,
		"tool_type": Tools.AxeIron,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/axeiron_icon.tres",
		"rarity": ItemRarity.RARE,
		"has_durability": true,
		"max_durability": 400,
		"description": "A high-quality iron axe. Very durable."
	},
	"hoe": {
		"display_name": "Hoe",
		"category": ItemCategory.TOOL,
		"tool_type": Tools.TillGround,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/hoe_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": true,
		"max_durability": 150,
		"description": "Used to till the ground for planting."
	},
	"wateringcan": {
		"display_name": "Watering Can",
		"category": ItemCategory.TOOL,
		"tool_type": Tools.WaterCrops,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/wateringcan_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": true,
		"max_durability": 100,
		"description": "Waters your crops to help them grow."
	},
	"pickaxe": {
		"display_name": "Pickaxe",
		"category": ItemCategory.TOOL,
		"tool_type": Tools.Pickaxe,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/pickaxe_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": true,
		"max_durability": 200,
		"description": "Breaks rocks and mines ore."
	},
	"fishingrod": {
		"display_name": "Fishing Rod",
		"category": ItemCategory.TOOL,
		"tool_type": Tools.FishingRod,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/fishingrod_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": true,
		"max_durability": 80,
		"description": "Cast into water to catch fish."
	},
	"sickle": {
		"display_name": "Sickle",
		"category": ItemCategory.TOOL,
		"tool_type": Tools.Sickle,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/sickle_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": true,
		"max_durability": 120,
		"description": "Harvests crops quickly."
	},
	
	# ===== WEAPONS =====
	"woodensword": {
		"display_name": "Wooden Sword",
		"category": ItemCategory.WEAPON,
		"weapon_type": Weapons.WoodenSword,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/woodensword_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": true,
		"max_durability": 80,
		"damage": 5,
		"damage_type": DamageType.PHYSICAL,
		"attack_speed": 1.0,
		"description": "A simple wooden training sword."
	},
	"stonesword": {
		"display_name": "Stone Sword",
		"category": ItemCategory.WEAPON,
		"weapon_type": Weapons.StoneSword,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/stonesword_icon.tres",
		"rarity": ItemRarity.UNCOMMON,
		"has_durability": true,
		"max_durability": 150,
		"damage": 12,
		"damage_type": DamageType.PHYSICAL,
		"attack_speed": 0.9,
		"description": "A crude but effective stone sword."
	},
	"ironsword": {
		"display_name": "Iron Sword",
		"category": ItemCategory.WEAPON,
		"weapon_type": Weapons.IronSword,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/ironsword_icon.tres",
		"rarity": ItemRarity.RARE,
		"has_durability": true,
		"max_durability": 300,
		"damage": 25,
		"damage_type": DamageType.PHYSICAL,
		"attack_speed": 1.2,
		"description": "A well-crafted iron blade."
	},
	"woodenbow": {
		"display_name": "Wooden Bow",
		"category": ItemCategory.WEAPON,
		"weapon_type": Weapons.WoodenBow,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/woodenbow_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": true,
		"max_durability": 100,
		"damage": 8,
		"damage_type": DamageType.PHYSICAL,
		"attack_speed": 0.7,
		"range": 10.0,
		"description": "A basic bow for ranged attacks."
	},
	"dagger": {
		"display_name": "Iron Dagger",
		"category": ItemCategory.WEAPON,
		"weapon_type": Weapons.Dagger,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/dagger_icon.tres",
		"rarity": ItemRarity.UNCOMMON,
		"has_durability": true,
		"max_durability": 120,
		"damage": 8,
		"damage_type": DamageType.PHYSICAL,
		"attack_speed": 1.8,
		"description": "Fast attacks but lower damage."
	},
	"spear": {
		"display_name": "Wooden Spear",
		"category": ItemCategory.WEAPON,
		"weapon_type": Weapons.Spear,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/spear_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": true,
		"max_durability": 90,
		"damage": 10,
		"damage_type": DamageType.PHYSICAL,
		"attack_speed": 0.8,
		"range": 2.0,
		"description": "Extended reach for keeping enemies at bay."
	},
	
	# ===== ARMOR =====
	"leatherhelmet": {
		"display_name": "Leather Helmet",
		"category": ItemCategory.ARMOR,
		"armor_slot": ArmorSlot.Head,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/leatherhelmet_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": true,
		"max_durability": 100,
		"defense": 2,
		"description": "Basic head protection made of leather."
	},
	"leatherchest": {
		"display_name": "Leather Chestplate",
		"category": ItemCategory.ARMOR,
		"armor_slot": ArmorSlot.Chest,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/leatherchest_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": true,
		"max_durability": 120,
		"defense": 3,
		"description": "Lightweight chest armor."
	},
	"leatherlegs": {
		"display_name": "Leather Leggings",
		"category": ItemCategory.ARMOR,
		"armor_slot": ArmorSlot.Legs,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/leatherlegs_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": true,
		"max_durability": 110,
		"defense": 2,
		"description": "Protects your legs."
	},
	"leatherboots": {
		"display_name": "Leather Boots",
		"category": ItemCategory.ARMOR,
		"armor_slot": ArmorSlot.Feet,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/leatherboots_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": true,
		"max_durability": 90,
		"defense": 1,
		"description": "Basic foot protection."
	},
	"ironhelmet": {
		"display_name": "Iron Helmet",
		"category": ItemCategory.ARMOR,
		"armor_slot": ArmorSlot.Head,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/ironhelmet_icon.tres",
		"rarity": ItemRarity.RARE,
		"has_durability": true,
		"max_durability": 250,
		"defense": 8,
		"description": "Heavy metal helmet offering good protection."
	},
	"ironchest": {
		"display_name": "Iron Chestplate",
		"category": ItemCategory.ARMOR,
		"armor_slot": ArmorSlot.Chest,
		"max_stack": 1,
		"icon_path": "res://scenes/ui/icons/ironchest_icon.tres",
		"rarity": ItemRarity.RARE,
		"has_durability": true,
		"max_durability": 300,
		"defense": 12,
		"description": "Strong iron plate armor for the chest."
	},
	
	# ===== CONSUMABLES =====
	"healthpotion": {
		"display_name": "Health Potion",
		"category": ItemCategory.CONSUMABLE,
		"max_stack": 10,
		"icon_path": "res://scenes/ui/icons/healthpotion_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": false,
		"heal_amount": 50,
		"description": "Restores 50 health points."
	},
	"manapotion": {
		"display_name": "Mana Potion",
		"category": ItemCategory.CONSUMABLE,
		"max_stack": 10,
		"icon_path": "res://scenes/ui/icons/manapotion_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": false,
		"mana_amount": 30,
		"description": "Restores 30 mana points."
	},
	"staminapotion": {
		"display_name": "Stamina Potion",
		"category": ItemCategory.CONSUMABLE,
		"max_stack": 10,
		"icon_path": "res://scenes/ui/icons/staminapotion_icon.tres",
		"rarity": ItemRarity.UNCOMMON,
		"has_durability": false,
		"stamina_amount": 40,
		"description": "Restores 40 stamina points."
	},
	"bread": {
		"display_name": "Bread",
		"category": ItemCategory.CONSUMABLE,
		"max_stack": 20,
		"icon_path": "res://scenes/ui/icons/bread_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": false,
		"heal_amount": 10,
		"description": "A simple loaf of bread. Restores a little health."
	},
	"cookedmeat": {
		"display_name": "Cooked Meat",
		"category": ItemCategory.CONSUMABLE,
		"max_stack": 15,
		"icon_path": "res://scenes/ui/icons/cookedmeat_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": false,
		"heal_amount": 25,
		"description": "Cooked meat. Restores health and satisfies hunger."
	},
	
	# ===== SEEDS =====
	"cornseed": {
		"display_name": "Corn Seeds",
		"category": ItemCategory.SEED,
		"tool_type": Tools.PlantCorn,
		"max_stack": 99,
		"icon_path": "res://scenes/ui/icons/cornseed_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": false,
		"grow_time": 5.0,
		"description": "Plant these to grow corn."
	},
	"tomatoseed": {
		"display_name": "Tomato Seeds",
		"category": ItemCategory.SEED,
		"tool_type": Tools.PlantTomato,
		"max_stack": 99,
		"icon_path": "res://scenes/ui/icons/tomatoseed_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": false,
		"grow_time": 6.0,
		"description": "Plant these to grow tomatoes."
	},
	
	# ===== CROPS =====
	"corn": {
		"display_name": "Corn",
		"category": ItemCategory.CROP,
		"tool_type": Tools.None,
		"max_stack": 99,
		"icon_path": "res://scenes/ui/icons/corn_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": false,
		"sell_value": 5,
		"description": "Fresh corn. Can be eaten or sold."
	},
	"tomato": {
		"display_name": "Tomato",
		"category": ItemCategory.CROP,
		"tool_type": Tools.None,
		"max_stack": 99,
		"icon_path": "res://scenes/ui/icons/tomato_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": false,
		"sell_value": 8,
		"description": "Juicy tomato. Can be eaten or sold."
	},
	
	# ===== RESOURCES =====
	"log": {
		"display_name": "Wood Log",
		"category": ItemCategory.RESOURCE,
		"tool_type": Tools.None,
		"max_stack": 99,
		"icon_path": "res://scenes/ui/icons/log_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": false,
		"sell_value": 2,
		"description": "Wooden log from chopping trees. Used in crafting."
	},
	"stone": {
		"display_name": "Stone",
		"category": ItemCategory.RESOURCE,
		"tool_type": Tools.None,
		"max_stack": 99,
		"icon_path": "res://scenes/ui/icons/stone_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": false,
		"sell_value": 3,
		"description": "A piece of stone. Useful for crafting."
	},
	"ironore": {
		"display_name": "Iron Ore",
		"category": ItemCategory.RESOURCE,
		"tool_type": Tools.None,
		"max_stack": 50,
		"icon_path": "res://scenes/ui/icons/ironore_icon.tres",
		"rarity": ItemRarity.UNCOMMON,
		"has_durability": false,
		"sell_value": 10,
		"description": "Raw iron ore. Can be smelted into iron bars."
	},
	"ironbar": {
		"display_name": "Iron Bar",
		"category": ItemCategory.RESOURCE,
		"tool_type": Tools.None,
		"max_stack": 50,
		"icon_path": "res://scenes/ui/icons/ironbar_icon.tres",
		"rarity": ItemRarity.UNCOMMON,
		"has_durability": false,
		"sell_value": 20,
		"description": "Refined iron bar. Used in advanced crafting."
	},
	"leather": {
		"display_name": "Leather",
		"category": ItemCategory.RESOURCE,
		"tool_type": Tools.None,
		"max_stack": 50,
		"icon_path": "res://scenes/ui/icons/leather_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": false,
		"sell_value": 5,
		"description": "Animal hide. Used to craft leather armor."
	},
	"fiber": {
		"display_name": "Plant Fiber",
		"category": ItemCategory.RESOURCE,
		"tool_type": Tools.None,
		"max_stack": 99,
		"icon_path": "res://scenes/ui/icons/fiber_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": false,
		"sell_value": 1,
		"description": "Plant fibers. Used in basic crafting."
	},
	
	# ===== MISC =====
	"egg": {
		"display_name": "Egg",
		"category": ItemCategory.CONSUMABLE,
		"tool_type": Tools.None,
		"max_stack": 12,
		"icon_path": "res://scenes/ui/icons/egg_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": false,
		"heal_amount": 5,
		"sell_value": 3,
		"description": "A fresh egg. Can be cooked or sold."
	},
	"milk": {
		"display_name": "Milk",
		"category": ItemCategory.CONSUMABLE,
		"tool_type": Tools.None,
		"max_stack": 10,
		"icon_path": "res://scenes/ui/icons/milk_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": false,
		"heal_amount": 8,
		"sell_value": 4,
		"description": "Fresh milk from a cow."
	},
	"coin": {
		"display_name": "Gold Coin",
		"category": ItemCategory.MISC,
		"tool_type": Tools.None,
		"max_stack": 999,
		"icon_path": "res://scenes/ui/icons/coin_icon.tres",
		"rarity": ItemRarity.COMMON,
		"has_durability": false,
		"description": "Currency used for buying and selling."
	},
}

# ============================================
# ITEM DATABASE HELPER FUNCTIONS
# ============================================

static func get_item_data(item_name: String) -> Dictionary:
	"""Get all data for an item from the database."""
	return ITEM_DATABASE.get(item_name.to_lower(), {})

static func item_exists(item_name: String) -> bool:
	"""Check if an item exists in the database."""
	return ITEM_DATABASE.has(item_name.to_lower())

static func get_display_name(item_name: String) -> String:
	"""Get the display name of an item."""
	var data = get_item_data(item_name)
	return data.get("display_name", item_name.capitalize())

static func get_category(item_name: String) -> ItemCategory:
	"""Get the category of an item."""
	var data = get_item_data(item_name)
	return data.get("category", ItemCategory.MISC)

static func get_tool_type(item_name: String) -> Tools:
	"""Get the tool type for an item (returns None if not a tool)."""
	var data = get_item_data(item_name)
	return data.get("tool_type", Tools.None)

static func get_weapon_type(item_name: String) -> Weapons:
	"""Get the weapon type for an item (returns None if not a weapon)."""
	var data = get_item_data(item_name)
	return data.get("weapon_type", Weapons.None)

static func get_armor_slot(item_name: String) -> ArmorSlot:
	"""Get the armor slot for an item (returns None if not armor)."""
	var data = get_item_data(item_name)
	return data.get("armor_slot", ArmorSlot.None)

static func get_max_stack(item_name: String) -> int:
	"""Get maximum stack size for an item."""
	var data = get_item_data(item_name)
	return data.get("max_stack", 99)

static func get_icon_path(item_name: String) -> String:
	"""Get the icon path for an item."""
	var data = get_item_data(item_name)
	return data.get("icon_path", "")

static func has_durability(item_name: String) -> bool:
	"""Check if an item has durability."""
	var data = get_item_data(item_name)
	return data.get("has_durability", false)

static func get_max_durability(item_name: String) -> int:
	"""Get maximum durability for an item."""
	var data = get_item_data(item_name)
	return data.get("max_durability", 100)

static func get_description(item_name: String) -> String:
	"""Get the description of an item."""
	var data = get_item_data(item_name)
	return data.get("description", "")

static func get_rarity(item_name: String) -> ItemRarity:
	"""Get the rarity of an item."""
	var data = get_item_data(item_name)
	return data.get("rarity", ItemRarity.COMMON)

static func get_damage(item_name: String) -> int:
	"""Get weapon damage value."""
	var data = get_item_data(item_name)
	return data.get("damage", 0)

static func get_defense(item_name: String) -> int:
	"""Get armor defense value."""
	var data = get_item_data(item_name)
	return data.get("defense", 0)

static func get_damage_type(item_name: String) -> DamageType:
	"""Get weapon damage type."""
	var data = get_item_data(item_name)
	return data.get("damage_type", DamageType.PHYSICAL)

static func get_attack_speed(item_name: String) -> float:
	"""Get weapon attack speed multiplier."""
	var data = get_item_data(item_name)
	return data.get("attack_speed", 1.0)

static func get_range(item_name: String) -> float:
	"""Get weapon/tool range."""
	var data = get_item_data(item_name)
	return data.get("range", 1.0)

static func get_heal_amount(item_name: String) -> int:
	"""Get healing amount for consumables."""
	var data = get_item_data(item_name)
	return data.get("heal_amount", 0)

static func get_mana_amount(item_name: String) -> int:
	"""Get mana restoration amount for consumables."""
	var data = get_item_data(item_name)
	return data.get("mana_amount", 0)

static func get_stamina_amount(item_name: String) -> int:
	"""Get stamina restoration amount for consumables."""
	var data = get_item_data(item_name)
	return data.get("stamina_amount", 0)

static func get_sell_value(item_name: String) -> int:
	"""Get the sell value of an item."""
	var data = get_item_data(item_name)
	return data.get("sell_value", 1)

static func get_grow_time(item_name: String) -> float:
	"""Get crop grow time for seeds."""
	var data = get_item_data(item_name)
	return data.get("grow_time", 5.0)

# ============================================
# CATEGORY CHECKS
# ============================================

static func is_tool(item_name: String) -> bool:
	"""Check if an item is a tool."""
	return get_category(item_name) == ItemCategory.TOOL

static func is_weapon(item_name: String) -> bool:
	"""Check if an item is a weapon."""
	return get_category(item_name) == ItemCategory.WEAPON

static func is_armor(item_name: String) -> bool:
	"""Check if an item is armor."""
	return get_category(item_name) == ItemCategory.ARMOR

static func is_consumable(item_name: String) -> bool:
	"""Check if an item is consumable."""
	return get_category(item_name) == ItemCategory.CONSUMABLE

static func is_stackable(item_name: String) -> bool:
	"""Check if an item can stack."""
	return get_max_stack(item_name) > 1

static func is_equipment(item_name: String) -> bool:
	"""Check if an item can be equipped (weapon, armor, tool)."""
	var category = get_category(item_name)
	return category in [ItemCategory.WEAPON, ItemCategory.ARMOR, ItemCategory.TOOL, ItemCategory.EQUIPMENT]

# ============================================
# QUERY FUNCTIONS
# ============================================

static func get_all_items() -> Array:
	"""Get list of all item names in the database."""
	return ITEM_DATABASE.keys()

static func get_items_by_category(category: ItemCategory) -> Array:
	"""Get all items of a specific category."""
	var items := []
	for item_name in ITEM_DATABASE.keys():
		if get_category(item_name) == category:
			items.append(item_name)
	return items

static func get_items_by_rarity(rarity: ItemRarity) -> Array:
	"""Get all items of a specific rarity."""
	var items := []
	for item_name in ITEM_DATABASE.keys():
		if get_rarity(item_name) == rarity:
			items.append(item_name)
	return items

static func get_armor_by_slot(slot: ArmorSlot) -> Array:
	"""Get all armor items for a specific slot."""
	var items := []
	for item_name in ITEM_DATABASE.keys():
		if get_armor_slot(item_name) == slot:
			items.append(item_name)
	return items
