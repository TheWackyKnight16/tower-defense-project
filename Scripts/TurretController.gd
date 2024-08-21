extends Node2D

@onready var collision_shape = $TurretRangeArea2D/CollisionShape2D
@onready var range_sprite = $RangeSprite

@export_enum("Close", "Far", "Strong", "Weak") var turret_mode: int

var target
var enemies_in_area = []

@export var cur_health := 500

@export var max_health = 500
@export var damage := 25
@export var fire_rate := 0.5
@export var range := 600

var time_elapsed = fire_rate
var temp_range

@export_group("Projcetile Properties")
@export var projectile_scene: PackedScene
@export var projectile_speed: float = 10
@export var spread_range: float = 10.0

func _ready():
	collision_shape.shape.radius = range
	temp_range = range_sprite.scale

func _process(delta):
	time_elapsed += delta
	
	range_sprite.scale = temp_range
	range_sprite.scale += Vector2(0.01563 * (range - 600), 0.01563 * (range - 600))
	
	if time_elapsed >= fire_rate:
		# if there is a target shoot
		if target != null:
			if damage > 0:
				Logger.custom_log("Target found: " + str(target), "INFO")
			fire_projectile()
		elif enemies_in_area.size() > 0:
			choose_target()
		
		time_elapsed = 0

func fire_projectile():
	var spread = Vector2(randf_range(-spread_range, spread_range), randf_range(-spread_range, spread_range))
	var target_dir = position.direction_to(target.position + spread)
	
	var projectile = projectile_scene.instantiate()
	add_child(projectile)
	projectile.global_position = global_position
	
	projectile.assign_projectile_variables(target_dir, projectile_speed, damage)

func take_damage(damage):
	cur_health -= damage
	Logger.custom_log("Took " + str(damage) + " damage, current health: " + str(cur_health), "DEBUG")
	if cur_health <= 0:
		Logger.custom_log("Health reached 0 or below, triggering death.", "WARNING")
		die()

func die():
	Logger.custom_log("Object is dying and will be removed from the scene.", "ERROR")
	queue_free()

func _on_area_2d_area_entered(area):
	Logger.custom_log("Area Entered", "INFO")
	Logger.custom_log("Target: " + str(area.get_parent()), "INFO", 1)
	if "Enemy" in area.get_parent().name:
		enemies_in_area.append(area.get_parent())

func _on_area_2d_area_exited(area):
	Logger.custom_log("Area Exited", "INFO")
	Logger.custom_log("Target: " + str(area.get_parent()), "INFO", 1)
	if "Enemy" in area.get_parent().name:
		enemies_in_area.erase(area.get_parent())

func choose_target():
	Logger.custom_log("Choosing Target", "INFO")
	match turret_mode:
		0:
			Logger.custom_log("Finding closest target...", "INFO", 1)
			target = get_closest_target()
		1:
			Logger.custom_log("Finding farthest target...", "INFO", 1)
			target = get_farthest_target()
		2:
			Logger.custom_log("Finding strongest target...", "INFO", 1)
			target = get_strongest_target()
		3:
			Logger.custom_log("Finding weakest target...", "INFO", 1)
			target = get_weakest_target()

func get_closest_target():
	var closest_target = null
	var shortest_distance = INF
	
	for target in enemies_in_area:
		Logger.custom_log("Checking target at position: " + str(target.position), "DEBUG", 2)
		var distance = position.distance_to(target.position)
		Logger.custom_log("Distance: " + str(distance), "DEBUG", 3)
		Logger.custom_log("Current Shortest Distance: " + str(shortest_distance), "DEBUG", 3)
		
		if distance < shortest_distance:
			shortest_distance = distance
			closest_target = target
			Logger.custom_log("New closest target found: " + str(target), "SUCCESS", 2)
	Logger.custom_log("", "INFO")
	return closest_target

func get_farthest_target():
	var farthest_target = null
	var farthest_distance = 0
	
	for target in enemies_in_area:
		Logger.custom_log("Checking target at position: " + str(target.position), "DEBUG", 2)
		var distance = position.distance_to(target.position)
		Logger.custom_log("Distance: " + str(distance), "DEBUG", 3)
		Logger.custom_log("Current Farthest Distance: " + str(farthest_distance), "DEBUG", 3)
		
		if distance > farthest_distance:
			farthest_distance = distance
			farthest_target = target
			Logger.custom_log("New farthest target found: " + str(target), "SUCCESS", 2)
	Logger.custom_log("", "INFO")
	return farthest_target

func get_strongest_target():
	var strongest_target = null
	var most_health = 0
	
	for target in enemies_in_area:
		Logger.custom_log("Checking target at position: " + str(target.position), "DEBUG", 2)
		var health = target.get_max_health()
		Logger.custom_log("Health: " + str(health), "DEBUG", 3)
		Logger.custom_log("Current Most Health: " + str(most_health), "DEBUG", 3)
		
		if health > most_health:
			most_health = health
			strongest_target = target
			Logger.custom_log("New strongest target found: " + str(target), "SUCCESS", 2)
	Logger.custom_log("", "INFO")
	return strongest_target

func get_weakest_target():
	var weakest_target = null
	var least_health = INF
	
	for target in enemies_in_area:
		Logger.custom_log("Checking target at position: " + str(target.position), "DEBUG", 2)
		var health = target.get_max_health()
		Logger.custom_log("Health: " + str(health), "DEBUG", 3)
		Logger.custom_log("Current Most Health: " + str(least_health), "DEBUG", 3)
		
		if health < least_health:
			least_health = health
			weakest_target = target
			Logger.custom_log("New strongest target found: " + str(target), "SUCCESS", 2)
	Logger.custom_log("", "INFO")
	return weakest_target
