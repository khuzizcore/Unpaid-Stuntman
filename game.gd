
extends Node2D

var barrel_scene = preload("res://barrels.tscn")


func _ready() -> void:
	randomize()
	spawn_barrel()


func spawn_barrel() -> void:
	var barrel = barrel_scene.instantiate() as Area2D

	$Objects.add_child(barrel)

	barrel.global_position = $BarrelStart/Marker2D.global_position

	$Timers/BarrelTimer.wait_time = randf_range(1.0, 5.0)
	$Timers/BarrelTimer.start()


func _on_barrel_timer_timeout() -> void:
	spawn_barrel()
