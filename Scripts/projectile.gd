extends Node2D

var target_dir
var projectile_speed
var projectile_damage
var blastOff = false

var prev_pos
var cur_pos

func _process(_delta):
	if blastOff:
		position += target_dir * projectile_speed

func assign_projectile_variables(direction, speed, damage):
	target_dir = direction
	projectile_speed = speed
	projectile_damage = damage
	blastOff = true

func _on_area_2d_area_entered(area):
	var node = area.get_parent()
	if "Enemy" in node.name:
		Logger.custom_log("Hit enemy: " + node.name, "DEBUG")
		node.take_damage(projectile_damage)
		queue_free()
