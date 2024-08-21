extends Node2D

@export_enum("Normal", "Strong", "Fast") var enemy_type: int

@export_group("Normal Alien Properties", "normal_")
@export var normal_max_health := 50
@export var normal_move_speed := 1
@export var normal_damage := 50
@export var normal_attack_speed := 1

@export_group("Strong Alien Properties", "strong_")
@export var strong_max_health := 100
@export var strong_move_speed := 0.5
@export var strong_damage := 100
@export var strong_attack_speed := 0.5

@export_group("Fast Alien Properties", "fast_")
@export var fast_max_health := 25
@export var fast_move_speed := 2
@export var fast_damage := 25
@export var fast_attack_speed = 2

@export var max_health = 50
@export var cur_health = 0
@export var move_speed = 1
@export var damage = 50
@export var attack_speed = 1

@onready var turret = $"../Turret"

var target
var time_elapsed = 0
var canAttack = false

func _ready():
	match enemy_type:
		0:
			max_health = normal_max_health
			move_speed = normal_move_speed
			damage = normal_damage
			attack_speed = normal_attack_speed
			Logger.custom_log("Normal enemy initialized", "INFO")
		1:
			max_health = strong_max_health
			move_speed = strong_move_speed
			damage = strong_damage
			attack_speed = strong_attack_speed
			Logger.custom_log("Strong enemy initialized", "INFO")
		2:
			max_health = fast_max_health
			move_speed = fast_move_speed
			damage = fast_damage
			attack_speed = fast_attack_speed
			Logger.custom_log("Fast enemy initialized", "INFO")    
			
	cur_health = max_health
	Logger.custom_log("Current health set to: " + str(cur_health), "DEBUG", 1)

func _process(delta):
	time_elapsed += delta
	
	if turret != null:
		var move_dir = (turret.position - position)
		position += move_dir.normalized() * move_speed
		
		if canAttack:
			if time_elapsed >= attack_speed:
				target.take_damage(damage)
				Logger.custom_log("Attacking target with " + str(damage) + " damage.", "INFO", 1)
				time_elapsed = 0

func take_damage(damage):
	cur_health -= damage
	Logger.custom_log("Took " + str(damage) + " damage, current health: " + str(cur_health), "DEBUG", 1)
	
	if cur_health <= 0:
		Logger.custom_log("Health depleted, enemy destroyed", "SUCCESS", 1)
		queue_free()

func get_max_health():
	return max_health

func _on_area_2d_area_entered(area):
	if area.name == "TurretArea2D":
		target = area.get_parent()
		canAttack = true
		time_elapsed = 0
		
		Logger.custom_log("Turret entered area. Target acquired: " + target.name, "INFO")
