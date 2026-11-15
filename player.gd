extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $texture
@onready var heart: AnimatedSprite2D = $heart

@export var jump_strength := 400.0
@export var gravity := 980.0
@export var speed := 200.0
@export var hit_duration := 0.4  # seconds, roughly your "hit" animation length
var score: int

var direction_x := 0.0
var max_health := 3
var health := 3
var takedamage := false
var hit_timer := 0.0


func _ready() -> void:
	add_to_group("player")
	heart.stop()  # stop autoplay so it does not override the frame
	update_heart()


func change_scene():
	get_tree().change_scene_to_file("res://title_screen.tscn")
	
	
func damage() -> void:
	if takedamage:
		return

	health -= 1
	print("Player Health: ", health)
	update_heart()

	if health <= 0:
		die()
		return

	takedamage = true
	hit_timer = hit_duration
	sprite.play("hit")


func update_heart() -> void:
	var last_frame := heart.sprite_frames.get_frame_count(heart.animation) - 1
	heart.frame = clampi(max_health - health, 0, last_frame)


func die() -> void:
	print("Player is dead!")
	Global.score = score
	call_deferred("change_scene")
	queue_free()


func update_hit_state(delta: float) -> void:
	if not takedamage:
		return

	hit_timer -= delta
	if hit_timer <= 0.0:
		takedamage = false


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta


func get_input() -> void:
	direction_x = Input.get_axis("left", "right")

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_strength


func animation() -> void:
	if takedamage:
		return

	if direction_x != 0:
		sprite.flip_h = direction_x < 0

	if is_on_floor():
		if direction_x != 0:
			sprite.play("run")
		else:
			sprite.play("idle")
	else:
		sprite.play("jump")


func _physics_process(delta: float) -> void:
	update_hit_state(delta)
	get_input()

	velocity.x = direction_x * speed

	apply_gravity(delta)
	move_and_slide()

	animation()


func _on_score_timeout() -> void:
	score += 1
	$"../../CanvasLayer/Label".text = "Score: " + str(score)
