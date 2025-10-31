extends KinematicBody2D

export var speed = 50
export var move_distance = 300
export var slow_duration = 2.0
export var slow_factor = 0.5

onready var sprite = $AnimatedSprite
var start_x = 0
var direction = 1

func _ready():
	start_x = position.x

func _physics_process(delta):
	position.x += direction * speed * delta
	if position.x > start_x + move_distance:
		direction = -1
		sprite.flip_h = true
	elif position.x < start_x:
		direction = 1
		sprite.flip_h = false

func _on_body_entered(body):
	if body.name == "Player":
		if not body.has_meta("slowed"):
			body.speed *= slow_factor
			body.set_meta("slowed", true)
			yield(get_tree().create_timer(slow_duration), "timeout")
			body.speed /= slow_factor
			body.set_meta("slowed", false)
