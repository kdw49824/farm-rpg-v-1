extends Node2D

var balloon_scene = preload("res://dialogue/game_dialogue_balloon.tscn")

var corn_harvest_scene = preload("res://scenes/objects/plants/corn_harvest.tscn")
var tomato_harvest_scene = preload("res://scenes/objects/plants/tomato_harvest.tscn")

@export var dialogue_start_command: String
@export var food_drop_height: int = 40
@export var reward_output_radius: int = 20
@export var output_reward_scenes: Array[PackedScene] = []

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var feed_component: FeedComponent = $FeedComponent
@onready var reward_marker: Marker2D = $RewardMarker
@onready var interactable_label_component: Control = $InteractableLabelComponent

var in_range: bool = false
var is_chest_open: bool = false


func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()
	
	GameDialogueManager.feed_the_animals.connect(on_feed_the_animals)
	feed_component.food_received.connect(on_food_received)


func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true


func on_interactable_deactivated() -> void:
	if is_chest_open:
		animated_sprite_2d.play("chest_close")
	
	is_chest_open = false
	interactable_label_component.hide()
	in_range = false


func _unhandled_input(event: InputEvent) -> void:
	if in_range and event.is_action_pressed("show_dialogue"):
		interactable_label_component.hide()
		animated_sprite_2d.play("chest_open")
		is_chest_open = true
		
		# create dialogue balloon
		var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate() 
		get_tree().root.add_child(balloon)
		balloon.start(load("res://dialogue/conversations/chest.dialogue"), dialogue_start_command)


func on_feed_the_animals() -> void:
	if in_range:
		trigger_feed_harvest("corn", corn_harvest_scene)
		trigger_feed_harvest("tomato", tomato_harvest_scene)


# ---------------------------
# Stardew-style compatible harvest
# ---------------------------
func trigger_feed_harvest(item_name: String, scene: Resource) -> void: 
	var inventory_totals: Dictionary = InventoryManager.get_inventory_totals()
	
	if not inventory_totals.has(item_name):
		return
	
	var item_count: int = inventory_totals[item_name]
	
	for i in item_count:
		# Instantiate the harvest object
		var harvest_instance = scene.instantiate() as Node2D
		harvest_instance.global_position = Vector2(global_position.x, global_position.y - food_drop_height)
		get_tree().root.add_child(harvest_instance)
		
		# Random small delay per item
		var time_delay = randf_range(0.5, 2.0)
		await get_tree().create_timer(time_delay).timeout
		
		# Tween position and scale
		var tween = get_tree().create_tween()
		tween.tween_property(harvest_instance, "position", global_position, 1.0)
		tween.tween_property(harvest_instance, "scale", Vector2(0.5, 0.5), 1.0)
		tween.tween_callback(harvest_instance.queue_free)
		
		# Remove one item from inventory
		InventoryManager.remove_collectable(item_name, 1)


func on_food_received(area: Area2D) -> void:
	call_deferred("add_reward_scene")


func add_reward_scene() -> void:
	for scene in output_reward_scenes:
		var reward_instance: Node2D = scene.instantiate()
		var reward_position: Vector2 = get_random_position_in_circle(reward_marker.global_position, reward_output_radius)
		reward_instance.global_position = reward_position
		get_tree().root.add_child(reward_instance)


func get_random_position_in_circle(center: Vector2, radius: int) -> Vector2:
	var angle = randf() * TAU
	var distance = sqrt(randf()) * radius
	var x = center.x + distance * cos(angle)
	var y = center.y + distance * sin(angle)
	return Vector2(x, y)
